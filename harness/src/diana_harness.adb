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

   --  Report what the used occurrence at Use_Site currently resolves to.
   procedure Show_Resolution is
   begin
      if Diana.Accessors.Is_Used_Name (Use_Site) then
         declare
            Def : constant Cursor := Diana.Accessors.As_Used_Name (Use_Site).Definition;
         begin
            if Diana.Accessors.Is_Defining_Occurrence (Def) then
               Put_Line ("    'Foo' resolves to defining name """
                         & SU.To_String (Diana.Accessors.As_Defining_Occurrence (Def).Spelling)
                         & """ (a loaded compilation).");
            elsif Trees.Element (Def) in Diana.Loading.Pending_Unit'Class then
               Put_Line ("    'Foo' still points at the stub for unit """
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
   Show_Resolution;
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
   Show_Resolution;
   New_Line;

   --  4. Now execution is permitted.
   Put_Line ("Re-checking ...");
   Lib.Require_All_Resolved;
   Put_Line ("    all separate compilations present — ready to interpret.");
end Diana_Harness;
