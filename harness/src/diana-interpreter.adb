with Ada.Text_IO;                           use Ada.Text_IO;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with Diana.Accessors;                       use Diana.Accessors;

package body Diana.Interpreter is

   use type Trees.Cursor;

   --  ---- the call stack -----------------------------------------------------
   --  Each call has a frame: its local/parameter bindings (keyed by defining-
   --  occurrence spelling, unique in this slice), plus a return slot.  Frame 1
   --  is the global frame.  Name lookup tries the top frame, then the globals.
   package Value_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Static_Value,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   type Frame is record
      Bindings : Value_Maps.Map;
      Returned : Boolean       := False;
      Result   : Static_Value  := (Kind => No_Value);
   end record;

   function Empty_Frame return Frame is
     (Bindings => Value_Maps.Empty_Map, Returned => False,
      Result   => (Kind => No_Value));

   package Frame_Vectors is new Ada.Containers.Vectors (Positive, Frame);
   package Value_Vectors is new Ada.Containers.Vectors (Positive, Static_Value);

   type Environment is limited record
      Frames : Frame_Vectors.Vector;
   end record;

   function Top (Env : Environment) return Positive is (Env.Frames.Last_Index);
   function Has_Returned (Env : Environment) return Boolean
     is (Env.Frames (Env.Frames.Last_Index).Returned);

   --  Read a name: top frame first, then the globals (frame 1).
   function Lookup (Env : Environment; Name : String) return Static_Value is
   begin
      if Env.Frames (Top (Env)).Bindings.Contains (Name) then
         return Env.Frames (Top (Env)).Bindings.Element (Name);
      elsif Env.Frames (1).Bindings.Contains (Name) then
         return Env.Frames (1).Bindings.Element (Name);
      else
         raise Interpretation_Error with "unbound variable: " & Name;
      end if;
   end Lookup;

   --  Assign a name: update where it is already bound (top frame, else the
   --  globals), otherwise introduce it in the top frame.
   procedure Bind (Env : in out Environment; Name : String; Value : Static_Value)
   is
      T : constant Positive := Top (Env);
   begin
      if not Env.Frames (T).Bindings.Contains (Name)
        and then T /= 1
        and then Env.Frames (1).Bindings.Contains (Name)
      then
         Env.Frames.Reference (1).Bindings.Include (Name, Value);
      else
         Env.Frames.Reference (T).Bindings.Include (Name, Value);
      end if;
   end Bind;

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

   --  ---- the evaluator / executor / caller (mutually recursive) -------------
   function Evaluate (Expr : Cursor; Env : in out Environment) return Static_Value;
   procedure Execute (Stmt : Cursor; Env : in out Environment);
   function Invoke (Definition : Cursor; Actuals : Node_List;
                    Env : in out Environment) return Static_Value;

   function Apply (Op : Cursor; Args : Node_List; Env : in out Environment)
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

   --  Call a user-defined subprogram: bind actuals to formals in a fresh
   --  frame, run the body block, and return its result (No_Value for a
   --  procedure).  Recursion just nests frames on the stack.
   function Invoke (Definition : Cursor; Actuals : Node_List;
                    Env : in out Environment) return Static_Value
   is
      Spec    : constant Cursor := As_Subprogram_Name (Definition).Specification;
      Comp    : constant Cursor := As_Subprogram_Name (Definition).Completion;
      Params  : Node_List;
      Formals : Node_List;             --  formal-parameter defining names, in order
      Values  : Value_Vectors.Vector;  --  actuals, evaluated in the caller's scope
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

      for A of Actuals loop
         Values.Append (Evaluate (As_Positional_Association (A).Value, Env));
      end loop;

      if Natural (Formals.Length) /= Natural (Values.Length) then
         raise Interpretation_Error with "wrong number of arguments in call";
      end if;

      Env.Frames.Append (Empty_Frame);
      for I in 1 .. Natural (Formals.Length) loop
         Env.Frames.Reference (Top (Env)).Bindings.Include
           (Spelling_Of (Formals (I)), Values (I));
      end loop;

      if Is_Block (Comp) then
         Execute (As_Block (Comp).Statements, Env);
      else
         Env.Frames.Delete_Last;
         raise Interpretation_Error with "subprogram body is not available";
      end if;

      Result := Env.Frames (Top (Env)).Result;
      Env.Frames.Delete_Last;
      return Result;
   end Invoke;

   function Evaluate (Expr : Cursor; Env : in out Environment) return Static_Value is
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
         return Lookup (Env, Spelling_Of (Definition_Of (Expr)));

      elsif Is_Function_Call (Expr) then
         declare
            Prefix : constant Cursor := As_Function_Call (Expr).Prefix;
            Args   : constant Node_List :=
              As_Association_S (As_Function_Call (Expr).Actuals).List;
         begin
            if Is_Used_Builtin (Prefix) then
               return Apply (As_Used_Builtin (Prefix).Builtin_Operator, Args, Env);
            end if;
            declare
               Def : constant Cursor := Definition_Of (Prefix);
            begin
               if Is_Subprogram_Name (Def) then
                  return Invoke (Def, Args, Env);
               else
                  raise Interpretation_Error with "call to a non-subprogram";
               end if;
            end;
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
            exit when Has_Returned (Env);
         end loop;

      elsif Is_Return_Statement (Stmt) then
         declare
            Obj : constant Cursor := As_Return_Statement (Stmt).Returned_Object;
         begin
            if Obj /= No_Element and then not Is_Void (Obj) then
               declare
                  Value : constant Static_Value := Evaluate (Obj, Env);
               begin
                  Env.Frames.Reference (Top (Env)).Result := Value;
               end;
            end if;
            Env.Frames.Reference (Top (Env)).Returned := True;
         end;

      elsif Is_Assignment (Stmt) then
         declare
            Target : constant String :=
              Spelling_Of (Definition_Of (As_Assignment (Stmt).Target));
            Value  : constant Static_Value :=
              Evaluate (As_Assignment (Stmt).Source, Env);
         begin
            Bind (Env, Target, Value);
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
                  Put_Line (Image (Evaluate (As_Positional_Association (A).Value, Env)));
               end loop;
            elsif Is_Subprogram_Name (Def) then
               Discard := Invoke (Def, Args, Env);
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
               while not Has_Returned (Env)
                 and then Bool_Of (Evaluate (As_While_Loop (Iteration).Condition, Env))
               loop
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
      Env.Frames.Append (Empty_Frame);   --  the global frame
      Execute (Statements, Env);
   end Run;

end Diana.Interpreter;
