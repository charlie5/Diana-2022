--  Diana.Nodes — concrete node kinds (a starter slice).
--
--  The full node set is large and maps mechanically from spec/DIANA_2022.idl,
--  so it is intended to be GENERATED from the IDL.  This unit hand-defines the
--  handful of kinds the library/merge machinery needs, to exercise the design.

with Ada.Containers.Vectors;

package Diana.Nodes is

   --  A compilation: the root of one compiled file's subtree.  Its library
   --  items are tree children.
   type Compilation_Node is new Node with record
      Name : Symbol_Rep;
   end record;

   --  A reference back to a pending unit: the referring node (a cursor) paired
   --  with the symbolic label it was resolving — the cursor <-> external-label
   --  duality.  A merge re-targets each referrer to the arrived entity.
   type Referrer is record
      Site   : Cursor;
      Wanted : Symbol_Rep;
   end record;

   package Referrer_Vectors is new Ada.Containers.Vectors (Positive, Referrer);

   --  A placeholder for a with'ed-but-not-yet-loaded compilation.  Holds its
   --  inbound references so a later merge can fix them up in place.
   type Pending_Unit is new Node with record
      Unit_Name : Symbol_Rep;
      Referrers : Referrer_Vectors.Vector;
   end record;

   --  A defining occurrence (the symbol-table entry an entity is known by).
   type Defining_Name is new Node with record
      Spelling : Symbol_Rep;
   end record;

   --  A used occurrence: its Definition cursor points at the Defining_Name it
   --  resolves to — or, until merge, at the Pending_Unit standing in for the
   --  not-yet-loaded compilation that declares it.
   type Used_Name is new Node with record
      Spelling   : Symbol_Rep;
      Definition : Cursor := No_Element;
   end record;

end Diana.Nodes;
