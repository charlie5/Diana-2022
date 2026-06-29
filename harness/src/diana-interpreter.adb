with Ada.Text_IO;                           use Ada.Text_IO;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with Diana.Accessors;                       use Diana.Accessors;

package body Diana.Interpreter is

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

   type Scope is record
      Bindings : Value_Maps.Map;
      Parent   : Natural := 0;        --  enclosing scope index, 0 = none
   end record;

   package Scope_Vectors is new Ada.Containers.Vectors (Positive, Scope);
   package Value_Vectors is new Ada.Containers.Vectors (Positive, Static_Value);

   Global_Scope : constant Positive := 1;

   type Environment is limited record
      Scopes       : Scope_Vectors.Vector;
      Returning    : Boolean      := False;          --  a return is in progress
      Return_Value : Static_Value := (Kind => No_Value);
   end record;

   --  Push a fresh scope whose enclosing scope is Parent; return its index.
   function Enter (Env : in out Environment; Parent : Natural) return Positive is
   begin
      Env.Scopes.Append (Scope'(Bindings => Value_Maps.Empty_Map, Parent => Parent));
      return Env.Scopes.Last_Index;
   end Enter;

   --  Pop every scope from Down_To upward (LIFO unwinding).
   procedure Leave (Env : in out Environment; Down_To : Positive) is
   begin
      while not Env.Scopes.Is_Empty and then Env.Scopes.Last_Index >= Down_To loop
         Env.Scopes.Delete_Last;
      end loop;
   end Leave;

   procedure Define (Env : in out Environment; Scope_Index : Positive;
                     Name : String; Value : Static_Value) is
   begin
      Env.Scopes.Reference (Scope_Index).Bindings.Include (Name, Value);
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

   --  ---- value helpers ------------------------------------------------------
   function Int  (V : Long_Long_Integer) return Static_Value
     is ((Kind => Integer_Value, Whole => V));
   function Bool (V : Boolean) return Static_Value
     is ((Kind => Boolean_Value, Flag => V));

   function Whole_Of (V : Static_Value) return Long_Long_Integer is
   begin
      if V.Kind /= Integer_Value then
         raise Interpretation_Error with "expected an integer value";
      end if;
      return V.Whole;
   end Whole_Of;

   function Bool_Of (V : Static_Value) return Boolean is
   begin
      if V.Kind /= Boolean_Value then
         raise Interpretation_Error with "expected a boolean value";
      end if;
      return V.Flag;
   end Bool_Of;

   function Image (V : Static_Value) return String is
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
         when Real_Value    => return Long_Long_Float'Image (V.Number);
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

   --  ---- evaluator / executor / caller (mutually recursive) -----------------
   function Evaluate (Expr : Cursor; Env : in out Environment; Current : Positive)
     return Static_Value;
   procedure Execute (Stmt : Cursor; Env : in out Environment; Current : Positive);
   function Invoke (Definition : Cursor; Actuals : Node_List;
                    Env : in out Environment; Current : Positive) return Static_Value;

   --  Elaborate object declarations (variables / constants) into Scope_Index,
   --  evaluating their initialisers; other declaration kinds are ignored here.
   procedure Elaborate (Decls : Node_List; Env : in out Environment;
                        Scope_Index : Positive)
   is
      procedure Declare_Objects (Names, Init : Cursor) is
         Value : Static_Value := (Kind => No_Value);
      begin
         if Init /= No_Element and then not Is_Void (Init) then
            Value := Evaluate (Init, Env, Scope_Index);
         end if;
         for Nm of As_Defining_Name_S (Names).List loop
            Define (Env, Scope_Index, Spelling_Of (Nm), Value);
         end loop;
      end Declare_Objects;
   begin
      for D of Decls loop
         if Is_Variable_Declaration (D) then
            Declare_Objects (As_Variable_Declaration (D).Names,
                             As_Variable_Declaration (D).Initialization);
         elsif Is_Constant_Declaration (D) then
            Declare_Objects (As_Constant_Declaration (D).Names,
                             As_Constant_Declaration (D).Initialization);
         end if;
      end loop;
   end Elaborate;

   --  Elaborate a Block's declarations into Scope_Index, then run its
   --  statements there (used for both block statements and subprogram bodies).
   procedure Run_Block_In (Block_Cursor : Cursor; Env : in out Environment;
                           Scope_Index : Positive)
   is
      Declarations : constant Cursor := As_Block (Block_Cursor).Declarations;
      Statements   : constant Cursor := As_Block (Block_Cursor).Statements;
   begin
      if Declarations /= No_Element and then Is_Item_S (Declarations) then
         Elaborate (As_Item_S (Declarations).List, Env, Scope_Index);
      end if;
      if Statements /= No_Element and then Is_Statement_S (Statements) then
         Execute (Statements, Env, Scope_Index);
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
   begin
      if    Is_Op_Unary_Minus (Op) then return Int (-Whole_Of (Operand (1)));
      elsif Is_Op_Unary_Plus  (Op) then return Operand (1);
      elsif Is_Op_Absolute    (Op) then return Int (abs Whole_Of (Operand (1)));
      elsif Is_Op_Not         (Op) then return Bool (not Bool_Of (Operand (1)));
      end if;

      declare
         L : constant Static_Value := Operand (1);
         R : constant Static_Value := Operand (2);
      begin
         if    Is_Op_Plus (Op)         then return Int (Whole_Of (L) + Whole_Of (R));
         elsif Is_Op_Minus (Op)        then return Int (Whole_Of (L) - Whole_Of (R));
         elsif Is_Op_Multiply (Op)     then return Int (Whole_Of (L) * Whole_Of (R));
         elsif Is_Op_Divide (Op)       then return Int (Whole_Of (L) / Whole_Of (R));
         elsif Is_Op_Modulo (Op)       then return Int (Whole_Of (L) mod Whole_Of (R));
         elsif Is_Op_Remainder (Op)    then return Int (Whole_Of (L) rem Whole_Of (R));
         elsif Is_Op_Exponentiate (Op) then
            return Int (Whole_Of (L) ** Natural (Whole_Of (R)));
         elsif Is_Op_And (Op) then return Bool (Bool_Of (L) and Bool_Of (R));
         elsif Is_Op_Or (Op)  then return Bool (Bool_Of (L) or Bool_Of (R));
         elsif Is_Op_Xor (Op) then return Bool (Bool_Of (L) xor Bool_Of (R));
         elsif Is_Op_Equal (Op)         then return Bool (Whole_Of (L) =  Whole_Of (R));
         elsif Is_Op_Not_Equal (Op)     then return Bool (Whole_Of (L) /= Whole_Of (R));
         elsif Is_Op_Less (Op)          then return Bool (Whole_Of (L) <  Whole_Of (R));
         elsif Is_Op_Less_Equal (Op)    then return Bool (Whole_Of (L) <= Whole_Of (R));
         elsif Is_Op_Greater (Op)       then return Bool (Whole_Of (L) >  Whole_Of (R));
         elsif Is_Op_Greater_Equal (Op) then return Bool (Whole_Of (L) >= Whole_Of (R));
         else
            raise Interpretation_Error with "unsupported operator";
         end if;
      end;
   end Apply;

   --  Call a user-defined subprogram.  The call scope's lexical parent is the
   --  global scope (top-level subprogram); recursion nests fresh call scopes.
   function Invoke (Definition : Cursor; Actuals : Node_List;
                    Env : in out Environment; Current : Positive) return Static_Value
   is
      Spec    : constant Cursor := As_Subprogram_Name (Definition).Specification;
      Comp    : constant Cursor := As_Subprogram_Name (Definition).Completion;
      Params  : Node_List;
      Formals : Node_List;
      Values  : Value_Vectors.Vector;
      Call    : Positive;
      Result  : Static_Value;
   begin
      if    Is_Procedure_Header (Spec) then
         Params := As_Parameter_S (As_Procedure_Header (Spec).Parameters).List;
      elsif Is_Function_Header (Spec) then
         Params := As_Parameter_S (As_Function_Header (Spec).Parameters).List;
      else
         raise Interpretation_Error with "subprogram specification is not callable";
      end if;

      for P of Params loop
         declare
            Names : Cursor;
         begin
            if    Is_In_Parameter (P)     then Names := As_In_Parameter (P).Names;
            elsif Is_Out_Parameter (P)    then Names := As_Out_Parameter (P).Names;
            elsif Is_In_Out_Parameter (P) then Names := As_In_Out_Parameter (P).Names;
            else raise Interpretation_Error with "unsupported parameter kind";
            end if;
            for Nm of As_Defining_Name_S (Names).List loop
               Formals.Append (Nm);
            end loop;
         end;
      end loop;

      --  actuals are evaluated in the caller's scope
      for A of Actuals loop
         Values.Append (Evaluate (As_Positional_Association (A).Value, Env, Current));
      end loop;

      if Natural (Formals.Length) /= Natural (Values.Length) then
         raise Interpretation_Error with "wrong number of arguments in call";
      end if;

      if not Is_Block (Comp) then
         raise Interpretation_Error with "subprogram body is not available";
      end if;

      Call := Enter (Env, Global_Scope);
      for I in 1 .. Natural (Formals.Length) loop
         Define (Env, Call, Spelling_Of (Formals (I)), Values (I));
      end loop;

      Env.Returning    := False;
      Env.Return_Value := (Kind => No_Value);
      Run_Block_In (Comp, Env, Call);
      Result := Env.Return_Value;
      Env.Returning := False;
      Leave (Env, Call);
      return Result;
   end Invoke;

   function Evaluate (Expr : Cursor; Env : in out Environment; Current : Positive)
     return Static_Value is
   begin
      if Is_Numeric_Literal (Expr) then
         return Int (Long_Long_Integer'Value
                       (SU.To_String (As_Numeric_Literal (Expr).Literal_Image)));

      elsif Is_String_Literal (Expr) then
         return (Kind => String_Value,
                 Text => As_String_Literal (Expr).Literal_Image);

      elsif Is_Parenthesized_Expression (Expr) then
         return Evaluate (As_Parenthesized_Expression (Expr).Operand, Env, Current);

      elsif Is_Used_Object (Expr) or else Is_Used_Name (Expr) then
         return Lookup (Env, Current, Spelling_Of (Definition_Of (Expr)));

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
            declare
               Def : constant Cursor := Definition_Of (Prefix);
            begin
               if Is_Subprogram_Name (Def) then
                  return Invoke (Def, Args, Env, Current);
               else
                  raise Interpretation_Error with "call to a non-subprogram";
               end if;
            end;
         end;

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
      else
         raise Interpretation_Error with "unsupported discrete range";
      end if;
   end Eval_Range;

   --  Does a case alternative carry an "others" choice?
   function Has_Others (Alt : Cursor) return Boolean is
   begin
      for C of As_Choice_S (As_Case_Alternative (Alt).Choices).List loop
         if Is_Others_Choice (C) then
            return True;
         end if;
      end loop;
      return False;
   end Has_Others;

   --  Does any value/range choice of the alternative cover the selector value?
   function Choice_Matches (Alt : Cursor; Selector : Long_Long_Integer;
                            Env : in out Environment; Current : Positive)
     return Boolean
   is
      Low, High : Long_Long_Integer;
   begin
      for C of As_Choice_S (As_Case_Alternative (Alt).Choices).List loop
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

   procedure Execute (Stmt : Cursor; Env : in out Environment; Current : Positive) is
   begin
      if Is_Null_Statement (Stmt) then
         null;

      elsif Is_Statement_S (Stmt) then
         for S of As_Statement_S (Stmt).List loop
            Execute (S, Env, Current);
            exit when Env.Returning;
         end loop;

      elsif Is_Block_Statement (Stmt) then
         declare
            Inner : constant Positive := Enter (Env, Current);
         begin
            Run_Block_In (As_Block_Statement (Stmt).Block, Env, Inner);
            Leave (Env, Inner);
         end;

      elsif Is_Return_Statement (Stmt) then
         declare
            Obj : constant Cursor := As_Return_Statement (Stmt).Returned_Object;
         begin
            if Obj /= No_Element and then not Is_Void (Obj) then
               Env.Return_Value := Evaluate (Obj, Env, Current);
            end if;
            Env.Returning := True;
         end;

      elsif Is_Assignment (Stmt) then
         declare
            Target : constant String :=
              Spelling_Of (Definition_Of (As_Assignment (Stmt).Target));
            Value  : constant Static_Value :=
              Evaluate (As_Assignment (Stmt).Source, Env, Current);
         begin
            Assign (Env, Current, Target, Value);
         end;

      elsif Is_Procedure_Call (Stmt) then
         declare
            Def  : constant Cursor :=
              Definition_Of (As_Procedure_Call (Stmt).Prefix);
            Name : constant String := Spelling_Of (Def);
            Args : constant Node_List :=
              As_Association_S (As_Procedure_Call (Stmt).Actuals).List;
            Discard : Static_Value;
         begin
            if Name = "Put_Line" or else Name = "Put" then
               for A of Args loop
                  Put_Line (Image (Evaluate (As_Positional_Association (A).Value,
                                             Env, Current)));
               end loop;
            elsif Is_Subprogram_Name (Def) then
               Discard := Invoke (Def, Args, Env, Current);
            else
               raise Interpretation_Error with "unknown procedure: " & Name;
            end if;
         end;

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
               while not Env.Returning
                 and then Bool_Of (Evaluate (As_While_Loop (Iteration).Condition,
                                             Env, Current))
               loop
                  Execute (Statements, Env, Current);
               end loop;

            elsif Is_For_Loop (Iteration) then
               declare
                  Iter : constant Cursor := As_For_Loop (Iteration).Iterator;
               begin
                  if not Is_Range_Iterator (Iter) then
                     raise Interpretation_Error with
                       "only range-based for loops are supported";
                  end if;
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
                           while V <= High and then not Env.Returning loop
                              Iterate (V);
                              exit when V = High;   --  guard type'Last overflow
                              V := V + 1;
                           end loop;
                        end;
                     else
                        declare
                           V : Long_Long_Integer := High;
                        begin
                           while V >= Low and then not Env.Returning loop
                              Iterate (V);
                              exit when V = Low;
                              V := V - 1;
                           end loop;
                        end;
                     end if;
                     Leave (Env, Scope);
                  end;
               end;

            else
               raise Interpretation_Error with "unsupported loop form";
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
                  if Has_Others (Alt) then
                     Others_Branch := As_Case_Alternative (Alt).Statements;
                  elsif Choice_Matches (Alt, Selector, Env, Current) then
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

      else
         raise Interpretation_Error with "cannot execute this statement node";
      end if;
   end Execute;

   procedure Run (Statements : Cursor) is
      Env    : Environment;
      Global : constant Positive := Enter (Env, 0);   --  the global scope
   begin
      Execute (Statements, Env, Global);
   end Run;

end Diana.Interpreter;
