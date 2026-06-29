--  Diana.Library — the program library: a forest of compilation subtrees with
--  separate-compilation support.
--
--  The forest root's children are units: either a loaded Compilation_Node
--  subtree or a Pending_Unit stub standing in for a with'ed-but-not-yet-loaded
--  compilation.  References into a not-yet-loaded unit point at its stub and
--  are recorded there; Merge fixes them up in place when the unit arrives.
--  This implements the harness's two stated requirements:
--    * "merge in separately compiled DIANA"  -> Merge
--    * "error out ... (missing separate compilation)" -> Require_All_Resolved

package Diana.Library is

   type Instance is tagged limited private;

   --  Raised by Require_All_Resolved when a with'ed unit was never merged.
   Missing_Compilation : exception;

   --  How a merged separate compilation declares its entity: a plain object,
   --  a package, or a generic package template (a separately-compiled generic).
   type Unit_Kind is (Object_Unit, Package_Unit, Generic_Package_Unit);

   function Root_Of (Lib : Instance) return Cursor;

   --  Append a loaded compilation named Name; return its root cursor.
   function Add_Compilation (Lib : in out Instance; Name : String) return Cursor;

   --  Append node N as a child of Parent; return the new node's cursor.
   function Add_Child (Lib    : in out Instance;
                       Parent : Cursor;
                       N      : Node'Class) return Cursor;

   --  Return the cursor of unit Name, creating a Pending_Unit stub if absent.
   function Require (Lib : in out Instance; Name : String) return Cursor;

   --  Note that the node at Site refers to entity Wanted in unit Name (so a
   --  later Merge can re-target it).  Creates the stub if needed.
   procedure Reference (Lib    : in out Instance;
                        Name   : String;
                        Site   : Cursor;
                        Wanted : String);

   --  Merge a separately-compiled unit: replace its stub with a real
   --  compilation declaring entity Declared, and re-target every recorded
   --  referrer whose wanted entity matches.  Kind selects the declared node:
   --  a plain object (the default), a package, or a generic package template,
   --  so an instantiation that referred to a not-yet-compiled generic resolves
   --  to it.  Parent (non-empty) makes this a child unit, loaded beneath its
   --  parent's compilation; the parent must already be compiled (else
   --  Missing_Compilation), modelling a child unit's dependency on its parent.
   --  Nested (non-empty) additionally declares a generic package nested inside
   --  this (package) unit's specification: a single separate compilation brings
   --  in both the unit and its nested generic, so referrers wanting either the
   --  unit's entity or the nested generic are resolved by this one merge.
   procedure Merge (Lib      : in out Instance;
                    Name     : String;
                    Declared : String;
                    Kind     : Unit_Kind := Object_Unit;
                    Parent   : String := "";
                    Nested   : String := "");

   --  Merge a separately-compiled subunit: complete the "is separate" body stub
   --  in its parent.  Unlike Merge (which resolves name references), this
   --  re-targets each recorded referrer's Subprogram_Body *Completion* from its
   --  Stub to the subunit's proper body, loaded beneath the parent.  The parent
   --  (which carries the stub) must already be compiled, else Missing_Compilation.
   procedure Merge_Subunit (Lib    : in out Instance;
                            Name   : String;
                            Parent : String);

   function Is_Pending (Lib : Instance; Name : String) return Boolean;

   --  Raise Missing_Compilation (named) if any unit is still a stub.
   procedure Require_All_Resolved (Lib : Instance);

private

   type Instance is tagged limited record
      Forest : Tree;
   end record;

end Diana.Library;
