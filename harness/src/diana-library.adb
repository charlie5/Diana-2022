with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Diana.Loading;          use Diana.Loading;
with Diana.Nodes;
with Diana.Builders;

package body Diana.Library is

   use type Trees.Cursor;   --  make "="/"/=" on cursors directly visible

   function Root_Of (Lib : Instance) return Cursor is (Lib.Forest.Root);

   --  Name of a unit node (Loaded_Unit or Pending_Unit); "" otherwise.
   function Unit_Name_Of (N : Node'Class) return String is
   begin
      if N in Loaded_Unit'Class then
         return To_String (Loaded_Unit (N).Unit_Name);
      elsif N in Pending_Unit'Class then
         return To_String (Pending_Unit (N).Unit_Name);
      else
         return "";
      end if;
   end Unit_Name_Of;

   --  The cursor of the top-level unit named Name, or No_Element if absent.
   function Find_Unit (Lib : Instance; Name : String) return Cursor is
      C : Cursor := Trees.First_Child (Lib.Forest.Root);
   begin
      while C /= No_Element loop
         if Unit_Name_Of (Trees.Element (C)) = Name then
            return C;
         end if;
         C := Trees.Next_Sibling (C);
      end loop;
      return No_Element;
   end Find_Unit;

   function Add_Compilation
     (Lib : in out Instance; Name : String) return Cursor is
   begin
      Lib.Forest.Append_Child
        (Lib.Forest.Root,
         Loaded_Unit'(Node with Unit_Name => To_Unbounded_String (Name)));
      return Trees.Last_Child (Lib.Forest.Root);
   end Add_Compilation;

   function Add_Child
     (Lib : in out Instance; Parent : Cursor; N : Node'Class) return Cursor is
   begin
      Lib.Forest.Append_Child (Parent, N);
      return Trees.Last_Child (Parent);
   end Add_Child;

   function Require (Lib : in out Instance; Name : String) return Cursor is
      Found : constant Cursor := Find_Unit (Lib, Name);
   begin
      if Found /= No_Element then
         return Found;
      end if;
      Lib.Forest.Append_Child
        (Lib.Forest.Root,
         Pending_Unit'(Node with
                         Unit_Name => To_Unbounded_String (Name),
                         Referrers => Referrer_Vectors.Empty_Vector));
      return Trees.Last_Child (Lib.Forest.Root);
   end Require;

   procedure Reference
     (Lib : in out Instance; Name : String; Site : Cursor; Wanted : String)
   is
      Stub    : constant Cursor   := Require (Lib, Name);
      New_Ref : constant Referrer :=
        (Site => Site, Wanted => To_Unbounded_String (Wanted));

      procedure Add (E : in out Node'Class) is
      begin
         if E in Pending_Unit'Class then
            Pending_Unit (E).Referrers.Append (New_Ref);
         end if;
      end Add;
   begin
      Lib.Forest.Update_Element (Stub, Add'Access);
   end Reference;

   procedure Merge (Lib : in out Instance; Name : String; Declared : String) is
      Stub   : constant Cursor := Find_Unit (Lib, Name);
      Refs   : Referrer_Vectors.Vector;
      Comp   : Cursor;
      Def    : Cursor;
      Target : Cursor;
      Doomed : Cursor;

      procedure Retarget (E : in out Node'Class) is
      begin
         if E in Diana.Nodes.Used_Name'Class then
            Diana.Nodes.Used_Name (E).Definition := Target;
         end if;
      end Retarget;
   begin
      --  Salvage any recorded inbound references before touching the tree.
      if Stub /= No_Element
        and then Trees.Element (Stub) in Pending_Unit'Class
      then
         Refs := Pending_Unit (Trees.Element (Stub)).Referrers;
      end if;

      --  Build the real compilation and its single declared entity (modelled,
      --  for this demo, as a defining-name node carrying the entity spelling).
      Comp := Add_Compilation (Lib, Name);
      Lib.Forest.Append_Child
        (Comp,
         Diana.Builders.Variable_Name (Spelling => To_Unbounded_String (Declared)));
      Def := Trees.Last_Child (Comp);

      --  Re-target every referrer that wanted the declared entity, in place.
      for R of Refs loop
         if To_String (R.Wanted) = Declared then
            Target := Def;
            Lib.Forest.Update_Element (R.Site, Retarget'Access);
         end if;
      end loop;

      --  Discard the now-superseded stub (its referrers have moved on).
      if Stub /= No_Element
        and then Trees.Element (Stub) in Pending_Unit'Class
      then
         Doomed := Stub;
         Lib.Forest.Delete_Subtree (Doomed);
      end if;
   end Merge;

   function Is_Pending (Lib : Instance; Name : String) return Boolean is
      C : constant Cursor := Find_Unit (Lib, Name);
   begin
      return C /= No_Element
        and then Trees.Element (C) in Pending_Unit'Class;
   end Is_Pending;

   procedure Require_All_Resolved (Lib : Instance) is
      C : Cursor := Trees.First_Child (Lib.Forest.Root);
   begin
      while C /= No_Element loop
         if Trees.Element (C) in Pending_Unit'Class then
            raise Missing_Compilation with
              "missing separate compilation: " & Unit_Name_Of (Trees.Element (C));
         end if;
         C := Trees.Next_Sibling (C);
      end loop;
   end Require_All_Resolved;

end Diana.Library;
