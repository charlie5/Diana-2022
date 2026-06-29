--  diana_harness — a first interpretive-harness driver.
--
--  It builds a small program library where the main compilation refers to an
--  entity ("Foo") in a unit ("P") that has NOT been compiled yet, then shows
--  the two required behaviours: error out on the missing separate compilation,
--  and resolve the reference in place once that compilation is merged in.
--
--  Trees are assembled with the generated Diana.Builders (value constructors)
--  and read back with the generated Diana.Accessors (Is_/As_ views); the
--  pending-unit bookkeeping is Diana.Loading.

with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Exceptions;
with Diana;          use Diana;
with Diana.Builders;
with Diana.Accessors;
with Diana.Loading;
with Diana.Library;

procedure Diana_Harness is
   Lib      : Diana.Library.Instance;
   Main     : Cursor;
   P_Stub   : Cursor;
   Use_Site : Cursor;

   --  Report what the used occurrence at Site currently resolves to.  A
   --  Generic_Name is reported specially (it is a separately-compiled generic);
   --  note it is also a Defining_Occurrence, so it must be checked first.
   procedure Show_Resolution (Site : Cursor; What : String) is
   begin
      if Diana.Accessors.Is_Used_Name (Site) then
         declare
            Def : constant Cursor := Diana.Accessors.As_Used_Name (Site).Definition;
         begin
            if Diana.Accessors.Is_Generic_Name (Def) then
               Put_Line ("    '" & What & "' resolves to generic package """
                         & SU.To_String (Diana.Accessors.As_Generic_Name (Def).Spelling)
                         & """ (a separately-compiled generic).");
            elsif Diana.Accessors.Is_Package_Name (Def) then
               Put_Line ("    '" & What & "' resolves to package """
                         & SU.To_String (Diana.Accessors.As_Package_Name (Def).Spelling)
                         & """ (a loaded compilation).");
            elsif Diana.Accessors.Is_Defining_Occurrence (Def) then
               Put_Line ("    '" & What & "' resolves to defining name """
                         & SU.To_String (Diana.Accessors.As_Defining_Occurrence (Def).Spelling)
                         & """ (a loaded compilation).");
            elsif Trees.Element (Def) in Diana.Loading.Pending_Unit'Class then
               Put_Line ("    '" & What & "' still points at the stub for unit """
                         & SU.To_String (Diana.Loading.Pending_Unit (Trees.Element (Def)).Unit_Name)
                         & """ (unresolved).");
            end if;
         end;
      end if;
   end Show_Resolution;
begin
   Put_Line ("DIANA_2022 interpretive harness — separate-compilation demo");
   New_Line;

   Main := Lib.Add_Compilation ("Main");

   --  0. Builder / accessor check: assemble "X := 0" bottom-up and read it back.
   Put_Line ("Builder / accessor check:");
   declare
      Lit : constant Cursor := Lib.Add_Child
        (Main, Diana.Builders.Numeric_Literal
                 (Literal_Image => SU.To_Unbounded_String ("0")));
      Var : constant Cursor := Lib.Add_Child
        (Main, Diana.Builders.Variable_Name
                 (Spelling   => SU.To_Unbounded_String ("X"),
                  Object_Def => Lit));
   begin
      Put_Line ("    built variable """
                & SU.To_String (Diana.Accessors.As_Variable_Name (Var).Spelling)
                & """ initialised to literal "
                & SU.To_String (Diana.Accessors.As_Numeric_Literal
                                  (Diana.Accessors.As_Variable_Name (Var).Object_Def)
                                  .Literal_Image));
   end;
   New_Line;

   --  1. Main compilation uses P.Foo; P is only with'ed, so it is a stub.
   P_Stub   := Lib.Require ("P");
   Use_Site := Lib.Add_Child
     (Main, Diana.Builders.Used_Name (Definition => P_Stub));
   Lib.Reference (Name => "P", Site => Use_Site, Wanted => "Foo");

   Put_Line ("Built 'Main', which references entity 'Foo' in unit 'P'.");
   Show_Resolution (Use_Site, "Foo");
   New_Line;

   --  2. Executing now must fail: P's DIANA was never supplied.
   Put_Line ("Attempting to run with 'P' missing ...");
   begin
      Lib.Require_All_Resolved;
      Put_Line ("    (unexpected) library reported fully resolved");
   exception
      when E : Diana.Library.Missing_Compilation =>
         Put_Line ("    errored out as required: "
                   & Ada.Exceptions.Exception_Message (E));
   end;
   New_Line;

   --  3. Merge the separately-compiled P; the reference is fixed up in place.
   Put_Line ("Merging separately-compiled unit 'P' (declares 'Foo') ...");
   Lib.Merge (Name => "P", Declared => "Foo");
   Show_Resolution (Use_Site, "Foo");
   New_Line;

   --  4. Now execution is permitted.
   Put_Line ("Re-checking ...");
   Lib.Require_All_Resolved;
   Put_Line ("    all separate compilations present — ready to interpret.");
   New_Line;

   --  5. Separate compilation of a generic package: a second compilation
   --     'Client' instantiates generic package 'Stacks', whose template is in a
   --     separately-compiled unit (so it starts as a stub).  The same merge
   --     machinery resolves the instantiation's reference to the generic.
   Put_Line ("Separate compilation of a generic package:");
   declare
      Client      : constant Cursor := Lib.Add_Compilation ("Client");
      Stacks_Stub : constant Cursor := Lib.Require ("Stacks");
      Gen_Ref     : constant Cursor := Lib.Add_Child
        (Client, Diana.Builders.Used_Name (Definition => Stacks_Stub));
      --  "package My_Stack is new Stacks;" — the instantiation refers to Stacks
      Inst        : constant Cursor := Lib.Add_Child
        (Client, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Ref));

      --  the instantiation's generic-unit reference (the site to resolve)
      function Gen_Site return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
   begin
      Lib.Reference (Name => "Stacks", Site => Gen_Site, Wanted => "Stacks");
      Put_Line ("    built 'Client': package My_Stack is new Stacks;");
      Show_Resolution (Gen_Site, "Stacks");

      Put_Line ("    attempting to run with generic 'Stacks' missing ...");
      begin
         Lib.Require_All_Resolved;
         Put_Line ("    (unexpected) library reported fully resolved");
      exception
         when E : Diana.Library.Missing_Compilation =>
            Put_Line ("    errored out as required: "
                      & Ada.Exceptions.Exception_Message (E));
      end;

      Put_Line ("    merging separately-compiled generic package 'Stacks' ...");
      Lib.Merge (Name     => "Stacks",
                 Declared => "Stacks",
                 Kind     => Diana.Library.Generic_Package_Unit);
      Show_Resolution (Gen_Site, "Stacks");

      Lib.Require_All_Resolved;
      Put_Line ("    all separate compilations present — ready to interpret.");
   end;
   New_Line;

   --  6. Separate compilation of a CHILD generic package.  'Client2'
   --     instantiates 'Buffers.Bounded', a generic child of package 'Buffers';
   --     both the parent package and the child generic are separately compiled
   --     (two stubs).  The instantiation names the generic by its compound name,
   --     so it carries two references — the prefix 'Buffers' and the selector
   --     'Bounded' — both fixed up in place by merging the two units.
   Put_Line ("Separate compilation of a child generic package:");
   declare
      Client2      : constant Cursor := Lib.Add_Compilation ("Client2");
      Parent_Stub  : constant Cursor := Lib.Require ("Buffers");
      Child_Stub   : constant Cursor := Lib.Require ("Buffers.Bounded");
      Prefix_Ref   : constant Cursor := Lib.Add_Child
        (Client2, Diana.Builders.Used_Name (Definition => Parent_Stub));
      Selector_Ref : constant Cursor := Lib.Add_Child
        (Client2, Diana.Builders.Used_Name (Definition => Child_Stub));
      --  the generic name "Buffers.Bounded" as a selected component
      Gen_Unit     : constant Cursor := Lib.Add_Child
        (Client2, Diana.Builders.Selected_Component
                    (Prefix => Prefix_Ref, Selector => Selector_Ref));
      --  "package My_Buffer is new Buffers.Bounded (100);"
      Inst         : constant Cursor := Lib.Add_Child
        (Client2, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit));

      --  read the prefix / selector reference sites back out of the instantiation
      function Selected return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
      function Parent_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Selected).Prefix);
      function Child_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Selected).Selector);
   begin
      Lib.Reference (Name => "Buffers", Site => Parent_Site, Wanted => "Buffers");
      Lib.Reference (Name => "Buffers.Bounded", Site => Child_Site,
                     Wanted => "Bounded");
      Put_Line ("    built 'Client2': package My_Buffer is new Buffers.Bounded (100);");
      Show_Resolution (Parent_Site, "Buffers");
      Show_Resolution (Child_Site, "Bounded");

      --  a child unit cannot be compiled before its parent
      Put_Line ("    merging child 'Buffers.Bounded' before its parent ...");
      begin
         Lib.Merge (Name     => "Buffers.Bounded",
                    Declared => "Bounded",
                    Kind     => Diana.Library.Generic_Package_Unit,
                    Parent   => "Buffers");
         Put_Line ("    (unexpected) child merged without its parent");
      exception
         when E : Diana.Library.Missing_Compilation =>
            Put_Line ("    errored out as required: "
                      & Ada.Exceptions.Exception_Message (E));
      end;

      --  merge the parent package, then the child generic beneath it
      Put_Line ("    merging parent package 'Buffers', then child generic "
                & "'Buffers.Bounded' ...");
      Lib.Merge (Name => "Buffers", Declared => "Buffers",
                 Kind => Diana.Library.Package_Unit);
      Lib.Merge (Name     => "Buffers.Bounded",
                 Declared => "Bounded",
                 Kind     => Diana.Library.Generic_Package_Unit,
                 Parent   => "Buffers");
      Show_Resolution (Parent_Site, "Buffers");
      Show_Resolution (Child_Site, "Bounded");

      Lib.Require_All_Resolved;
      Put_Line ("    all separate compilations present — "
                & "'Buffers.Bounded' loaded beneath 'Buffers'.");
   end;
end Diana_Harness;
