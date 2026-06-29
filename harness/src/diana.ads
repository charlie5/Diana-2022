--  ===========================================================================
--  Diana — foundation of the DIANA_2022 interpretive harness.
--
--  The IR (spec/DIANA_2022.idl) is a single-parent class lattice; this package
--  realises it the modern-Ada way (per the design worked out with Shark8):
--
--    * Every node is a tagged type rooted at Diana.Node; the IDL classes become
--      abstract intermediate types and the concrete node kinds become leaves
--      (single inheritance == the single-parent partition).  "Is X a kind of
--      Expression?" is just  X in Expression'Class.
--    * The whole program library is ONE Ada.Containers.Indefinite_Multiway_Tree
--      of Node'Class.  Parent/child edges are the *structural* (as_) attributes;
--      the tree root's children are per-compilation subtrees.
--    * Semantic cross-links and the universal lexical attributes that aren't
--      child nodes live in the node records.  Cross-links are tree Cursors
--      (the in-memory form of a symbolic external label).
--
--  The six DIANA private types are realised below with ordinary Ada types
--  rather than the 1980s paged-work-file form (cf. the reference USERPK).
--  ===========================================================================

with Ada.Containers.Indefinite_Multiway_Trees;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

package Diana is

   package SU renames Ada.Strings.Unbounded;

   --  ---- The six implementation-defined ("private") DIANA types ------------
   type Source_Position is record
      Line   : Natural := 0;
      Column : Natural := 0;
   end record;
   No_Position : constant Source_Position := (0, 0);

   subtype Symbol_Rep is SU.Unbounded_String;   --  identifier/string/char spelling
   subtype Comments   is SU.Unbounded_String;   --  attached comments
   subtype Number_Rep is SU.Unbounded_String;   --  numeric-literal image

   --  A static value (external rep of the IDL Value type / VAL_CLASS).  The
   --  interpreter also uses this as its runtime value type; Access_Value is a
   --  runtime-only addition (an address into the interpreter's heap; 0 = null).
   --  Array_Value / Record_Value carry a handle into the interpreter's array
   --  or record store; Access_Value an address into its heap (0 = null).
   type Value_Kind is (No_Value, String_Value, Boolean_Value,
                       Integer_Value, Real_Value, Access_Value,
                       Array_Value, Record_Value);
   type Static_Value (Kind : Value_Kind := No_Value) is record
      case Kind is
         when No_Value      => null;
         when String_Value  => Text     : Symbol_Rep;
         when Boolean_Value => Flag     : Boolean;
         when Integer_Value => Whole    : Long_Long_Integer;
         when Real_Value    => Number   : Long_Long_Float;
         when Access_Value  => Address  : Natural;
         when Array_Value   => Elements : Natural;
         when Record_Value  => Fields   : Natural;
      end case;
   end record;

   --  ---- The node hierarchy root --------------------------------------------
   --  Carries the universal lexical attributes hoisted onto the IDL Diana_Node
   --  class (named exactly as in the IDL, so generated leaf attributes never
   --  collide with these inherited components).  Concrete kinds (and the
   --  abstract intermediate classes) are declared in Diana.Nodes, generated
   --  from spec/DIANA_2022.idl once the tree — and hence Cursor — exists.
   type Node is abstract tagged record
      Source_Position : Diana.Source_Position := No_Position;        -- lexical
      Comments        : Diana.Comments := SU.Null_Unbounded_String;  -- lexical
   end record;

   --  ---- The library-wide structural tree -----------------------------------
   --  Navigation is by cursor/identity; the predefined class-wide "=" suffices
   --  for the container's needs.
   package Trees is new Ada.Containers.Indefinite_Multiway_Trees
     (Element_Type => Node'Class);

   subtype Tree   is Trees.Tree;
   subtype Cursor is Trees.Cursor;

   No_Element : Cursor renames Trees.No_Element;

   --  ---- The IDL "Seq Of T" idiom -------------------------------------------
   --  A sequence attribute is a vector of cursors to the element subtrees.
   package Node_Lists is new Ada.Containers.Vectors
     (Index_Type => Positive, Element_Type => Cursor, "=" => Trees."=");
   subtype Node_List is Node_Lists.Vector;

end Diana;
