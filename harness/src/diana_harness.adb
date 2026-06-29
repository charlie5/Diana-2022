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
   --  Detail overrides the parenthetical note for a resolved entity.
   procedure Show_Resolution (Site : Cursor; What : String; Detail : String := "") is
      function Note (Default : String) return String is
        (if Detail = "" then Default else Detail);
   begin
      if Diana.Accessors.Is_Used_Name (Site) then
         declare
            Def : constant Cursor := Diana.Accessors.As_Used_Name (Site).Definition;
         begin
            if Diana.Accessors.Is_Generic_Name (Def) then
               Put_Line ("    '" & What & "' resolves to generic package """
                         & SU.To_String (Diana.Accessors.As_Generic_Name (Def).Spelling)
                         & """ (" & Note ("a separately-compiled generic") & ").");
            elsif Diana.Accessors.Is_Package_Name (Def) then
               Put_Line ("    '" & What & "' resolves to package """
                         & SU.To_String (Diana.Accessors.As_Package_Name (Def).Spelling)
                         & """ (" & Note ("a loaded compilation") & ").");
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

   --  Report whether the body at Site (a Subprogram_Body) is still an
   --  "is separate" stub, or has been completed by its subunit.
   procedure Show_Body_Status (Site : Cursor; What : String) is
   begin
      if Diana.Accessors.Is_Subprogram_Body (Site) then
         if Diana.Accessors.Is_Stub
              (Diana.Accessors.As_Subprogram_Body (Site).Completion)
         then
            Put_Line ("    body of '" & What
                      & "' is separate (subunit not yet compiled).");
         else
            Put_Line ("    body of '" & What & "' completed by its subunit.");
         end if;
      end if;
   end Show_Body_Status;
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
   New_Line;

   --  7. Separate compilation of a NESTED generic package.  'Client3'
   --     instantiates 'Registry.Cache', a generic package nested inside the
   --     specification of package 'Registry'.  Unlike a child unit, the nested
   --     generic is NOT a separate compilation: only 'Registry' is a stub, and
   --     both references of the compound-name instantiation — the prefix
   --     'Registry' and the selector 'Cache' (an entity *within* 'Registry') —
   --     are resolved by the single merge that brings 'Registry' in.
   Put_Line ("Separate compilation of a nested generic package:");
   declare
      Client3      : constant Cursor := Lib.Add_Compilation ("Client3");
      Outer_Stub   : constant Cursor := Lib.Require ("Registry");
      Prefix_Ref   : constant Cursor := Lib.Add_Child
        (Client3, Diana.Builders.Used_Name (Definition => Outer_Stub));
      Selector_Ref : constant Cursor := Lib.Add_Child
        (Client3, Diana.Builders.Used_Name (Definition => Outer_Stub));
      --  the generic name "Registry.Cache" as a selected component
      Gen_Unit     : constant Cursor := Lib.Add_Child
        (Client3, Diana.Builders.Selected_Component
                    (Prefix => Prefix_Ref, Selector => Selector_Ref));
      --  "package My_Cache is new Registry.Cache;"
      Inst         : constant Cursor := Lib.Add_Child
        (Client3, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit));

      function Selected return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
      function Outer_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Selected).Prefix);
      function Nested_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Selected).Selector);
   begin
      --  both referrers are recorded against the SAME unit 'Registry': the
      --  selector wants 'Cache', an entity nested inside 'Registry'.
      Lib.Reference (Name => "Registry", Site => Outer_Site, Wanted => "Registry");
      Lib.Reference (Name => "Registry", Site => Nested_Site, Wanted => "Cache");
      Put_Line ("    built 'Client3': package My_Cache is new Registry.Cache;");
      Show_Resolution (Outer_Site, "Registry");
      Show_Resolution (Nested_Site, "Cache");

      Put_Line ("    attempting to run with 'Registry' missing ...");
      begin
         Lib.Require_All_Resolved;
         Put_Line ("    (unexpected) library reported fully resolved");
      exception
         when E : Diana.Library.Missing_Compilation =>
            Put_Line ("    errored out as required: "
                      & Ada.Exceptions.Exception_Message (E));
      end;

      --  one merge brings in 'Registry' and its nested generic 'Cache'
      Put_Line ("    merging package 'Registry' (with nested generic 'Cache') ...");
      Lib.Merge (Name     => "Registry",
                 Declared => "Registry",
                 Kind     => Diana.Library.Package_Unit,
                 Nested   => "Cache");
      Show_Resolution (Outer_Site, "Registry");
      Show_Resolution (Nested_Site, "Cache",
                       Detail => "a generic nested in Registry");

      Lib.Require_All_Resolved;
      Put_Line ("    all separate compilations present — one merge resolved both.");
   end;
   New_Line;

   --  8. Separate compilation of a CHILD PACKAGE OF A GENERIC PACKAGE.  Here the
   --     PARENT 'Tables' is itself a generic package; its child 'Tables.Sorted'
   --     is therefore implicitly generic (Ada 22 RM 10.1.1).  Both are separately
   --     compiled.  A child of a generic is used through an INSTANCE of the
   --     parent: 'Client4' does
   --        package T_Inst is new Tables;          -- references generic Tables
   --        package S_Inst is new T_Inst.Sorted;   -- T_Inst local, Sorted cross-unit
   --     so the second instantiation's prefix resolves *locally* to the parent
   --     instance and only its selector is a cross-unit reference to the child.
   Put_Line ("Separate compilation of a child package of a generic package:");
   declare
      Client4     : constant Cursor := Lib.Add_Compilation ("Client4");
      Tables_Stub : constant Cursor := Lib.Require ("Tables");
      Sorted_Stub : constant Cursor := Lib.Require ("Tables.Sorted");

      --  "package T_Inst is new Tables;" — a local instance of the generic parent
      Parent_Inst : constant Cursor := Lib.Add_Child
        (Client4, Diana.Builders.Package_Name
                    (Spelling => SU.To_Unbounded_String ("T_Inst")));
      Inst1_Ref   : constant Cursor := Lib.Add_Child
        (Client4, Diana.Builders.Used_Name (Definition => Tables_Stub));
      Inst1       : constant Cursor := Lib.Add_Child
        (Client4, Diana.Builders.Generic_Instantiation (Generic_Unit => Inst1_Ref));

      --  "package S_Inst is new T_Inst.Sorted;" — child of the parent INSTANCE
      Prefix_Ref   : constant Cursor := Lib.Add_Child
        (Client4, Diana.Builders.Used_Name (Definition => Parent_Inst));
      Selector_Ref : constant Cursor := Lib.Add_Child
        (Client4, Diana.Builders.Used_Name (Definition => Sorted_Stub));
      Gen_Unit2    : constant Cursor := Lib.Add_Child
        (Client4, Diana.Builders.Selected_Component
                    (Prefix => Prefix_Ref, Selector => Selector_Ref));
      Inst2        : constant Cursor := Lib.Add_Child
        (Client4, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit2));

      function Parent_Site return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst1).Generic_Unit);
      function Sel return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst2).Generic_Unit);
      function Inst_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Prefix);
      function Child_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Selector);
   begin
      --  the parent generic and the child generic are cross-unit; the parent
      --  instance prefix 'T_Inst' is local (no reference recorded for it).
      Lib.Reference (Name => "Tables", Site => Parent_Site, Wanted => "Tables");
      Lib.Reference (Name => "Tables.Sorted", Site => Child_Site, Wanted => "Sorted");
      Put_Line ("    built 'Client4': package T_Inst is new Tables;");
      Put_Line ("                     package S_Inst is new T_Inst.Sorted;");
      Show_Resolution (Parent_Site, "Tables");
      Show_Resolution (Inst_Site, "T_Inst", Detail => "a local parent instance");
      Show_Resolution (Child_Site, "Sorted");

      --  the child of a generic still needs its (generic) parent compiled first
      Put_Line ("    merging child 'Tables.Sorted' before its parent ...");
      begin
         Lib.Merge (Name => "Tables.Sorted", Declared => "Sorted",
                    Kind => Diana.Library.Generic_Package_Unit, Parent => "Tables");
         Put_Line ("    (unexpected) child merged without its parent");
      exception
         when E : Diana.Library.Missing_Compilation =>
            Put_Line ("    errored out as required: "
                      & Ada.Exceptions.Exception_Message (E));
      end;

      --  merge the parent GENERIC, then the child generic beneath it
      Put_Line ("    merging generic parent 'Tables', then child generic "
                & "'Tables.Sorted' ...");
      Lib.Merge (Name => "Tables", Declared => "Tables",
                 Kind => Diana.Library.Generic_Package_Unit);
      Lib.Merge (Name => "Tables.Sorted", Declared => "Sorted",
                 Kind => Diana.Library.Generic_Package_Unit, Parent => "Tables");
      Show_Resolution (Parent_Site, "Tables");
      Show_Resolution (Inst_Site, "T_Inst", Detail => "a local parent instance");
      Show_Resolution (Child_Site, "Sorted",
                       Detail => "a child of generic Tables");

      Lib.Require_All_Resolved;
      Put_Line ("    all separate compilations present — "
                & "child generic loaded beneath its generic parent.");
   end;
   New_Line;

   --  9. Separate compilation of a GRANDCHILD generic package.  'Client5'
   --     instantiates 'Graphics.Drivers.Pool': a generic grandchild whose
   --     ancestors 'Graphics' and 'Graphics.Drivers' are ordinary packages.
   --     All three are separately compiled, forming a dependency chain
   --     Graphics <- Graphics.Drivers <- Graphics.Drivers.Pool, and the
   --     instantiation names the generic by a doubly-nested selected component
   --     (A.B).C, so it carries three referrers — one per ancestor level — all
   --     fixed up by merging the three units top-down.
   Put_Line ("Separate compilation of a grandchild generic package:");
   declare
      Client5      : constant Cursor := Lib.Add_Compilation ("Client5");
      G_Stub       : constant Cursor := Lib.Require ("Graphics");
      D_Stub       : constant Cursor := Lib.Require ("Graphics.Drivers");
      P_Stub       : constant Cursor := Lib.Require ("Graphics.Drivers.Pool");
      G_Ref        : constant Cursor := Lib.Add_Child
        (Client5, Diana.Builders.Used_Name (Definition => G_Stub));
      D_Ref        : constant Cursor := Lib.Add_Child
        (Client5, Diana.Builders.Used_Name (Definition => D_Stub));
      P_Ref        : constant Cursor := Lib.Add_Child
        (Client5, Diana.Builders.Used_Name (Definition => P_Stub));
      --  "Graphics.Drivers" then "(Graphics.Drivers).Pool"
      Inner_Sel    : constant Cursor := Lib.Add_Child
        (Client5, Diana.Builders.Selected_Component
                    (Prefix => G_Ref, Selector => D_Ref));
      Gen_Unit     : constant Cursor := Lib.Add_Child
        (Client5, Diana.Builders.Selected_Component
                    (Prefix => Inner_Sel, Selector => P_Ref));
      --  "package My_Pool is new Graphics.Drivers.Pool;"
      Inst         : constant Cursor := Lib.Add_Child
        (Client5, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit));

      function Outer return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
      function Inner return Cursor is
        (Diana.Accessors.As_Selected_Component (Outer).Prefix);
      function Graphics_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Inner).Prefix);
      function Drivers_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Inner).Selector);
      function Pool_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Outer).Selector);
   begin
      Lib.Reference (Name => "Graphics", Site => Graphics_Site,
                     Wanted => "Graphics");
      Lib.Reference (Name => "Graphics.Drivers", Site => Drivers_Site,
                     Wanted => "Drivers");
      Lib.Reference (Name => "Graphics.Drivers.Pool", Site => Pool_Site,
                     Wanted => "Pool");
      Put_Line ("    built 'Client5': package My_Pool is new Graphics.Drivers.Pool;");
      Show_Resolution (Graphics_Site, "Graphics");
      Show_Resolution (Drivers_Site, "Drivers");
      Show_Resolution (Pool_Site, "Pool");

      --  the grandchild needs its whole ancestor chain compiled first
      Put_Line ("    merging grandchild 'Graphics.Drivers.Pool' before its "
                & "ancestors ...");
      begin
         Lib.Merge (Name => "Graphics.Drivers.Pool", Declared => "Pool",
                    Kind => Diana.Library.Generic_Package_Unit,
                    Parent => "Graphics.Drivers");
         Put_Line ("    (unexpected) grandchild merged without its parent");
      exception
         when E : Diana.Library.Missing_Compilation =>
            Put_Line ("    errored out as required: "
                      & Ada.Exceptions.Exception_Message (E));
      end;

      --  merge the chain top-down: Graphics, then Graphics.Drivers, then the
      --  grandchild generic beneath it
      Put_Line ("    merging 'Graphics', then 'Graphics.Drivers', then "
                & "'Graphics.Drivers.Pool' ...");
      Lib.Merge (Name => "Graphics", Declared => "Graphics",
                 Kind => Diana.Library.Package_Unit);
      Lib.Merge (Name => "Graphics.Drivers", Declared => "Drivers",
                 Kind => Diana.Library.Package_Unit, Parent => "Graphics");
      Lib.Merge (Name => "Graphics.Drivers.Pool", Declared => "Pool",
                 Kind => Diana.Library.Generic_Package_Unit,
                 Parent => "Graphics.Drivers");
      Show_Resolution (Graphics_Site, "Graphics");
      Show_Resolution (Drivers_Site, "Drivers");
      Show_Resolution (Pool_Site, "Pool",
                       Detail => "a generic grandchild of Graphics");

      Lib.Require_All_Resolved;
      Put_Line ("    all separate compilations present — grandchild generic "
                & "loaded three levels deep.");
   end;
   New_Line;

   --  10. Separate compilation of a SUBUNIT.  Unlike the unit references above,
   --      a subunit completes a body STUB: the body of package 'Engine' contains
   --      "procedure Process is separate;" — a Subprogram_Body whose Completion
   --      is a Stub.  The subunit 'Engine.Process' is separately compiled; until
   --      merged the stub is unresolved (and erroring), then the subunit's proper
   --      body completes it in place.
   Put_Line ("Separate compilation of a subunit:");
   declare
      Engine     : constant Cursor := Lib.Add_Compilation ("Engine");
      Process_Id : constant Cursor := Lib.Add_Child
        (Engine, Diana.Builders.Subprogram_Name
                   (Spelling => SU.To_Unbounded_String ("Process")));
      Stub_Node  : constant Cursor := Lib.Add_Child (Engine, Diana.Builders.Stub);
      --  "procedure Process is separate;" in the body of 'Engine'
      Sep_Body   : constant Cursor := Lib.Add_Child
        (Engine, Diana.Builders.Subprogram_Body
                   (Designator => Process_Id, Completion => Stub_Node));
   begin
      --  record the body-stub site against the (pending) subunit
      Lib.Reference (Name => "Engine.Process", Site => Sep_Body, Wanted => "Process");
      Put_Line ("    built body of 'Engine': procedure Process is separate;");
      Show_Body_Status (Sep_Body, "Process");

      Put_Line ("    attempting to run with subunit 'Engine.Process' missing ...");
      begin
         Lib.Require_All_Resolved;
         Put_Line ("    (unexpected) library reported fully resolved");
      exception
         when E : Diana.Library.Missing_Compilation =>
            Put_Line ("    errored out as required: "
                      & Ada.Exceptions.Exception_Message (E));
      end;

      Put_Line ("    merging separately-compiled subunit 'Engine.Process' ...");
      Lib.Merge_Subunit (Name => "Engine.Process", Parent => "Engine");
      Show_Body_Status (Sep_Body, "Process");

      Lib.Require_All_Resolved;
      Put_Line ("    all separate compilations present — "
                & "subunit body completed in place.");
   end;
   New_Line;

   --  11. Separate compilation of a SUBUNIT OF A GENERIC PACKAGE — combining two
   --      capabilities.  The generic package 'Allocators' is itself separately
   --      compiled (resolved via an instantiation), and its body carries
   --      "procedure Free is separate;" — a subunit of the generic, separately
   --      compiled and completed once the generic is present.
   Put_Line ("Separate compilation of a subunit of a generic package:");
   declare
      Client6  : constant Cursor := Lib.Add_Compilation ("Client6");
      Gen_Ref  : constant Cursor := Lib.Add_Child
        (Client6, Diana.Builders.Used_Name (Definition => Lib.Require ("Allocators")));
      --  "package Mem is new Allocators;"
      Inst     : constant Cursor := Lib.Add_Child
        (Client6, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Ref));
      function Gen_Site return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
   begin
      Lib.Reference (Name => "Allocators", Site => Gen_Site, Wanted => "Allocators");
      Put_Line ("    built 'Client6': package Mem is new Allocators;");
      Show_Resolution (Gen_Site, "Allocators");

      --  merge the generic package; the instantiation resolves to it
      Put_Line ("    merging separately-compiled generic package 'Allocators' ...");
      Lib.Merge (Name => "Allocators", Declared => "Allocators",
                 Kind => Diana.Library.Generic_Package_Unit);
      Show_Resolution (Gen_Site, "Allocators");

      --  the generic's body has "procedure Free is separate;" — a body stub
      --  built into the now-loaded generic, completed by its separate subunit.
      declare
         Body_Of_Gen : constant Cursor := Lib.Require ("Allocators");  -- loaded
         Free_Id     : constant Cursor := Lib.Add_Child
           (Body_Of_Gen, Diana.Builders.Subprogram_Name
                           (Spelling => SU.To_Unbounded_String ("Free")));
         Stub_Node   : constant Cursor := Lib.Add_Child
           (Body_Of_Gen, Diana.Builders.Stub);
         Free_Body   : constant Cursor := Lib.Add_Child
           (Body_Of_Gen, Diana.Builders.Subprogram_Body
                           (Designator => Free_Id, Completion => Stub_Node));
      begin
         Lib.Reference (Name => "Allocators.Free", Site => Free_Body, Wanted => "Free");
         Put_Line ("    'Allocators' body has: procedure Free is separate;");
         Show_Body_Status (Free_Body, "Free");

         Put_Line ("    attempting to run with subunit 'Allocators.Free' missing ...");
         begin
            Lib.Require_All_Resolved;
            Put_Line ("    (unexpected) library reported fully resolved");
         exception
            when E : Diana.Library.Missing_Compilation =>
               Put_Line ("    errored out as required: "
                         & Ada.Exceptions.Exception_Message (E));
         end;

         Put_Line ("    merging subunit 'Allocators.Free' of the generic package ...");
         Lib.Merge_Subunit (Name => "Allocators.Free", Parent => "Allocators");
         Show_Body_Status (Free_Body, "Free");

         Lib.Require_All_Resolved;
         Put_Line ("    all separate compilations present — generic package and "
                   & "its subunit body both resolved.");
      end;
   end;
   New_Line;

   --  12. Separate compilation of a SUBUNIT OF A CHILD GENERIC PACKAGE — the
   --      deepest combination so far.  'Containers.Vectors' is a generic child
   --      of package 'Containers' (both separately compiled, child beneath
   --      parent); the child generic's body carries "procedure Reserve is
   --      separate;", a subunit 'Containers.Vectors.Reserve' separately compiled
   --      and completed once the child generic is present.
   Put_Line ("Separate compilation of a subunit of a child generic package:");
   declare
      Client7      : constant Cursor := Lib.Add_Compilation ("Client7");
      Parent_Stub  : constant Cursor := Lib.Require ("Containers");
      Child_Stub   : constant Cursor := Lib.Require ("Containers.Vectors");
      Prefix_Ref   : constant Cursor := Lib.Add_Child
        (Client7, Diana.Builders.Used_Name (Definition => Parent_Stub));
      Selector_Ref : constant Cursor := Lib.Add_Child
        (Client7, Diana.Builders.Used_Name (Definition => Child_Stub));
      Gen_Unit     : constant Cursor := Lib.Add_Child
        (Client7, Diana.Builders.Selected_Component
                    (Prefix => Prefix_Ref, Selector => Selector_Ref));
      --  "package V is new Containers.Vectors;"
      Inst         : constant Cursor := Lib.Add_Child
        (Client7, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit));

      function Sel return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
      function Parent_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Prefix);
      function Child_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Selector);
   begin
      Lib.Reference (Name => "Containers", Site => Parent_Site,
                     Wanted => "Containers");
      Lib.Reference (Name => "Containers.Vectors", Site => Child_Site,
                     Wanted => "Vectors");
      Put_Line ("    built 'Client7': package V is new Containers.Vectors;");
      Show_Resolution (Parent_Site, "Containers");
      Show_Resolution (Child_Site, "Vectors");

      --  merge the parent package, then the child generic beneath it
      Put_Line ("    merging package 'Containers', then child generic "
                & "'Containers.Vectors' ...");
      Lib.Merge (Name => "Containers", Declared => "Containers",
                 Kind => Diana.Library.Package_Unit);
      Lib.Merge (Name => "Containers.Vectors", Declared => "Vectors",
                 Kind => Diana.Library.Generic_Package_Unit,
                 Parent => "Containers");
      Show_Resolution (Parent_Site, "Containers");
      Show_Resolution (Child_Site, "Vectors");

      --  the child generic's body has "procedure Reserve is separate;"
      declare
         Child_Body : constant Cursor := Lib.Require ("Containers.Vectors"); -- loaded
         Reserve_Id : constant Cursor := Lib.Add_Child
           (Child_Body, Diana.Builders.Subprogram_Name
                          (Spelling => SU.To_Unbounded_String ("Reserve")));
         Stub_Node  : constant Cursor := Lib.Add_Child
           (Child_Body, Diana.Builders.Stub);
         Reserve_Body : constant Cursor := Lib.Add_Child
           (Child_Body, Diana.Builders.Subprogram_Body
                          (Designator => Reserve_Id, Completion => Stub_Node));
      begin
         Lib.Reference (Name => "Containers.Vectors.Reserve",
                        Site => Reserve_Body, Wanted => "Reserve");
         Put_Line ("    'Containers.Vectors' body has: procedure Reserve is separate;");
         Show_Body_Status (Reserve_Body, "Reserve");

         Put_Line ("    attempting to run with subunit "
                   & "'Containers.Vectors.Reserve' missing ...");
         begin
            Lib.Require_All_Resolved;
            Put_Line ("    (unexpected) library reported fully resolved");
         exception
            when E : Diana.Library.Missing_Compilation =>
               Put_Line ("    errored out as required: "
                         & Ada.Exceptions.Exception_Message (E));
         end;

         Put_Line ("    merging subunit 'Containers.Vectors.Reserve' of the "
                   & "child generic ...");
         Lib.Merge_Subunit (Name   => "Containers.Vectors.Reserve",
                            Parent => "Containers.Vectors");
         Show_Body_Status (Reserve_Body, "Reserve");

         Lib.Require_All_Resolved;
         Put_Line ("    all separate compilations present — child generic and "
                   & "its subunit body both resolved.");
      end;
   end;
   New_Line;

   --  13. Separate compilation of a SUBUNIT OF A NESTED GENERIC PACKAGE.  The
   --      generic 'Pool' is nested inside the spec of package 'Sessions' (NOT a
   --      unit of its own — there is no 'Sessions.Pool' compilation), so its
   --      body's "procedure Evict is separate;" subunit completes a stub that
   --      lives in the ENCLOSING compilation 'Sessions'.  Merge_Subunit's
   --      Enclosing parameter names that compilation (Parent => "Sessions.Pool",
   --      Enclosing => "Sessions").
   Put_Line ("Separate compilation of a subunit of a nested generic package:");
   declare
      Client8      : constant Cursor := Lib.Add_Compilation ("Client8");
      Outer_Stub   : constant Cursor := Lib.Require ("Sessions");
      Prefix_Ref   : constant Cursor := Lib.Add_Child
        (Client8, Diana.Builders.Used_Name (Definition => Outer_Stub));
      Selector_Ref : constant Cursor := Lib.Add_Child
        (Client8, Diana.Builders.Used_Name (Definition => Outer_Stub));
      Gen_Unit     : constant Cursor := Lib.Add_Child
        (Client8, Diana.Builders.Selected_Component
                    (Prefix => Prefix_Ref, Selector => Selector_Ref));
      --  "package P is new Sessions.Pool;"
      Inst         : constant Cursor := Lib.Add_Child
        (Client8, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit));

      function Sel return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
      function Outer_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Prefix);
      function Nested_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Selector);
   begin
      --  both referrers recorded against the SAME unit 'Sessions' (Pool is
      --  nested in it), so one merge of 'Sessions' resolves both.
      Lib.Reference (Name => "Sessions", Site => Outer_Site, Wanted => "Sessions");
      Lib.Reference (Name => "Sessions", Site => Nested_Site, Wanted => "Pool");
      Put_Line ("    built 'Client8': package P is new Sessions.Pool;");
      Show_Resolution (Outer_Site, "Sessions");
      Show_Resolution (Nested_Site, "Pool");

      Put_Line ("    merging package 'Sessions' (with nested generic 'Pool') ...");
      Lib.Merge (Name => "Sessions", Declared => "Sessions",
                 Kind => Diana.Library.Package_Unit, Nested => "Pool");
      Show_Resolution (Outer_Site, "Sessions");
      Show_Resolution (Nested_Site, "Pool",
                       Detail => "a generic nested in Sessions");

      --  the nested generic's body has "procedure Evict is separate;" — a stub
      --  in the enclosing compilation 'Sessions'.
      declare
         Encl       : constant Cursor := Lib.Require ("Sessions");  -- loaded
         Evict_Id   : constant Cursor := Lib.Add_Child
           (Encl, Diana.Builders.Subprogram_Name
                    (Spelling => SU.To_Unbounded_String ("Evict")));
         Stub_Node  : constant Cursor := Lib.Add_Child (Encl, Diana.Builders.Stub);
         Evict_Body : constant Cursor := Lib.Add_Child
           (Encl, Diana.Builders.Subprogram_Body
                    (Designator => Evict_Id, Completion => Stub_Node));
      begin
         Lib.Reference (Name => "Sessions.Pool.Evict",
                        Site => Evict_Body, Wanted => "Evict");
         Put_Line ("    'Sessions.Pool' body has: procedure Evict is separate;");
         Show_Body_Status (Evict_Body, "Evict");

         Put_Line ("    attempting to run with subunit "
                   & "'Sessions.Pool.Evict' missing ...");
         begin
            Lib.Require_All_Resolved;
            Put_Line ("    (unexpected) library reported fully resolved");
         exception
            when E : Diana.Library.Missing_Compilation =>
               Put_Line ("    errored out as required: "
                         & Ada.Exceptions.Exception_Message (E));
         end;

         Put_Line ("    merging subunit 'Sessions.Pool.Evict' (parent nested in "
                   & "'Sessions') ...");
         Lib.Merge_Subunit (Name      => "Sessions.Pool.Evict",
                            Parent    => "Sessions.Pool",
                            Enclosing => "Sessions");
         Show_Body_Status (Evict_Body, "Evict");

         Lib.Require_All_Resolved;
         Put_Line ("    all separate compilations present — nested generic and "
                   & "its subunit body both resolved.");
      end;
   end;
   New_Line;

   --  14. Separate compilation of a SUBUNIT OF A SUBUNIT.  Package body 'Driver'
   --      has "procedure Run is separate;"; the subunit 'Driver.Run' in turn has
   --      "procedure Step is separate;", so 'Driver.Run.Step' is a subunit whose
   --      parent is itself a subunit.  A merged subunit is loaded as its own
   --      compilation, so completing the sub-subunit's stub uses the very same
   --      Merge_Subunit, its (recursive) parent lookup finding the loaded subunit.
   Put_Line ("Separate compilation of a subunit of a subunit:");
   declare
      Driver   : constant Cursor := Lib.Add_Compilation ("Driver");
      Run_Id   : constant Cursor := Lib.Add_Child
        (Driver, Diana.Builders.Subprogram_Name
                   (Spelling => SU.To_Unbounded_String ("Run")));
      Run_Stub : constant Cursor := Lib.Add_Child (Driver, Diana.Builders.Stub);
      --  "procedure Run is separate;" in the body of 'Driver'
      Run_Body : constant Cursor := Lib.Add_Child
        (Driver, Diana.Builders.Subprogram_Body
                   (Designator => Run_Id, Completion => Run_Stub));
   begin
      Lib.Reference (Name => "Driver.Run", Site => Run_Body, Wanted => "Run");
      Put_Line ("    built body of 'Driver': procedure Run is separate;");
      Show_Body_Status (Run_Body, "Run");

      Put_Line ("    merging subunit 'Driver.Run' ...");
      Lib.Merge_Subunit (Name => "Driver.Run", Parent => "Driver");
      Show_Body_Status (Run_Body, "Run");

      --  the subunit 'Driver.Run' itself has "procedure Step is separate;"
      declare
         Run_Unit  : constant Cursor := Lib.Require ("Driver.Run");  -- loaded subunit
         Step_Id   : constant Cursor := Lib.Add_Child
           (Run_Unit, Diana.Builders.Subprogram_Name
                        (Spelling => SU.To_Unbounded_String ("Step")));
         Step_Stub : constant Cursor := Lib.Add_Child (Run_Unit, Diana.Builders.Stub);
         Step_Body : constant Cursor := Lib.Add_Child
           (Run_Unit, Diana.Builders.Subprogram_Body
                        (Designator => Step_Id, Completion => Step_Stub));
      begin
         Lib.Reference (Name => "Driver.Run.Step", Site => Step_Body, Wanted => "Step");
         Put_Line ("    subunit 'Driver.Run' body has: procedure Step is separate;");
         Show_Body_Status (Step_Body, "Step");

         Put_Line ("    attempting to run with sub-subunit "
                   & "'Driver.Run.Step' missing ...");
         begin
            Lib.Require_All_Resolved;
            Put_Line ("    (unexpected) library reported fully resolved");
         exception
            when E : Diana.Library.Missing_Compilation =>
               Put_Line ("    errored out as required: "
                         & Ada.Exceptions.Exception_Message (E));
         end;

         Put_Line ("    merging sub-subunit 'Driver.Run.Step' (parent is itself "
                   & "a subunit) ...");
         Lib.Merge_Subunit (Name => "Driver.Run.Step", Parent => "Driver.Run");
         Show_Body_Status (Step_Body, "Step");

         Lib.Require_All_Resolved;
         Put_Line ("    all separate compilations present — subunit and its own "
                   & "subunit both completed.");
      end;
   end;
   New_Line;

   --  15. Separate compilation of a SUBUNIT OF A GRANDCHILD GENERIC PACKAGE.
   --      'Hardware.Devices.Queue' is a generic grandchild (ancestors 'Hardware'
   --      and 'Hardware.Devices' are packages), a three-unit chain; its body
   --      carries "procedure Push is separate;", a subunit
   --      'Hardware.Devices.Queue.Push' separately compiled and completed once
   --      the whole chain is present.
   Put_Line ("Separate compilation of a subunit of a grandchild generic package:");
   declare
      Client9    : constant Cursor := Lib.Add_Compilation ("Client9");
      H_Stub     : constant Cursor := Lib.Require ("Hardware");
      D_Stub     : constant Cursor := Lib.Require ("Hardware.Devices");
      Q_Stub     : constant Cursor := Lib.Require ("Hardware.Devices.Queue");
      H_Ref      : constant Cursor := Lib.Add_Child
        (Client9, Diana.Builders.Used_Name (Definition => H_Stub));
      D_Ref      : constant Cursor := Lib.Add_Child
        (Client9, Diana.Builders.Used_Name (Definition => D_Stub));
      Q_Ref      : constant Cursor := Lib.Add_Child
        (Client9, Diana.Builders.Used_Name (Definition => Q_Stub));
      Inner_Sel  : constant Cursor := Lib.Add_Child
        (Client9, Diana.Builders.Selected_Component
                    (Prefix => H_Ref, Selector => D_Ref));
      Gen_Unit   : constant Cursor := Lib.Add_Child
        (Client9, Diana.Builders.Selected_Component
                    (Prefix => Inner_Sel, Selector => Q_Ref));
      --  "package Q is new Hardware.Devices.Queue;"
      Inst       : constant Cursor := Lib.Add_Child
        (Client9, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit));

      function Outer return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
      function Inner return Cursor is
        (Diana.Accessors.As_Selected_Component (Outer).Prefix);
      function Hardware_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Inner).Prefix);
      function Devices_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Inner).Selector);
      function Queue_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Outer).Selector);
   begin
      Lib.Reference (Name => "Hardware", Site => Hardware_Site,
                     Wanted => "Hardware");
      Lib.Reference (Name => "Hardware.Devices", Site => Devices_Site,
                     Wanted => "Devices");
      Lib.Reference (Name => "Hardware.Devices.Queue", Site => Queue_Site,
                     Wanted => "Queue");
      Put_Line ("    built 'Client9': package Q is new Hardware.Devices.Queue;");
      Show_Resolution (Hardware_Site, "Hardware");
      Show_Resolution (Devices_Site, "Devices");
      Show_Resolution (Queue_Site, "Queue");

      --  merge the chain top-down: package, package, then the grandchild generic
      Put_Line ("    merging 'Hardware', 'Hardware.Devices', then grandchild "
                & "generic 'Hardware.Devices.Queue' ...");
      Lib.Merge (Name => "Hardware", Declared => "Hardware",
                 Kind => Diana.Library.Package_Unit);
      Lib.Merge (Name => "Hardware.Devices", Declared => "Devices",
                 Kind => Diana.Library.Package_Unit, Parent => "Hardware");
      Lib.Merge (Name => "Hardware.Devices.Queue", Declared => "Queue",
                 Kind => Diana.Library.Generic_Package_Unit,
                 Parent => "Hardware.Devices");
      Show_Resolution (Queue_Site, "Queue",
                       Detail => "a generic grandchild of Hardware");

      --  the grandchild generic's body has "procedure Push is separate;"
      declare
         GC_Body   : constant Cursor :=
           Lib.Require ("Hardware.Devices.Queue");  -- loaded grandchild generic
         Push_Id   : constant Cursor := Lib.Add_Child
           (GC_Body, Diana.Builders.Subprogram_Name
                       (Spelling => SU.To_Unbounded_String ("Push")));
         Stub_Node : constant Cursor := Lib.Add_Child (GC_Body, Diana.Builders.Stub);
         Push_Body : constant Cursor := Lib.Add_Child
           (GC_Body, Diana.Builders.Subprogram_Body
                       (Designator => Push_Id, Completion => Stub_Node));
      begin
         Lib.Reference (Name => "Hardware.Devices.Queue.Push",
                        Site => Push_Body, Wanted => "Push");
         Put_Line ("    'Hardware.Devices.Queue' body has: procedure Push is separate;");
         Show_Body_Status (Push_Body, "Push");

         Put_Line ("    attempting to run with subunit "
                   & "'Hardware.Devices.Queue.Push' missing ...");
         begin
            Lib.Require_All_Resolved;
            Put_Line ("    (unexpected) library reported fully resolved");
         exception
            when E : Diana.Library.Missing_Compilation =>
               Put_Line ("    errored out as required: "
                         & Ada.Exceptions.Exception_Message (E));
         end;

         Put_Line ("    merging subunit 'Hardware.Devices.Queue.Push' of the "
                   & "grandchild generic ...");
         Lib.Merge_Subunit (Name   => "Hardware.Devices.Queue.Push",
                            Parent => "Hardware.Devices.Queue");
         Show_Body_Status (Push_Body, "Push");

         Lib.Require_All_Resolved;
         Put_Line ("    all separate compilations present — grandchild generic "
                   & "and its subunit body both resolved.");
      end;
   end;
   New_Line;

   --  16. Separate compilation of a SUBUNIT OF A SUBUNIT OF A GENERIC PACKAGE.
   --      The generic package 'Logger' (resolved via its instantiation) has a
   --      subunit 'Logger.Rotate', which in turn has a subunit
   --      'Logger.Rotate.Archive'.  Each merged subunit is a loaded unit, so the
   --      same Merge_Subunit completes each level of the chain.
   Put_Line ("Separate compilation of a subunit of a subunit of a generic package:");
   declare
      Client10 : constant Cursor := Lib.Add_Compilation ("Client10");
      Gen_Ref  : constant Cursor := Lib.Add_Child
        (Client10, Diana.Builders.Used_Name (Definition => Lib.Require ("Logger")));
      --  "package Log is new Logger;"
      Inst     : constant Cursor := Lib.Add_Child
        (Client10, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Ref));
      function Gen_Site return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst).Generic_Unit);
   begin
      Lib.Reference (Name => "Logger", Site => Gen_Site, Wanted => "Logger");
      Put_Line ("    built 'Client10': package Log is new Logger;");
      Show_Resolution (Gen_Site, "Logger");

      Put_Line ("    merging separately-compiled generic package 'Logger' ...");
      Lib.Merge (Name => "Logger", Declared => "Logger",
                 Kind => Diana.Library.Generic_Package_Unit);
      Show_Resolution (Gen_Site, "Logger");

      --  the generic's body has "procedure Rotate is separate;"
      declare
         Logger_Body : constant Cursor := Lib.Require ("Logger");  -- loaded generic
         Rotate_Id   : constant Cursor := Lib.Add_Child
           (Logger_Body, Diana.Builders.Subprogram_Name
                           (Spelling => SU.To_Unbounded_String ("Rotate")));
         Rotate_Stub : constant Cursor := Lib.Add_Child
           (Logger_Body, Diana.Builders.Stub);
         Rotate_Body : constant Cursor := Lib.Add_Child
           (Logger_Body, Diana.Builders.Subprogram_Body
                           (Designator => Rotate_Id, Completion => Rotate_Stub));
      begin
         Lib.Reference (Name => "Logger.Rotate", Site => Rotate_Body,
                        Wanted => "Rotate");
         Put_Line ("    'Logger' body has: procedure Rotate is separate;");
         Show_Body_Status (Rotate_Body, "Rotate");
         Put_Line ("    merging subunit 'Logger.Rotate' of the generic ...");
         Lib.Merge_Subunit (Name => "Logger.Rotate", Parent => "Logger");
         Show_Body_Status (Rotate_Body, "Rotate");

         --  the subunit 'Logger.Rotate' itself has "procedure Archive is separate;"
         declare
            Rotate_Unit  : constant Cursor :=
              Lib.Require ("Logger.Rotate");  -- loaded subunit
            Archive_Id   : constant Cursor := Lib.Add_Child
              (Rotate_Unit, Diana.Builders.Subprogram_Name
                              (Spelling => SU.To_Unbounded_String ("Archive")));
            Archive_Stub : constant Cursor := Lib.Add_Child
              (Rotate_Unit, Diana.Builders.Stub);
            Archive_Body : constant Cursor := Lib.Add_Child
              (Rotate_Unit, Diana.Builders.Subprogram_Body
                              (Designator => Archive_Id, Completion => Archive_Stub));
         begin
            Lib.Reference (Name => "Logger.Rotate.Archive", Site => Archive_Body,
                           Wanted => "Archive");
            Put_Line ("    subunit 'Logger.Rotate' body has: procedure Archive "
                      & "is separate;");
            Show_Body_Status (Archive_Body, "Archive");

            Put_Line ("    attempting to run with sub-subunit "
                      & "'Logger.Rotate.Archive' missing ...");
            begin
               Lib.Require_All_Resolved;
               Put_Line ("    (unexpected) library reported fully resolved");
            exception
               when E : Diana.Library.Missing_Compilation =>
                  Put_Line ("    errored out as required: "
                            & Ada.Exceptions.Exception_Message (E));
            end;

            Put_Line ("    merging sub-subunit 'Logger.Rotate.Archive' ...");
            Lib.Merge_Subunit (Name => "Logger.Rotate.Archive",
                               Parent => "Logger.Rotate");
            Show_Body_Status (Archive_Body, "Archive");

            Lib.Require_All_Resolved;
            Put_Line ("    all separate compilations present — generic package, "
                      & "its subunit, and its sub-subunit all resolved.");
         end;
      end;
   end;
   New_Line;

   --  17. Separate compilation of a SUBUNIT OF A CHILD PACKAGE OF A GENERIC
   --      PACKAGE.  'Vault.Sealed' is a child of the generic package 'Vault'
   --      (so itself generic, used through a parent instance); its body carries
   --      "procedure Unlock is separate;", a subunit 'Vault.Sealed.Unlock'
   --      separately compiled and completed once the child generic is present.
   Put_Line ("Separate compilation of a subunit of a child package "
             & "of a generic package:");
   declare
      Client11    : constant Cursor := Lib.Add_Compilation ("Client11");
      Vault_Stub  : constant Cursor := Lib.Require ("Vault");
      Sealed_Stub : constant Cursor := Lib.Require ("Vault.Sealed");
      --  "package V_Inst is new Vault;" — a local instance of the generic parent
      Parent_Inst : constant Cursor := Lib.Add_Child
        (Client11, Diana.Builders.Package_Name
                     (Spelling => SU.To_Unbounded_String ("V_Inst")));
      Inst1_Ref   : constant Cursor := Lib.Add_Child
        (Client11, Diana.Builders.Used_Name (Definition => Vault_Stub));
      Inst1       : constant Cursor := Lib.Add_Child
        (Client11, Diana.Builders.Generic_Instantiation (Generic_Unit => Inst1_Ref));
      --  "package S_Inst is new V_Inst.Sealed;" — child of the parent INSTANCE
      Prefix_Ref   : constant Cursor := Lib.Add_Child
        (Client11, Diana.Builders.Used_Name (Definition => Parent_Inst));
      Selector_Ref : constant Cursor := Lib.Add_Child
        (Client11, Diana.Builders.Used_Name (Definition => Sealed_Stub));
      Gen_Unit2    : constant Cursor := Lib.Add_Child
        (Client11, Diana.Builders.Selected_Component
                     (Prefix => Prefix_Ref, Selector => Selector_Ref));
      Inst2        : constant Cursor := Lib.Add_Child
        (Client11, Diana.Builders.Generic_Instantiation (Generic_Unit => Gen_Unit2));

      function Parent_Site return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst1).Generic_Unit);
      function Sel return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst2).Generic_Unit);
      function Inst_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Prefix);
      function Child_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel).Selector);
   begin
      Lib.Reference (Name => "Vault", Site => Parent_Site, Wanted => "Vault");
      Lib.Reference (Name => "Vault.Sealed", Site => Child_Site, Wanted => "Sealed");
      Put_Line ("    built 'Client11': package V_Inst is new Vault;");
      Put_Line ("                      package S_Inst is new V_Inst.Sealed;");
      Show_Resolution (Parent_Site, "Vault");
      Show_Resolution (Inst_Site, "V_Inst", Detail => "a local parent instance");
      Show_Resolution (Child_Site, "Sealed");

      --  merge the generic parent, then the child generic beneath it
      Put_Line ("    merging generic parent 'Vault', then child generic "
                & "'Vault.Sealed' ...");
      Lib.Merge (Name => "Vault", Declared => "Vault",
                 Kind => Diana.Library.Generic_Package_Unit);
      Lib.Merge (Name => "Vault.Sealed", Declared => "Sealed",
                 Kind => Diana.Library.Generic_Package_Unit, Parent => "Vault");
      Show_Resolution (Child_Site, "Sealed", Detail => "a child of generic Vault");

      --  the child generic's body has "procedure Unlock is separate;"
      declare
         Child_Body : constant Cursor := Lib.Require ("Vault.Sealed");  -- loaded child
         Unlock_Id  : constant Cursor := Lib.Add_Child
           (Child_Body, Diana.Builders.Subprogram_Name
                          (Spelling => SU.To_Unbounded_String ("Unlock")));
         Stub_Node  : constant Cursor := Lib.Add_Child
           (Child_Body, Diana.Builders.Stub);
         Unlock_Body : constant Cursor := Lib.Add_Child
           (Child_Body, Diana.Builders.Subprogram_Body
                          (Designator => Unlock_Id, Completion => Stub_Node));
      begin
         Lib.Reference (Name => "Vault.Sealed.Unlock",
                        Site => Unlock_Body, Wanted => "Unlock");
         Put_Line ("    'Vault.Sealed' body has: procedure Unlock is separate;");
         Show_Body_Status (Unlock_Body, "Unlock");

         Put_Line ("    attempting to run with subunit "
                   & "'Vault.Sealed.Unlock' missing ...");
         begin
            Lib.Require_All_Resolved;
            Put_Line ("    (unexpected) library reported fully resolved");
         exception
            when E : Diana.Library.Missing_Compilation =>
               Put_Line ("    errored out as required: "
                         & Ada.Exceptions.Exception_Message (E));
         end;

         Put_Line ("    merging subunit 'Vault.Sealed.Unlock' of the child "
                   & "generic ...");
         Lib.Merge_Subunit (Name   => "Vault.Sealed.Unlock",
                            Parent => "Vault.Sealed");
         Show_Body_Status (Unlock_Body, "Unlock");

         Lib.Require_All_Resolved;
         Put_Line ("    all separate compilations present — child of a generic "
                   & "and its subunit body both resolved.");
      end;
   end;
   New_Line;

   --  18. Separate compilation of a SUBUNIT OF A GRANDCHILD PACKAGE OF A GENERIC
   --      PACKAGE.  'Geometry' is a generic package, 'Geometry.Shapes' a child of
   --      it, 'Geometry.Shapes.Solids' a grandchild — all generic, reached
   --      through TWO instance levels (new Geometry; new G_Inst.Shapes; new
   --      S_Inst.Solids).  The grandchild's body carries "procedure Render is
   --      separate;", a subunit completed once the whole chain is present.
   Put_Line ("Separate compilation of a subunit of a grandchild package "
             & "of a generic package:");
   declare
      Client12    : constant Cursor := Lib.Add_Compilation ("Client12");
      Geo_Stub    : constant Cursor := Lib.Require ("Geometry");
      Shapes_Stub : constant Cursor := Lib.Require ("Geometry.Shapes");
      Solids_Stub : constant Cursor := Lib.Require ("Geometry.Shapes.Solids");
      --  two local parent instances feeding the next instantiation level
      G_Inst : constant Cursor := Lib.Add_Child
        (Client12, Diana.Builders.Package_Name
                     (Spelling => SU.To_Unbounded_String ("G_Inst")));
      S_Inst : constant Cursor := Lib.Add_Child
        (Client12, Diana.Builders.Package_Name
                     (Spelling => SU.To_Unbounded_String ("S_Inst")));
      --  "package G_Inst is new Geometry;"
      Inst1  : constant Cursor := Lib.Add_Child
        (Client12, Diana.Builders.Generic_Instantiation
                     (Generic_Unit => Lib.Add_Child
                        (Client12, Diana.Builders.Used_Name
                                     (Definition => Geo_Stub))));
      --  "package S_Inst is new G_Inst.Shapes;"
      Inst2  : constant Cursor := Lib.Add_Child
        (Client12, Diana.Builders.Generic_Instantiation
                     (Generic_Unit => Lib.Add_Child
                        (Client12, Diana.Builders.Selected_Component
           (Prefix   => Lib.Add_Child (Client12,
                          Diana.Builders.Used_Name (Definition => G_Inst)),
            Selector => Lib.Add_Child (Client12,
                          Diana.Builders.Used_Name (Definition => Shapes_Stub))))));
      --  "package Solids_Inst is new S_Inst.Solids;"
      Inst3  : constant Cursor := Lib.Add_Child
        (Client12, Diana.Builders.Generic_Instantiation
                     (Generic_Unit => Lib.Add_Child
                        (Client12, Diana.Builders.Selected_Component
           (Prefix   => Lib.Add_Child (Client12,
                          Diana.Builders.Used_Name (Definition => S_Inst)),
            Selector => Lib.Add_Child (Client12,
                          Diana.Builders.Used_Name (Definition => Solids_Stub))))));

      function Geo_Site return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst1).Generic_Unit);
      function Sel2 return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst2).Generic_Unit);
      function Shapes_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel2).Selector);
      function Sel3 return Cursor is
        (Diana.Accessors.As_Generic_Instantiation (Inst3).Generic_Unit);
      function Solids_Site return Cursor is
        (Diana.Accessors.As_Selected_Component (Sel3).Selector);
   begin
      Lib.Reference (Name => "Geometry", Site => Geo_Site, Wanted => "Geometry");
      Lib.Reference (Name => "Geometry.Shapes", Site => Shapes_Site,
                     Wanted => "Shapes");
      Lib.Reference (Name => "Geometry.Shapes.Solids", Site => Solids_Site,
                     Wanted => "Solids");
      Put_Line ("    built 'Client12': package G_Inst is new Geometry;");
      Put_Line ("                      package S_Inst is new G_Inst.Shapes;");
      Put_Line ("                      package Solids_Inst is new S_Inst.Solids;");
      Show_Resolution (Geo_Site, "Geometry");
      Show_Resolution (Shapes_Site, "Shapes");
      Show_Resolution (Solids_Site, "Solids");

      --  merge the generic chain top-down (each child via its loaded parent)
      Put_Line ("    merging generics 'Geometry', 'Geometry.Shapes', then "
                & "'Geometry.Shapes.Solids' ...");
      Lib.Merge (Name => "Geometry", Declared => "Geometry",
                 Kind => Diana.Library.Generic_Package_Unit);
      Lib.Merge (Name => "Geometry.Shapes", Declared => "Shapes",
                 Kind => Diana.Library.Generic_Package_Unit, Parent => "Geometry");
      Lib.Merge (Name => "Geometry.Shapes.Solids", Declared => "Solids",
                 Kind => Diana.Library.Generic_Package_Unit,
                 Parent => "Geometry.Shapes");
      Show_Resolution (Solids_Site, "Solids",
                       Detail => "a generic grandchild of Geometry");

      --  the grandchild generic's body has "procedure Render is separate;"
      declare
         GC_Body   : constant Cursor :=
           Lib.Require ("Geometry.Shapes.Solids");  -- loaded grandchild generic
         Render_Id : constant Cursor := Lib.Add_Child
           (GC_Body, Diana.Builders.Subprogram_Name
                       (Spelling => SU.To_Unbounded_String ("Render")));
         Stub_Node : constant Cursor := Lib.Add_Child (GC_Body, Diana.Builders.Stub);
         Render_Body : constant Cursor := Lib.Add_Child
           (GC_Body, Diana.Builders.Subprogram_Body
                       (Designator => Render_Id, Completion => Stub_Node));
      begin
         Lib.Reference (Name => "Geometry.Shapes.Solids.Render",
                        Site => Render_Body, Wanted => "Render");
         Put_Line ("    'Geometry.Shapes.Solids' body has: procedure Render "
                   & "is separate;");
         Show_Body_Status (Render_Body, "Render");

         Put_Line ("    attempting to run with subunit "
                   & "'Geometry.Shapes.Solids.Render' missing ...");
         begin
            Lib.Require_All_Resolved;
            Put_Line ("    (unexpected) library reported fully resolved");
         exception
            when E : Diana.Library.Missing_Compilation =>
               Put_Line ("    errored out as required: "
                         & Ada.Exceptions.Exception_Message (E));
         end;

         Put_Line ("    merging subunit 'Geometry.Shapes.Solids.Render' of the "
                   & "grandchild generic ...");
         Lib.Merge_Subunit (Name   => "Geometry.Shapes.Solids.Render",
                            Parent => "Geometry.Shapes.Solids");
         Show_Body_Status (Render_Body, "Render");

         Lib.Require_All_Resolved;
         Put_Line ("    all separate compilations present — grandchild of a "
                   & "generic and its subunit body both resolved.");
      end;
   end;
end Diana_Harness;
