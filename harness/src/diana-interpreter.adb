with Ada.Text_IO;                       use Ada.Text_IO;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Hash;
with Diana.Accessors;                   use Diana.Accessors;

package body Diana.Interpreter is

   use type Trees.Cursor;

   --  The environment: a variable's value keyed by its (unique, in this slice)
   --  defining-occurrence spelling.
   package Value_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Static_Value,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   type Environment is tagged limited record
      Bindings : Value_Maps.Map;
   end record;

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

   --  ---- the evaluator / executor (mutually recursive) ----------------------
   function Evaluate (Expr : Cursor; Env : Environment) return Static_Value;
   procedure Execute (Stmt : Cursor; Env : in out Environment);

   function Apply (Op : Cursor; Args : Node_List; Env : Environment)
     return Static_Value
   is
      function Operand (I : Positive) return Static_Value is
      begin
         if I > Natural (Args.Length) then
            raise Interpretation_Error with "operator: missing operand";
         end if;
         return Evaluate (As_Positional_Association (Args (I)).Value, Env);
      end Operand;
   begin
      --  unary operators
      if    Is_Op_Unary_Minus (Op) then return Int (-Whole_Of (Operand (1)));
      elsif Is_Op_Unary_Plus  (Op) then return Operand (1);
      elsif Is_Op_Absolute    (Op) then return Int (abs Whole_Of (Operand (1)));
      elsif Is_Op_Not         (Op) then return Bool (not Bool_Of (Operand (1)));
      end if;

      --  binary operators
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
         elsif Is_Op_And (Op)  then return Bool (Bool_Of (L) and Bool_Of (R));
         elsif Is_Op_Or (Op)   then return Bool (Bool_Of (L) or Bool_Of (R));
         elsif Is_Op_Xor (Op)  then return Bool (Bool_Of (L) xor Bool_Of (R));
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

   function Evaluate (Expr : Cursor; Env : Environment) return Static_Value is
   begin
      if Is_Numeric_Literal (Expr) then
         return Int (Long_Long_Integer'Value
                       (SU.To_String (As_Numeric_Literal (Expr).Literal_Image)));

      elsif Is_String_Literal (Expr) then
         return (Kind => String_Value,
                 Text => As_String_Literal (Expr).Literal_Image);

      elsif Is_Parenthesized_Expression (Expr) then
         return Evaluate (As_Parenthesized_Expression (Expr).Operand, Env);

      elsif Is_Used_Object (Expr) or else Is_Used_Name (Expr) then
         declare
            Name : constant String := Spelling_Of (Definition_Of (Expr));
         begin
            if not Env.Bindings.Contains (Name) then
               raise Interpretation_Error with "unbound variable: " & Name;
            end if;
            return Env.Bindings.Element (Name);
         end;

      elsif Is_Function_Call (Expr) then
         declare
            Prefix : constant Cursor := As_Function_Call (Expr).Prefix;
         begin
            if not Is_Used_Builtin (Prefix) then
               raise Interpretation_Error with
                 "only built-in operator calls can be evaluated";
            end if;
            return Apply (As_Used_Builtin (Prefix).Builtin_Operator,
                          As_Association_S (As_Function_Call (Expr).Actuals).List,
                          Env);
         end;

      else
         raise Interpretation_Error with "cannot evaluate this expression node";
      end if;
   end Evaluate;

   procedure Execute (Stmt : Cursor; Env : in out Environment) is
   begin
      if Is_Null_Statement (Stmt) then
         null;

      elsif Is_Statement_S (Stmt) then
         for S of As_Statement_S (Stmt).List loop
            Execute (S, Env);
         end loop;

      elsif Is_Assignment (Stmt) then
         declare
            Name : constant String :=
              Spelling_Of (Definition_Of (As_Assignment (Stmt).Target));
         begin
            Env.Bindings.Include
              (Name, Evaluate (As_Assignment (Stmt).Source, Env));
         end;

      elsif Is_Procedure_Call (Stmt) then
         declare
            Name : constant String :=
              Spelling_Of (Definition_Of (As_Procedure_Call (Stmt).Prefix));
            Args : constant Node_List :=
              As_Association_S (As_Procedure_Call (Stmt).Actuals).List;
         begin
            if Name = "Put_Line" or else Name = "Put" then
               for A of Args loop
                  Put_Line (Image (Evaluate (As_Positional_Association (A).Value, Env)));
               end loop;
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
                  Execute (As_Conditional_Clause (Clause).Statements, Env);  -- "else"
                  exit;
               elsif Bool_Of (Evaluate (Condition, Env)) then
                  Execute (As_Conditional_Clause (Clause).Statements, Env);
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
               while Bool_Of (Evaluate (As_While_Loop (Iteration).Condition, Env)) loop
                  Execute (Statements, Env);
               end loop;
            else
               raise Interpretation_Error with "only while-loops are supported";
            end if;
         end;

      else
         raise Interpretation_Error with "cannot execute this statement node";
      end if;
   end Execute;

   procedure Run (Statements : Cursor) is
      Env : Environment;
   begin
      Execute (Statements, Env);
   end Run;

end Diana.Interpreter;
