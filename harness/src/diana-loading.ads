--  Diana.Loading — library bookkeeping node kinds.
--
--  These are NOT part of the DIANA IR (they are not in spec/DIANA_2022.idl);
--  they live in the same forest only so the program library can represent
--  units that have been with'ed but not yet compiled, and fix references up
--  when they arrive.  The IR node set proper is the generated Diana.Nodes.

with Ada.Containers.Vectors;

package Diana.Loading is

   --  A loaded compilation, tagged with its unit name.  Its DIANA tree (a
   --  Diana.Nodes.Compilation and below) hangs beneath it as tree children.
   type Loaded_Unit is new Node with record
      Unit_Name : Symbol_Rep;
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

end Diana.Loading;
