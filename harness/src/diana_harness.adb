--  diana_harness — a first interpretive-harness driver.
--
--  It builds a small program library where the main compilation refers to an
--  entity ("Foo") in a unit ("P") that has NOT been compiled yet, then shows
--  the two required behaviours: error out on the missing separate compilation,
--  and resolve the reference in place once that compilation is merged in.
--
--  The user-program nodes are the generated DIANA IR (Diana.Nodes); the
--  pending-unit bookkeeping is Diana.Loading.

with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Exceptions;
with Diana;          use Diana;
with Diana.Nodes;
with Diana.Loading;
with Diana.Library;

procedure Diana_Harness is
   Lib      : Diana.Library.Instance;
   Main     : Cursor;
   P_Stub   : Cursor;
   Use_Site : Cursor;

   --  Report what the used occurrence at Use_Site currently resolves to.
   procedure Show_Resolution is
      Used : constant Node'Class := Trees.Element (Use_Site);
   begin
      if Used in Diana.Nodes.Used_Name'Class then
         declare
            Def : constant Cursor      := Diana.Nodes.Used_Name (Used).Definition;
            Tgt : constant Node'Class  := Trees.Element (Def);
         begin
            if Tgt in Diana.Nodes.Defining_Occurrence'Class then
               Put_Line ("    'Foo' resolves to defining name """
                         & SU.To_String (Diana.Nodes.Defining_Occurrence (Tgt).Spelling)
                         & """ (a loaded compilation).");
            elsif Tgt in Diana.Loading.Pending_Unit'Class then
               Put_Line ("    'Foo' still points at the stub for unit """
                         & SU.To_String (Diana.Loading.Pending_Unit (Tgt).Unit_Name)
                         & """ (unresolved).");
            end if;
         end;
      end if;
   end Show_Resolution;
begin
   Put_Line ("DIANA_2022 interpretive harness — separate-compilation demo");
   New_Line;

   --  1. Main compilation uses P.Foo; P is only with'ed, so it is a stub.
   Main   := Lib.Add_Compilation ("Main");
   P_Stub := Lib.Require ("P");
   declare
      Used : Diana.Nodes.Used_Name;     --  a used occurrence of P.Foo
   begin
      Used.Definition := P_Stub;        --  initially unresolved (points at the stub)
      Use_Site := Lib.Add_Child (Main, Used);
   end;
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
