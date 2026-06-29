--  interp_demo — build a small DIANA program and execute it with the
--  interpreter.  The program assembled below is, in Ada surface syntax:
--
--     Sum := 0;
--     N   := 1;
--     while N <= 5 loop
--        Sum := Sum + N;
--        N   := N + 1;
--     end loop;
--     Put_Line (Sum);          --  expects 15
--
--  Everything is built bottom-up with Diana.Builders and run via
--  Diana.Interpreter, exercising the execute-a-given-DIANA-tree requirement.

with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Exceptions;
with Diana;            use Diana;
with Diana.Nodes;
with Diana.Builders;
with Diana.Interpreter;

procedure Interp_Demo is
   package B renames Diana.Builders;

   Program_Tree : Tree;
   type Cursor_Array is array (Positive range <>) of Cursor;

   --  Append a node under the tree root and return its cursor; structure is
   --  carried by the nodes' cursor attributes, not by tree-child order.
   function Add (N : Node'Class) return Cursor is
   begin
      Program_Tree.Append_Child (Program_Tree.Root, N);
      return Trees.Last_Child (Program_Tree.Root);
   end Add;

   --  A Node_List (an IDL "Seq Of") from a literal array of cursors.
   function NL (Items : Cursor_Array) return Node_List is
      L : Node_List;
   begin
      for I of Items loop
         L.Append (I);
      end loop;
      return L;
   end NL;

   --  The symbol table: operators and defining occurrences, built once.
   Op_Plus  : constant Cursor := Add (B.Op_Plus);
   Op_Minus : constant Cursor := Add (B.Op_Minus);
   Op_Mul   : constant Cursor := Add (B.Op_Multiply);
   Op_Le    : constant Cursor := Add (B.Op_Less_Equal);
   Sum_Def  : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Sum")));
   N_Def    : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("N")));
   Put_Def  : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Put_Line")));
   --  The recursive function "Fact" and its formal parameter "N".  Subprogram_
   --  Name is created first (a stub); its spec and body are filled in once the
   --  body — which calls Fact recursively — has been built.
   Fact_Def : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Fact")));
   N_Param  : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("N")));
   --  Two distinct defining occurrences, both spelled "X": a global and a
   --  block-local that shadows it.
   X_Global : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("X")));
   X_Local  : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("X")));

   --  Expression constructors.
   function Lit (V : Integer) return Cursor is
     (Add (B.Numeric_Literal
             (Literal_Image => SU.To_Unbounded_String (Integer'Image (V)))));

   function Ref (Definition : Cursor) return Cursor is
     (Add (B.Used_Object (Definition => Definition)));

   function Call (Op : Cursor; Operands : Cursor_Array) return Cursor is
      Items : Node_List;
   begin
      for Operand of Operands loop
         Items.Append (Add (B.Positional_Association (Value => Operand)));
      end loop;
      return Add (B.Function_Call
                    (Prefix  => Add (B.Used_Builtin (Builtin_Operator => Op)),
                     Actuals => Add (B.Association_S (List => Items))));
   end Call;

   function Bin (Op, L, R : Cursor) return Cursor is (Call (Op, [L, R]));

   --  Statement constructors.
   function Assign (Target_Def, Source : Cursor) return Cursor is
     (Add (B.Assignment (Target => Ref (Target_Def), Source => Source)));

   function Seq (Items : Cursor_Array) return Cursor is
      L : Node_List;
   begin
      for I of Items loop
         L.Append (I);
      end loop;
      return Add (B.Statement_S (List => L));
   end Seq;

   function While_Do (Condition, Body_Seq : Cursor) return Cursor is
     (Add (B.Loop_Statement
             (Iteration  => Add (B.While_Loop (Condition => Condition)),
              Statements => Body_Seq)));

   function Print (Arg : Cursor) return Cursor is
      Actual : constant Cursor := Add (B.Positional_Association (Value => Arg));
   begin
      return Add (B.Procedure_Call
                    (Prefix  => Add (B.Used_Name (Definition => Put_Def)),
                     Actuals => Add (B.Association_S (List => NL ([Actual])))));
   end Print;

   --  A call to a user subprogram Def with the given actuals.
   function Sub_Call (Def : Cursor; Args : Cursor_Array) return Cursor is
      Items : Node_List;
   begin
      for A of Args loop
         Items.Append (Add (B.Positional_Association (Value => A)));
      end loop;
      return Add (B.Function_Call
                    (Prefix  => Add (B.Used_Name (Definition => Def)),
                     Actuals => Add (B.Association_S (List => Items))));
   end Sub_Call;

   function Ret (Value : Cursor) return Cursor is
     (Add (B.Return_Statement (Returned_Object => Value)));

   --  "if Condition then Then_Seq else Else_Seq end if" (the else clause has a
   --  null condition, which the interpreter reads as the else arm).
   function If_Else (Condition, Then_Seq, Else_Seq : Cursor) return Cursor is
     (Add (B.If_Statement
             (Clauses => Add (B.Conditional_Clause_S
               (List => NL
                  ([Add (B.Conditional_Clause (Condition  => Condition,
                                               Statements => Then_Seq)),
                    Add (B.Conditional_Clause (Statements => Else_Seq))]))))));

   --  "Definition : <type> := Init;" object declaration.
   function Var_Decl (Definition, Init : Cursor) return Cursor is
     (Add (B.Variable_Declaration
             (Names          => Add (B.Defining_Name_S (List => NL ([Definition]))),
              Initialization => Init)));

   --  "declare <Decls> begin <Stmts> end;" block statement.
   function Block_Stmt (Decls, Stmts : Cursor_Array) return Cursor is
     (Add (B.Block_Statement
             (Block => Add (B.Block
               (Declarations => Add (B.Item_S (List => NL (Decls))),
                Statements   => Add (B.Statement_S (List => NL (Stmts))))))));

   --  The summation program (no calls).
   Program : constant Cursor :=
     Seq ([Assign (Sum_Def, Lit (0)),
           Assign (N_Def,   Lit (1)),
           While_Do (Bin (Op_Le, Ref (N_Def), Lit (5)),
                     Seq ([Assign (Sum_Def, Bin (Op_Plus, Ref (Sum_Def), Ref (N_Def))),
                           Assign (N_Def,   Bin (Op_Plus, Ref (N_Def),   Lit (1)))])),
           Print (Ref (Sum_Def))]);

   --  function Fact (N : Integer) return Integer is
   --     begin if N <= 1 then return 1; else return N * Fact (N - 1); end if; end;
   N_Formal  : constant Cursor :=
     Add (B.In_Parameter
            (Names => Add (B.Defining_Name_S (List => NL ([N_Param])))));
   Fact_Spec : constant Cursor :=
     Add (B.Function_Header
            (Parameters => Add (B.Parameter_S (List => NL ([N_Formal])))));
   Fact_Body : constant Cursor :=
     Add (B.Block
            (Statements => Seq
              ([If_Else (Bin (Op_Le, Ref (N_Param), Lit (1)),
                         Seq ([Ret (Lit (1))]),
                         Seq ([Ret (Bin (Op_Mul, Ref (N_Param),
                                         Sub_Call (Fact_Def,
                                           [Bin (Op_Minus, Ref (N_Param), Lit (1))])))]))])));

   --  Put_Line (Fact (5));   -- expects 120
   Fact_Program : constant Cursor :=
     Seq ([Print (Sub_Call (Fact_Def, [Lit (5)]))]);

   --  X := 100;  declare X : Integer := 7; begin Put_Line (X); end;  Put_Line (X);
   Scope_Program : constant Cursor :=
     Seq ([Assign (X_Global, Lit (100)),
           Block_Stmt ([Var_Decl (X_Local, Lit (7))],
                       [Print (Ref (X_Local))]),
           Print (Ref (X_Global))]);

   --  Fill Fact's stub now that its spec and body exist.
   procedure Define_Fact (E : in out Node'Class) is
   begin
      if E in Diana.Nodes.Subprogram_Name'Class then
         Diana.Nodes.Subprogram_Name (E).Specification := Fact_Spec;
         Diana.Nodes.Subprogram_Name (E).Completion    := Fact_Body;
      end if;
   end Define_Fact;
begin
   Put_Line ("DIANA_2022 interpreter — executing a built program:");
   New_Line;
   Put_Line ("    Sum := 0;");
   Put_Line ("    N   := 1;");
   Put_Line ("    while N <= 5 loop");
   Put_Line ("       Sum := Sum + N;");
   Put_Line ("       N   := N + 1;");
   Put_Line ("    end loop;");
   Put_Line ("    Put_Line (Sum);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Program);

   --  Subprogram calls + a call stack: a recursive factorial.
   New_Line;
   Put_Line ("Executing (recursion + call stack):");
   Put_Line ("    function Fact (N) is");
   Put_Line ("       if N <= 1 then return 1; else return N * Fact (N - 1); end if;");
   Put_Line ("    Put_Line (Fact (5));");
   New_Line;
   Put_Line ("Output:");
   Program_Tree.Update_Element (Fact_Def, Define_Fact'Access);  -- complete Fact's stub
   Diana.Interpreter.Run (Fact_Program);

   --  Lexically-scoped local declaration: a block-local shadows a global, and
   --  the global is unchanged after the block exits.
   New_Line;
   Put_Line ("Executing (lexically-scoped local declaration):");
   Put_Line ("    X := 100;");
   Put_Line ("    declare X : Integer := 7; begin Put_Line (X); end;  -- local shadows");
   Put_Line ("    Put_Line (X);                                       -- global unchanged");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Scope_Program);

   --  The execute-or-error requirement: running a use of an unbound variable
   --  must fail rather than produce a wrong answer.
   New_Line;
   Put_Line ("Error path — executing 'Put_Line (Undefined);':");
   declare
      Undef : constant Cursor :=
        Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Undefined")));
      Bad   : constant Cursor := Seq ([Print (Ref (Undef))]);
   begin
      Diana.Interpreter.Run (Bad);
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Interpretation_Error =>
         Put_Line ("    errored out as required: "
                   & Ada.Exceptions.Exception_Message (E));
   end;
end Interp_Demo;
