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

   --  The cursor of the unit named Name anywhere in the forest, or No_Element
   --  if absent.  Searches the whole forest (not just the top level) so a child
   --  unit loaded beneath its parent's compilation is still found.
   function Find_Unit (Lib : Instance; Name : String) return Cursor is
      Result : Cursor := No_Element;

      procedure Visit (C : Cursor) is
         Child : Cursor := Trees.First_Child (C);
      begin
         if Result /= No_Element then
            return;
         elsif Unit_Name_Of (Trees.Element (C)) = Name then
            Result := C;
            return;
         end if;
         while Child /= No_Element loop
            Visit (Child);
            exit when Result /= No_Element;
            Child := Trees.Next_Sibling (Child);
         end loop;
      end Visit;

      C : Cursor := Trees.First_Child (Lib.Forest.Root);
   begin
      while C /= No_Element loop
         Visit (C);
         exit when Result /= No_Element;
         C := Trees.Next_Sibling (C);
      end loop;
      return Result;
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

   procedure Merge (Lib : in out Instance; Name : String; Declared : String;
                    Kind : Unit_Kind := Object_Unit; Parent : String := "";
                    Nested : String := "") is
      Stub       : constant Cursor := Find_Unit (Lib, Name);
      Refs       : Referrer_Vectors.Vector;
      Home       : Cursor := Lib.Forest.Root;  --  where the loaded unit is appended
      Comp       : Cursor;
      Outer_Spec : Cursor := No_Element;       --  the package spec (if any)
      Def        : Cursor;
      Nested_Def : Cursor := No_Element;       --  the nested generic (if any)
      Target     : Cursor;
      Doomed     : Cursor;

      procedure Retarget (E : in out Node'Class) is
      begin
         if E in Diana.Nodes.Used_Name'Class then
            Diana.Nodes.Used_Name (E).Definition := Target;
         end if;
      end Retarget;
   begin
      --  A child unit depends on its parent: the parent must already be a
      --  loaded compilation, beneath which the child is loaded.  Checked before
      --  any tree mutation so a premature merge leaves the child stub intact.
      if Parent /= "" then
         Home := Find_Unit (Lib, Parent);
         if Home = No_Element
           or else Trees.Element (Home) not in Loaded_Unit'Class
         then
            raise Missing_Compilation with
              "child unit '" & Name & "' needs its parent '" & Parent
              & "' compiled first";
         end if;
      end if;

      --  Salvage any recorded inbound references before touching the tree.
      if Stub /= No_Element
        and then Trees.Element (Stub) in Pending_Unit'Class
      then
         Refs := Pending_Unit (Trees.Element (Stub)).Referrers;
      end if;

      --  Build the real compilation (beneath its parent if a child unit) and its
      --  single declared entity.  An object unit declares a defining-name node
      --  carrying the entity spelling; a package unit a Package_Name; a generic-
      --  package unit a Generic_Name — both with a (here empty) package
      --  specification, modelling a separately-compiled (child) generic.
      Lib.Forest.Append_Child
        (Home, Loaded_Unit'(Node with Unit_Name => To_Unbounded_String (Name)));
      Comp := Trees.Last_Child (Home);
      case Kind is
         when Object_Unit =>
            Lib.Forest.Append_Child
              (Comp,
               Diana.Builders.Variable_Name
                 (Spelling => To_Unbounded_String (Declared)));
         when Package_Unit =>
            Lib.Forest.Append_Child (Comp, Diana.Builders.Package_Specification);
            Outer_Spec := Trees.Last_Child (Comp);
            Lib.Forest.Append_Child
              (Comp,
               Diana.Builders.Package_Name
                 (Spelling      => To_Unbounded_String (Declared),
                  Specification => Outer_Spec));
         when Generic_Package_Unit =>
            Lib.Forest.Append_Child (Comp, Diana.Builders.Package_Specification);
            Lib.Forest.Append_Child
              (Comp,
               Diana.Builders.Generic_Name
                 (Spelling      => To_Unbounded_String (Declared),
                  Specification => Trees.Last_Child (Comp)));
      end case;
      Def := Trees.Last_Child (Comp);

      --  A generic package NESTED inside this unit's specification: declared as
      --  part of the same compilation (not a separate unit), so this one merge
      --  also makes it available.  It hangs inside the package spec.
      if Nested /= "" then
         declare
            Host : constant Cursor :=
              (if Outer_Spec /= No_Element then Outer_Spec else Comp);
         begin
            Lib.Forest.Append_Child (Host, Diana.Builders.Package_Specification);
            Lib.Forest.Append_Child
              (Host,
               Diana.Builders.Generic_Name
                 (Spelling      => To_Unbounded_String (Nested),
                  Specification => Trees.Last_Child (Host)));
            Nested_Def := Trees.Last_Child (Host);
         end;
      end if;

      --  Re-target every referrer in place: those wanting the unit's entity to
      --  it, and those wanting the nested generic to the nested generic.
      for R of Refs loop
         if To_String (R.Wanted) = Declared then
            Target := Def;
            Lib.Forest.Update_Element (R.Site, Retarget'Access);
         elsif Nested /= "" and then To_String (R.Wanted) = Nested then
            Target := Nested_Def;
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

   procedure Merge_Subunit (Lib : in out Instance; Name : String; Parent : String;
                            Enclosing : String := "")
   is
      --  the loaded compilation that carries the stub: the parent itself for an
      --  ordinary subunit, or an enclosing compilation for a nested-generic one.
      Container : constant String := (if Enclosing /= "" then Enclosing else Parent);
      Stub   : constant Cursor := Find_Unit (Lib, Name);
      Home   : constant Cursor := Find_Unit (Lib, Container);
      Refs   : Referrer_Vectors.Vector;
      Comp   : Cursor;
      Proper : Cursor;          --  the subunit's proper body
      Target : Cursor;
      Doomed : Cursor;

      --  Complete an "is separate" stub: the parent's Subprogram_Body whose
      --  Completion was a Stub now points at the subunit's proper body.
      procedure Complete_Stub (E : in out Node'Class) is
      begin
         if E in Diana.Nodes.Subprogram_Body'Class then
            Diana.Nodes.Subprogram_Body (E).Completion := Target;
         end if;
      end Complete_Stub;
   begin
      --  the stub being completed lives in the enclosing compilation's body, so
      --  that compilation must already be loaded.
      if Home = No_Element or else Trees.Element (Home) not in Loaded_Unit'Class then
         raise Missing_Compilation with
           "subunit '" & Name & "' needs its parent '" & Container
           & "' compiled first";
      end if;

      --  Salvage the recorded body-stub sites before touching the tree.
      if Stub /= No_Element
        and then Trees.Element (Stub) in Pending_Unit'Class
      then
         Refs := Pending_Unit (Trees.Element (Stub)).Referrers;
      end if;

      --  Build the loaded subunit beneath its parent: a Subunit node whose
      --  completion is the proper body (a Subprogram_Body with a Block).
      Lib.Forest.Append_Child
        (Home, Loaded_Unit'(Node with Unit_Name => To_Unbounded_String (Name)));
      Comp := Trees.Last_Child (Home);
      Lib.Forest.Append_Child (Comp, Diana.Builders.Block);
      Lib.Forest.Append_Child
        (Comp, Diana.Builders.Subprogram_Body
                 (Completion => Trees.Last_Child (Comp)));
      Proper := Trees.Last_Child (Comp);
      Lib.Forest.Append_Child
        (Comp, Diana.Builders.Subunit (Completion => Proper));

      --  Complete every recorded "is separate" stub in place.
      for R of Refs loop
         Target := Proper;
         Lib.Forest.Update_Element (R.Site, Complete_Stub'Access);
      end loop;

      --  Discard the now-superseded subunit stub.
      if Stub /= No_Element
        and then Trees.Element (Stub) in Pending_Unit'Class
      then
         Doomed := Stub;
         Lib.Forest.Delete_Subtree (Doomed);
      end if;
   end Merge_Subunit;

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
