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
   Op_Lt    : constant Cursor := Add (B.Op_Less);
   Op_Eq    : constant Cursor := Add (B.Op_Equal);
   Op_Cat   : constant Cursor := Add (B.Op_Concatenate);
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
   --  Loop variables / accumulator for the for-loop + case demo.
   Total_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Total")));
   I_Def     : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("I")));
   J_Def     : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("J")));
   --  out / in out copy-back demo: caller variables, Swap's formals + local,
   --  and Get_Answer's out formal.
   A_Def   : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("A")));
   B_Def   : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("B")));
   C_Def   : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("C")));
   X_Par   : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("X")));
   Y_Par   : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("Y")));
   T_Local : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("T")));
   R_Par   : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("R")));
   --  real-value demo variables.
   Pi_Def     : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Pi")));
   Radius_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Radius")));
   --  closure demo: Outer's parameter N, Inner's parameter M.
   N_Outer : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("N")));
   M_Inner : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("M")));
   --  exit / goto demo: an accumulator, a loop name, and a goto label.
   Found_Def   : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Found")));
   Outer_Loop  : constant Cursor :=
     Add (B.Loop_Block_Name (Spelling => SU.To_Unbounded_String ("Outer")));
   Again_Label : constant Cursor :=
     Add (B.Statement_Label_Name (Spelling => SU.To_Unbounded_String ("Again")));
   --  access-value demo: two pointers that alias the same heap object.
   P_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("P")));
   Q_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Q")));

   --  Expression constructors.
   function Lit (V : Integer) return Cursor is
     (Add (B.Numeric_Literal
             (Literal_Image => SU.To_Unbounded_String (Integer'Image (V)))));

   --  Real / string literals (the literal image carries the source spelling).
   function Real_Lit (Image : String) return Cursor is
     (Add (B.Numeric_Literal (Literal_Image => SU.To_Unbounded_String (Image))));
   function Str_Lit (S : String) return Cursor is
     (Add (B.String_Literal (Literal_Image => SU.To_Unbounded_String (S))));

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

   --  "for Param_Def in Low .. High loop Body_Seq end loop".
   function For_In (Param_Def : Cursor; Low, High : Integer;
                    Body_Seq : Cursor; Backward : Boolean := False) return Cursor is
     (Add (B.Loop_Statement
             (Iteration => Add (B.For_Loop (Iterator => Add (B.Range_Iterator
                (Parameter      => Param_Def,
                 Discrete_Range => Add (B.Range_Bounds (Lower => Lit (Low),
                                                        Upper => Lit (High))),
                 Reverse_Order  => Backward)))),
              Statements => Body_Seq)));

   --  Case choices and alternatives.
   function Val_Choice (V : Integer) return Cursor is
     (Add (B.Choice_Expression (Value => Lit (V))));
   function Range_Choice (Low, High : Integer) return Cursor is
     (Add (B.Choice_Range (Range_Item => Add (B.Range_Bounds (Lower => Lit (Low),
                                                              Upper => Lit (High))))));
   function Others_Ch return Cursor is (Add (B.Others_Choice));
   function Alt (Choices : Cursor_Array; Stmts : Cursor) return Cursor is
     (Add (B.Case_Alternative (Choices    => Add (B.Choice_S (List => NL (Choices))),
                               Statements => Stmts)));
   function Case_Of (Selector : Cursor; Alternatives : Cursor_Array) return Cursor is
     (Add (B.Case_Statement
             (Selector     => Selector,
              Alternatives => Add (B.Alternative_S (List => NL (Alternatives))))));

   --  Parameters, a procedure spec, a bare body block, and a procedure call.
   function In_Out_Par (Def : Cursor) return Cursor is
     (Add (B.In_Out_Parameter (Names => Add (B.Defining_Name_S (List => NL ([Def]))))));
   function Out_Par (Def : Cursor) return Cursor is
     (Add (B.Out_Parameter (Names => Add (B.Defining_Name_S (List => NL ([Def]))))));
   function Proc_Spec (Params : Cursor_Array) return Cursor is
     (Add (B.Procedure_Header (Parameters => Add (B.Parameter_S (List => NL (Params))))));
   function Blk (Decls, Stmts : Cursor_Array) return Cursor is
     (Add (B.Block (Declarations => Add (B.Item_S (List => NL (Decls))),
                    Statements   => Add (B.Statement_S (List => NL (Stmts))))));
   function Call_Proc (Def : Cursor; Args : Cursor_Array) return Cursor is
      Items : Node_List;
   begin
      for A of Args loop
         Items.Append (Add (B.Positional_Association (Value => A)));
      end loop;
      return Add (B.Procedure_Call
                    (Prefix  => Add (B.Used_Name (Definition => Def)),
                     Actuals => Add (B.Association_S (List => Items))));
   end Call_Proc;

   --  an "in" parameter, a function spec, and a nested subprogram-body item.
   function In_Par (Def : Cursor) return Cursor is
     (Add (B.In_Parameter (Names => Add (B.Defining_Name_S (List => NL ([Def]))))));
   function Func_Spec (Params : Cursor_Array) return Cursor is
     (Add (B.Function_Header (Parameters => Add (B.Parameter_S (List => NL (Params))))));
   function Sub_Body_Item (Designator : Cursor) return Cursor is
     (Add (B.Subprogram_Body (Designator => Designator)));

   --  "if Condition then Then_Seq end if" (no else arm).
   function If_Then (Condition, Then_Seq : Cursor) return Cursor is
     (Add (B.If_Statement
             (Clauses => Add (B.Conditional_Clause_S (List => NL
               ([Add (B.Conditional_Clause (Condition  => Condition,
                                            Statements => Then_Seq))]))))));

   --  exit / named exit / goto, and a labelled statement.
   function Exit_When (Condition : Cursor) return Cursor is
     (Add (B.Exit_Statement (Condition => Condition)));
   function Exit_From (Loop_Name_Def : Cursor) return Cursor is
     (Add (B.Exit_Statement
             (Loop_Name => Add (B.Used_Name (Definition => Loop_Name_Def)))));
   function Goto_Stmt (Label_Def : Cursor) return Cursor is
     (Add (B.Goto_Statement
             (Target => Add (B.Used_Name (Definition => Label_Def)))));
   function Labeled (Label_Def, Statement : Cursor) return Cursor is
     (Add (B.Labeled_Statement
             (Labels    => Add (B.Defining_Name_S (List => NL ([Label_Def]))),
              Statement => Statement)));

   --  access values: "new Integer'(V)", "name.all", "null", and an assignment
   --  to an arbitrary target (e.g. a dereference).
   function New_Int (V : Integer) return Cursor is
     (Add (B.Qualified_Allocator (Value => Lit (V))));
   function Deref (Acc : Cursor) return Cursor is
     (Add (B.Dereference (Prefix => Acc)));
   function Null_Acc return Cursor is (Add (B.Null_Literal));
   function Assign_To (Target, Source : Cursor) return Cursor is
     (Add (B.Assignment (Target => Target, Source => Source)));

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

   --  for J in 1 .. 10 loop Total := Total + J; end loop; Put_Line (Total);  -- 55
   --  for I in 1 .. 5 loop case I is ... end case; end loop;     -- 100 200 30 40 5
   Loops_Program : constant Cursor :=
     Seq ([Assign (Total_Def, Lit (0)),
           For_In (J_Def, 1, 10,
                   Seq ([Assign (Total_Def,
                                 Bin (Op_Plus, Ref (Total_Def), Ref (J_Def)))])),
           Print (Ref (Total_Def)),
           For_In (I_Def, 1, 5,
                   Seq ([Case_Of (Ref (I_Def),
                          [Alt ([Val_Choice (1), Val_Choice (2)],
                                Seq ([Print (Bin (Op_Mul, Ref (I_Def), Lit (100)))])),
                           Alt ([Range_Choice (3, 4)],
                                Seq ([Print (Bin (Op_Mul, Ref (I_Def), Lit (10)))])),
                           Alt ([Others_Ch],
                                Seq ([Print (Ref (I_Def))]))])]))]);

   --  procedure Swap (X, Y : in out Integer) is T : Integer := X;
   --     begin X := Y; Y := T; end;
   Swap_Def : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Swap"),
             Specification => Proc_Spec ([In_Out_Par (X_Par), In_Out_Par (Y_Par)]),
             Completion    => Blk ([Var_Decl (T_Local, Ref (X_Par))],
                                   [Assign (X_Par, Ref (Y_Par)),
                                    Assign (Y_Par, Ref (T_Local))])));

   --  procedure Get_Answer (R : out Integer) is begin R := 42; end;
   Answer_Def : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Get_Answer"),
             Specification => Proc_Spec ([Out_Par (R_Par)]),
             Completion    => Blk ([], [Assign (R_Par, Lit (42))])));

   --  A := 1; B := 2; Swap (A, B); Put_Line (A); Put_Line (B);  -- 2, 1
   --  Get_Answer (C); Put_Line (C);                             -- 42
   Params_Program : constant Cursor :=
     Seq ([Assign (A_Def, Lit (1)),
           Assign (B_Def, Lit (2)),
           Call_Proc (Swap_Def, [Ref (A_Def), Ref (B_Def)]),
           Print (Ref (A_Def)),
           Print (Ref (B_Def)),
           Call_Proc (Answer_Def, [Ref (C_Def)]),
           Print (Ref (C_Def))]);

   --  Pi := 3.14; Radius := 2.0; Put_Line (Pi * Radius * Radius);   -- 12.5600
   --  Put_Line ("Hello, " & "DIANA" & "!");  Put_Line (Radius <= Pi);  -- True
   Values_Program : constant Cursor :=
     Seq ([Assign (Pi_Def, Real_Lit ("3.14")),
           Assign (Radius_Def, Real_Lit ("2.0")),
           Print (Bin (Op_Mul, Bin (Op_Mul, Ref (Pi_Def), Ref (Radius_Def)),
                       Ref (Radius_Def))),
           Print (Bin (Op_Cat, Bin (Op_Cat, Str_Lit ("Hello, "), Str_Lit ("DIANA")),
                       Str_Lit ("!"))),
           Print (Bin (Op_Le, Ref (Radius_Def), Ref (Pi_Def)))]);

   --  function Outer (N : Integer) return Integer is
   --     function Inner (M : Integer) return Integer is begin return M + N; end;
   --     begin return Inner (10); end;        -- Inner closes over Outer's N
   Inner_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Inner"),
             Specification => Func_Spec ([In_Par (M_Inner)]),
             Completion    => Blk ([], [Ret (Bin (Op_Plus, Ref (M_Inner),
                                                  Ref (N_Outer)))])));
   Outer_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Outer"),
             Specification => Func_Spec ([In_Par (N_Outer)]),
             Completion    => Blk ([Sub_Body_Item (Inner_Name)],
                                   [Ret (Sub_Call (Inner_Name, [Lit (10)]))])));

   --  Put_Line (Outer (5));   -- 15  (Inner returns 10 + Outer's N)
   Closure_Program : constant Cursor :=
     Seq ([Print (Sub_Call (Outer_Name, [Lit (5)]))]);

   --  for J in 1 .. 3 loop if I * J = 6 then Found := I*100 + J; exit Outer; end if;
   Inner_For : constant Cursor :=
     For_In (J_Def, 1, 3,
       Seq ([If_Then
               (Bin (Op_Eq, Bin (Op_Mul, Ref (I_Def), Ref (J_Def)), Lit (6)),
                Seq ([Assign (Found_Def,
                              Bin (Op_Plus,
                                   Bin (Op_Mul, Ref (I_Def), Lit (100)),
                                   Ref (J_Def))),
                      Exit_From (Outer_Loop)]))]));

   --  Outer: for I in 1 .. 3 loop <Inner_For> end loop Outer;
   Outer_For : constant Cursor :=
     Labeled (Outer_Loop, For_In (I_Def, 1, 3, Seq ([Inner_For])));

   --  Sum := 0; for I in 1 .. 100 loop Sum := Sum + I; exit when I = 5; end loop;
   --  Found := 0; <Outer_For>;  Put_Line (Sum); Put_Line (Found);
   Exit_Program : constant Cursor :=
     Seq ([Assign (Sum_Def, Lit (0)),
           For_In (I_Def, 1, 100,
                   Seq ([Assign (Sum_Def, Bin (Op_Plus, Ref (Sum_Def), Ref (I_Def))),
                         Exit_When (Bin (Op_Eq, Ref (I_Def), Lit (5)))])),
           Print (Ref (Sum_Def)),                                          -- 15
           Assign (Found_Def, Lit (0)),
           Outer_For,
           Print (Ref (Found_Def))]);                                      -- 203

   --  N := 0; <<Again>> N := N + 1; if N < 3 then goto Again; end if; Put_Line (N);
   Goto_Program : constant Cursor :=
     Seq ([Assign (N_Def, Lit (0)),
           Labeled (Again_Label,
                    Assign (N_Def, Bin (Op_Plus, Ref (N_Def), Lit (1)))),
           If_Then (Bin (Op_Lt, Ref (N_Def), Lit (3)),
                    Seq ([Goto_Stmt (Again_Label)])),
           Print (Ref (N_Def))]);                                          -- 3

   --  P := new Integer'(10);  Q := P;  P.all := 42;
   --  Put_Line (Q.all);  Put_Line (P = Q);     -- Q aliases P -> 42, then True
   Access_Program : constant Cursor :=
     Seq ([Assign (P_Def, New_Int (10)),
           Assign (Q_Def, Ref (P_Def)),
           Assign_To (Deref (Ref (P_Def)), Lit (42)),
           Print (Deref (Ref (Q_Def))),                                    -- 42
           Print (Bin (Op_Eq, Ref (P_Def), Ref (Q_Def)))]);               -- True

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

   --  for-loops and a case statement.
   New_Line;
   Put_Line ("Executing (for-loops + case):");
   Put_Line ("    Total := 0;");
   Put_Line ("    for J in 1 .. 10 loop Total := Total + J; end loop;  Put_Line (Total);");
   Put_Line ("    for I in 1 .. 5 loop");
   Put_Line ("       case I is when 1 | 2 => Put_Line (I * 100);");
   Put_Line ("                 when 3 .. 4 => Put_Line (I * 10);");
   Put_Line ("                 when others => Put_Line (I); end case;");
   Put_Line ("    end loop;");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Loops_Program);

   --  out / in out parameters: the callee's final formal values are copied back
   --  to the caller's actual variables.
   New_Line;
   Put_Line ("Executing (out / in out parameter copy-back):");
   Put_Line ("    procedure Swap (X, Y : in out Integer) is T : Integer := X;");
   Put_Line ("       begin X := Y; Y := T; end;");
   Put_Line ("    procedure Get_Answer (R : out Integer) is begin R := 42; end;");
   Put_Line ("    A := 1; B := 2; Swap (A, B); Put_Line (A); Put_Line (B);");
   Put_Line ("    Get_Answer (C); Put_Line (C);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Params_Program);

   --  Real and string values: real arithmetic, string concatenation, and a
   --  real comparison.
   New_Line;
   Put_Line ("Executing (real + string values):");
   Put_Line ("    Pi := 3.14; Radius := 2.0; Put_Line (Pi * Radius * Radius);");
   Put_Line ("    Put_Line (""Hello, "" & ""DIANA"" & ""!"");");
   Put_Line ("    Put_Line (Radius <= Pi);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Values_Program);

   --  Nested subprograms and closures: Inner reads Outer's parameter N.
   New_Line;
   Put_Line ("Executing (nested subprograms + closures):");
   Put_Line ("    function Outer (N : Integer) return Integer is");
   Put_Line ("       function Inner (M : Integer) return Integer is");
   Put_Line ("          begin return M + N; end;          -- closes over N");
   Put_Line ("       begin return Inner (10); end;");
   Put_Line ("    Put_Line (Outer (5));");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Closure_Program);

   --  exit / exit-when / named exit.
   New_Line;
   Put_Line ("Executing (exit, exit-when, named exit):");
   Put_Line ("    Sum := 0; for I in 1 .. 100 loop Sum := Sum + I; exit when I = 5;");
   Put_Line ("       end loop;  Put_Line (Sum);");
   Put_Line ("    Found := 0; Outer: for I in 1 .. 3 loop for J in 1 .. 3 loop");
   Put_Line ("       if I * J = 6 then Found := I * 100 + J; exit Outer; end if;");
   Put_Line ("       end loop; end loop Outer;  Put_Line (Found);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Exit_Program);

   --  goto (a backward jump forming a loop).
   New_Line;
   Put_Line ("Executing (goto):");
   Put_Line ("    N := 0; <<Again>> N := N + 1;");
   Put_Line ("    if N < 3 then goto Again; end if;  Put_Line (N);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Goto_Program);

   --  Access values: allocation, aliasing, dereference, assignment through a
   --  dereference, and access equality.
   New_Line;
   Put_Line ("Executing (access values):");
   Put_Line ("    P := new Integer'(10); Q := P; P.all := 42;");
   Put_Line ("    Put_Line (Q.all);  Put_Line (P = Q);    -- Q aliases P");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Access_Program);

   --  The execute-or-error requirement: an unbound variable and a null
   --  dereference must both fail rather than produce a wrong answer.
   New_Line;
   Put_Line ("Error paths:");
   declare
      Undef : constant Cursor :=
        Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Undefined")));
   begin
      Diana.Interpreter.Run (Seq ([Print (Ref (Undef))]));     -- Put_Line (Undefined)
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Interpretation_Error =>
         Put_Line ("    'Put_Line (Undefined)' -> " & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run (Seq ([Print (Deref (Null_Acc))]));  -- Put_Line (null.all)
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Interpretation_Error =>
         Put_Line ("    'Put_Line (null.all)'  -> " & Ada.Exceptions.Exception_Message (E));
   end;
end Interp_Demo;
