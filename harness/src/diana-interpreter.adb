with Ada.Text_IO;                           use Ada.Text_IO;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Hashed_Sets;
with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Strings.Hash;
with Diana.Accessors;                       use Diana.Accessors;

package body Diana.Interpreter is

   --  Component names in a stable order, so "for ... of" over a record (whose
   --  store is an unordered map) iterates its components deterministically.
   package Name_Vectors is new Ada.Containers.Indefinite_Vectors (Positive, String);
   package Name_Sorting  is new Name_Vectors.Generic_Sorting;

   package Real_IO is new Ada.Text_IO.Float_IO (Long_Long_Float);

   use type Trees.Cursor;

   --  ---- scopes and the scope chain -----------------------------------------
   --  Names are resolved lexically: each scope holds its own bindings (keyed by
   --  defining-occurrence spelling) and points at its enclosing scope.  Scopes
   --  live in one vector and are referred to by index; index 1 is the global
   --  scope (Parent 0).  A block / subprogram call pushes a scope and pops it on
   --  exit, so the vector is a stack and the Parent links give lexical nesting.
   package Value_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Static_Value,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   package Name_Sets is new Ada.Containers.Indefinite_Hashed_Sets
     (Element_Type        => String,
      Hash                => Ada.Strings.Hash,
      Equivalent_Elements => "=");

   --  Generic formal subprograms: the formal's name -> the actual subprogram's
   --  defining occurrence, bound in an instance's call scope.
   package Cursor_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Cursor,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=",
      "="             => Trees."=");

   type Scope is record
      Bindings    : Value_Maps.Map;
      Subs        : Name_Sets.Set;     --  subprograms declared here (static link)
      Formal_Subs : Cursor_Maps.Map;   --  generic formal subprogram -> actual
      Parent      : Natural := 0;      --  enclosing scope index, 0 = none
   end record;

   package Scope_Vectors is new Ada.Containers.Vectors (Positive, Scope);
   package Value_Vectors is new Ada.Containers.Vectors (Positive, Static_Value);
   package Flag_Vectors  is new Ada.Containers.Vectors (Positive, Boolean);

   --  Composite stores: an array value is a vector of element values, a record
   --  value a map of component-name -> value; both are referred to by handle.
   package Array_Store  is new Ada.Containers.Vectors
     (Positive, Value_Vectors.Vector, Value_Vectors."=");
   package Record_Store is new Ada.Containers.Vectors
     (Positive, Value_Maps.Map, Value_Maps."=");

   --  Subprogram-reference store: a Subprogram_Value (from "X'Access") is a
   --  handle into this vector of the referenced subprograms' defining occurrences.
   package Subprogram_Store is new Ada.Containers.Vectors
     (Positive, Cursor, Trees."=");

   --  A subprogram's runtime contract: Pre / Post conditions, the guard and
   --  consequence of each Contract_Cases alternative (parallel lists; a void
   --  guard is "others"), and a Subprogram_Variant expression (decreases).
   type Contract is record
      Pre          : Node_List;
      Post         : Node_List;
      Case_Guards  : Node_List;
      Case_Results : Node_List;
      Variant      : Cursor := No_Element;
   end record;

   package Contract_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Contract,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   --  Active Subprogram_Variant values, a stack per subprogram name, so each
   --  recursive call can check its variant strictly decreased.
   package Variant_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Value_Vectors.Vector,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=",
      "="             => Value_Vectors."=");

   --  Predicate / Type_Invariant conditions keyed by the (sub)type name; the
   --  type name is also the placeholder the condition uses for the value.
   package Predicate_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Node_List,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=",
      "="             => Node_Lists."=");

   --  Which variables are declared with a predicated/invariant-bearing type,
   --  mapping the variable name to that type name (so assignments re-check it).
   package Constraint_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => String,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   --  Enumeration types: the literal spellings in position order (so 'Val maps a
   --  position back to the named value, and 'Succ / 'Pred step by name).
   package Enum_Type_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Name_Vectors.Vector,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=",
      "="             => Name_Vectors."=");

   Global_Scope : constant Positive := 1;

   --  In-flight control transfer.  At most one of Returning / Exiting / Jumping
   --  is set; statement sequences and loops stop when one is pending and the
   --  relevant construct (subprogram, loop, label) consumes it.
   type Environment is limited record
      Scopes       : Scope_Vectors.Vector;
      Heap         : Value_Vectors.Vector;           --  allocated objects (1-based)
      Arrays       : Array_Store.Vector;             --  array values (1-based)
      Records      : Record_Store.Vector;            --  record values (1-based)
      Sub_Refs     : Subprogram_Store.Vector;        --  subprogram references (1-based)
      Contracts    : Contract_Maps.Map;              --  Pre/Post/Cases/Variant by name
      Variants     : Variant_Maps.Map;               --  active variant values per name
      Old_Values   : Value_Maps.Map;                 --  'Old snapshots during a Post check
      Predicates   : Predicate_Maps.Map;             --  predicate/invariant by type name
      Constrained  : Constraint_Maps.Map;            --  variable name -> its type name
      Enum_Types   : Enum_Type_Maps.Map;             --  enum type name -> literal spellings
      Entries      : Cursor_Maps.Map;                --  protected entry name -> Entry_Body
      Accepts      : Cursor_Maps.Map;                --  task entry name -> Accept_Statement
      Accept_Guards : Cursor_Maps.Map;               --  guarded entry name -> guard expr
      Returning    : Boolean      := False;          --  a return is in progress
      Return_Value : Static_Value := (Kind => No_Value);
      Exiting      : Boolean      := False;          --  an exit is in progress
      Exit_Target  : Symbol_Rep   := SU.Null_Unbounded_String;  -- "" = innermost
      Jumping      : Boolean      := False;          --  a goto is in progress
      Goto_Target  : Symbol_Rep   := SU.Null_Unbounded_String;  -- the label
      Raising      : Boolean      := False;          --  an exception is in flight
      Raised       : Symbol_Rep   := SU.Null_Unbounded_String;  -- its name
      Raised_Msg   : Symbol_Rep   := SU.Null_Unbounded_String;  -- its "with" message
      Handling     : Symbol_Rep   := SU.Null_Unbounded_String;  -- exc. now in a handler
      Handling_Msg : Symbol_Rep   := SU.Null_Unbounded_String;  -- its message
      --  the "@" assignment target (Ada 2022): evaluated lazily and cached for
      --  the duration of one assignment's right-hand side.
      Target_Expr  : Cursor       := No_Element;     --  No_Element when not in an assignment
      Target_Scope : Positive     := 1;              --  scope to evaluate it in
      Target_Value : Static_Value := (Kind => No_Value);
      Target_Ready : Boolean      := False;          --  True once "@" has been evaluated
   end record;

   function Pending (Env : Environment) return Boolean
     is (Env.Returning or else Env.Exiting or else Env.Jumping
         or else Env.Raising);

   --  Push a fresh scope whose enclosing scope is Parent; return its index.
   function Enter (Env : in out Environment; Parent : Natural) return Positive is
   begin
      Env.Scopes.Append
        (Scope'(Bindings    => Value_Maps.Empty_Map,
                Subs        => Name_Sets.Empty_Set,
                Formal_Subs => Cursor_Maps.Empty_Map,
                Parent      => Parent));
      return Env.Scopes.Last_Index;
   end Enter;

   --  Pop every scope from Down_To upward (LIFO unwinding).
   procedure Leave (Env : in out Environment; Down_To : Positive) is
   begin
      while not Env.Scopes.Is_Empty and then Env.Scopes.Last_Index >= Down_To loop
         Env.Scopes.Delete_Last;
      end loop;
   end Leave;

   --  Composites have value semantics: a fresh handle with (recursively) copied
   --  contents.  Scalars and access values are returned unchanged, so access
   --  values alias their designated object while arrays / records do not.
   function Copy (Env : in out Environment; Value : Static_Value) return Static_Value is
   begin
      case Value.Kind is
         when Array_Value =>
            declare
               Source : constant Value_Vectors.Vector := Env.Arrays (Value.Elements);
               Target : Value_Vectors.Vector;
            begin
               for E of Source loop
                  Target.Append (Copy (Env, E));
               end loop;
               Env.Arrays.Append (Target);
               return (Kind => Array_Value, Elements => Env.Arrays.Last_Index);
            end;
         when Record_Value =>
            declare
               Source : constant Value_Maps.Map := Env.Records (Value.Fields);
               Target : Value_Maps.Map;
            begin
               for C in Source.Iterate loop
                  Target.Insert (Value_Maps.Key (C), Copy (Env, Value_Maps.Element (C)));
               end loop;
               Env.Records.Append (Target);
               return (Kind => Record_Value, Fields => Env.Records.Last_Index);
            end;
         when others =>
            return Value;
      end case;
   end Copy;

   --  Bind Name in Scope_Index, taking a value copy (composite value semantics).
   procedure Define (Env : in out Environment; Scope_Index : Positive;
                     Name : String; Value : Static_Value) is
   begin
      Env.Scopes.Reference (Scope_Index).Bindings.Include (Name, Copy (Env, Value));
   end Define;

   --  Read a name, walking out through the lexical chain from Current.
   function Lookup (Env : Environment; Current : Positive; Name : String)
     return Static_Value
   is
      I : Natural := Current;
   begin
      while I /= 0 loop
         if Env.Scopes (I).Bindings.Contains (Name) then
            return Env.Scopes (I).Bindings.Element (Name);
         end if;
         I := Env.Scopes (I).Parent;
      end loop;
      raise Interpretation_Error with "unbound variable: " & Name;
   end Lookup;

   --  Like Lookup but yields a No_Value rather than raising when Name is unbound
   --  (used to detect a name bound to a Subprogram_Value, i.e. callable through).
   function Bound_Value (Env : Environment; Current : Positive; Name : String)
     return Static_Value
   is
      I : Natural := Current;
   begin
      while I /= 0 loop
         if Env.Scopes (I).Bindings.Contains (Name) then
            return Env.Scopes (I).Bindings.Element (Name);
         end if;
         I := Env.Scopes (I).Parent;
      end loop;
      return (Kind => No_Value);
   end Bound_Value;

   --  Assign a name: update it in the innermost scope that declares it; if no
   --  scope declares it, introduce it in the global scope (an implicit global).
   procedure Assign (Env : in out Environment; Current : Positive;
                     Name : String; Value : Static_Value)
   is
      I : Natural := Current;
   begin
      while I /= 0 loop
         if Env.Scopes (I).Bindings.Contains (Name) then
            Define (Env, I, Name, Value);
            return;
         end if;
         I := Env.Scopes (I).Parent;
      end loop;
      Define (Env, Global_Scope, Name, Value);
   end Assign;

   --  The static link for a call: the innermost enclosing scope that declares
   --  the subprogram Name (so a nested subprogram closes over that activation's
   --  locals); the global scope if it is a top-level subprogram.
   function Static_Link (Env : Environment; Current : Positive; Name : String)
     return Positive
   is
      I : Natural := Current;
   begin
      while I /= 0 loop
         if Env.Scopes (I).Subs.Contains (Name) then
            return I;
         end if;
         I := Env.Scopes (I).Parent;
      end loop;
      return Global_Scope;
   end Static_Link;

   --  The actual subprogram bound to a generic formal subprogram Name, walking
   --  out through the scope chain; No_Element if Name is not a formal subprogram.
   function Lookup_Formal_Sub (Env : Environment; Current : Positive; Name : String)
     return Cursor
   is
      I : Natural := Current;
   begin
      while I /= 0 loop
         if Env.Scopes (I).Formal_Subs.Contains (Name) then
            return Env.Scopes (I).Formal_Subs.Element (Name);
         end if;
         I := Env.Scopes (I).Parent;
      end loop;
      return No_Element;
   end Lookup_Formal_Sub;

   --  ---- value helpers ------------------------------------------------------
   function Int  (V : Long_Long_Integer) return Static_Value
     is ((Kind => Integer_Value, Whole => V));
   function Bool (V : Boolean) return Static_Value
     is ((Kind => Boolean_Value, Flag => V));
   function Real_V (V : Long_Long_Float) return Static_Value
     is ((Kind => Real_Value, Number => V));
   function Str (V : Symbol_Rep) return Static_Value
     is ((Kind => String_Value, Text => V));

   --  Whole / discrete value: an integer, or an enumeration value (its position).
   function Whole_Of (V : Static_Value) return Long_Long_Integer is
   begin
      case V.Kind is
         when Integer_Value => return V.Whole;
         when Enum_Value    => return V.Pos;
         when others        =>
            raise Interpretation_Error with "expected an integer value";
      end case;
   end Whole_Of;
   function Is_Discrete (V : Static_Value) return Boolean
     is (V.Kind = Integer_Value or else V.Kind = Enum_Value);

   function Bool_Of (V : Static_Value) return Boolean is
   begin
      if V.Kind /= Boolean_Value then
         raise Interpretation_Error with "expected a boolean value";
      end if;
      return V.Flag;
   end Bool_Of;

   --  Numeric values (Integer or Real); a real view promotes an integer.
   function Is_Number (V : Static_Value) return Boolean
     is (V.Kind = Integer_Value or else V.Kind = Real_Value);
   function Real_Of (V : Static_Value) return Long_Long_Float is
   begin
      case V.Kind is
         when Integer_Value => return Long_Long_Float (V.Whole);
         when Real_Value    => return V.Number;
         when Enum_Value    => return Long_Long_Float (V.Pos);
         when others        =>
            raise Interpretation_Error with "expected a numeric value";
      end case;
   end Real_Of;
   function Str_Of (V : Static_Value) return Symbol_Rep is
   begin
      if V.Kind /= String_Value then
         raise Interpretation_Error with "expected a string value";
      end if;
      return V.Text;
   end Str_Of;

   function Image (V : Static_Value; Env : Environment) return String is
   begin
      case V.Kind is
         when Integer_Value =>
            declare
               S : constant String := Long_Long_Integer'Image (V.Whole);
            begin
               return (if S (S'First) = ' ' then S (S'First + 1 .. S'Last) else S);
            end;
         when Boolean_Value => return (if V.Flag then "True" else "False");
         when String_Value  => return SU.To_String (V.Text);
         when Real_Value    =>
            declare
               Buffer : String (1 .. 64);
            begin
               Real_IO.Put (Buffer, V.Number, Aft => 4, Exp => 0);
               return Ada.Strings.Fixed.Trim (Buffer, Ada.Strings.Both);
            end;
         when Access_Value  =>
            return (if V.Address = 0 then "null"
                    else "access #"
                         & Ada.Strings.Fixed.Trim
                             (Natural'Image (V.Address), Ada.Strings.Both));
         when Array_Value   =>
            --  render the elements: "(e1, e2, ...)"
            declare
               Elements : constant Value_Vectors.Vector := Env.Arrays (V.Elements);
               Result   : SU.Unbounded_String := SU.To_Unbounded_String ("(");
            begin
               for I in 1 .. Natural (Elements.Length) loop
                  if I > 1 then
                     SU.Append (Result, ", ");
                  end if;
                  SU.Append (Result, Image (Elements (I), Env));
               end loop;
               SU.Append (Result, ")");
               return SU.To_String (Result);
            end;
         when Record_Value  =>
            --  render the components in component-name order: "(N1 => v1, ...)"
            declare
               Fields : constant Value_Maps.Map := Env.Records (V.Fields);
               Names  : Name_Vectors.Vector;
               Result : SU.Unbounded_String := SU.To_Unbounded_String ("(");
               First  : Boolean := True;
            begin
               for C in Fields.Iterate loop
                  Names.Append (Value_Maps.Key (C));
               end loop;
               Name_Sorting.Sort (Names);
               for N of Names loop
                  if not First then
                     SU.Append (Result, ", ");
                  end if;
                  First := False;
                  SU.Append (Result, N & " => " & Image (Fields.Element (N), Env));
               end loop;
               SU.Append (Result, ")");
               return SU.To_String (Result);
            end;
         when Enum_Value    => return SU.To_String (V.Lit_Name);   --  by name
         when Package_Value => return "(package)";
         when Subprogram_Value => return "(subprogram)";
         when No_Value      => return "<no value>";
      end case;
   end Image;

   --  ---- name / symbol-table helpers ----------------------------------------
   function Spelling_Of (Definition : Cursor) return String is
   begin
      if not Is_Defining_Occurrence (Definition) then
         raise Interpretation_Error with "name has no defining occurrence";
      end if;
      return SU.To_String (As_Defining_Occurrence (Definition).Spelling);
   end Spelling_Of;

   function Definition_Of (Name : Cursor) return Cursor is
   begin
      if    Is_Used_Object (Name) then return As_Used_Object (Name).Definition;
      elsif Is_Used_Name   (Name) then return As_Used_Name   (Name).Definition;
      else
         raise Interpretation_Error with "expected a name with a definition";
      end if;
   end Definition_Of;

   --  The component name of a record-aggregate association ("(Comp => ...)"):
   --  a single value choice naming the component.
   function Field_Name (Assoc : Cursor) return String is
      Choices : constant Node_List :=
        As_Choice_S (As_Named_Association (Assoc).Choices).List;
   begin
      if Natural (Choices.Length) /= 1
        or else not Is_Choice_Expression (Choices (1))
      then
         raise Interpretation_Error with "record aggregate: bad component choice";
      end if;
      return Spelling_Of (Definition_Of (As_Choice_Expression (Choices (1)).Value));
   end Field_Name;

   --  True when a named aggregate's first association selects by an integer
   --  index ("N => ...") rather than a component name -- i.e. it is an ARRAY
   --  aggregate, not a record aggregate (whose choices are component names).
   function First_Choice_Is_Index (Assoc : Cursor) return Boolean is
      Choices : constant Node_List :=
        As_Choice_S (As_Named_Association (Assoc).Choices).List;
   begin
      return not Choices.Is_Empty
        and then Is_Choice_Expression (Choices (1))
        and then Is_Numeric_Literal (As_Choice_Expression (Choices (1)).Value);
   end First_Choice_Is_Index;

   --  Record the Pre / Post aspect conditions of a declaration's Properties
   --  list under the subprogram name, for checking at each call.
   procedure Register_Contracts (Env : in out Environment; Name : String;
                                 Properties : Cursor)
   is
      Result : Contract;
   begin
      if Properties = No_Element or else not Is_Semantic_Property_S (Properties) then
         return;
      end if;
      for P of As_Semantic_Property_S (Properties).List loop
         if Is_Semantic_Property (P) then
            declare
               Identity : constant Cursor := As_Semantic_Property (P).Identity;
               Value    : constant Cursor := As_Semantic_Property (P).Value;
            begin
               if Value = No_Element then
                  null;
               elsif Is_Aspect_Expression (Value) then
                  if Is_Aspect_Pre (Identity) then
                     Result.Pre.Append (As_Aspect_Expression (Value).Value);
                  elsif Is_Aspect_Post (Identity) then
                     Result.Post.Append (As_Aspect_Expression (Value).Value);
                  elsif Is_Aspect_Subprogram_Variant (Identity) then
                     Result.Variant := As_Aspect_Expression (Value).Value;
                  end if;
               elsif Is_Contract_Case_List (Value)
                 and then Is_Aspect_Contract_Cases (Identity)
               then
                  for K of As_Contract_Case_S
                             (As_Contract_Case_List (Value).Cases).List
                  loop
                     Result.Case_Guards.Append (As_Contract_Case (K).Guard);
                     Result.Case_Results.Append (As_Contract_Case (K).Consequence);
                  end loop;
               end if;
            end;
         end if;
      end loop;
      if not Result.Pre.Is_Empty or else not Result.Post.Is_Empty
        or else not Result.Case_Guards.Is_Empty
        or else Result.Variant /= No_Element
      then
         Env.Contracts.Include (Name, Result);
      end if;
   end Register_Contracts;

   --  Record the Predicate / Type_Invariant aspect conditions of a type or
   --  subtype declaration's Properties under its name, for checking on every
   --  assignment to a variable of that (sub)type.
   procedure Register_Predicates (Env : in out Environment; Name : String;
                                  Properties : Cursor)
   is
      Conditions : Node_List;
   begin
      if Properties = No_Element or else not Is_Semantic_Property_S (Properties) then
         return;
      end if;
      for P of As_Semantic_Property_S (Properties).List loop
         if Is_Semantic_Property (P) then
            declare
               Identity : constant Cursor := As_Semantic_Property (P).Identity;
               Value    : constant Cursor := As_Semantic_Property (P).Value;
            begin
               if Value /= No_Element and then Is_Aspect_Expression (Value)
                 and then (Is_Aspect_Predicate (Identity)
                           or else Is_Aspect_Static_Predicate (Identity)
                           or else Is_Aspect_Dynamic_Predicate (Identity)
                           or else Is_Aspect_Type_Invariant (Identity))
               then
                  Conditions.Append (As_Aspect_Expression (Value).Value);
               end if;
            end;
         end if;
      end loop;
      if not Conditions.Is_Empty then
         Env.Predicates.Include (Name, Conditions);
      end if;
   end Register_Predicates;

   --  The (sub)type name an object subtype indication denotes, or "".
   function Subtype_Name_Of (Subtype_Spec : Cursor) return String is
   begin
      if Subtype_Spec = No_Element then
         return "";
      elsif Is_Constrained_Spec (Subtype_Spec) then
         return Spelling_Of (Definition_Of (As_Constrained_Spec (Subtype_Spec).Mark));
      elsif Is_Used_Name (Subtype_Spec) or else Is_Used_Object (Subtype_Spec) then
         return Spelling_Of (Definition_Of (Subtype_Spec));
      else
         return "";
      end if;
   end Subtype_Name_Of;

   --  ---- evaluator / executor / caller (mutually recursive) -----------------
   function Evaluate (Expr : Cursor; Env : in out Environment; Current : Positive)
     return Static_Value;
   procedure Execute (Stmt : Cursor; Env : in out Environment; Current : Positive);
   --  Home, when non-zero, is the call's static link (used for a package-member
   --  call: the static link is the package instance's scope, not a lexical one).
   function Invoke (Definition : Cursor; Actuals : Node_List;
                    Env : in out Environment; Current : Positive;
                    Home : Natural := 0) return Static_Value;
   --  Case-choice helpers (shared by case statements and case expressions);
   --  defined below, forward-declared so Evaluate can use them.
   function Has_Others (Choices : Cursor) return Boolean;
   function Choice_Matches (Choices : Cursor; Selector : Long_Long_Integer;
                            Env : in out Environment; Current : Positive)
     return Boolean;
   --  Evaluate a discrete range "Low .. High" (forward-declared for membership).
   procedure Eval_Range (Discrete_Range : Cursor; Env : in out Environment;
                         Current : Positive; Low, High : out Long_Long_Integer);
   procedure Elaborate (Decls : Node_List; Env : in out Environment;
                        Scope_Index : Positive);
   procedure Instantiate_Package (Name, Completion : Cursor;
                                  Env : in out Environment; Scope_Index : Positive);
   procedure Run_Block_In (Block_Cursor : Cursor; Env : in out Environment;
                           Scope_Index : Positive);

   --  Check a value against the predicate / invariant of Type_Name (the type
   --  name is bound as the placeholder the condition tests).
   procedure Check_Constraint (Env : in out Environment; Type_Name : String;
                               Value : Static_Value; Context : Positive)
   is
   begin
      if not Env.Predicates.Contains (Type_Name) then
         return;
      end if;
      declare
         Temp : constant Positive := Enter (Env, Context);
      begin
         Env.Scopes.Reference (Temp).Bindings.Include (Type_Name, Value);
         for Condition of Env.Predicates.Element (Type_Name) loop
            if not Bool_Of (Evaluate (Condition, Env, Temp)) then
               Leave (Env, Temp);
               raise Assertion_Error with
                 "value violates the predicate/invariant of " & Type_Name;
            end if;
         end loop;
         Leave (Env, Temp);
      end;
   end Check_Constraint;

   --  Elaborate a declarative part into Scope_Index: object declarations
   --  (variables / constants) bind their initialised values (re-checking any
   --  predicate / invariant), subprogram bodies / declarations register for
   --  static links and contracts, and type / subtype declarations register
   --  their predicate or invariant.
   procedure Elaborate (Decls : Node_List; Env : in out Environment;
                        Scope_Index : Positive)
   is
      Task_Bodies : Node_List;   --  task bodies, activated at end of this part

      procedure Declare_Objects (Names, Subtype_Spec, Init : Cursor) is
         Type_Name : constant String := Subtype_Name_Of (Subtype_Spec);
         Constrained : constant Boolean := Env.Predicates.Contains (Type_Name);
         Value : Static_Value := (Kind => No_Value);
      begin
         if Init /= No_Element and then not Is_Void (Init) then
            Value := Evaluate (Init, Env, Scope_Index);
         end if;
         for Nm of As_Defining_Name_S (Names).List loop
            if Constrained then
               Env.Constrained.Include (Spelling_Of (Nm), Type_Name);
               if Init /= No_Element and then not Is_Void (Init) then
                  Check_Constraint (Env, Type_Name, Value, Scope_Index);
               end if;
            end if;
            Define (Env, Scope_Index, Spelling_Of (Nm), Value);
         end loop;
      end Declare_Objects;
   begin
      for D of Decls loop
         if Is_Variable_Declaration (D) then
            Declare_Objects (As_Variable_Declaration (D).Names,
                             As_Variable_Declaration (D).Object_Subtype,
                             As_Variable_Declaration (D).Initialization);
         elsif Is_Constant_Declaration (D) then
            Declare_Objects (As_Constant_Declaration (D).Names,
                             As_Constant_Declaration (D).Object_Subtype,
                             As_Constant_Declaration (D).Initialization);
         elsif Is_Number_Declaration (D) then
            --  a named number "N : constant := <value>;" (no explicit subtype)
            Declare_Objects (As_Number_Declaration (D).Names,
                             No_Element,
                             As_Number_Declaration (D).Static_Value_Expression);
         elsif Is_Subtype_Declaration (D) then
            Register_Predicates (Env, Spelling_Of (As_Subtype_Declaration (D).Name),
                                 As_Subtype_Declaration (D).Properties);
         elsif Is_Type_Declaration (D) then
            Register_Predicates (Env, Spelling_Of (As_Type_Declaration (D).Name),
                                 As_Type_Declaration (D).Properties);
            --  record an enumeration type's literals (in position order) so its
            --  'Val / 'Succ / 'Pred attributes yield named values, not bare ints.
            if Is_Enumeration_Type (As_Type_Declaration (D).Definition) then
               declare
                  Literals : Name_Vectors.Vector;
               begin
                  for Lit of As_Defining_Name_S (As_Enumeration_Type
                    (As_Type_Declaration (D).Definition).Literals).List
                  loop
                     Literals.Append (Spelling_Of (Lit));
                  end loop;
                  Env.Enum_Types.Include
                    (Spelling_Of (As_Type_Declaration (D).Name), Literals);
               end;
            end if;
         elsif Is_Subprogram_Body (D) then
            declare
               Designator : constant Cursor := As_Subprogram_Body (D).Designator;
            begin
               if Is_Subprogram_Name (Designator) then
                  Env.Scopes.Reference (Scope_Index).Subs.Include
                    (Spelling_Of (Designator));
               end if;
            end;
         elsif Is_Subprogram_Declaration (D) then
            declare
               Designator : constant Cursor :=
                 As_Subprogram_Declaration (D).Designator;
            begin
               if Is_Subprogram_Name (Designator) then
                  Env.Scopes.Reference (Scope_Index).Subs.Include
                    (Spelling_Of (Designator));
                  Register_Contracts (Env, Spelling_Of (Designator),
                                      As_Subprogram_Declaration (D).Properties);
               end if;
            end;
         elsif Is_Package_Declaration (D)
           and then Is_Unit_Instantiation (As_Package_Declaration (D).Completion)
         then
            --  "package I is new G (...);" — elaborate the instance now
            Instantiate_Package (As_Package_Declaration (D).Name,
                                 As_Package_Declaration (D).Completion,
                                 Env, Scope_Index);
         elsif Is_Protected_Body (D) then
            --  A protected object: its private state and operations live in a
            --  fresh scope, bound by name to a Package_Value.  A protected
            --  procedure mutates that state (Assign walks out to it); a
            --  protected function reads it.  Mutual exclusion is trivial here
            --  (the interpreter is sequential), so this is the executable core.
            declare
               Scope : constant Positive := Enter (Env, Scope_Index);
            begin
               Elaborate (As_Item_S (As_Protected_Body (D).Operations).List,
                          Env, Scope);
               Define (Env, Scope_Index, Spelling_Of (As_Protected_Body (D).Name),
                       Static_Value'(Kind => Package_Value, Instance => Scope));
            end;
         elsif Is_Task_Body (D) then
            --  A task: defer its body to activation at the end of this
            --  declarative part (below), then run it to completion.
            Task_Bodies.Append (D);
         elsif Is_Entry_Body (D) then
            --  A protected entry: register it by name; a call evaluates its
            --  barrier (in the protected object's scope) before running the body.
            Env.Entries.Include (Spelling_Of (As_Entry_Body (D).Name), D);
         end if;
      end loop;

      --  Activate the declared tasks (after the whole declarative part).  A task
      --  with no entries runs its body to completion (a thread of control,
      --  sequential here).  A task that offers entries instead keeps a persistent
      --  scope: its local state is elaborated, its accept bodies are registered
      --  by entry name, and its name is bound to that scope, so an entry call can
      --  rendezvous with it (run the matching accept body) — see Entry_Call.
      for T of Task_Bodies loop
         declare
            Completion  : constant Cursor := As_Task_Body (T).Completion;
            Scope       : constant Positive := Enter (Env, Scope_Index);
            Has_Accepts : Boolean := False;
         begin
            if Is_Block (Completion) then
               declare
                  Decls : constant Cursor := As_Block (Completion).Declarations;
                  Stmts : constant Cursor := As_Block (Completion).Statements;
               begin
                  if Decls /= No_Element and then Is_Item_S (Decls) then
                     Elaborate (As_Item_S (Decls).List, Env, Scope);
                  end if;
                  if Stmts /= No_Element and then Is_Statement_S (Stmts) then
                     for S of As_Statement_S (Stmts).List loop
                        if Is_Accept_Statement (S) then
                           Env.Accepts.Include
                             (Spelling_Of (Definition_Of
                                (As_Accept_Statement (S).Entry_Name)), S);
                           Has_Accepts := True;
                        elsif Is_Selective_Accept (S) then
                           --  a "select accept E1; or accept E2; ... end select":
                           --  register each alternative's accept (and its guard,
                           --  if any), so a call to any offered entry rendezvous.
                           for Alt of As_Select_Alternative_S
                                        (As_Selective_Accept (S).Alternatives).List
                           loop
                              if Is_Accept_Alternative (Alt) then
                                 declare
                                    Acc : constant Cursor :=
                                      As_Accept_Alternative (Alt).Accept_Statement;
                                    Grd : constant Cursor :=
                                      As_Accept_Alternative (Alt).Guard;
                                    Nm  : constant String := Spelling_Of
                                      (Definition_Of (As_Accept_Statement (Acc).Entry_Name));
                                 begin
                                    Env.Accepts.Include (Nm, Acc);
                                    if Grd /= No_Element and then not Is_Void (Grd) then
                                       Env.Accept_Guards.Include (Nm, Grd);
                                    end if;
                                    Has_Accepts := True;
                                 end;
                              end if;
                           end loop;
                        else
                           Execute (S, Env, Scope);
                        end if;
                     end loop;
                  end if;
               end;
            end if;
            if Has_Accepts then
               Define (Env, Scope_Index, Spelling_Of (As_Task_Body (T).Name),
                       Static_Value'(Kind => Package_Value, Instance => Scope));
            else
               Leave (Env, Scope);   --  no entries: the body ran to completion
            end if;
         end;
      end loop;
   end Elaborate;

   --  Instantiate a generic package: create the instance's scope, bind the
   --  generic formal objects to the actuals, elaborate the template's visible
   --  declarations into that scope, and bind the instance name to a
   --  Package_Value handle so "I.Member" / "I.Sub (...)" resolve through it.
   --
   --  The instance scope nests in its "home" scope: normally the scope where the
   --  instantiation is written (so it sees the enclosing names), but for a child
   --  unit ("package C is new Parent_Instance.Child (...)", a selected generic
   --  name) the parent instance's scope — so the child's declarations see the
   --  parent's members by simple name, just as a real child unit does.
   procedure Instantiate_Package (Name, Completion : Cursor;
                                  Env : in out Environment; Scope_Index : Positive)
   is
      Inst         : constant Cursor := As_Unit_Instantiation (Completion).Instance;
      Generic_Unit : constant Cursor := As_Generic_Instantiation (Inst).Generic_Unit;
      Template     : Cursor;
      Home_Scope   : Positive := Scope_Index;  --  scope the instance nests in
      Gen_Spec     : Cursor;
      Formals      : Node_List;   --  generic formal-object names
      Actuals      : Node_List;   --  the instantiation's actual expressions
      Instance_Scope : Positive;
   begin
      if Is_Selected_Component (Generic_Unit) then     --  a generic child unit
         declare
            Parent_Pkg : constant Static_Value :=
              Evaluate (As_Selected_Component (Generic_Unit).Prefix,
                        Env, Scope_Index);
         begin
            if Parent_Pkg.Kind /= Package_Value then
               raise Interpretation_Error with
                 "parent of a child instantiation is not a package";
            end if;
            Home_Scope := Parent_Pkg.Instance;
            Template := Definition_Of (As_Selected_Component (Generic_Unit).Selector);
         end;
      else
         Template := Definition_Of (Generic_Unit);
      end if;
      Gen_Spec := As_Generic_Name (Template).Specification;

      if not Is_Package_Specification (Gen_Spec) then
         raise Interpretation_Error with
           "instantiating a non-package generic as a package";
      end if;

      for F of As_Generic_Formal_S
                 (As_Generic_Name (Template).Formals).List
      loop
         if Is_Generic_Formal_Object (F) then
            for Nm of As_Defining_Name_S
                        (As_Generic_Formal_Object (F).Names).List
            loop
               Formals.Append (Nm);
            end loop;
         end if;
      end loop;
      for A of As_Association_S
                 (As_Generic_Instantiation (Inst).Associations).List
      loop
         if Is_Positional_Association (A) then
            Actuals.Append (As_Positional_Association (A).Value);
         end if;
      end loop;
      if Natural (Formals.Length) /= Natural (Actuals.Length) then
         raise Interpretation_Error with "wrong number of generic actuals";
      end if;

      --  the instance scope nests in its home (enclosing scope, or the parent
      --  instance for a child); actuals are evaluated where the instance is written
      Instance_Scope := Enter (Env, Home_Scope);
      for I in 1 .. Natural (Formals.Length) loop
         Define (Env, Instance_Scope, Spelling_Of (Formals (I)),
                 Evaluate (Actuals (I), Env, Scope_Index));
      end loop;
      Elaborate (As_Declaration_S
                   (As_Package_Specification (Gen_Spec).Visible_Declarations).List,
                 Env, Instance_Scope);

      Define (Env, Scope_Index, Spelling_Of (Name),
              Static_Value'(Kind => Package_Value, Instance => Instance_Scope));
   end Instantiate_Package;

   --  Elaborate a Block's declarations into Scope_Index, then run its
   --  statements there (used for both block statements and subprogram bodies).
   --  A handler is either an Exception_Handler ("when E : ... =>", carrying a
   --  choice parameter) or a plain Case_Alternative ("when ... =>").  Its parts:
   function Handler_Choices (Alt : Cursor) return Cursor is
     (if Is_Exception_Handler (Alt) then As_Exception_Handler (Alt).Choices
      else As_Case_Alternative (Alt).Choices);
   function Handler_Statements (Alt : Cursor) return Cursor is
     (if Is_Exception_Handler (Alt) then As_Exception_Handler (Alt).Statements
      else As_Case_Alternative (Alt).Statements);
   function Is_Handler (Alt : Cursor) return Boolean is
     (Is_Exception_Handler (Alt) or else Is_Case_Alternative (Alt));

   --  Does a handler ("when E1 | E2 | others => ...") catch Exception_Name?
   function Handler_Matches (Alt : Cursor; Exception_Name : String) return Boolean is
   begin
      for C of As_Choice_S (Handler_Choices (Alt)).List loop
         if Is_Others_Choice (C) then
            return True;
         elsif Is_Choice_Expression (C)
           and then Spelling_Of (Definition_Of (As_Choice_Expression (C).Value))
                    = Exception_Name
         then
            return True;
         end if;
      end loop;
      return False;
   end Handler_Matches;

   procedure Run_Block_In (Block_Cursor : Cursor; Env : in out Environment;
                           Scope_Index : Positive)
   is
      Declarations : constant Cursor := As_Block (Block_Cursor).Declarations;
      Statements   : constant Cursor := As_Block (Block_Cursor).Statements;
      Handlers     : constant Cursor := As_Block (Block_Cursor).Handlers;
   begin
      if Declarations /= No_Element and then Is_Item_S (Declarations) then
         Elaborate (As_Item_S (Declarations).List, Env, Scope_Index);
      end if;
      if Statements /= No_Element and then Is_Statement_S (Statements) then
         Execute (Statements, Env, Scope_Index);
      end if;

      --  exception handlers: a "when E | others => ..." catching the in-flight
      --  exception clears it and runs its statements in this block's scope.
      if Env.Raising and then Handlers /= No_Element
        and then Is_Alternative_S (Handlers)
      then
         declare
            Name : constant String := SU.To_String (Env.Raised);
         begin
            for Alt of As_Alternative_S (Handlers).List loop
               if Is_Handler (Alt) and then Handler_Matches (Alt, Name) then
                  --  enter the handler: record the exception being handled (for
                  --  a bare "raise;", Exception_Message, Exception_Name, and the
                  --  "when E : ..." choice parameter), saving the outer one
                  declare
                     Saved_Handling : constant Symbol_Rep := Env.Handling;
                     Saved_Message  : constant Symbol_Rep := Env.Handling_Msg;
                  begin
                     Env.Handling     := Env.Raised;
                     Env.Handling_Msg := Env.Raised_Msg;
                     Env.Raising := False;
                     Execute (Handler_Statements (Alt), Env, Scope_Index);
                     Env.Handling     := Saved_Handling;
                     Env.Handling_Msg := Saved_Message;
                  end;
                  exit;
               end if;
            end loop;
         end;
      end if;
   end Run_Block_In;

   function Apply (Op : Cursor; Args : Node_List; Env : in out Environment;
                   Current : Positive) return Static_Value
   is
      function Operand (I : Positive) return Static_Value is
      begin
         if I > Natural (Args.Length) then
            raise Interpretation_Error with "operator: missing operand";
         end if;
         return Evaluate (As_Positional_Association (Args (I)).Value, Env, Current);
      end Operand;

      --  +, -, *, / : integer if both operands are integers, else real.
      function Arithmetic (L, R : Static_Value) return Static_Value is
      begin
         if L.Kind = Integer_Value and then R.Kind = Integer_Value then
            if    Is_Op_Plus (Op)     then return Int (L.Whole + R.Whole);
            elsif Is_Op_Minus (Op)    then return Int (L.Whole - R.Whole);
            elsif Is_Op_Multiply (Op) then return Int (L.Whole * R.Whole);
            else                           return Int (L.Whole / R.Whole);  -- /
            end if;
         elsif Is_Number (L) and then Is_Number (R) then
            declare
               X : constant Long_Long_Float := Real_Of (L);
               Y : constant Long_Long_Float := Real_Of (R);
            begin
               if    Is_Op_Plus (Op)     then return Real_V (X + Y);
               elsif Is_Op_Minus (Op)    then return Real_V (X - Y);
               elsif Is_Op_Multiply (Op) then return Real_V (X * Y);
               else                           return Real_V (X / Y);
               end if;
            end;
         else
            raise Interpretation_Error with "arithmetic on non-numeric values";
         end if;
      end Arithmetic;

      --  Equality / ordering over discretes (integers / enumerations), reals,
      --  strings (and booleans / access for =).
      function Equal (A, B : Static_Value) return Boolean is
      begin
         if Is_Discrete (A) and then Is_Discrete (B) then
            return Whole_Of (A) = Whole_Of (B);
         elsif Is_Number (A) and then Is_Number (B) then
            return Real_Of (A) = Real_Of (B);
         elsif A.Kind = Boolean_Value and then B.Kind = Boolean_Value then
            return A.Flag = B.Flag;
         elsif A.Kind = String_Value and then B.Kind = String_Value then
            return SU."=" (A.Text, B.Text);
         elsif A.Kind = Access_Value and then B.Kind = Access_Value then
            return A.Address = B.Address;   --  same designated object (or both null)
         elsif A.Kind = Array_Value and then B.Kind = Array_Value then
            --  array equality: same length and equal elements (element-wise).
            declare
               EA : constant Value_Vectors.Vector := Env.Arrays (A.Elements);
               EB : constant Value_Vectors.Vector := Env.Arrays (B.Elements);
            begin
               if Natural (EA.Length) /= Natural (EB.Length) then
                  return False;
               end if;
               for I in 1 .. Natural (EA.Length) loop
                  if not Equal (EA (I), EB (I)) then
                     return False;
                  end if;
               end loop;
               return True;
            end;
         elsif A.Kind = Record_Value and then B.Kind = Record_Value then
            --  record equality: same components, each pair equal.
            declare
               FA : constant Value_Maps.Map := Env.Records (A.Fields);
               FB : constant Value_Maps.Map := Env.Records (B.Fields);
            begin
               if Natural (FA.Length) /= Natural (FB.Length) then
                  return False;
               end if;
               for C in FA.Iterate loop
                  if not FB.Contains (Value_Maps.Key (C))
                    or else not Equal (Value_Maps.Element (C),
                                       FB.Element (Value_Maps.Key (C)))
                  then
                     return False;
                  end if;
               end loop;
               return True;
            end;
         else
            raise Interpretation_Error with "incompatible operands in comparison";
         end if;
      end Equal;

      function Less (A, B : Static_Value) return Boolean is
      begin
         if Is_Discrete (A) and then Is_Discrete (B) then
            return Whole_Of (A) < Whole_Of (B);
         elsif Is_Number (A) and then Is_Number (B) then
            return Real_Of (A) < Real_Of (B);
         elsif A.Kind = String_Value and then B.Kind = String_Value then
            return SU."<" (A.Text, B.Text);
         elsif A.Kind = Array_Value and then B.Kind = Array_Value then
            --  lexicographic order over one-dimensional arrays: compare element
            --  by element; if one is a prefix of the other, the shorter is less.
            declare
               EA : constant Value_Vectors.Vector := Env.Arrays (A.Elements);
               EB : constant Value_Vectors.Vector := Env.Arrays (B.Elements);
               N  : constant Natural :=
                 Natural'Min (Natural (EA.Length), Natural (EB.Length));
            begin
               for I in 1 .. N loop
                  if Less (EA (I), EB (I)) then
                     return True;
                  elsif Less (EB (I), EA (I)) then
                     return False;
                  end if;
               end loop;
               return Natural (EA.Length) < Natural (EB.Length);
            end;
         else
            raise Interpretation_Error with "incompatible operands in comparison";
         end if;
      end Less;
   begin
      if Is_Op_Unary_Minus (Op) then
         declare
            V : constant Static_Value := Operand (1);
         begin
            if V.Kind = Integer_Value then return Int (-V.Whole);
            else return Real_V (-Real_Of (V)); end if;
         end;
      elsif Is_Op_Unary_Plus (Op) then return Operand (1);
      elsif Is_Op_Absolute (Op) then
         declare
            V : constant Static_Value := Operand (1);
         begin
            if V.Kind = Integer_Value then return Int (abs V.Whole);
            else return Real_V (abs Real_Of (V)); end if;
         end;
      elsif Is_Op_Not (Op) then return Bool (not Bool_Of (Operand (1)));
      end if;

      declare
         L : constant Static_Value := Operand (1);
         R : constant Static_Value := Operand (2);
      begin
         if    Is_Op_Plus (Op) or else Is_Op_Minus (Op)
            or else Is_Op_Multiply (Op) or else Is_Op_Divide (Op)
         then
            return Arithmetic (L, R);
         elsif Is_Op_Modulo (Op)       then return Int (Whole_Of (L) mod Whole_Of (R));
         elsif Is_Op_Remainder (Op)    then return Int (Whole_Of (L) rem Whole_Of (R));
         elsif Is_Op_Exponentiate (Op) then
            if L.Kind = Integer_Value then
               return Int (L.Whole ** Natural (Whole_Of (R)));
            else
               return Real_V (Real_Of (L) ** Natural (Whole_Of (R)));
            end if;
         elsif Is_Op_Concatenate (Op) then
            if L.Kind = Array_Value or else R.Kind = Array_Value then
               --  array concatenation: array & array, array & element, and
               --  element & array -- a fresh array with value semantics.
               declare
                  Result : Value_Vectors.Vector;
                  procedure Add_Side (V : Static_Value) is
                  begin
                     if V.Kind = Array_Value then
                        --  snapshot first: Copy may grow Env.Arrays and so
                        --  invalidate a reference into it (see Copy).
                        declare
                           Source : constant Value_Vectors.Vector :=
                             Env.Arrays (V.Elements);
                        begin
                           for E of Source loop
                              Result.Append (Copy (Env, E));
                           end loop;
                        end;
                     else
                        Result.Append (Copy (Env, V));
                     end if;
                  end Add_Side;
               begin
                  Add_Side (L);
                  Add_Side (R);
                  Env.Arrays.Append (Result);
                  return (Kind => Array_Value, Elements => Env.Arrays.Last_Index);
               end;
            else
               return Str (SU."&" (Str_Of (L), Str_Of (R)));
            end if;
         elsif Is_Op_And (Op) then return Bool (Bool_Of (L) and Bool_Of (R));
         elsif Is_Op_Or (Op)  then return Bool (Bool_Of (L) or Bool_Of (R));
         elsif Is_Op_Xor (Op) then return Bool (Bool_Of (L) xor Bool_Of (R));
         elsif Is_Op_Equal (Op)         then return Bool (Equal (L, R));
         elsif Is_Op_Not_Equal (Op)     then return Bool (not Equal (L, R));
         elsif Is_Op_Less (Op)          then return Bool (Less (L, R));
         elsif Is_Op_Less_Equal (Op)    then return Bool (not Less (R, L));
         elsif Is_Op_Greater (Op)       then return Bool (Less (R, L));
         elsif Is_Op_Greater_Equal (Op) then return Bool (not Less (L, R));
         else
            raise Interpretation_Error with "unsupported operator";
         end if;
      end;
   end Apply;

   --  Call a user-defined subprogram.  The call scope's lexical parent is the
   --  global scope (top-level subprogram); recursion nests fresh call scopes.
   function Invoke (Definition : Cursor; Actuals : Node_List;
                    Env : in out Environment; Current : Positive;
                    Home : Natural := 0) return Static_Value
   is
      Spec      : Cursor := As_Subprogram_Name (Definition).Specification;
      Comp      : Cursor := As_Subprogram_Name (Definition).Completion;
      Params    : Node_List;
      Formals   : Node_List;          --  formal defining names, flattened
      Actuals_E : Node_List;          --  actual expressions (parallel to Formals)
      Copy_In   : Flag_Vectors.Vector;  --  in / in out: copy actual into formal
      Copy_Back : Flag_Vectors.Vector;  --  out / in out: copy formal back to actual
      Values    : Value_Vectors.Vector;
      Gen_Formal_Nodes : Node_List;   --  generic formals (objects + subprograms)
      Gen_Actuals      : Node_List;   --  the instantiation's actuals (parallel)
      Gen_Out_Formals  : Node_List;   --  in-out formal-object names (copy back)
      Gen_Out_Actuals  : Node_List;   --  their actual variables (parallel)
      Call      : Positive;
      Count     : Natural;
      Result    : Static_Value;
      Name      : constant String := Spelling_Of (Definition);
      Selected  : Cursor := No_Element;   --  chosen Contract_Cases consequence
      Old_Snap  : Value_Maps.Map;         --  parameter values at entry (for 'Old)
      Pushed    : Boolean := False;       --  this call pushed a variant value
   begin
      --  A generic instance ("F is new G (...)"): redirect to the generic
      --  template's profile and body, capturing the generic formal -> actual
      --  binding to apply (alongside the call parameters) in the call scope.
      if Is_Unit_Instantiation (Comp) then
         declare
            Inst     : constant Cursor := As_Unit_Instantiation (Comp).Instance;
            Template : constant Cursor :=
              Definition_Of (As_Generic_Instantiation (Inst).Generic_Unit);
            Gen_Spec : constant Cursor := As_Generic_Name (Template).Specification;
         begin
            if not Is_Generic_Subprogram_Header (Gen_Spec) then
               raise Interpretation_Error with
                 "only generic subprograms can be instantiated";
            end if;
            Spec := As_Generic_Subprogram_Header (Gen_Spec).Profile;
            Comp := As_Generic_Name (Template).Completion;
            --  collect the generic formals (objects and subprograms) in order,
            --  parallel to the instantiation's positional actuals
            for F of As_Generic_Formal_S
                       (As_Generic_Name (Template).Formals).List
            loop
               Gen_Formal_Nodes.Append (F);
            end loop;
            for A of As_Association_S
                       (As_Generic_Instantiation (Inst).Associations).List
            loop
               if Is_Positional_Association (A) then
                  Gen_Actuals.Append (As_Positional_Association (A).Value);
               end if;
            end loop;
         end;
      end if;

      if    Is_Procedure_Header (Spec) then
         Params := As_Parameter_S (As_Procedure_Header (Spec).Parameters).List;
      elsif Is_Function_Header (Spec) then
         Params := As_Parameter_S (As_Function_Header (Spec).Parameters).List;
      else
         raise Interpretation_Error with "subprogram specification is not callable";
      end if;

      --  flatten the formals, recording each one's mode
      for P of Params loop
         declare
            Names    : Cursor;
            In_Mode  : constant Boolean :=
              Is_In_Parameter (P) or else Is_In_Out_Parameter (P);
            Out_Mode : constant Boolean :=
              Is_Out_Parameter (P) or else Is_In_Out_Parameter (P);
         begin
            if    Is_In_Parameter (P)     then Names := As_In_Parameter (P).Names;
            elsif Is_Out_Parameter (P)    then Names := As_Out_Parameter (P).Names;
            elsif Is_In_Out_Parameter (P) then Names := As_In_Out_Parameter (P).Names;
            else raise Interpretation_Error with "unsupported parameter kind";
            end if;
            for Nm of As_Defining_Name_S (Names).List loop
               Formals.Append (Nm);
               Copy_In.Append (In_Mode);
               Copy_Back.Append (Out_Mode);
            end loop;
         end;
      end loop;

      for A of Actuals loop
         Actuals_E.Append (As_Positional_Association (A).Value);
      end loop;

      Count := Natural (Formals.Length);
      if Count /= Natural (Actuals_E.Length) then
         raise Interpretation_Error with "wrong number of arguments in call";
      end if;
      if Is_Stub (Comp) then
         raise Interpretation_Error with
           "body of " & Name & " is separate — its subunit is not compiled";
      elsif not Is_Block (Comp) then
         raise Interpretation_Error with "subprogram body is not available";
      end if;

      --  copy actuals in (in the caller's scope); an out formal starts unset
      for I in 1 .. Count loop
         if Copy_In (I) then
            Values.Append (Evaluate (Actuals_E (I), Env, Current));
         else
            Values.Append (Static_Value'(Kind => No_Value));
         end if;
      end loop;

      --  the call scope's lexical parent is where the subprogram was declared:
      --  the package instance scope for a member call (Home), else the static
      --  link found from the caller.
      Call := Enter (Env,
                     (if Home /= 0 then Home else Static_Link (Env, Current, Name)));
      for I in 1 .. Count loop
         Define (Env, Call, Spelling_Of (Formals (I)), Values (I));
      end loop;

      --  bind the generic formals to the instantiation's actuals (for an
      --  instance): a formal object binds to the actual's value; a formal
      --  subprogram binds (in Formal_Subs) to the actual subprogram, so calls
      --  to the formal inside the template dispatch to it.  Evaluated/resolved
      --  in the caller's scope.  Actuals are positional; a formal beyond the
      --  supplied actuals falls back to its DEFAULT (object: a Default
      --  expression; subprogram: a Default_Name), else it is a missing actual.
      if Natural (Gen_Actuals.Length) > Natural (Gen_Formal_Nodes.Length) then
         Leave (Env, Call);
         raise Interpretation_Error with "too many generic actuals in " & Name;
      end if;
      for I in 1 .. Natural (Gen_Formal_Nodes.Length) loop
         declare
            F          : constant Cursor := Gen_Formal_Nodes (I);
            Has_Actual : constant Boolean := I <= Natural (Gen_Actuals.Length);
            A          : constant Cursor :=
              (if Has_Actual then Gen_Actuals (I) else No_Element);
         begin
            if Is_Generic_Formal_Object (F) then
               declare
                  Value_Expr : constant Cursor :=
                    (if Has_Actual then A
                     else As_Generic_Formal_Object (F).Default);
               begin
                  if Value_Expr = No_Element or else Is_Void (Value_Expr) then
                     Leave (Env, Call);
                     raise Interpretation_Error with
                       "missing generic actual (no default) in " & Name;
                  end if;
                  declare
                     Formal_Name : constant Cursor := As_Defining_Name_S
                       (As_Generic_Formal_Object (F).Names).List.First_Element;
                  begin
                     Define (Env, Call, Spelling_Of (Formal_Name),
                             Evaluate (Value_Expr, Env, Current));
                     --  an "in out" formal aliases its actual variable: record
                     --  it so the formal's final value is copied back on exit.
                     if Has_Actual
                       and then Is_Generic_In_Out (As_Generic_Formal_Object (F).Mode)
                     then
                        Gen_Out_Formals.Append (Formal_Name);
                        Gen_Out_Actuals.Append (A);
                     end if;
                  end;
               end;
            elsif Is_Generic_Formal_Subprogram (F) then
               declare
                  Default : constant Cursor :=
                    As_Generic_Formal_Subprogram (F).Default;
                  Actual_Sub : Cursor;
               begin
                  if Has_Actual then
                     Actual_Sub := Definition_Of (A);
                  elsif Is_Default_Name (Default) then
                     Actual_Sub := Definition_Of (As_Default_Name (Default).Subprogram);
                  else
                     Leave (Env, Call);
                     raise Interpretation_Error with
                       "missing generic subprogram actual (no default) in " & Name;
                  end if;
                  Env.Scopes.Reference (Call).Formal_Subs.Include
                    (Spelling_Of (As_Subprogram_Declaration
                       (As_Generic_Formal_Subprogram (F).Specification).Designator),
                     Actual_Sub);
               end;
            elsif Is_Generic_Formal_Type_Declaration (F) then
               null;  --  a formal type is erased at runtime (values are
                      --  dynamically typed); the actual type name binds nothing,
                      --  it only consumes its positional actual slot.
            elsif Is_Generic_Formal_Package (F) then
               --  a formal package binds to the actual instance's value (a
               --  Package_Value), so "P.Member" inside the template resolves
               --  through the actual instance's scope.
               if not Has_Actual then
                  Leave (Env, Call);
                  raise Interpretation_Error with
                    "missing generic package actual in " & Name;
               end if;
               Define (Env, Call,
                       Spelling_Of (As_Generic_Formal_Package (F).Name),
                       Evaluate (A, Env, Current));
            else
               Leave (Env, Call);
               raise Interpretation_Error with
                 "unsupported generic formal in " & Name;
            end if;
         end;
      end loop;

      --  contract checks at entry: Pre, Contract_Cases guard selection, and
      --  the Subprogram_Variant strict-decrease check.
      if Env.Contracts.Contains (Name) then
         declare
            C : constant Contract := Env.Contracts.Element (Name);
            Entry_Bindings : constant Value_Maps.Map := Env.Scopes (Call).Bindings;
         begin
            --  snapshot the parameters' entry values for 'Old in the postcondition
            for B in Entry_Bindings.Iterate loop
               Old_Snap.Include (Value_Maps.Key (B),
                                 Copy (Env, Value_Maps.Element (B)));
            end loop;

            for Condition of C.Pre loop
               if not Bool_Of (Evaluate (Condition, Env, Call)) then
                  Leave (Env, Call);
                  raise Assertion_Error with "precondition failed in " & Name;
               end if;
            end loop;

            if not C.Case_Guards.Is_Empty then
               declare
                  Others_At : Natural := 0;
               begin
                  for I in 1 .. Natural (C.Case_Guards.Length) loop
                     if C.Case_Guards (I) = No_Element
                       or else Is_Void (C.Case_Guards (I))
                     then
                        Others_At := I;
                     elsif Bool_Of (Evaluate (C.Case_Guards (I), Env, Call)) then
                        Selected := C.Case_Results (I);
                        exit;
                     end if;
                  end loop;
                  if Selected = No_Element and then Others_At /= 0 then
                     Selected := C.Case_Results (Others_At);
                  end if;
                  if Selected = No_Element then
                     Leave (Env, Call);
                     raise Assertion_Error with "no contract case applies in " & Name;
                  end if;
               end;
            end if;

            if C.Variant /= No_Element then
               declare
                  V : constant Static_Value := Evaluate (C.Variant, Env, Call);
               begin
                  if Env.Variants.Contains (Name)
                    and then not Env.Variants.Element (Name).Is_Empty
                    and then Whole_Of (V)
                             >= Whole_Of (Env.Variants.Element (Name).Last_Element)
                  then
                     Leave (Env, Call);
                     raise Assertion_Error with
                       "subprogram variant does not decrease in " & Name;
                  end if;
                  if not Env.Variants.Contains (Name) then
                     Env.Variants.Insert (Name, Value_Vectors.Empty_Vector);
                  end if;
                  Env.Variants.Reference (Name).Append (V);
                  Pushed := True;
               end;
            end if;
         end;
      end if;

      Env.Returning    := False;
      Env.Return_Value := (Kind => No_Value);
      Run_Block_In (Comp, Env, Call);
      Result := Env.Return_Value;
      Env.Returning := False;
      if Env.Exiting or else Env.Jumping then
         raise Interpretation_Error with "exit or goto cannot leave a subprogram";
      end if;

      --  On normal completion (no exception propagating): exit contract checks
      --  ("Result" bound) — Post and the selected Contract_Cases consequence —
      --  then copy back out / in out formals.  An exception skips both and just
      --  propagates out of the subprogram.
      if not Env.Raising then
         if Env.Contracts.Contains (Name) then
            declare
               C         : constant Contract := Env.Contracts.Element (Name);
               Saved_Old : constant Value_Maps.Map := Env.Old_Values;
            begin
               Define (Env, Call, "Result", Result);
               Env.Old_Values := Old_Snap;    --  'Old visible to Post / consequences
               for Condition of C.Post loop
                  if not Bool_Of (Evaluate (Condition, Env, Call)) then
                     Leave (Env, Call);
                     raise Assertion_Error with "postcondition failed in " & Name;
                  end if;
               end loop;
               if Selected /= No_Element
                 and then not Bool_Of (Evaluate (Selected, Env, Call))
               then
                  Leave (Env, Call);
                  raise Assertion_Error with "contract case failed in " & Name;
               end if;
               Env.Old_Values := Saved_Old;   --  restore the caller's 'Old (if any)
            end;
         end if;

         for I in 1 .. Count loop
            if Copy_Back (I) then
               declare
                  Final  : constant Static_Value :=
                    Lookup (Env, Call, Spelling_Of (Formals (I)));
                  Target : constant String :=
                    Spelling_Of (Definition_Of (Actuals_E (I)));
               begin
                  Assign (Env, Current, Target, Final);
               end;
            end if;
         end loop;

         --  copy back each "in out" generic formal object to its actual variable
         for I in 1 .. Natural (Gen_Out_Formals.Length) loop
            Assign (Env, Current,
                    Spelling_Of (Definition_Of (Gen_Out_Actuals (I))),
                    Lookup (Env, Call, Spelling_Of (Gen_Out_Formals (I))));
         end loop;
      end if;

      --  pop this call's variant value (on either the normal or exception path)
      if Pushed and then Env.Variants.Contains (Name)
        and then not Env.Variants.Element (Name).Is_Empty
      then
         Env.Variants.Reference (Name).Delete_Last;
      end if;

      Leave (Env, Call);
      return Result;
   end Invoke;

   function Evaluate (Expr : Cursor; Env : in out Environment; Current : Positive)
     return Static_Value is
   begin
      if Is_Numeric_Literal (Expr) then
         declare
            Image : constant String :=
              SU.To_String (As_Numeric_Literal (Expr).Literal_Image);
         begin
            --  a decimal point marks a real literal (Ada requires the point)
            if (for some C of Image => C = '.') then
               return Real_V (Long_Long_Float'Value (Image));
            else
               return Int (Long_Long_Integer'Value (Image));
            end if;
         end;

      elsif Is_String_Literal (Expr) then
         return (Kind => String_Value,
                 Text => As_String_Literal (Expr).Literal_Image);

      elsif Is_Null_Literal (Expr) then
         return (Kind => Access_Value, Address => 0);          --  the null access

      elsif Is_Qualified_Allocator (Expr) then                --  new T'(x)
         declare
            Designated : constant Static_Value :=
              Evaluate (As_Qualified_Allocator (Expr).Value, Env, Current);
         begin
            Env.Heap.Append (Copy (Env, Designated));
            return (Kind => Access_Value, Address => Env.Heap.Last_Index);
         end;

      elsif Is_Subtype_Allocator (Expr) then                  --  new T (uninitialised)
         Env.Heap.Append (Static_Value'(Kind => No_Value));
         return (Kind => Access_Value, Address => Env.Heap.Last_Index);

      elsif Is_Dereference (Expr) then                        --  name.all
         declare
            Acc : constant Static_Value :=
              Evaluate (As_Dereference (Expr).Prefix, Env, Current);
         begin
            if Acc.Kind /= Access_Value then
               raise Interpretation_Error with "dereference of a non-access value";
            elsif Acc.Address = 0 then
               raise Interpretation_Error with "dereference of null";
            end if;
            return Env.Heap.Element (Acc.Address);
         end;

      elsif Is_Aggregate (Expr) or else Is_Container_Aggregate (Expr) then
         declare
            Associations : constant Cursor :=
              (if Is_Aggregate (Expr) then As_Aggregate (Expr).Associations
               else As_Container_Aggregate (Expr).Associations);
            Items : constant Node_List := As_Association_S (Associations).List;
         begin
            if Items.Is_Empty or else Is_Positional_Association (Items (1)) then
               --  positional => array value (1-based)
               declare
                  Elements : Value_Vectors.Vector;
               begin
                  for A of Items loop
                     if not Is_Positional_Association (A) then
                        raise Interpretation_Error with "mixed aggregate";
                     end if;
                     Elements.Append
                       (Copy (Env, Evaluate (As_Positional_Association (A).Value,
                                             Env, Current)));
                  end loop;
                  Env.Arrays.Append (Elements);
                  return (Kind => Array_Value, Elements => Env.Arrays.Last_Index);
               end;
            elsif Is_Named_Association (Items (1))
              and then First_Choice_Is_Index (Items (1))
            then
               --  named ARRAY aggregate (integer-index choices: "N => V",
               --  "Lo .. Hi => V", "others => V") => an array value (1-based).
               declare
                  Max_Index   : Natural := 0;
                  Has_Others  : Boolean := False;

                  --  scan the index choices of an association
                  procedure Scan (Choices : Cursor) is
                  begin
                     for C of As_Choice_S (Choices).List loop
                        if Is_Choice_Expression (C) then
                           Max_Index := Natural'Max (Max_Index, Natural (Whole_Of
                             (Evaluate (As_Choice_Expression (C).Value, Env, Current))));
                        elsif Is_Choice_Range (C) then
                           declare
                              Lo, Hi : Long_Long_Integer;
                           begin
                              Eval_Range (As_Choice_Range (C).Range_Item, Env,
                                          Current, Lo, Hi);
                              Max_Index := Natural'Max (Max_Index, Natural (Hi));
                           end;
                        elsif Is_Others_Choice (C) then
                           Has_Others := True;
                        end if;
                     end loop;
                  end Scan;
               begin
                  for A of Items loop
                     Scan (As_Named_Association (A).Choices);
                  end loop;
                  declare
                     Elements : Value_Vectors.Vector;
                     Filled   : array (1 .. Max_Index) of Boolean :=
                       [others => False];
                     Others_V : Static_Value := (Kind => No_Value);
                  begin
                     for I in 1 .. Max_Index loop
                        Elements.Append (Static_Value'(Kind => No_Value));
                     end loop;
                     for A of Items loop
                        declare
                           V : constant Static_Value :=
                             Evaluate (As_Named_Association (A).Actual, Env, Current);
                        begin
                           for C of As_Choice_S
                                      (As_Named_Association (A).Choices).List
                           loop
                              if Is_Choice_Expression (C) then
                                 declare
                                    Idx : constant Positive := Positive (Whole_Of
                                      (Evaluate (As_Choice_Expression (C).Value,
                                                 Env, Current)));
                                 begin
                                    Elements.Replace_Element (Idx, Copy (Env, V));
                                    Filled (Idx) := True;
                                 end;
                              elsif Is_Choice_Range (C) then
                                 declare
                                    Lo, Hi : Long_Long_Integer;
                                 begin
                                    Eval_Range (As_Choice_Range (C).Range_Item,
                                                Env, Current, Lo, Hi);
                                    for I in Positive (Lo) .. Positive (Hi) loop
                                       Elements.Replace_Element (I, Copy (Env, V));
                                       Filled (I) := True;
                                    end loop;
                                 end;
                              elsif Is_Others_Choice (C) then
                                 Others_V := V;
                              end if;
                           end loop;
                        end;
                     end loop;
                     for I in 1 .. Max_Index loop      --  fill gaps with "others"
                        if not Filled (I) then
                           if not Has_Others then
                              raise Interpretation_Error with
                                "array aggregate leaves index" & I'Image & " unset";
                           end if;
                           Elements.Replace_Element (I, Copy (Env, Others_V));
                        end if;
                     end loop;
                     Env.Arrays.Append (Elements);
                     return (Kind => Array_Value, Elements => Env.Arrays.Last_Index);
                  end;
               end;
            else
               --  named components => record value
               declare
                  Fields : Value_Maps.Map;
               begin
                  for A of Items loop
                     if not Is_Named_Association (A) then
                        raise Interpretation_Error with "mixed aggregate";
                     end if;
                     Fields.Include
                       (Field_Name (A),
                        Copy (Env, Evaluate (As_Named_Association (A).Actual,
                                             Env, Current)));
                  end loop;
                  Env.Records.Append (Fields);
                  return (Kind => Record_Value, Fields => Env.Records.Last_Index);
               end;
            end if;
         end;

      elsif Is_Indexed_Component (Expr) then                  --  A (I)
         declare
            Arr : constant Static_Value :=
              Evaluate (As_Indexed_Component (Expr).Prefix, Env, Current);
            Indices : constant Node_List :=
              As_Expression_S (As_Indexed_Component (Expr).Indices).List;
            I : Long_Long_Integer;
         begin
            if Arr.Kind = String_Value then            --  S (I) => the I-th character
               declare
                  S : constant String := SU.To_String (Arr.Text);
               begin
                  I := Whole_Of (Evaluate (Indices (1), Env, Current));
                  if I < 1 or else I > S'Length then
                     raise Interpretation_Error with "string index out of range";
                  end if;
                  return Str (SU.To_Unbounded_String
                    (S (Natural (I) .. Natural (I))));
               end;
            elsif Arr.Kind /= Array_Value then
               raise Interpretation_Error with "indexing a non-array value";
            end if;
            I := Whole_Of (Evaluate (Indices (1), Env, Current));
            if I < 1 or else I > Long_Long_Integer (Env.Arrays (Arr.Elements).Length) then
               raise Interpretation_Error with "array index out of range";
            end if;
            return Env.Arrays (Arr.Elements).Element (Positive (I));
         end;

      elsif Is_Slice (Expr) then                              --  A (Low .. High)
         declare
            Arr : constant Static_Value :=
              Evaluate (As_Slice (Expr).Prefix, Env, Current);
            Low, High : Long_Long_Integer;
            Slice : Value_Vectors.Vector;     --  a fresh (1-based) sub-array
         begin
            if Arr.Kind = String_Value then         --  S (Low .. High) => substring
               declare
                  S : constant String := SU.To_String (Arr.Text);
               begin
                  Eval_Range (As_Slice (Expr).Discrete_Range, Env, Current, Low, High);
                  if Low < 1 or else High > S'Length then
                     raise Interpretation_Error with "slice bounds out of range";
                  elsif Low > High then            --  empty slice
                     return Str (SU.Null_Unbounded_String);
                  end if;
                  return Str (SU.To_Unbounded_String (S (Natural (Low) .. Natural (High))));
               end;
            elsif Arr.Kind /= Array_Value then
               raise Interpretation_Error with "slicing a non-array value";
            end if;
            Eval_Range (As_Slice (Expr).Discrete_Range, Env, Current, Low, High);
            if Low < 1
              or else High > Long_Long_Integer (Env.Arrays (Arr.Elements).Length)
            then
               raise Interpretation_Error with "slice bounds out of range";
            end if;
            for I in Low .. High loop      --  empty when Low > High
               Slice.Append (Copy (Env,
                 Env.Arrays (Arr.Elements).Element (Positive (I))));
            end loop;
            Env.Arrays.Append (Slice);
            return (Kind => Array_Value, Elements => Env.Arrays.Last_Index);
         end;

      elsif Is_Selected_Component (Expr) then                 --  R.Field / Pkg.Member
         declare
            Prefix_Value : constant Static_Value :=
              Evaluate (As_Selected_Component (Expr).Prefix, Env, Current);
            Name : constant String :=
              Spelling_Of (Definition_Of (As_Selected_Component (Expr).Selector));
         begin
            if Prefix_Value.Kind = Package_Value then          --  a package member
               return Lookup (Env, Prefix_Value.Instance, Name);
            elsif Prefix_Value.Kind /= Record_Value then
               raise Interpretation_Error with "selecting from a non-record value";
            elsif not Env.Records (Prefix_Value.Fields).Contains (Name) then
               raise Interpretation_Error with "no such component: " & Name;
            end if;
            return Env.Records (Prefix_Value.Fields).Element (Name);
         end;

      elsif Is_Parenthesized_Expression (Expr) then
         return Evaluate (As_Parenthesized_Expression (Expr).Operand, Env, Current);

      elsif Is_Target_Name (Expr) then
         --  "@" in an assignment RHS: the current value of the assignment
         --  target, evaluated once and cached for the rest of the RHS.
         if Env.Target_Expr = No_Element then
            raise Interpretation_Error with "'@' used outside an assignment";
         end if;
         if not Env.Target_Ready then
            Env.Target_Value := Evaluate (Env.Target_Expr, Env, Env.Target_Scope);
            Env.Target_Ready := True;
         end if;
         return Env.Target_Value;

      elsif Is_Used_Character (Expr) then
         --  a character literal, modelled as a one-character string (consistent
         --  with string indexing, which also yields a one-character string).
         declare
            Code : constant Integer :=
              As_Defining_Character (As_Used_Character (Expr).Definition).Representation;
         begin
            return Str (SU.To_Unbounded_String ("" & Character'Val (Code)));
         end;

      elsif Is_Used_Object (Expr) or else Is_Used_Name (Expr) then
         declare
            Def : constant Cursor := Definition_Of (Expr);
         begin
            --  an enumeration literal is its position (so it behaves like an
            --  integer) plus its name (so it prints by name); others are looked up
            if Is_Enumeration_Literal_Name (Def) then
               return (Kind     => Enum_Value,
                       Pos      => Long_Long_Integer
                                     (As_Enumeration_Literal_Name (Def).Position),
                       Lit_Name => As_Defining_Occurrence (Def).Spelling);
            else
               return Lookup (Env, Current, Spelling_Of (Def));
            end if;
         end;

      elsif Is_Attribute_Reference (Expr) then                --  Prefix'Attribute
         declare
            Attribute : constant String :=
              Spelling_Of (Definition_Of (As_Attribute_Reference (Expr).Attribute));
         begin
            if Attribute = "Result" then
               --  F'Result in a postcondition: the function's result, bound as
               --  "Result" by Invoke while the postcondition is checked.
               return Lookup (Env, Current, "Result");

            elsif Attribute = "First" or else Attribute = "Last"
              or else Attribute = "Length"
            then
               declare
                  Prefix : constant Cursor := As_Attribute_Reference (Expr).Prefix;
                  --  the prefix's name, but only for a simple name (a type or
                  --  object); "" for a computed prefix like A (I)'First.
                  Prefix_Name : constant String :=
                    (if Is_Used_Name (Prefix) or else Is_Used_Object (Prefix)
                     then Spelling_Of (Definition_Of (Prefix)) else "");
               begin
                  --  enumeration type attributes: T'First / T'Last as named values.
                  if (Attribute = "First" or else Attribute = "Last")
                    and then Env.Enum_Types.Contains (Prefix_Name)
                  then
                     declare
                        Literals : constant Name_Vectors.Vector :=
                          Env.Enum_Types.Element (Prefix_Name);
                        P : constant Positive :=
                          (if Attribute = "First" then 1
                           else Positive (Literals.Length));
                     begin
                        return (Kind     => Enum_Value,
                                Pos      => Long_Long_Integer (P - 1),
                                Lit_Name => SU.To_Unbounded_String (Literals (P)));
                     end;
                  end if;
                  --  otherwise array/string bounds (both 1-based: First=1, Last=Length)
                  declare
                     Arr : constant Static_Value :=
                       Evaluate (Prefix, Env, Current);
                     Length : Long_Long_Integer;
                  begin
                     if Arr.Kind = String_Value then
                        Length := Long_Long_Integer (SU.Length (Arr.Text));
                     elsif Arr.Kind = Array_Value then
                        Length := Long_Long_Integer (Env.Arrays (Arr.Elements).Length);
                     else
                        raise Interpretation_Error with
                          "'" & Attribute & " requires an array or string value";
                     end if;
                     if Attribute = "First" then
                        return Int (1);
                     else                                  --  Last or Length
                        return Int (Length);
                     end if;
                  end;
               end;

            elsif Attribute = "Old" then
               declare
                  Name : constant String :=
                    Spelling_Of (Definition_Of (As_Attribute_Reference (Expr).Prefix));
               begin
                  if not Env.Old_Values.Contains (Name) then
                     raise Interpretation_Error with
                       "'Old is only available in a postcondition, for: " & Name;
                  end if;
                  return Env.Old_Values.Element (Name);
               end;

            elsif Attribute = "Access" then
               --  Subprogram'Access: a first-class reference to the subprogram,
               --  stored by handle and callable through (see Function_Call).
               Env.Sub_Refs.Append
                 (Definition_Of (As_Attribute_Reference (Expr).Prefix));
               return (Kind => Subprogram_Value, Reference => Env.Sub_Refs.Last_Index);
            else
               raise Interpretation_Error with "unsupported attribute: " & Attribute;
            end if;
         end;

      elsif Is_Attribute_Call (Expr) then                     --  T'Attr (X)
         declare
            Prefix : constant Cursor := As_Attribute_Call (Expr).Prefix;
         begin
            if not Is_Attribute_Reference (Prefix) then
               raise Interpretation_Error with "unsupported attribute call";
            end if;
            declare
               Attribute : constant String := Spelling_Of
                 (Definition_Of (As_Attribute_Reference (Prefix).Attribute));
               Args : constant Node_List :=
                 As_Expression_S (As_Attribute_Call (Expr).Arguments).List;
               Arg_Val : Static_Value;
            begin
               if Args.Is_Empty then
                  raise Interpretation_Error with
                    "'" & Attribute & " requires an argument";
               end if;
               Arg_Val := Evaluate (Args (1), Env, Current);
               --  'Image renders any value to its string form (the interpreter's
               --  Image — note: no Ada-style leading space for non-negatives).
               if Attribute = "Image" then
                  return Str (SU.To_Unbounded_String (Image (Arg_Val, Env)));
               --  real-valued attributes: round/truncate a real to a whole real.
               elsif Attribute = "Floor" then
                  return Real_V (Long_Long_Float'Floor (Real_Of (Arg_Val)));
               elsif Attribute = "Ceiling" then
                  return Real_V (Long_Long_Float'Ceiling (Real_Of (Arg_Val)));
               elsif Attribute = "Truncation" then
                  return Real_V (Long_Long_Float'Truncation (Real_Of (Arg_Val)));
               elsif Attribute = "Rounding" then
                  return Real_V (Long_Long_Float'Rounding (Real_Of (Arg_Val)));
               --  scalar 'Value: parse a string into a value.  An enumeration
               --  type (its literals known) maps the spelling to the named
               --  value; otherwise the target type name selects integer vs. real.
               elsif Attribute = "Value" then
                  declare
                     Text : constant String := SU.To_String (Str_Of (Arg_Val));
                     Type_Name : constant String := Spelling_Of
                       (Definition_Of (As_Attribute_Reference (Prefix).Prefix));
                  begin
                     if Env.Enum_Types.Contains (Type_Name) then
                        declare
                           Literals : constant Name_Vectors.Vector :=
                             Env.Enum_Types.Element (Type_Name);
                        begin
                           for P in 1 .. Natural (Literals.Length) loop
                              if Literals (P) = Text then
                                 return (Kind     => Enum_Value,
                                         Pos      => Long_Long_Integer (P - 1),
                                         Lit_Name => SU.To_Unbounded_String (Text));
                              end if;
                           end loop;
                           raise Interpretation_Error with
                             "'Value: """ & Text & """ is not a value of " & Type_Name;
                        end;
                     elsif Type_Name = "Float" or else Type_Name = "Long_Float"
                       or else Type_Name = "Real"
                     then
                        return Real_V (Long_Long_Float'Value (Text));
                     else
                        return Int (Long_Long_Integer'Value (Text));
                     end if;
                  exception
                     when Constraint_Error =>
                        raise Interpretation_Error with
                          "'Value: """ & Text & """ is not a valid " & Type_Name;
                  end;
               --  'Min / 'Max: two arguments; integer result if both integer,
               --  else real.  [Ada 2022 RM 3.5]
               elsif Attribute = "Min" or else Attribute = "Max" then
                  if Natural (Args.Length) < 2 then
                     raise Interpretation_Error with
                       "'" & Attribute & " requires two arguments";
                  end if;
                  declare
                     Second   : constant Static_Value :=
                       Evaluate (Args (2), Env, Current);
                     Want_Min : constant Boolean := Attribute = "Min";
                  begin
                     if Arg_Val.Kind = Integer_Value
                       and then Second.Kind = Integer_Value
                     then
                        return Int (if Want_Min
                                    then Long_Long_Integer'Min (Arg_Val.Whole, Second.Whole)
                                    else Long_Long_Integer'Max (Arg_Val.Whole, Second.Whole));
                     elsif Arg_Val.Kind = String_Value
                       and then Second.Kind = String_Value
                     then
                        --  characters / strings: keep the lesser / greater operand
                        return (if Want_Min = SU."<" (Arg_Val.Text, Second.Text)
                                then Arg_Val else Second);
                     elsif Is_Discrete (Arg_Val) and then Is_Discrete (Second) then
                        --  enumerations (compared by position): keep the operand,
                        --  so a named value stays named.
                        return (if Want_Min = (Whole_Of (Arg_Val) < Whole_Of (Second))
                                then Arg_Val else Second);
                     else
                        return Real_V (if Want_Min
                                       then Long_Long_Float'Min (Real_Of (Arg_Val), Real_Of (Second))
                                       else Long_Long_Float'Max (Real_Of (Arg_Val), Real_Of (Second)));
                     end if;
                  end;
               end if;
               --  discrete attributes.  Character is a one-character-string type
               --  here; an enumeration type (recorded in Enum_Types) yields named
               --  values; otherwise a position is the value itself.
               declare
                  Type_Name : constant String := Spelling_Of
                    (Definition_Of (As_Attribute_Reference (Prefix).Prefix));
               begin
                  --  Character'Pos -> code, 'Val -> char, 'Succ / 'Pred ->
                  --  neighbouring character (over one-character strings).
                  if Type_Name = "Character"
                    and then (Attribute = "Pos" or else Attribute = "Val"
                              or else Attribute = "Succ" or else Attribute = "Pred")
                  then
                     if Attribute = "Val" then
                        declare
                           Code : constant Long_Long_Integer := Whole_Of (Arg_Val);
                        begin
                           if Code < 0 or else Code > 255 then
                              raise Interpretation_Error with
                                "Character'Val: code" & Code'Image & " is out of range";
                           end if;
                           return Str (SU.To_Unbounded_String
                             ("" & Character'Val (Integer (Code))));
                        end;
                     else
                        declare
                           S : constant String := SU.To_String (Str_Of (Arg_Val));
                        begin
                           if S'Length /= 1 then
                              raise Interpretation_Error with
                                "Character'" & Attribute & " requires a single character";
                           end if;
                           declare
                              Code   : constant Integer := Character'Pos (S (S'First));
                              Result : Integer;
                           begin
                              if Attribute = "Pos" then
                                 return Int (Long_Long_Integer (Code));
                              end if;
                              Result := (if Attribute = "Succ" then Code + 1 else Code - 1);
                              if Result < 0 or else Result > 255 then
                                 raise Interpretation_Error with
                                   "Character'" & Attribute & " is out of range";
                              end if;
                              return Str (SU.To_Unbounded_String
                                ("" & Character'Val (Result)));
                           end;
                        end;
                     end if;
                  end if;

                  --  enumeration / integer discrete attributes
                  declare
                     Arg : constant Long_Long_Integer := Whole_Of (Arg_Val);

                     --  the value at position Pos of the prefix type: a named
                     --  enumeration literal, or the bare integer for a non-enum type.
                     function At_Position (Pos : Long_Long_Integer) return Static_Value is
                     begin
                        if not Env.Enum_Types.Contains (Type_Name) then
                           return Int (Pos);
                        end if;
                        declare
                           Literals : constant Name_Vectors.Vector :=
                             Env.Enum_Types.Element (Type_Name);
                        begin
                           if Pos < 0 or else Pos >= Long_Long_Integer (Literals.Length)
                           then
                              raise Interpretation_Error with
                                "'" & Attribute & ": position" & Pos'Image
                                & " is out of range for " & Type_Name;
                           end if;
                           return (Kind     => Enum_Value,
                                   Pos      => Pos,
                                   Lit_Name => SU.To_Unbounded_String
                                                 (Literals (Positive (Pos + 1))));
                        end;
                     end At_Position;
                  begin
                     if    Attribute = "Succ" then return At_Position (Arg + 1);
                     elsif Attribute = "Pred" then return At_Position (Arg - 1);
                     elsif Attribute = "Pos"  then return Int (Arg);
                     elsif Attribute = "Val"  then return At_Position (Arg);
                     else
                        raise Interpretation_Error with "unsupported attribute: " & Attribute;
                     end if;
                  end;
               end;
            end;
         end;

      elsif Is_Declare_Expression (Expr) then
         declare
            Inner : constant Positive := Enter (Env, Current);
            Decls : constant Cursor := As_Declare_Expression (Expr).Declarations;
            Result : Static_Value;
         begin
            if Decls /= No_Element and then Is_Declaration_S (Decls) then
               Elaborate (As_Declaration_S (Decls).List, Env, Inner);
            end if;
            Result := Evaluate (As_Declare_Expression (Expr).Result, Env, Inner);
            Leave (Env, Inner);
            return Result;
         end;

      elsif Is_Function_Call (Expr) then
         declare
            Prefix : constant Cursor := As_Function_Call (Expr).Prefix;
            Args   : constant Node_List :=
              As_Association_S (As_Function_Call (Expr).Actuals).List;
         begin
            if Is_Used_Builtin (Prefix) then
               return Apply (As_Used_Builtin (Prefix).Builtin_Operator, Args, Env, Current);
            end if;
            if Is_Selected_Component (Prefix) then            --  Pkg.Sub (...)
               declare
                  Pkg : constant Static_Value :=
                    Evaluate (As_Selected_Component (Prefix).Prefix, Env, Current);
                  Sub : constant Cursor :=
                    Definition_Of (As_Selected_Component (Prefix).Selector);
               begin
                  if Pkg.Kind /= Package_Value then
                     raise Interpretation_Error with
                       "selected call on a non-package value";
                  end if;
                  return Invoke (Sub, Args, Env, Current, Home => Pkg.Instance);
               end;
            end if;
            declare
               Def : constant Cursor := Definition_Of (Prefix);
               --  a call to a generic formal subprogram dispatches to its actual
               Actual_Sub : constant Cursor :=
                 Lookup_Formal_Sub (Env, Current, Spelling_Of (Def));
               --  a name bound to a Subprogram_Value is called through (a
               --  reference of a formal access-to-subprogram type)
               Bound : constant Static_Value :=
                 Bound_Value (Env, Current, Spelling_Of (Def));
            begin
               if Spelling_Of (Def) = "Exception_Message" then
                  --  the message of the exception currently being handled
                  return (Kind => String_Value, Text => Env.Handling_Msg);
               elsif Spelling_Of (Def) = "Exception_Name" then
                  --  the name of the exception currently being handled
                  return (Kind => String_Value, Text => Env.Handling);
               elsif Actual_Sub /= No_Element then
                  return Invoke (Actual_Sub, Args, Env, Current);
               elsif Bound.Kind = Subprogram_Value then
                  return Invoke (Env.Sub_Refs (Bound.Reference), Args, Env, Current);
               elsif Is_Subprogram_Name (Def) then
                  return Invoke (Def, Args, Env, Current);
               else
                  raise Interpretation_Error with "call to a non-subprogram";
               end if;
            end;
         end;

      elsif Is_Short_Circuit (Expr) then           --  A and then B  /  A or else B
         --  short-circuit: the Right operand is evaluated only when the Left
         --  does not already settle the result.
         declare
            Left : constant Boolean :=
              Bool_Of (Evaluate (As_Short_Circuit (Expr).Left, Env, Current));
         begin
            if Is_And_Then (As_Short_Circuit (Expr).Operator) then
               return Bool (Left and then
                 Bool_Of (Evaluate (As_Short_Circuit (Expr).Right, Env, Current)));
            else                                    --  or else
               return Bool (Left or else
                 Bool_Of (Evaluate (As_Short_Circuit (Expr).Right, Env, Current)));
            end if;
         end;

      elsif Is_If_Expression (Expr) then           --  (if C then A elsif ... else Z)
         --  return the Result of the first clause whose Condition holds (a Void
         --  condition is the "else" arm).
         for Clause of As_Expression_Clause_S
                         (As_If_Expression (Expr).Clauses).List
         loop
            declare
               Condition : constant Cursor := As_Expression_Clause (Clause).Condition;
            begin
               if Condition = No_Element or else Is_Void (Condition)
                 or else Bool_Of (Evaluate (Condition, Env, Current))
               then
                  return Evaluate (As_Expression_Clause (Clause).Result, Env, Current);
               end if;
            end;
         end loop;
         raise Interpretation_Error with "no arm of the if-expression applies";

      elsif Is_Case_Expression (Expr) then         --  (case S is when ... => R, ...)
         declare
            Selector : constant Long_Long_Integer :=
              Whole_Of (Evaluate (As_Case_Expression (Expr).Selector, Env, Current));
            Others_Result : Cursor := No_Element;
         begin
            for Alt of As_Expression_Alternative_S
                         (As_Case_Expression (Expr).Alternatives).List
            loop
               if Has_Others (As_Expression_Alternative (Alt).Choices) then
                  Others_Result := As_Expression_Alternative (Alt).Result;
               elsif Choice_Matches (As_Expression_Alternative (Alt).Choices,
                                     Selector, Env, Current)
               then
                  return Evaluate (As_Expression_Alternative (Alt).Result, Env, Current);
               end if;
            end loop;
            if Others_Result /= No_Element then
               return Evaluate (Others_Result, Env, Current);
            end if;
            raise Interpretation_Error with "no alternative of the case-expression applies";
         end;

      elsif Is_Membership (Expr) then              --  X in C1 | C2 .. C3 | ...
         declare
            V : constant Long_Long_Integer :=
              Whole_Of (Evaluate (As_Membership (Expr).Operand, Env, Current));
            In_Set : Boolean := False;
            Low, High : Long_Long_Integer;
         begin
            for C of As_Membership_Choice_S (As_Membership (Expr).Choices).List loop
               if Is_Membership_Value (C) then
                  if V = Whole_Of (Evaluate
                       (As_Membership_Value (C).Value, Env, Current))
                  then
                     In_Set := True;
                  end if;
               elsif Is_Membership_Range (C) then
                  Eval_Range (As_Membership_Range (C).Range_Item, Env, Current,
                              Low, High);
                  if V >= Low and then V <= High then
                     In_Set := True;
                  end if;
               end if;
               exit when In_Set;
            end loop;
            if Is_Not_In_Set (As_Membership (Expr).Operator) then
               In_Set := not In_Set;     --  "not in"
            end if;
            return Bool (In_Set);
         end;

      elsif Is_Quantified_Expression (Expr) then   --  (for all/some I in L .. H => P)
         declare
            Iter    : constant Cursor := As_Quantified_Expression (Expr).Iterator;
            Pred    : constant Cursor := As_Quantified_Expression (Expr).Predicate;
            For_All : constant Boolean :=
              Is_For_All (As_Quantified_Expression (Expr).Quantifier);
            Low, High : Long_Long_Integer;
         begin
            if not Is_Range_Iterator (Iter) then
               raise Interpretation_Error with
                 "only range iterators are supported in a quantified expression";
            end if;
            Eval_Range (As_Range_Iterator (Iter).Discrete_Range, Env, Current,
                        Low, High);
            for I in Low .. High loop
               declare
                  Scope : constant Positive := Enter (Env, Current);
                  Holds : Boolean;
               begin
                  Define (Env, Scope,
                          Spelling_Of (As_Range_Iterator (Iter).Parameter), Int (I));
                  Holds := Bool_Of (Evaluate (Pred, Env, Scope));
                  Leave (Env, Scope);
                  --  "for all" fails on the first counter-example; "for some"
                  --  succeeds on the first witness.
                  if For_All and then not Holds then
                     return Bool (False);
                  elsif not For_All and then Holds then
                     return Bool (True);
                  end if;
               end;
            end loop;
            return Bool (For_All);   --  all held / no witness for some
         end;

      elsif Is_Type_Conversion (Expr) then         --  Target (Operand)
         declare
            Target : constant String :=
              Spelling_Of (Definition_Of (As_Type_Conversion (Expr).Target));
            V : constant Static_Value :=
              Evaluate (As_Type_Conversion (Expr).Operand, Env, Current);
         begin
            --  numeric conversions change representation (the interpreter is
            --  otherwise dynamically typed): to an integer type rounds a real to
            --  the nearest integer; to a float type widens an integer to real.
            if Target = "Integer" or else Target = "Natural"
              or else Target = "Positive"
            then
               return Int (Long_Long_Integer (Real_Of (V)));
            elsif Target = "Float" or else Target = "Long_Float"
              or else Target = "Real"
            then
               return Real_V (Real_Of (V));
            else
               return V;   --  same-category / unmodelled conversion: identity
            end if;
         end;

      elsif Is_Qualified_Expression (Expr) then     --  Target'(Operand)
         --  qualification asserts a type; at runtime it is just the value.
         return Evaluate (As_Qualified_Expression (Expr).Operand, Env, Current);

      else
         raise Interpretation_Error with "cannot evaluate this expression node";
      end if;
   end Evaluate;

   --  Evaluate a discrete range "Low .. High" (this slice supports Range_Bounds).
   procedure Eval_Range (Discrete_Range : Cursor; Env : in out Environment;
                         Current : Positive; Low, High : out Long_Long_Integer) is
   begin
      if Is_Range_Bounds (Discrete_Range) then
         Low  := Whole_Of (Evaluate (As_Range_Bounds (Discrete_Range).Lower, Env, Current));
         High := Whole_Of (Evaluate (As_Range_Bounds (Discrete_Range).Upper, Env, Current));
      elsif Is_Attribute_Reference (Discrete_Range)
        and then Spelling_Of (Definition_Of
                   (As_Attribute_Reference (Discrete_Range).Attribute)) = "Range"
      then
         --  A'Range == A'First .. A'Last (arrays and strings are 1-based)
         declare
            Arr : constant Static_Value :=
              Evaluate (As_Attribute_Reference (Discrete_Range).Prefix, Env, Current);
         begin
            Low := 1;
            if Arr.Kind = String_Value then
               High := Long_Long_Integer (SU.Length (Arr.Text));
            elsif Arr.Kind = Array_Value then
               High := Long_Long_Integer (Env.Arrays (Arr.Elements).Length);
            else
               raise Interpretation_Error with "'Range requires an array or string value";
            end if;
         end;
      else
         raise Interpretation_Error with "unsupported discrete range";
      end if;
   end Eval_Range;

   --  Does a choice list (of a case alternative or case-expression alternative)
   --  carry an "others" choice?
   function Has_Others (Choices : Cursor) return Boolean is
   begin
      for C of As_Choice_S (Choices).List loop
         if Is_Others_Choice (C) then
            return True;
         end if;
      end loop;
      return False;
   end Has_Others;

   --  Does any value/range choice of the alternative cover the selector value?
   function Choice_Matches (Choices : Cursor; Selector : Long_Long_Integer;
                            Env : in out Environment; Current : Positive)
     return Boolean
   is
      Low, High : Long_Long_Integer;
   begin
      for C of As_Choice_S (Choices).List loop
         if Is_Choice_Expression (C) then
            if Whole_Of (Evaluate (As_Choice_Expression (C).Value, Env, Current)) = Selector then
               return True;
            end if;
         elsif Is_Choice_Range (C) then
            Eval_Range (As_Choice_Range (C).Range_Item, Env, Current, Low, High);
            if Selector >= Low and then Selector <= High then
               return True;
            end if;
         end if;
      end loop;
      return False;
   end Choice_Matches;

   --  Index (1-based) of the item in Items labelled Name, or 0 if none.
   function Find_Label (Items : Node_List; Name : String) return Natural is
   begin
      for I in 1 .. Natural (Items.Length) loop
         if Is_Labeled_Statement (Items (I)) then
            for L of As_Defining_Name_S
                       (As_Labeled_Statement (Items (I)).Labels).List
            loop
               if Spelling_Of (L) = Name then
                  return I;
               end if;
            end loop;
         end if;
      end loop;
      return 0;
   end Find_Label;

   --  True when an entry call "Task.Entry" can be accepted right now: the prefix
   --  is a task currently offering that entry with an open guard.  The sequential
   --  model never waits, so a conditional / timed call that is not acceptable now
   --  never will be -- it takes its else / timeout branch.
   function Entry_Acceptable (Call : Cursor; Env : in out Environment;
                              Current : Positive) return Boolean
   is
      Prefix : constant Cursor := As_Entry_Call (Call).Prefix;
   begin
      if not Is_Selected_Component (Prefix) then
         return False;
      end if;
      declare
         Task_Val : constant Static_Value :=
           Evaluate (As_Selected_Component (Prefix).Prefix, Env, Current);
         Entry_Nm : constant String :=
           Spelling_Of (Definition_Of (As_Selected_Component (Prefix).Selector));
      begin
         if Task_Val.Kind /= Package_Value
           or else not Env.Accepts.Contains (Entry_Nm)
         then
            return False;
         elsif Env.Accept_Guards.Contains (Entry_Nm) then
            return Bool_Of (Evaluate
              (Env.Accept_Guards.Element (Entry_Nm), Env, Task_Val.Instance));
         else
            return True;        --  unguarded accept: always acceptable
         end if;
      end;
   end Entry_Acceptable;

   procedure Execute (Stmt : Cursor; Env : in out Environment; Current : Positive) is
   begin
      if Is_Null_Statement (Stmt) then
         null;

      elsif Is_Delay_Statement (Stmt) then
         --  the interpreter has no real-time model, so a delay does not wait;
         --  its expression is still evaluated (to surface any error in it).
         declare
            Ignored : constant Static_Value :=
              Evaluate (As_Delay_Statement (Stmt).Expression, Env, Current);
            pragma Unreferenced (Ignored);
         begin
            null;
         end;

      elsif Is_Statement_S (Stmt) then
         --  an index loop so a goto can jump to a labelled item in THIS sequence
         declare
            Items : constant Node_List := As_Statement_S (Stmt).List;
            I     : Natural := 1;
            Target : Natural;
         begin
            while I <= Natural (Items.Length) loop
               Execute (Items (I), Env, Current);
               if Env.Returning or else Env.Exiting then
                  exit;
               elsif Env.Jumping then
                  Target := Find_Label (Items, SU.To_String (Env.Goto_Target));
                  if Target /= 0 then
                     Env.Jumping := False;
                     I := Target;            --  jump within this sequence
                  else
                     exit;                   --  propagate to the enclosing sequence
                  end if;
               else
                  I := I + 1;
               end if;
            end loop;
         end;

      elsif Is_Labeled_Statement (Stmt) then
         Execute (As_Labeled_Statement (Stmt).Statement, Env, Current);
         --  a named exit targeting one of this statement's labels stops here
         if Env.Exiting then
            for L of As_Defining_Name_S
                       (As_Labeled_Statement (Stmt).Labels).List
            loop
               if Spelling_Of (L) = SU.To_String (Env.Exit_Target) then
                  Env.Exiting := False;
                  exit;
               end if;
            end loop;
         end if;

      elsif Is_Exit_Statement (Stmt) then
         declare
            Loop_Name : constant Cursor := As_Exit_Statement (Stmt).Loop_Name;
            Condition : constant Cursor := As_Exit_Statement (Stmt).Condition;
            Fire      : Boolean := True;
         begin
            if Condition /= No_Element and then not Is_Void (Condition) then
               Fire := Bool_Of (Evaluate (Condition, Env, Current));
            end if;
            if Fire then
               Env.Exiting := True;
               if Loop_Name /= No_Element and then not Is_Void (Loop_Name) then
                  Env.Exit_Target := SU.To_Unbounded_String
                    (Spelling_Of (Definition_Of (Loop_Name)));
               else
                  Env.Exit_Target := SU.Null_Unbounded_String;
               end if;
            end if;
         end;

      elsif Is_Goto_Statement (Stmt) then
         Env.Jumping := True;
         Env.Goto_Target := SU.To_Unbounded_String
           (Spelling_Of (Definition_Of (As_Goto_Statement (Stmt).Target)));

      elsif Is_Block_Statement (Stmt) then
         declare
            Inner : constant Positive := Enter (Env, Current);
         begin
            Run_Block_In (As_Block_Statement (Stmt).Block, Env, Inner);
            Leave (Env, Inner);
         end;

      elsif Is_Raise_Statement (Stmt) then           --  raise E [with Msg];  /  raise;
         declare
            Exc : constant Cursor := As_Raise_Statement (Stmt).Exception_Name;
            Msg : constant Cursor := As_Raise_Statement (Stmt).Message;
         begin
            if Exc = No_Element or else Is_Void (Exc) then
               --  bare re-raise: re-raise the exception currently being handled
               if SU.Length (Env.Handling) = 0 then
                  raise Interpretation_Error with "'raise;' outside an exception handler";
               end if;
               Env.Raising    := True;
               Env.Raised     := Env.Handling;
               Env.Raised_Msg := Env.Handling_Msg;
            else
               Env.Raising := True;
               Env.Raised  := SU.To_Unbounded_String (Spelling_Of (Definition_Of (Exc)));
               if Msg /= No_Element and then not Is_Void (Msg) then
                  Env.Raised_Msg :=
                    SU.To_Unbounded_String (Image (Evaluate (Msg, Env, Current), Env));
               else
                  Env.Raised_Msg := SU.Null_Unbounded_String;
               end if;
            end if;
         end;

      elsif Is_Return_Statement (Stmt) then
         declare
            Obj : constant Cursor := As_Return_Statement (Stmt).Returned_Object;
         begin
            if Obj /= No_Element and then not Is_Void (Obj) then
               declare
                  Value : constant Static_Value := Evaluate (Obj, Env, Current);
               begin
                  if Env.Raising then        --  the returned expression raised
                     return;
                  end if;
                  Env.Return_Value := Value;
               end;
            end if;
            Env.Returning := True;
         end;

      elsif Is_Assignment (Stmt) then
         declare
            Target : constant Cursor := As_Assignment (Stmt).Target;
            Value  : Static_Value;
         begin
            --  evaluate the RHS with the "@" target context set (Ada 2022),
            --  then restore the enclosing context.
            declare
               Saved_Expr  : constant Cursor       := Env.Target_Expr;
               Saved_Scope : constant Positive     := Env.Target_Scope;
               Saved_Value : constant Static_Value := Env.Target_Value;
               Saved_Ready : constant Boolean      := Env.Target_Ready;
            begin
               Env.Target_Expr  := Target;
               Env.Target_Scope := Current;
               Env.Target_Ready := False;
               Value := Evaluate (As_Assignment (Stmt).Source, Env, Current);
               Env.Target_Expr  := Saved_Expr;
               Env.Target_Scope := Saved_Scope;
               Env.Target_Value := Saved_Value;
               Env.Target_Ready := Saved_Ready;
            end;
            if Env.Raising then              --  the source expression raised
               return;
            elsif Is_Dereference (Target) then       --  name.all := Value
               declare
                  Acc : constant Static_Value :=
                    Evaluate (As_Dereference (Target).Prefix, Env, Current);
               begin
                  if Acc.Kind /= Access_Value or else Acc.Address = 0 then
                     raise Interpretation_Error with
                       "assignment through a null or non-access value";
                  end if;
                  Env.Heap.Replace_Element (Acc.Address, Copy (Env, Value));
               end;

            elsif Is_Indexed_Component (Target) then  --  A (I) := Value
               declare
                  Arr : constant Static_Value :=
                    Evaluate (As_Indexed_Component (Target).Prefix, Env, Current);
                  Indices : constant Node_List :=
                    As_Expression_S (As_Indexed_Component (Target).Indices).List;
                  I : Long_Long_Integer;
               begin
                  if Arr.Kind /= Array_Value then
                     raise Interpretation_Error with "indexing a non-array value";
                  end if;
                  I := Whole_Of (Evaluate (Indices (1), Env, Current));
                  if I < 1
                    or else I > Long_Long_Integer (Env.Arrays (Arr.Elements).Length)
                  then
                     raise Interpretation_Error with "array index out of range";
                  end if;
                  Env.Arrays.Reference (Arr.Elements).Replace_Element
                    (Positive (I), Copy (Env, Value));
               end;

            elsif Is_Selected_Component (Target) then  --  R.Field := Value
               declare
                  Rec : constant Static_Value :=
                    Evaluate (As_Selected_Component (Target).Prefix, Env, Current);
                  Name : constant String := Spelling_Of
                    (Definition_Of (As_Selected_Component (Target).Selector));
               begin
                  if Rec.Kind /= Record_Value then
                     raise Interpretation_Error with "selecting from a non-record value";
                  end if;
                  Env.Records.Reference (Rec.Fields).Include (Name, Copy (Env, Value));
               end;

            else                                      --  X := Value
               declare
                  Name : constant String := Spelling_Of (Definition_Of (Target));
               begin
                  Assign (Env, Current, Name, Value);
                  if Env.Constrained.Contains (Name) then
                     Check_Constraint
                       (Env, Env.Constrained.Element (Name), Value, Current);
                  end if;
               end;
            end if;
         end;

      elsif Is_Procedure_Call (Stmt) then
         declare
            Prefix : constant Cursor := As_Procedure_Call (Stmt).Prefix;
            Args   : constant Node_List :=
              As_Association_S (As_Procedure_Call (Stmt).Actuals).List;
            Discard : Static_Value;
         begin
            if Is_Selected_Component (Prefix) then   --  Pkg.Proc / PO.Operation / PO.Entry
               declare
                  Pkg : constant Static_Value :=
                    Evaluate (As_Selected_Component (Prefix).Prefix, Env, Current);
                  Sub : constant Cursor :=
                    Definition_Of (As_Selected_Component (Prefix).Selector);
                  Name : constant String := Spelling_Of (Sub);
               begin
                  if Pkg.Kind /= Package_Value then
                     raise Interpretation_Error with
                       "selected procedure call on a non-package value";
                  elsif Env.Entries.Contains (Name) then
                     --  a protected entry: its barrier must be open (the
                     --  interpreter is sequential, so a closed barrier would
                     --  block forever — an error), then run its body in the
                     --  protected object's scope.
                     declare
                        E       : constant Cursor := Env.Entries.Element (Name);
                        Barrier : constant Cursor := As_Entry_Body (E).Barrier;
                        Scope   : Positive;
                     begin
                        if not Bool_Of (Evaluate (Barrier, Env, Pkg.Instance)) then
                           raise Interpretation_Error with
                             "protected entry barrier is closed (would block): " & Name;
                        end if;
                        Scope := Enter (Env, Pkg.Instance);
                        Run_Block_In (As_Entry_Body (E).Completion, Env, Scope);
                        Leave (Env, Scope);
                     end;
                  else
                     Discard := Invoke (Sub, Args, Env, Current, Home => Pkg.Instance);
                  end if;
               end;
            else
               declare
                  Def  : constant Cursor := Definition_Of (Prefix);
                  Name : constant String := Spelling_Of (Def);
               begin
                  if Name = "Put_Line" or else Name = "Put" then
                     for A of Args loop
                        declare
                           V : constant Static_Value :=
                             Evaluate (As_Positional_Association (A).Value, Env, Current);
                        begin
                           exit when Env.Raising;   --  the argument expression raised
                           Put_Line (Image (V, Env));
                        end;
                     end loop;
                  elsif Is_Subprogram_Name (Def) then
                     Discard := Invoke (Def, Args, Env, Current);
                  else
                     raise Interpretation_Error with "unknown procedure: " & Name;
                  end if;
               end;
            end if;
         end;

      elsif Is_Entry_Call (Stmt) then               --  Task.Entry (Actuals)
         --  A rendezvous (modelled synchronously): run the task's matching
         --  accept body, with the accept's parameters bound to the call's
         --  actuals, in the task's (persistent) scope.
         declare
            Prefix  : constant Cursor := As_Entry_Call (Stmt).Prefix;
            Actuals : constant Node_List :=
              As_Association_S (As_Entry_Call (Stmt).Actuals).List;
         begin
            if not Is_Selected_Component (Prefix) then
               raise Interpretation_Error with "entry call must name Task.Entry";
            end if;
            declare
               Task_Val : constant Static_Value :=
                 Evaluate (As_Selected_Component (Prefix).Prefix, Env, Current);
               Entry_Nm : constant String :=
                 Spelling_Of (Definition_Of (As_Selected_Component (Prefix).Selector));
            begin
               if Task_Val.Kind /= Package_Value then
                  raise Interpretation_Error with "entry call on a non-task value";
               elsif not Env.Accepts.Contains (Entry_Nm) then
                  raise Interpretation_Error with
                    "task is not accepting entry: " & Entry_Nm;
               elsif Env.Accept_Guards.Contains (Entry_Nm)
                 and then not Bool_Of (Evaluate
                   (Env.Accept_Guards.Element (Entry_Nm), Env, Task_Val.Instance))
               then
                  --  the select alternative's guard is closed (would block)
                  raise Interpretation_Error with
                    "select alternative guard is closed: " & Entry_Nm;
               end if;
               declare
                  Accept_Node : constant Cursor := Env.Accepts.Element (Entry_Nm);
                  Params : constant Node_List := As_Parameter_S
                    (As_Accept_Statement (Accept_Node).Parameters).List;
                  Rendezvous : constant Positive := Enter (Env, Task_Val.Instance);
                  J : Natural := 0;
               begin
                  --  bind the accept's (in) parameters to the call's actuals
                  for P of Params loop
                     if Is_In_Parameter (P) then
                        for Nm of As_Defining_Name_S
                                    (As_In_Parameter (P).Names).List
                        loop
                           J := J + 1;
                           Define (Env, Rendezvous, Spelling_Of (Nm),
                                   Evaluate (As_Positional_Association
                                     (Actuals (J)).Value, Env, Current));
                        end loop;
                     end if;
                  end loop;
                  Execute (As_Accept_Statement (Accept_Node).Handled_Statements,
                           Env, Rendezvous);
                  Leave (Env, Rendezvous);
               end;
            end;
         end;

      elsif Is_Conditional_Entry_Call (Stmt) then   --  select E; S1; else S2; end select
         --  if the entry can be accepted now, rendezvous then run the call
         --  statements; otherwise run the else statements (no waiting).
         if Entry_Acceptable
              (As_Conditional_Entry_Call (Stmt).Entry_Call, Env, Current)
         then
            Execute (As_Conditional_Entry_Call (Stmt).Entry_Call, Env, Current);
            Execute (As_Conditional_Entry_Call (Stmt).Call_Statements, Env, Current);
         else
            Execute (As_Conditional_Entry_Call (Stmt).Else_Statements, Env, Current);
         end if;

      elsif Is_Timed_Entry_Call (Stmt) then          --  select E; S1; or delay D; S2;
         --  acceptable now => rendezvous + call statements; otherwise the delay
         --  expires (nothing changes while we "wait") => the timeout statements.
         if Entry_Acceptable (As_Timed_Entry_Call (Stmt).Entry_Call, Env, Current) then
            Execute (As_Timed_Entry_Call (Stmt).Entry_Call, Env, Current);
            Execute (As_Timed_Entry_Call (Stmt).Call_Statements, Env, Current);
         else
            Execute (As_Timed_Entry_Call (Stmt).Delay_Statements, Env, Current);
         end if;

      elsif Is_If_Statement (Stmt) then
         for Clause of As_Conditional_Clause_S
                         (As_If_Statement (Stmt).Clauses).List
         loop
            declare
               Condition : constant Cursor := As_Conditional_Clause (Clause).Condition;
            begin
               if Condition = No_Element or else Is_Void (Condition) then
                  Execute (As_Conditional_Clause (Clause).Statements, Env, Current);
                  exit;
               elsif Bool_Of (Evaluate (Condition, Env, Current)) then
                  Execute (As_Conditional_Clause (Clause).Statements, Env, Current);
                  exit;
               end if;
            end;
         end loop;

      elsif Is_Loop_Statement (Stmt) then
         declare
            Iteration  : constant Cursor := As_Loop_Statement (Stmt).Iteration;
            Statements : constant Cursor := As_Loop_Statement (Stmt).Statements;
         begin
            if Is_While_Loop (Iteration) then
               while not Pending (Env)
                 and then Bool_Of (Evaluate (As_While_Loop (Iteration).Condition,
                                             Env, Current))
               loop
                  Execute (Statements, Env, Current);
               end loop;

            elsif Is_For_Loop (Iteration) then
               declare
                  Iter : constant Cursor := As_For_Loop (Iteration).Iterator;
               begin
                  if Is_Range_Iterator (Iter) then        --  for I in Low .. High
                     declare
                        Parameter : constant String :=
                          Spelling_Of (As_Range_Iterator (Iter).Parameter);
                        Filter    : constant Cursor := As_Range_Iterator (Iter).Filter;
                        Backward  : constant Boolean :=
                          As_Range_Iterator (Iter).Reverse_Order;
                        Scope     : constant Positive := Enter (Env, Current);
                        Low, High : Long_Long_Integer;

                        --  one iteration with the loop parameter set to V; the
                        --  Ada 2022 "when" filter (if any) can skip the body
                        procedure Iterate (V : Long_Long_Integer) is
                        begin
                           Define (Env, Scope, Parameter, Int (V));
                           if Filter = No_Element or else Is_Void (Filter)
                             or else Bool_Of (Evaluate (Filter, Env, Scope))
                           then
                              Execute (Statements, Env, Scope);
                           end if;
                        end Iterate;
                     begin
                        Eval_Range (As_Range_Iterator (Iter).Discrete_Range,
                                    Env, Current, Low, High);
                        if not Backward then
                           declare
                              V : Long_Long_Integer := Low;
                           begin
                              while V <= High and then not Pending (Env) loop
                                 Iterate (V);
                                 exit when V = High;   --  guard type'Last overflow
                                 V := V + 1;
                              end loop;
                           end;
                        else
                           declare
                              V : Long_Long_Integer := High;
                           begin
                              while V >= Low and then not Pending (Env) loop
                                 Iterate (V);
                                 exit when V = Low;
                                 V := V - 1;
                              end loop;
                           end;
                        end if;
                        Leave (Env, Scope);
                     end;

                  elsif Is_Container_Iterator (Iter) then  --  for E of array
                     declare
                        Parameter : constant String :=
                          Spelling_Of (As_Container_Iterator (Iter).Parameter);
                        Filter    : constant Cursor := As_Container_Iterator (Iter).Filter;
                        Backward  : constant Boolean :=
                          As_Container_Iterator (Iter).Reverse_Order;
                        Iterable  : constant Static_Value :=
                          Evaluate (As_Container_Iterator (Iter).Iterable, Env, Current);
                        Scope     : constant Positive := Enter (Env, Current);

                        --  one iteration with the loop parameter bound to element E
                        procedure Iterate (E : Static_Value) is
                        begin
                           Define (Env, Scope, Parameter, E);
                           if Filter = No_Element or else Is_Void (Filter)
                             or else Bool_Of (Evaluate (Filter, Env, Scope))
                           then
                              Execute (Statements, Env, Scope);
                           end if;
                        end Iterate;
                     begin
                        if Iterable.Kind = Array_Value then       --  over elements
                           declare
                              --  iterate a snapshot of the elements at loop entry
                              Elements : constant Value_Vectors.Vector :=
                                Env.Arrays (Iterable.Elements);
                           begin
                              if not Backward then
                                 for I in 1 .. Natural (Elements.Length) loop
                                    exit when Pending (Env);
                                    Iterate (Elements (I));
                                 end loop;
                              else
                                 for I in reverse 1 .. Natural (Elements.Length) loop
                                    exit when Pending (Env);
                                    Iterate (Elements (I));
                                 end loop;
                              end if;
                           end;

                        elsif Iterable.Kind = Record_Value then   --  over components
                           declare
                              Fields : constant Value_Maps.Map :=
                                Env.Records (Iterable.Fields);
                              Names  : Name_Vectors.Vector;
                           begin
                              --  component-name order, so iteration is deterministic
                              for C in Fields.Iterate loop
                                 Names.Append (Value_Maps.Key (C));
                              end loop;
                              Name_Sorting.Sort (Names);
                              if not Backward then
                                 for I in 1 .. Natural (Names.Length) loop
                                    exit when Pending (Env);
                                    Iterate (Fields.Element (Names (I)));
                                 end loop;
                              else
                                 for I in reverse 1 .. Natural (Names.Length) loop
                                    exit when Pending (Env);
                                    Iterate (Fields.Element (Names (I)));
                                 end loop;
                              end if;
                           end;

                        elsif Iterable.Kind = String_Value then   --  over characters
                           declare
                              S : constant String := SU.To_String (Iterable.Text);
                           begin
                              if not Backward then
                                 for I in S'Range loop
                                    exit when Pending (Env);
                                    Iterate (Str (SU.To_Unbounded_String (S (I .. I))));
                                 end loop;
                              else
                                 for I in reverse S'Range loop
                                    exit when Pending (Env);
                                    Iterate (Str (SU.To_Unbounded_String (S (I .. I))));
                                 end loop;
                              end if;
                           end;

                        else
                           Leave (Env, Scope);
                           raise Interpretation_Error with
                             "'for ... of' requires an array, record, or string value";
                        end if;
                        Leave (Env, Scope);
                     end;

                  else
                     raise Interpretation_Error with "unsupported iterator form";
                  end if;
               end;

            elsif Is_No_Iteration (Iteration) then  --  plain "loop ... end loop"
               --  repeat the body until an exit / return / goto becomes pending.
               while not Pending (Env) loop
                  Execute (Statements, Env, Current);
               end loop;

            else
               raise Interpretation_Error with "unsupported loop form";
            end if;

            --  this loop consumes an unnamed exit (it is the innermost loop);
            --  a named exit propagates out to its matching labelled statement
            if Env.Exiting and then SU.Length (Env.Exit_Target) = 0 then
               Env.Exiting := False;
            end if;
         end;

      elsif Is_Case_Statement (Stmt) then
         declare
            Selector : constant Long_Long_Integer :=
              Whole_Of (Evaluate (As_Case_Statement (Stmt).Selector, Env, Current));
            Others_Branch : Cursor := No_Element;
            Done          : Boolean := False;
         begin
            for Alt of As_Alternative_S
                         (As_Case_Statement (Stmt).Alternatives).List
            loop
               if Is_Case_Alternative (Alt) then
                  if Has_Others (As_Case_Alternative (Alt).Choices) then
                     Others_Branch := As_Case_Alternative (Alt).Statements;
                  elsif Choice_Matches (As_Case_Alternative (Alt).Choices,
                                        Selector, Env, Current)
                  then
                     Execute (As_Case_Alternative (Alt).Statements, Env, Current);
                     Done := True;
                     exit;
                  end if;
               end if;
            end loop;
            if not Done and then Others_Branch /= No_Element then
               Execute (Others_Branch, Env, Current);
            end if;
         end;

      elsif Is_Statement_Pragma (Stmt) then
         declare
            Prag : constant Cursor := As_Statement_Pragma (Stmt).Pragma_Item;
            Name : constant String :=
              Spelling_Of (Definition_Of (As_Pragma_Item (Prag).Name));
            Args : constant Node_List :=
              As_Association_S (As_Pragma_Item (Prag).Arguments).List;
         begin
            if Name = "Assert" and then not Args.Is_Empty then
               if not Bool_Of (Evaluate (As_Positional_Association (Args (1)).Value,
                                         Env, Current))
               then
                  raise Assertion_Error with
                    (if Natural (Args.Length) >= 2
                     then Image (Evaluate (As_Positional_Association (Args (2)).Value,
                                           Env, Current), Env)
                     else "assertion failed");
               end if;
            end if;
            --  other pragmas are no-ops at runtime
         end;

      else
         raise Interpretation_Error with "cannot execute this statement node";
      end if;
   end Execute;

   procedure Run (Statements : Cursor) is
      Env    : Environment;
      Global : constant Positive := Enter (Env, 0);   --  the global scope
   begin
      Execute (Statements, Env, Global);
      if Env.Jumping then
         raise Interpretation_Error with
           "goto: label not found: " & SU.To_String (Env.Goto_Target);
      end if;
      if Env.Raising then
         raise Unhandled_Exception with
           SU.To_String (Env.Raised)
           & (if SU.Length (Env.Raised_Msg) = 0 then ""
              else " (" & SU.To_String (Env.Raised_Msg) & ")");
      end if;
   end Run;

end Diana.Interpreter;
