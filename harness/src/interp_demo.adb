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
   Op_Gt    : constant Cursor := Add (B.Op_Greater);
   Op_Ge    : constant Cursor := Add (B.Op_Greater_Equal);
   Op_Eq    : constant Cursor := Add (B.Op_Equal);
   Op_Mod   : constant Cursor := Add (B.Op_Modulo);
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
   --  aggregate demo: an array, its (value) copy, a record, and two fields.
   Arr_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Arr")));
   Cpy_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Cpy")));
   Rec_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Rec")));
   X_Field : constant Cursor :=
     Add (B.Component_Name (Spelling => SU.To_Unbounded_String ("X")));
   Y_Field : constant Cursor :=
     Add (B.Component_Name (Spelling => SU.To_Unbounded_String ("Y")));
   --  "for ... of" demo: the element loop parameter and a filtered accumulator.
   E_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("E")));
   Big_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Big")));
   --  contract demo: a pragma name, a function parameter, and the Post 'Result.
   Assert_Name : constant Cursor :=
     Add (B.Pragma_Name (Spelling => SU.To_Unbounded_String ("Assert")));
   Dbl_X       : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("X")));
   Result_Attr : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Result")));
   First_Attr  : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("First")));
   Last_Attr   : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Last")));
   Length_Attr : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Length")));
   Succ_Attr   : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Succ")));
   Pred_Attr   : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Pred")));
   Pos_Attr    : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Pos")));
   Val_Attr    : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Val")));
   Old_Attr    : constant Cursor :=
     Add (B.Attribute_Name (Spelling => SU.To_Unbounded_String ("Old")));
   My_Error    : constant Cursor :=
     Add (B.Exception_Name (Spelling => SU.To_Unbounded_String ("My_Error")));
   ExcMsg_Name : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Exception_Message")));
   ExcName_Name : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Exception_Name")));
   --  enumeration demo: "type Color is (Red, Green, Blue)" -- literals carry
   --  their 0-based position, which is how the interpreter represents them.
   Color_Type : constant Cursor :=
     Add (B.Full_Type_Name (Spelling => SU.To_Unbounded_String ("Color")));
   Int_Type   : constant Cursor :=
     Add (B.Full_Type_Name (Spelling => SU.To_Unbounded_String ("Integer")));
   Red_Lit    : constant Cursor :=
     Add (B.Enumeration_Literal_Name (Spelling => SU.To_Unbounded_String ("Red"),
                                      Position => 0));
   Green_Lit  : constant Cursor :=
     Add (B.Enumeration_Literal_Name (Spelling => SU.To_Unbounded_String ("Green"),
                                      Position => 1));
   Blue_Lit   : constant Cursor :=
     Add (B.Enumeration_Literal_Name (Spelling => SU.To_Unbounded_String ("Blue"),
                                      Position => 2));
   C_Var      : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("C")));
   --  generic demo: a generic formal object "Increment" and a function param "Y".
   Increment_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Increment")));
   Y_Gen         : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("Y")));
   --  generic-package demo: the formal object "Factor", a visible constant
   --  "Base", a visible function "Scale" + its parameter, and two instances.
   Factor_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Factor")));
   Base_Def   : constant Cursor :=
     Add (B.Constant_Name (Spelling => SU.To_Unbounded_String ("Base")));
   Scale_Def  : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Scale")));
   Scale_X    : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("X")));
   By_2_Def   : constant Cursor :=
     Add (B.Package_Name (Spelling => SU.To_Unbounded_String ("By_2")));
   By_3_Def   : constant Cursor :=
     Add (B.Package_Name (Spelling => SU.To_Unbounded_String ("By_3")));
   --  child-generic-package demo: the child's own generic formal "Bonus", two
   --  member functions, a parameter, and the child instance name.  (The child
   --  template "Scaler.Extras" itself is built below, near the other generics.)
   Bonus_Def         : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Bonus")));
   Boosted_Base_Def  : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Boosted_Base")));
   Scale_Twice_Def   : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Scale_Twice")));
   ST_V              : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("V")));
   By_2_Extras_Def   : constant Cursor :=
     Add (B.Package_Name (Spelling => SU.To_Unbounded_String ("By_2_Extras")));
   --  generic-formal-subprogram demo: the formal subprogram "Op" (+ its two
   --  formal parameters), Fold's three parameters, two actual functions
   --  "Plus"/"Times" (+ their parameters), and two instances.
   Op_Def    : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Op")));
   Op_X      : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("X")));
   Op_Y      : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("Y")));
   A_Par     : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("A")));
   B_Par     : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("B")));
   C_Par     : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("C")));
   Plus_Def  : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Plus")));
   Plus_X    : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("X")));
   Plus_Y    : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("Y")));
   Times_Def : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Times")));
   Times_X   : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("X")));
   Times_Y   : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("Y")));
   --  (the Sum3 / Product3 instances are built below, near the Fold generic.)
   --  subunit demo: "Area" (is separate) and its parameter "S".
   Area_Def  : constant Cursor :=
     Add (B.Subprogram_Name (Spelling    => SU.To_Unbounded_String ("Area"),
                             Completion  => Add (B.Stub)));
   Area_S    : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("S")));
   --  generic-formal-type demo: the formal type "Element", Are_Equal's two
   --  parameters, and the actual type names "Integer" / "String".
   Element_Type : constant Cursor :=
     Add (B.Full_Type_Name (Spelling => SU.To_Unbounded_String ("Element")));
   AE_A         : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("A")));
   AE_B         : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("B")));
   Integer_Type : constant Cursor :=
     Add (B.Full_Type_Name (Spelling => SU.To_Unbounded_String ("Integer")));
   String_Type  : constant Cursor :=
     Add (B.Full_Type_Name (Spelling => SU.To_Unbounded_String ("String")));
   --  generic-formal-package demo: a formal package "S" (any Scaler instance)
   --  and Scale_Twice_Gen's parameter "X".
   S_Formal : constant Cursor :=
     Add (B.Package_Name (Spelling => SU.To_Unbounded_String ("S")));
   STG_X    : constant Cursor :=
     Add (B.Parameter_Name (Spelling => SU.To_Unbounded_String ("X")));
   --  predicate / invariant demo: a subtype, a type, their variables, a field.
   Even_Type    : constant Cursor :=
     Add (B.Subtype_Name (Spelling => SU.To_Unbounded_String ("Even")));
   V_Def        : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("V")));
   Account_Type : constant Cursor :=
     Add (B.Full_Type_Name (Spelling => SU.To_Unbounded_String ("Account")));
   Acct_Def     : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Acct")));
   Balance      : constant Cursor :=
     Add (B.Component_Name (Spelling => SU.To_Unbounded_String ("Balance")));

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

   --  "for Param_Def in Low_Expr .. High_Expr loop Body_Seq end loop".
   function For_In_Range (Param_Def, Low_Expr, High_Expr, Body_Seq : Cursor)
     return Cursor is
     (Add (B.Loop_Statement
             (Iteration => Add (B.For_Loop (Iterator => Add (B.Range_Iterator
                (Parameter      => Param_Def,
                 Discrete_Range => Add (B.Range_Bounds (Lower => Low_Expr,
                                                        Upper => High_Expr)))))),
              Statements => Body_Seq)));

   --  "for Param_Def of Iterable [when Filter] loop Body_Seq end loop".
   function For_Of (Param_Def, Iterable, Body_Seq : Cursor;
                    Filter : Cursor := No_Element) return Cursor is
     (Add (B.Loop_Statement
             (Iteration => Add (B.For_Loop (Iterator => Add (B.Container_Iterator
                (Parameter => Param_Def,
                 Iterable  => Iterable,
                 Filter    => Filter)))),
              Statements => Body_Seq)));

   --  Case choices and alternatives.
   function Val_Choice (V : Integer) return Cursor is
     (Add (B.Choice_Expression (Value => Lit (V))));
   function Choice_Expr (Value : Cursor) return Cursor is  -- a value choice
     (Add (B.Choice_Expression (Value => Value)));
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

   --  a "generic Name : Integer;" formal object, and an instantiation
   --  completion "is new Generic_Def (Actuals)".
   function Generic_Object (Name_Def : Cursor) return Cursor is
     (Add (B.Generic_Formal_Object
             (Names => Add (B.Defining_Name_S (List => NL ([Name_Def]))),
              Mode  => Add (B.Generic_In))));
   --  a "with function Designator (...) return ...;" generic formal subprogram.
   function Generic_Sub_Formal (Designator, Header : Cursor) return Cursor is
     (Add (B.Generic_Formal_Subprogram
             (Specification => Add (B.Subprogram_Declaration
                (Designator => Designator, Header => Header)))));
   --  a "type Name is private;" generic formal type.
   function Generic_Type_Formal (Name_Def : Cursor) return Cursor is
     (Add (B.Generic_Formal_Type_Declaration
             (Name => Name_Def, Definition => Add (B.Formal_Private_Type))));
   --  a "with package Name is new Template (<>);" generic formal package.
   function Generic_Pkg_Formal (Name_Def, Template_Def : Cursor) return Cursor is
     (Add (B.Generic_Formal_Package
             (Name     => Name_Def,
              Template => Add (B.Used_Name (Definition => Template_Def)),
              Is_Box   => True)));
   function Instance_Of (Generic_Def : Cursor; Actuals : Cursor_Array)
     return Cursor is
      Items : Node_List;
   begin
      for A of Actuals loop
         Items.Append (Add (B.Positional_Association (Value => A)));
      end loop;
      return Add (B.Unit_Instantiation (Instance => Add (B.Generic_Instantiation
        (Generic_Unit => Add (B.Used_Name (Definition => Generic_Def)),
         Associations => Add (B.Association_S (List => Items))))));
   end Instance_Of;

   --  "Name : constant := Init;" and "package Name is new Generic (Actuals);"
   --  as a declarative item.
   function Const_Decl (Definition, Init : Cursor) return Cursor is
     (Add (B.Constant_Declaration
             (Names          => Add (B.Defining_Name_S (List => NL ([Definition]))),
              Initialization => Init)));
   function Pkg_Instance (Name_Def, Generic_Def : Cursor; Actuals : Cursor_Array)
     return Cursor is
     (Add (B.Package_Declaration
             (Name       => Name_Def,
              Completion => Instance_Of (Generic_Def, Actuals))));

   --  "package Name is new Parent_Instance.Child (Actuals);" — a generic child
   --  unit: the generic name is a selected component "Parent.Child".
   function Child_Instance_Of (Parent_Def, Child_Generic_Def : Cursor;
                               Actuals : Cursor_Array) return Cursor is
      Items : Node_List;
   begin
      for A of Actuals loop
         Items.Append (Add (B.Positional_Association (Value => A)));
      end loop;
      return Add (B.Unit_Instantiation (Instance => Add (B.Generic_Instantiation
        (Generic_Unit => Add (B.Selected_Component
           (Prefix   => Add (B.Used_Name (Definition => Parent_Def)),
            Selector => Add (B.Used_Name (Definition => Child_Generic_Def)))),
         Associations => Add (B.Association_S (List => Items))))));
   end Child_Instance_Of;
   function Child_Pkg_Instance
     (Name_Def, Parent_Def, Child_Generic_Def : Cursor; Actuals : Cursor_Array)
     return Cursor is
     (Add (B.Package_Declaration
             (Name       => Name_Def,
              Completion => Child_Instance_Of (Parent_Def, Child_Generic_Def,
                                               Actuals))));

   --  package-instance members: "Pkg.Member" and "Pkg.Sub (Args)".
   function Member (Pkg_Def, Member_Def : Cursor) return Cursor is
     (Add (B.Selected_Component
             (Prefix   => Add (B.Used_Name (Definition => Pkg_Def)),
              Selector => Add (B.Used_Name (Definition => Member_Def)))));
   function Member_Call (Pkg_Def, Member_Def : Cursor; Args : Cursor_Array)
     return Cursor is
      Items : Node_List;
   begin
      for A of Args loop
         Items.Append (Add (B.Positional_Association (Value => A)));
      end loop;
      return Add (B.Function_Call
                    (Prefix  => Member (Pkg_Def, Member_Def),
                     Actuals => Add (B.Association_S (List => Items))));
   end Member_Call;

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

   --  array aggregate "(e1, e2, ...)" and indexing "A (I)".
   function Arr (Elements : Cursor_Array) return Cursor is
      Items : Node_List;
   begin
      for E of Elements loop
         Items.Append (Add (B.Positional_Association (Value => E)));
      end loop;
      return Add (B.Aggregate (Associations => Add (B.Association_S (List => Items))));
   end Arr;
   function Index_At (Array_Ref, Index_Expr : Cursor) return Cursor is
     (Add (B.Indexed_Component
             (Prefix  => Array_Ref,
              Indices => Add (B.Expression_S (List => NL ([Index_Expr]))))));

   --  record aggregate "(Field => Value, ...)" and selection "R.Field".
   function Field_Assoc (Field_Def, Value : Cursor) return Cursor is
     (Add (B.Named_Association
             (Choices => Add (B.Choice_S (List => NL
               ([Add (B.Choice_Expression
                        (Value => Add (B.Used_Name (Definition => Field_Def))))]))),
              Actual  => Value)));
   function Rec (Fields : Cursor_Array) return Cursor is
     (Add (B.Aggregate (Associations => Add (B.Association_S (List => NL (Fields))))));
   function Field_Of (Record_Ref, Field_Def : Cursor) return Cursor is
     (Add (B.Selected_Component
             (Prefix   => Record_Ref,
              Selector => Add (B.Used_Name (Definition => Field_Def)))));

   --  "pragma Assert (Condition);"
   function Assert_Stmt (Condition : Cursor) return Cursor is
     (Add (B.Statement_Pragma (Pragma_Item => Add (B.Pragma_Item
        (Name      => Add (B.Used_Name (Definition => Assert_Name)),
         Arguments => Add (B.Association_S (List => NL
           ([Add (B.Positional_Association (Value => Condition))]))))))));

   --  "with Pre => Condition" / "with Post => Condition" aspects, and a
   --  subprogram declaration carrying a list of them.
   function Pre_Aspect (Condition : Cursor) return Cursor is
     (Add (B.Semantic_Property
             (Identity => Add (B.Aspect_Pre),
              Value    => Add (B.Aspect_Expression (Value => Condition)))));
   function Post_Aspect (Condition : Cursor) return Cursor is
     (Add (B.Semantic_Property
             (Identity => Add (B.Aspect_Post),
              Value    => Add (B.Aspect_Expression (Value => Condition)))));
   function Sub_Decl (Designator : Cursor; Aspects : Cursor_Array) return Cursor is
     (Add (B.Subprogram_Declaration
             (Designator => Designator,
              Properties => Add (B.Semantic_Property_S (List => NL (Aspects))))));

   --  "with Dynamic_Predicate => C" / "with Type_Invariant => C" aspects.
   function Predicate_Aspect (Condition : Cursor) return Cursor is
     (Add (B.Semantic_Property
             (Identity => Add (B.Aspect_Dynamic_Predicate),
              Value    => Add (B.Aspect_Expression (Value => Condition)))));
   function Invariant_Aspect (Condition : Cursor) return Cursor is
     (Add (B.Semantic_Property
             (Identity => Add (B.Aspect_Type_Invariant),
              Value    => Add (B.Aspect_Expression (Value => Condition)))));

   --  "subtype Name is ... with <aspects>" and "type Name is ... with <aspects>".
   function Subtype_Decl (Name_Def : Cursor; Aspects : Cursor_Array) return Cursor is
     (Add (B.Subtype_Declaration
             (Name       => Name_Def,
              Properties => Add (B.Semantic_Property_S (List => NL (Aspects))))));
   function Type_Decl (Name_Def, Definition : Cursor; Aspects : Cursor_Array)
     return Cursor is
     (Add (B.Type_Declaration
             (Name       => Name_Def,
              Definition => Definition,
              Properties => Add (B.Semantic_Property_S (List => NL (Aspects))))));

   --  "Var_Def : Type_Name_Def := Init;" -- an object of a named (sub)type.
   function Typed_Var (Var_Def, Type_Name_Def, Init : Cursor) return Cursor is
     (Add (B.Variable_Declaration
             (Names          => Add (B.Defining_Name_S (List => NL ([Var_Def]))),
              Object_Subtype => Add (B.Constrained_Spec
                (Mark => Add (B.Used_Name (Definition => Type_Name_Def)))),
              Initialization => Init)));

   --  "with Contract_Cases => (Guard => Consequence, ...)" and one case of it.
   function Case_Of (Guard, Consequence : Cursor) return Cursor is
     (Add (B.Contract_Case (Guard => Guard, Consequence => Consequence)));
   function Cases_Aspect (Cases : Cursor_Array) return Cursor is
     (Add (B.Semantic_Property
             (Identity => Add (B.Aspect_Contract_Cases),
              Value    => Add (B.Contract_Case_List
                (Cases => Add (B.Contract_Case_S (List => NL (Cases))))))));

   --  "with Subprogram_Variant => (Decreases => Expr)".
   function Variant_Aspect (Expr : Cursor) return Cursor is
     (Add (B.Semantic_Property
             (Identity => Add (B.Aspect_Subprogram_Variant),
              Value    => Add (B.Aspect_Expression (Value => Expr)))));

   --  "Name'Old" -- the value of Name at subprogram entry (for postconditions).
   function Old (Name_Def : Cursor) return Cursor is
     (Add (B.Attribute_Reference
             (Prefix    => Add (B.Used_Object (Definition => Name_Def)),
              Attribute => Add (B.Used_Name (Definition => Old_Attr)))));

   --  "Func'Result" -- the result of Func, in its postcondition / contract case.
   function Result_Of (Func_Def : Cursor) return Cursor is
     (Add (B.Attribute_Reference
             (Prefix    => Add (B.Used_Name (Definition => Func_Def)),
              Attribute => Add (B.Used_Name (Definition => Result_Attr)))));

   --  "Prefix'Attr" -- an array attribute ('First / 'Last / 'Length) of Prefix.
   function Attr (Prefix, Attr_Def : Cursor) return Cursor is
     (Add (B.Attribute_Reference
             (Prefix    => Prefix,
              Attribute => Add (B.Used_Name (Definition => Attr_Def)))));

   --  "Type_Def'Attr (Arg)" -- a scalar attribute ('Succ / 'Pred / 'Pos / 'Val).
   function Attr_Call (Type_Def, Attr_Def, Arg : Cursor) return Cursor is
     (Add (B.Attribute_Call
             (Prefix   => Add (B.Attribute_Reference
                (Prefix    => Add (B.Used_Name (Definition => Type_Def)),
                 Attribute => Add (B.Used_Name (Definition => Attr_Def)))),
              Argument => Arg)));

   --  "raise Exc [with Message];", a "when Exc => Stmts" handler, and a block
   --  statement with exception handlers.
   function Raise_Exc (Exc_Def : Cursor; Message : Cursor := No_Element)
     return Cursor is
     (Add (B.Raise_Statement
             (Exception_Name => Add (B.Used_Name (Definition => Exc_Def)),
              Message        => Message)));
   function Handler (Exc_Def, Stmts : Cursor) return Cursor is
     (Add (B.Case_Alternative
             (Choices => Add (B.Choice_S (List => NL
               ([Add (B.Choice_Expression
                        (Value => Add (B.Used_Name (Definition => Exc_Def))))]))),
              Statements => Stmts)));
   function Block_With (Decls, Stmts, Handlers : Cursor_Array) return Cursor is
     (Add (B.Block_Statement (Block => Add (B.Block
        (Declarations => Add (B.Item_S (List => NL (Decls))),
         Statements   => Add (B.Statement_S (List => NL (Stmts))),
         Handlers     => Add (B.Alternative_S (List => NL (Handlers))))))));

   --  bare "raise;" (re-raise) and the "Exception_Message" of the handled exc.
   function Re_Raise return Cursor is (Add (B.Raise_Statement));
   function Exc_Msg return Cursor is
     (Add (B.Function_Call
             (Prefix  => Add (B.Used_Name (Definition => ExcMsg_Name)),
              Actuals => Add (B.Association_S))));

   --  "Builtin (Occ)" -- Exception_Name / Exception_Message of an occurrence.
   function Exc_Attr (Builtin_Def, Occ : Cursor) return Cursor is
     (Add (B.Function_Call
             (Prefix  => Add (B.Used_Name (Definition => Builtin_Def)),
              Actuals => Add (B.Association_S (List => NL
                ([Add (B.Positional_Association
                         (Value => Add (B.Used_Object (Definition => Occ))))]))))));

   --  "when Occ : Exc => Stmts" -- a handler with a choice (occurrence) parameter.
   function Exc_Handler (Occ, Exc_Def, Stmts : Cursor) return Cursor is
     (Add (B.Exception_Handler
             (Choice_Parameter => Occ,
              Choices => Add (B.Choice_S (List => NL
                ([Add (B.Choice_Expression
                         (Value => Add (B.Used_Name (Definition => Exc_Def))))]))),
              Statements => Stmts)));

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

   --  Arr := (10, 20, 30);  Cpy := Arr;  Arr (2) := 99;
   --  Put_Line (Arr (2)); Put_Line (Cpy (2));   -- 99, then 20 (value copy)
   --  Rec := (X => 1, Y => 2);  Rec.Y := 5;  Put_Line (Rec.X); Put_Line (Rec.Y);
   Aggregate_Program : constant Cursor :=
     Seq ([Assign (Arr_Def, Arr ([Lit (10), Lit (20), Lit (30)])),
           Assign (Cpy_Def, Ref (Arr_Def)),
           Assign_To (Index_At (Ref (Arr_Def), Lit (2)), Lit (99)),
           Print (Index_At (Ref (Arr_Def), Lit (2))),                      -- 99
           Print (Index_At (Ref (Cpy_Def), Lit (2))),                      -- 20
           Assign (Rec_Def, Rec ([Field_Assoc (X_Field, Lit (1)),
                                  Field_Assoc (Y_Field, Lit (2))])),
           Assign_To (Field_Of (Ref (Rec_Def), Y_Field), Lit (5)),
           Print (Field_Of (Ref (Rec_Def), X_Field)),                      -- 1
           Print (Field_Of (Ref (Rec_Def), Y_Field))]);                    -- 5

   --  Arr := (3, 5, 7, 9);
   --  Total := 0; for E of Arr loop Total := Total + E; end loop;        -- 24
   --  Big := 0; for E of Arr when E > 4 loop Big := Big + E; end loop;   -- 21
   Iterate_Program : constant Cursor :=
     Seq ([Assign (Arr_Def, Arr ([Lit (3), Lit (5), Lit (7), Lit (9)])),
           Assign (Total_Def, Lit (0)),
           For_Of (E_Def, Ref (Arr_Def),
                   Seq ([Assign (Total_Def,
                                 Bin (Op_Plus, Ref (Total_Def), Ref (E_Def)))])),
           Print (Ref (Total_Def)),                                        -- 24
           Assign (Big_Def, Lit (0)),
           For_Of (E_Def, Ref (Arr_Def),
                   Seq ([Assign (Big_Def,
                                 Bin (Op_Plus, Ref (Big_Def), Ref (E_Def)))]),
                   Filter => Bin (Op_Gt, Ref (E_Def), Lit (4))),
           Print (Ref (Big_Def))]);                                        -- 21

   --  Rec := (X => 1, Y => 2);  Total := 0;
   --  for E of Rec loop Total := Total + E; end loop;  Put_Line (Total);   -- 3
   Record_For_Program : constant Cursor :=
     Seq ([Assign (Rec_Def, Rec ([Field_Assoc (X_Field, Lit (1)),
                                  Field_Assoc (Y_Field, Lit (2))])),
           Assign (Total_Def, Lit (0)),
           For_Of (E_Def, Ref (Rec_Def),
                   Seq ([Assign (Total_Def,
                                 Bin (Op_Plus, Ref (Total_Def), Ref (E_Def)))])),
           Print (Ref (Total_Def))]);                                      -- 3

   --  Arr := (10, 20, 30);
   --  Put_Line (Arr'First); Put_Line (Arr'Last); Put_Line (Arr'Length);   -- 1, 3, 3
   --  for I in Arr'First .. Arr'Last loop Put_Line (Arr (I)); end loop;   -- 10, 20, 30
   Attribute_Program : constant Cursor :=
     Seq ([Assign (Arr_Def, Arr ([Lit (10), Lit (20), Lit (30)])),
           Print (Attr (Ref (Arr_Def), First_Attr)),                       -- 1
           Print (Attr (Ref (Arr_Def), Last_Attr)),                        -- 3
           Print (Attr (Ref (Arr_Def), Length_Attr)),                      -- 3
           For_In_Range (I_Def,
                         Attr (Ref (Arr_Def), First_Attr),
                         Attr (Ref (Arr_Def), Last_Attr),
                         Seq ([Print (Index_At (Ref (Arr_Def), Ref (I_Def)))]))]);

   --  type Color is (Red, Green, Blue);  C := Green;  Put_Line (C);          -- Green
   --  case C is when Red => 10; when Green => 20; when Blue => 30; end case;  -- 20
   --  Total := 0; for I in Red .. Blue loop Total := Total + 1; end loop;     -- 3
   Enum_Program : constant Cursor :=
     Block_Stmt
       ([Type_Decl (Color_Type,
           Add (B.Enumeration_Type (Literals => Add (B.Defining_Name_S
             (List => NL ([Red_Lit, Green_Lit, Blue_Lit]))))),
           [])],
        [Assign (C_Var, Ref (Green_Lit)),
         Print (Ref (C_Var)),                          --  prints "Green", not 1
         Case_Of (Ref (C_Var),
            [Alt ([Choice_Expr (Ref (Red_Lit))],   Seq ([Print (Lit (10))])),
             Alt ([Choice_Expr (Ref (Green_Lit))], Seq ([Print (Lit (20))])),
             Alt ([Choice_Expr (Ref (Blue_Lit))],  Seq ([Print (Lit (30))]))]),
         Assign (Total_Def, Lit (0)),
         For_In_Range (I_Def, Ref (Red_Lit), Ref (Blue_Lit),
                       Seq ([Assign (Total_Def,
                                     Bin (Op_Plus, Ref (Total_Def), Lit (1)))])),
         Print (Ref (Total_Def))]);

   --  Put_Line (Integer'Succ (5)); Put_Line (Integer'Pred (5));   -- 6, 4
   --  Put_Line (Color'Pos (Blue)); Put_Line (Color'Val (1));      -- 2, 1
   Attr_Call_Program : constant Cursor :=
     Seq ([Print (Attr_Call (Int_Type, Succ_Attr, Lit (5))),                  -- 6
           Print (Attr_Call (Int_Type, Pred_Attr, Lit (5))),                  -- 4
           Print (Attr_Call (Color_Type, Pos_Attr, Ref (Blue_Lit))),          -- 2
           Print (Attr_Call (Color_Type, Val_Attr, Lit (1)))]);               -- 1

   --  function Double (X : Integer) return Integer
   --     with Pre => X >= 0, Post => Result = X + X is begin return X + X; end;
   Double_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Double"),
             Specification => Func_Spec ([In_Par (Dbl_X)]),
             Completion    => Blk ([], [Ret (Bin (Op_Plus, Ref (Dbl_X),
                                                  Ref (Dbl_X)))])));
   Double_Decl : constant Cursor :=
     Sub_Decl (Double_Name,
       [Pre_Aspect (Bin (Op_Ge, Ref (Dbl_X), Lit (0))),
        Post_Aspect (Bin (Op_Eq, Result_Of (Double_Name),
                          Bin (Op_Plus, Ref (Dbl_X), Ref (Dbl_X))))]);

   --  N := 5; pragma Assert (N > 0); Put_Line (N);     -- assert holds -> 5
   Assert_Program : constant Cursor :=
     Seq ([Assign (N_Def, Lit (5)),
           Assert_Stmt (Bin (Op_Gt, Ref (N_Def), Lit (0))),
           Print (Ref (N_Def))]);

   --  declare <Double with Pre/Post> begin Put_Line (Double (5)); end;  -- 10
   Contract_Program : constant Cursor :=
     Block_Stmt ([Double_Decl], [Print (Sub_Call (Double_Name, [Lit (5)]))]);

   --  subtype Even is Integer with Dynamic_Predicate => Even mod 2 = 0;
   --  V : Even := 4; Put_Line (V); V := 6; Put_Line (V);            -- 4, 6
   Even_Predicate : constant Cursor :=
     Predicate_Aspect (Bin (Op_Eq, Bin (Op_Mod, Ref (Even_Type), Lit (2)), Lit (0)));
   Predicate_Program : constant Cursor :=
     Block_Stmt
       ([Subtype_Decl (Even_Type, [Even_Predicate]),
         Typed_Var (V_Def, Even_Type, Lit (4))],
        [Print (Ref (V_Def)),
         Assign (V_Def, Lit (6)),
         Print (Ref (V_Def))]);

   --  type Account is record Balance : Integer; end record
   --     with Type_Invariant => Account.Balance >= 0;
   --  Acct : Account := (Balance => 5); Put_Line (Acct.Balance);
   --  Acct := (Balance => 10); Put_Line (Acct.Balance);            -- 5, 10
   Account_Invariant : constant Cursor :=
     Invariant_Aspect (Bin (Op_Ge, Field_Of (Ref (Account_Type), Balance), Lit (0)));
   Invariant_Program : constant Cursor :=
     Block_Stmt
       ([Type_Decl (Account_Type, Add (B.Record_Type), [Account_Invariant]),
         Typed_Var (Acct_Def, Account_Type, Rec ([Field_Assoc (Balance, Lit (5))]))],
        [Print (Field_Of (Ref (Acct_Def), Balance)),
         Assign (Acct_Def, Rec ([Field_Assoc (Balance, Lit (10))])),
         Print (Field_Of (Ref (Acct_Def), Balance))]);

   --  function Sign (X) with Contract_Cases =>
   --     (X > 0 => Result = 1, X = 0 => Result = 0, X < 0 => Result = -1);
   Sign_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Sign"),
             Specification => Func_Spec ([In_Par (Dbl_X)]),
             Completion    => Blk ([],
               [If_Else (Bin (Op_Gt, Ref (Dbl_X), Lit (0)),
                         Seq ([Ret (Lit (1))]),
                         Seq ([If_Else (Bin (Op_Eq, Ref (Dbl_X), Lit (0)),
                                        Seq ([Ret (Lit (0))]),
                                        Seq ([Ret (Lit (-1))]))]))])));
   Sign_Decl : constant Cursor :=
     Sub_Decl (Sign_Name,
       [Cases_Aspect
          ([Case_Of (Bin (Op_Gt, Ref (Dbl_X), Lit (0)),
                     Bin (Op_Eq, Result_Of (Sign_Name), Lit (1))),
            Case_Of (Bin (Op_Eq, Ref (Dbl_X), Lit (0)),
                     Bin (Op_Eq, Result_Of (Sign_Name), Lit (0))),
            Case_Of (Bin (Op_Lt, Ref (Dbl_X), Lit (0)),
                     Bin (Op_Eq, Result_Of (Sign_Name), Lit (-1)))])]);

   --  function Bad_Abs (X) with Contract_Cases =>
   --     (X >= 0 => Result = X, X < 0 => Result + X = 0);  -- body returns X (wrong)
   Bad_Abs_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Bad_Abs"),
             Specification => Func_Spec ([In_Par (Dbl_X)]),
             Completion    => Blk ([], [Ret (Ref (Dbl_X))])));
   Bad_Abs_Decl : constant Cursor :=
     Sub_Decl (Bad_Abs_Name,
       [Cases_Aspect
          ([Case_Of (Bin (Op_Ge, Ref (Dbl_X), Lit (0)),
                     Bin (Op_Eq, Result_Of (Bad_Abs_Name), Ref (Dbl_X))),
            Case_Of (Bin (Op_Lt, Ref (Dbl_X), Lit (0)),
                     Bin (Op_Eq, Bin (Op_Plus, Result_Of (Bad_Abs_Name), Ref (Dbl_X)),
                          Lit (0)))])]);

   --  function Count_Down (N) with Subprogram_Variant => (Decreases => N)
   --     is begin if N = 0 then return 0; else return Count_Down (N - 1); end if;
   Count_Name : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Count_Down")));
   Count_Spec : constant Cursor := Func_Spec ([In_Par (N_Param)]);
   Count_Body : constant Cursor :=
     Blk ([], [If_Else (Bin (Op_Eq, Ref (N_Param), Lit (0)),
                        Seq ([Ret (Lit (0))]),
                        Seq ([Ret (Sub_Call (Count_Name,
                                [Bin (Op_Minus, Ref (N_Param), Lit (1))]))]))]);
   Count_Decl : constant Cursor :=
     Sub_Decl (Count_Name, [Variant_Aspect (Ref (N_Param))]);

   --  function Stuck (N) with Subprogram_Variant => (Decreases => N)
   --     is begin return Stuck (N);  -- the variant does not decrease
   Stuck_Name : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Stuck")));
   Stuck_Spec : constant Cursor := Func_Spec ([In_Par (N_Param)]);
   Stuck_Body : constant Cursor :=
     Blk ([], [Ret (Sub_Call (Stuck_Name, [Ref (N_Param)]))]);
   Stuck_Decl : constant Cursor :=
     Sub_Decl (Stuck_Name, [Variant_Aspect (Ref (N_Param))]);

   --  Put_Line (Sign (7)); Put_Line (Sign (-3));   -- 1, -1
   Cases_Program : constant Cursor :=
     Block_Stmt ([Sign_Decl],
       [Print (Sub_Call (Sign_Name, [Lit (7)])),
        Print (Sub_Call (Sign_Name, [Lit (-3)]))]);

   --  Put_Line (Count_Down (3));   -- 0  (variant 3 > 2 > 1 > 0)
   Variant_Program : constant Cursor :=
     Block_Stmt ([Count_Decl], [Print (Sub_Call (Count_Name, [Lit (3)]))]);

   --  procedure Increment (X : in out Integer) with Post => X = X'Old + 1
   --     is begin X := X + 1; end;
   Inc_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Increment"),
             Specification => Proc_Spec ([In_Out_Par (Dbl_X)]),
             Completion    => Blk ([], [Assign (Dbl_X,
                                Bin (Op_Plus, Ref (Dbl_X), Lit (1)))])));
   Inc_Decl : constant Cursor :=
     Sub_Decl (Inc_Name,
       [Post_Aspect (Bin (Op_Eq, Ref (Dbl_X),
                          Bin (Op_Plus, Old (Dbl_X), Lit (1))))]);

   --  procedure Bad_Inc (X : in out Integer) with Post => X = X'Old + 1
   --     is begin X := X + 2;  -- adds the wrong amount, so Post fails
   Bad_Inc_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Bad_Inc"),
             Specification => Proc_Spec ([In_Out_Par (Dbl_X)]),
             Completion    => Blk ([], [Assign (Dbl_X,
                                Bin (Op_Plus, Ref (Dbl_X), Lit (2)))])));
   Bad_Inc_Decl : constant Cursor :=
     Sub_Decl (Bad_Inc_Name,
       [Post_Aspect (Bin (Op_Eq, Ref (Dbl_X),
                          Bin (Op_Plus, Old (Dbl_X), Lit (1))))]);

   --  A := 10; Increment (A); Put_Line (A);   -- 11  (Post X = X'Old + 1 holds)
   Old_Program : constant Cursor :=
     Block_Stmt ([Inc_Decl],
       [Assign (A_Def, Lit (10)),
        Call_Proc (Inc_Name, [Ref (A_Def)]),
        Print (Ref (A_Def))]);

   --  procedure Boom is begin raise My_Error; end;
   Boom_Name : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling      => SU.To_Unbounded_String ("Boom"),
             Specification => Proc_Spec ([]),
             Completion    => Blk ([], [Raise_Exc (My_Error)])));

   --  begin Put_Line (1); raise My_Error; Put_Line (2);
   --  exception when My_Error => Put_Line (99); end;  Put_Line (3);   -- 1, 99, 3
   Exc_Program : constant Cursor :=
     Seq ([Block_With
             ([],
              [Print (Lit (1)), Raise_Exc (My_Error), Print (Lit (2))],
              [Handler (My_Error, Seq ([Print (Lit (99))]))]),
           Print (Lit (3))]);

   --  declare procedure Boom ... begin Boom; Put_Line (5);   -- Boom propagates
   --  exception when My_Error => Put_Line (77); end;                   -- 77
   Propagate_Program : constant Cursor :=
     Block_With
       ([Sub_Body_Item (Boom_Name)],
        [Call_Proc (Boom_Name, []), Print (Lit (5))],
        [Handler (My_Error, Seq ([Print (Lit (77))]))]);

   --  begin
   --     begin raise My_Error with "boom";
   --     exception when My_Error => Put_Line (Exception_Message); raise; end;
   --  exception when My_Error => Put_Line (99); end;          -- "boom", then 99
   Reraise_Program : constant Cursor :=
     Block_With
       ([],
        [Block_With
           ([],
            [Raise_Exc (My_Error, Str_Lit ("boom"))],
            [Handler (My_Error, Seq ([Print (Exc_Msg), Re_Raise]))])],
        [Handler (My_Error, Seq ([Print (Lit (99))]))]);

   --  begin raise My_Error with "details";
   --  exception when E : My_Error =>
   --     Put_Line (Exception_Name (E)); Put_Line (Exception_Message (E)); end;
   Occurrence_Program : constant Cursor :=
     Block_With
       ([],
        [Raise_Exc (My_Error, Str_Lit ("details"))],
        [Exc_Handler (E_Def, My_Error,
           Seq ([Print (Exc_Attr (ExcName_Name, E_Def)),
                 Print (Exc_Attr (ExcMsg_Name, E_Def))]))]);

   --  generic Increment : Integer;
   --  function Add_By (Y : Integer) return Integer is begin return Y + Increment; end;
   Add_By : constant Cursor :=
     Add (B.Generic_Name
            (Spelling      => SU.To_Unbounded_String ("Add_By"),
             Formals       => Add (B.Generic_Formal_S
               (List => NL ([Generic_Object (Increment_Def)]))),
             Specification => Add (B.Generic_Subprogram_Header
               (Profile => Func_Spec ([In_Par (Y_Gen)]))),
             Completion    => Blk ([], [Ret (Bin (Op_Plus, Ref (Y_Gen),
                                                  Ref (Increment_Def)))])));

   --  function Add_5  is new Add_By (5);
   --  function Add_10 is new Add_By (10);
   Add_5  : constant Cursor :=
     Add (B.Subprogram_Name (Spelling    => SU.To_Unbounded_String ("Add_5"),
                             Completion  => Instance_Of (Add_By, [Lit (5)])));
   Add_10 : constant Cursor :=
     Add (B.Subprogram_Name (Spelling    => SU.To_Unbounded_String ("Add_10"),
                             Completion  => Instance_Of (Add_By, [Lit (10)])));

   --  Put_Line (Add_5 (100)); Put_Line (Add_10 (100));   -- 105, 110
   Generic_Program : constant Cursor :=
     Seq ([Print (Sub_Call (Add_5, [Lit (100)])),
           Print (Sub_Call (Add_10, [Lit (100)]))]);

   --  generic
   --     Factor : Integer;
   --  package Scaler is
   --     Base : constant Integer := Factor * 10;
   --     function Scale (X : Integer) return Integer;   -- = X * Factor
   --  end Scaler;
   Scaler : constant Cursor :=
     Add (B.Generic_Name
            (Spelling      => SU.To_Unbounded_String ("Scaler"),
             Formals       => Add (B.Generic_Formal_S
               (List => NL ([Generic_Object (Factor_Def)]))),
             Specification => Add (B.Package_Specification
               (Visible_Declarations => Add (B.Declaration_S (List => NL
                 ([Const_Decl (Base_Def, Bin (Op_Mul, Ref (Factor_Def), Lit (10))),
                   Sub_Decl (Scale_Def, [])])))))));

   --  Two nested instantiations in a block, each with its own Factor; the
   --  members are read (Base) and called (Scale) through the instance name.
   --  declare
   --     package By_2 is new Scaler (2);
   --     package By_3 is new Scaler (3);
   --  begin
   --     Put_Line (By_2.Base);  Put_Line (By_3.Base);        -- 20, 30
   --     Put_Line (By_2.Scale (5));  Put_Line (By_3.Scale (5));  -- 10, 15
   --  end;
   Package_Program : constant Cursor :=
     Block_Stmt
       ([Pkg_Instance (By_2_Def, Scaler, [Lit (2)]),
         Pkg_Instance (By_3_Def, Scaler, [Lit (3)])],
        [Print (Member (By_2_Def, Base_Def)),
         Print (Member (By_3_Def, Base_Def)),
         Print (Member_Call (By_2_Def, Scale_Def, [Lit (5)])),
         Print (Member_Call (By_3_Def, Scale_Def, [Lit (5)]))]);

   --  A generic CHILD package of Scaler.  Its members reference the parent's
   --  Base / Scale by simple name (a child sees the parent's visible part) and
   --  it has its own generic formal Bonus.
   --  generic
   --     Bonus : Integer;
   --  package Scaler.Extras is
   --     function Boosted_Base return Integer;            -- = Base + Bonus
   --     function Scale_Twice (V : Integer) return Integer; -- = Scale (Scale (V))
   --  end Scaler.Extras;
   Scaler_Extras : constant Cursor :=
     Add (B.Generic_Name
            (Spelling      => SU.To_Unbounded_String ("Extras"),
             Formals       => Add (B.Generic_Formal_S
               (List => NL ([Generic_Object (Bonus_Def)]))),
             Specification => Add (B.Package_Specification
               (Visible_Declarations => Add (B.Declaration_S (List => NL
                 ([Sub_Decl (Boosted_Base_Def, []),
                   Sub_Decl (Scale_Twice_Def, [])])))))));

   --  declare
   --     package By_2        is new Scaler (2);
   --     package By_2_Extras is new By_2.Extras (100);   -- child of an instance
   --  begin
   --     Put_Line (By_2.Base);                     -- 20
   --     Put_Line (By_2_Extras.Boosted_Base);      -- 120 = parent Base 20 + Bonus 100
   --     Put_Line (By_2_Extras.Scale_Twice (5));   -- 20  = Scale (Scale (5))
   --  end;
   Child_Program : constant Cursor :=
     Block_Stmt
       ([Pkg_Instance (By_2_Def, Scaler, [Lit (2)]),
         Child_Pkg_Instance (By_2_Extras_Def, By_2_Def, Scaler_Extras, [Lit (100)])],
        [Print (Member (By_2_Def, Base_Def)),
         Print (Member_Call (By_2_Extras_Def, Boosted_Base_Def, [])),
         Print (Member_Call (By_2_Extras_Def, Scale_Twice_Def, [Lit (5)]))]);

   --  generic
   --     with function Op (X, Y : Integer) return Integer;
   --  function Fold (A, B, C : Integer) return Integer is
   --  begin return Op (Op (A, B), C); end;     -- folds Op left-to-right
   Fold : constant Cursor :=
     Add (B.Generic_Name
            (Spelling      => SU.To_Unbounded_String ("Fold"),
             Formals       => Add (B.Generic_Formal_S (List => NL
               ([Generic_Sub_Formal (Op_Def, Func_Spec ([In_Par (Op_X),
                                                          In_Par (Op_Y)]))]))),
             Specification => Add (B.Generic_Subprogram_Header
               (Profile => Func_Spec ([In_Par (A_Par), In_Par (B_Par),
                                       In_Par (C_Par)]))),
             Completion    => Blk ([], [Ret (Sub_Call (Op_Def,
               [Sub_Call (Op_Def, [Ref (A_Par), Ref (B_Par)]), Ref (C_Par)]))])));

   --  function Sum3     is new Fold (Op => Plus);
   --  function Product3 is new Fold (Op => Times);
   Sum3 : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling   => SU.To_Unbounded_String ("Sum3"),
             Completion => Instance_Of
               (Fold, [Add (B.Used_Name (Definition => Plus_Def))])));
   Product3 : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling   => SU.To_Unbounded_String ("Product3"),
             Completion => Instance_Of
               (Fold, [Add (B.Used_Name (Definition => Times_Def))])));

   --  Put_Line (Sum3 (2, 3, 4));      -- ((2+3)+4) = 9
   --  Put_Line (Product3 (2, 3, 4));  -- ((2*3)*4) = 24
   Formal_Sub_Program : constant Cursor :=
     Seq ([Print (Sub_Call (Sum3,     [Lit (2), Lit (3), Lit (4)])),
           Print (Sub_Call (Product3, [Lit (2), Lit (3), Lit (4)]))]);

   --  procedure Area (S : Integer) return Integer is separate;  -- completed below
   --  Put_Line (Area (5));            -- 25, run from the subunit's body
   Subunit_Program : constant Cursor :=
     Seq ([Print (Sub_Call (Area_Def, [Lit (5)]))]);

   --  generic
   --     type Element is private;
   --  function Are_Equal (A, B : Element) return Boolean is
   --  begin return A = B; end;        -- uses only "=", available for any type
   Are_Equal : constant Cursor :=
     Add (B.Generic_Name
            (Spelling      => SU.To_Unbounded_String ("Are_Equal"),
             Formals       => Add (B.Generic_Formal_S (List => NL
               ([Generic_Type_Formal (Element_Type)]))),
             Specification => Add (B.Generic_Subprogram_Header
               (Profile => Func_Spec ([In_Par (AE_A), In_Par (AE_B)]))),
             Completion    => Blk ([], [Ret (Bin (Op_Eq, Ref (AE_A), Ref (AE_B)))])));

   --  function Int_Eq is new Are_Equal (Integer);
   --  function Str_Eq is new Are_Equal (String);   -- same body, different types
   Int_Eq : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling   => SU.To_Unbounded_String ("Int_Eq"),
             Completion => Instance_Of (Are_Equal,
               [Add (B.Used_Name (Definition => Integer_Type))])));
   Str_Eq : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling   => SU.To_Unbounded_String ("Str_Eq"),
             Completion => Instance_Of (Are_Equal,
               [Add (B.Used_Name (Definition => String_Type))])));

   --  Put_Line (Int_Eq (4, 4));        -- True
   --  Put_Line (Str_Eq ("hi", "hi"));  -- True
   --  Put_Line (Str_Eq ("hi", "bye")); -- False
   Formal_Type_Program : constant Cursor :=
     Seq ([Print (Sub_Call (Int_Eq, [Lit (4), Lit (4)])),
           Print (Sub_Call (Str_Eq, [Str_Lit ("hi"), Str_Lit ("hi")])),
           Print (Sub_Call (Str_Eq, [Str_Lit ("hi"), Str_Lit ("bye")]))]);

   --  generic
   --     with package S is new Scaler (<>);   -- a formal package: any Scaler
   --  function Scale_Twice_Gen (X : Integer) return Integer is
   --  begin return S.Scale (S.Scale (X)); end;   -- uses the formal package's member
   Scale_Twice_Gen : constant Cursor :=
     Add (B.Generic_Name
            (Spelling      => SU.To_Unbounded_String ("Scale_Twice_Gen"),
             Formals       => Add (B.Generic_Formal_S (List => NL
               ([Generic_Pkg_Formal (S_Formal, Scaler)]))),
             Specification => Add (B.Generic_Subprogram_Header
               (Profile => Func_Spec ([In_Par (STG_X)]))),
             Completion    => Blk ([], [Ret (Member_Call (S_Formal, Scale_Def,
               [Member_Call (S_Formal, Scale_Def, [Ref (STG_X)])]))])));

   --  function ST3 is new Scale_Twice_Gen (S => By_3);   -- By_3 is new Scaler (3)
   ST3 : constant Cursor :=
     Add (B.Subprogram_Name
            (Spelling   => SU.To_Unbounded_String ("ST3"),
             Completion => Instance_Of (Scale_Twice_Gen,
               [Add (B.Used_Name (Definition => By_3_Def))])));

   --  declare package By_3 is new Scaler (3);
   --  begin Put_Line (ST3 (5)); end;     -- S.Scale (S.Scale (5)) = 5*3*3 = 45
   Formal_Pkg_Program : constant Cursor :=
     Block_Stmt
       ([Pkg_Instance (By_3_Def, Scaler, [Lit (3)])],
        [Print (Sub_Call (ST3, [Lit (5)]))]);

   --  Patch a recursive subprogram's stub once its spec and body are built.
   Patch_Spec, Patch_Body : Cursor;
   procedure Apply_Patch (E : in out Node'Class) is
   begin
      if E in Diana.Nodes.Subprogram_Name'Class then
         Diana.Nodes.Subprogram_Name (E).Specification := Patch_Spec;
         Diana.Nodes.Subprogram_Name (E).Completion    := Patch_Body;
      end if;
   end Apply_Patch;
   procedure Complete (Def, Spec, Body_Block : Cursor) is
   begin
      Patch_Spec := Spec;
      Patch_Body := Body_Block;
      Program_Tree.Update_Element (Def, Apply_Patch'Access);
   end Complete;

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

   --  Array and record aggregates: construction, indexing / selection,
   --  component assignment, and composite value semantics.
   New_Line;
   Put_Line ("Executing (array + record aggregates):");
   Put_Line ("    Arr := (10, 20, 30); Cpy := Arr; Arr (2) := 99;");
   Put_Line ("    Put_Line (Arr (2)); Put_Line (Cpy (2));   -- Cpy is a value copy");
   Put_Line ("    Rec := (X => 1, Y => 2); Rec.Y := 5;");
   Put_Line ("    Put_Line (Rec.X); Put_Line (Rec.Y);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Aggregate_Program);

   --  Container 'for ... of' iteration over an array, with an Ada 2022 filter.
   New_Line;
   Put_Line ("Executing (container for ... of):");
   Put_Line ("    Arr := (3, 5, 7, 9);");
   Put_Line ("    Total := 0; for E of Arr loop Total := Total + E; end loop;");
   Put_Line ("    Big := 0; for E of Arr when E > 4 loop Big := Big + E; end loop;");
   Put_Line ("    Put_Line (Total); Put_Line (Big);");
   Put_Line ("    Rec := (X => 1, Y => 2); Total := 0;");
   Put_Line ("    for E of Rec loop Total := Total + E; end loop;  Put_Line (Total);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Iterate_Program);
   Diana.Interpreter.Run (Record_For_Program);

   --  Array attributes 'First / 'Last / 'Length, and indexing a for-loop by them.
   New_Line;
   Put_Line ("Executing (array attributes 'First / 'Last / 'Length):");
   Put_Line ("    Arr := (10, 20, 30);");
   Put_Line ("    Put_Line (Arr'First); Put_Line (Arr'Last); Put_Line (Arr'Length);");
   Put_Line ("    for I in Arr'First .. Arr'Last loop Put_Line (Arr (I)); end loop;");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Attribute_Program);

   --  Enumeration-typed case and for (literals are their 0-based position).
   New_Line;
   Put_Line ("Executing (enumeration case + for):");
   Put_Line ("    type Color is (Red, Green, Blue);  C := Green;  Put_Line (C);");
   Put_Line ("    case C is when Red => 10; when Green => 20; when Blue => 30; end case;");
   Put_Line ("    Total := 0; for I in Red .. Blue loop Total := Total + 1; end loop;");
   Put_Line ("    Put_Line (Total);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Enum_Program);

   --  Scalar attributes 'Succ / 'Pred / 'Pos / 'Val.
   New_Line;
   Put_Line ("Executing (scalar attributes 'Succ / 'Pred / 'Pos / 'Val):");
   Put_Line ("    Put_Line (Integer'Succ (5)); Put_Line (Integer'Pred (5));");
   Put_Line ("    Put_Line (Color'Pos (Blue)); Put_Line (Color'Val (1));");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Attr_Call_Program);

   --  Runtime contract checks: a pragma Assert that holds, and a subprogram
   --  Pre/Post that hold.
   New_Line;
   Put_Line ("Executing (contracts: pragma Assert, Pre / Post):");
   Put_Line ("    N := 5; pragma Assert (N > 0); Put_Line (N);");
   Put_Line ("    function Double (X) with Pre => X >= 0, Post => Result = X + X;");
   Put_Line ("    Put_Line (Double (5));");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Assert_Program);
   Diana.Interpreter.Run (Contract_Program);

   --  Subtype predicates and type invariants, checked on declaration/assignment.
   New_Line;
   Put_Line ("Executing (subtype predicate + type invariant):");
   Put_Line ("    subtype Even is Integer with Dynamic_Predicate => Even mod 2 = 0;");
   Put_Line ("    V : Even := 4; Put_Line (V); V := 6; Put_Line (V);");
   Put_Line ("    type Account is record ... with Type_Invariant => Account.Balance >= 0;");
   Put_Line ("    Acct := (Balance => 5); Put_Line (Acct.Balance);");
   Put_Line ("    Acct := (Balance => 10); Put_Line (Acct.Balance);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Predicate_Program);
   Diana.Interpreter.Run (Invariant_Program);

   --  Contract_Cases (Sign) and a recursive Subprogram_Variant (Count_Down).
   Complete (Count_Name, Count_Spec, Count_Body);   -- close the recursive stubs
   Complete (Stuck_Name, Stuck_Spec, Stuck_Body);
   New_Line;
   Put_Line ("Executing (Contract_Cases + Subprogram_Variant):");
   Put_Line ("    function Sign (X) with Contract_Cases =>");
   Put_Line ("       (X > 0 => Result = 1, X = 0 => Result = 0, X < 0 => Result = -1);");
   Put_Line ("    Put_Line (Sign (7)); Put_Line (Sign (-3));");
   Put_Line ("    function Count_Down (N) with Subprogram_Variant => (Decreases => N);");
   Put_Line ("    Put_Line (Count_Down (3));");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Cases_Program);
   Diana.Interpreter.Run (Variant_Program);

   --  'Old in a postcondition: the entry value of an in-out parameter.
   New_Line;
   Put_Line ("Executing ('Old in a postcondition):");
   Put_Line ("    procedure Increment (X : in out Integer) with Post => X = X'Old + 1;");
   Put_Line ("    A := 10; Increment (A); Put_Line (A);");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Old_Program);

   --  Exception handlers: raise + handle in the same block, and propagation
   --  out of a called procedure to the caller's handler.
   New_Line;
   Put_Line ("Executing (exception handlers):");
   Put_Line ("    begin Put_Line (1); raise My_Error; Put_Line (2);");
   Put_Line ("       exception when My_Error => Put_Line (99); end;  Put_Line (3);");
   Put_Line ("    procedure Boom is begin raise My_Error; end;");
   Put_Line ("    begin Boom; Put_Line (5); exception when My_Error => Put_Line (77); end;");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Exc_Program);
   Diana.Interpreter.Run (Propagate_Program);

   --  Bare re-raise and Exception_Message: an inner handler prints the message
   --  and re-raises; the outer handler then catches it.
   New_Line;
   Put_Line ("Executing (re-raise + Exception_Message):");
   Put_Line ("    begin");
   Put_Line ("       begin raise My_Error with ""boom"";");
   Put_Line ("       exception when My_Error => Put_Line (Exception_Message); raise; end;");
   Put_Line ("    exception when My_Error => Put_Line (99); end;");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Reraise_Program);

   --  Exception occurrence parameter: "when E : Exc =>" with Exception_Name (E)
   --  and Exception_Message (E).
   New_Line;
   Put_Line ("Executing (when E : ... occurrence parameter):");
   Put_Line ("    begin raise My_Error with ""details"";");
   Put_Line ("    exception when E : My_Error =>");
   Put_Line ("       Put_Line (Exception_Name (E)); Put_Line (Exception_Message (E)); end;");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Occurrence_Program);

   --  Generic instantiation: one generic, two instances with different actuals.
   New_Line;
   Put_Line ("Executing (generic instantiation):");
   Put_Line ("    generic Increment : Integer; function Add_By (Y : Integer) return Integer");
   Put_Line ("       is begin return Y + Increment; end;");
   Put_Line ("    function Add_5 is new Add_By (5); function Add_10 is new Add_By (10);");
   Put_Line ("    Put_Line (Add_5 (100)); Put_Line (Add_10 (100));");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Generic_Program);

   --  Nested generic packages: a generic package instantiated twice in a block,
   --  its members read and called through each instance name.
   New_Line;
   Put_Line ("Executing (nested generic packages):");
   Put_Line ("    generic Factor : Integer; package Scaler is");
   Put_Line ("       Base : constant Integer := Factor * 10;");
   Put_Line ("       function Scale (X : Integer) return Integer;  -- = X * Factor");
   Put_Line ("    end Scaler;");
   Put_Line ("    declare package By_2 is new Scaler (2); package By_3 is new Scaler (3);");
   Put_Line ("    begin Put_Line (By_2.Base); Put_Line (By_3.Base);          -- 20, 30");
   Put_Line ("          Put_Line (By_2.Scale (5)); Put_Line (By_3.Scale (5)); end;  -- 10, 15");
   New_Line;
   Put_Line ("Output:");
   --  complete the package's visible function Scale before instantiation
   Complete (Scale_Def, Func_Spec ([In_Par (Scale_X)]),
             Blk ([], [Ret (Bin (Op_Mul, Ref (Scale_X), Ref (Factor_Def)))]));
   Diana.Interpreter.Run (Package_Program);

   --  Child generic packages: a generic child of Scaler whose members see the
   --  parent instance's Base / Scale, plus its own generic formal Bonus.
   New_Line;
   Put_Line ("Executing (child generic packages):");
   Put_Line ("    generic Bonus : Integer; package Scaler.Extras is  -- a child unit");
   Put_Line ("       function Boosted_Base return Integer;             -- = Base + Bonus");
   Put_Line ("       function Scale_Twice (V : Integer) return Integer; -- = Scale (Scale (V))");
   Put_Line ("    end Scaler.Extras;");
   Put_Line ("    declare package By_2 is new Scaler (2);");
   Put_Line ("            package By_2_Extras is new By_2.Extras (100);");
   Put_Line ("    begin Put_Line (By_2.Base);                  -- 20");
   Put_Line ("          Put_Line (By_2_Extras.Boosted_Base);   -- 120 = Base 20 + Bonus 100");
   Put_Line ("          Put_Line (By_2_Extras.Scale_Twice (5)); end;  -- 20 = Scale (Scale (5))");
   New_Line;
   Put_Line ("Output:");
   --  complete the child's member functions before instantiation
   Complete (Boosted_Base_Def, Func_Spec ([]),
             Blk ([], [Ret (Bin (Op_Plus, Ref (Base_Def), Ref (Bonus_Def)))]));
   Complete (Scale_Twice_Def, Func_Spec ([In_Par (ST_V)]),
             Blk ([], [Ret (Sub_Call (Scale_Def,
                              [Sub_Call (Scale_Def, [Ref (ST_V)])]))]));
   Diana.Interpreter.Run (Child_Program);

   --  Generic formal subprograms: a generic that takes a subprogram parameter,
   --  instantiated with two different actual functions.
   New_Line;
   Put_Line ("Executing (generic formal subprograms):");
   Put_Line ("    generic with function Op (X, Y : Integer) return Integer;");
   Put_Line ("    function Fold (A, B, C : Integer) return Integer");
   Put_Line ("       is begin return Op (Op (A, B), C); end;");
   Put_Line ("    function Sum3 is new Fold (Plus); function Product3 is new Fold (Times);");
   Put_Line ("    Put_Line (Sum3 (2, 3, 4)); Put_Line (Product3 (2, 3, 4));");
   New_Line;
   Put_Line ("Output:");
   --  complete the actual functions the instances pass for Op
   Complete (Plus_Def,  Func_Spec ([In_Par (Plus_X),  In_Par (Plus_Y)]),
             Blk ([], [Ret (Bin (Op_Plus, Ref (Plus_X), Ref (Plus_Y)))]));
   Complete (Times_Def, Func_Spec ([In_Par (Times_X), In_Par (Times_Y)]),
             Blk ([], [Ret (Bin (Op_Mul, Ref (Times_X), Ref (Times_Y)))]));
   Diana.Interpreter.Run (Formal_Sub_Program);

   --  Subunits: a subprogram declared "is separate" whose body is supplied by a
   --  subunit; once that body is in place, calling it runs the subunit's code.
   New_Line;
   Put_Line ("Executing (subunit body):");
   Put_Line ("    function Area (S : Integer) return Integer is separate;");
   Put_Line ("    separate (Demo) function Area (S : Integer) return Integer");
   Put_Line ("       is begin return S * S; end;     -- the subunit's body");
   Put_Line ("    Put_Line (Area (5));                -- 25, run from the subunit");
   New_Line;
   Put_Line ("Output:");
   --  supply the subunit's body, completing the "is separate" stub in place
   Complete (Area_Def, Func_Spec ([In_Par (Area_S)]),
             Blk ([], [Ret (Bin (Op_Mul, Ref (Area_S), Ref (Area_S)))]));
   Diana.Interpreter.Run (Subunit_Program);

   --  Generic formal types: one generic body instantiated over two actual
   --  types.  The formal type is erased at runtime (values are dynamically
   --  typed), so the same body works over integers and strings.
   New_Line;
   Put_Line ("Executing (generic formal types):");
   Put_Line ("    generic type Element is private;");
   Put_Line ("    function Are_Equal (A, B : Element) return Boolean");
   Put_Line ("       is begin return A = B; end;");
   Put_Line ("    function Int_Eq is new Are_Equal (Integer);");
   Put_Line ("    function Str_Eq is new Are_Equal (String);");
   Put_Line ("    Put_Line (Int_Eq (4, 4)); Put_Line (Str_Eq (""hi"", ""hi""));");
   Put_Line ("    Put_Line (Str_Eq (""hi"", ""bye""));");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Formal_Type_Program);

   --  Generic formal packages: a generic parameterised by an instance of another
   --  generic, using that instance's members (S.Scale) through the formal package.
   New_Line;
   Put_Line ("Executing (generic formal packages):");
   Put_Line ("    generic with package S is new Scaler (<>);");
   Put_Line ("    function Scale_Twice_Gen (X : Integer) return Integer");
   Put_Line ("       is begin return S.Scale (S.Scale (X)); end;");
   Put_Line ("    declare package By_3 is new Scaler (3);");
   Put_Line ("            function ST3 is new Scale_Twice_Gen (By_3);");
   Put_Line ("    begin Put_Line (ST3 (5)); end;   -- S.Scale (S.Scale (5)) = 5*3*3 = 45");
   New_Line;
   Put_Line ("Output:");
   Diana.Interpreter.Run (Formal_Pkg_Program);

   --  The execute-or-error requirement: bad executions and failed contracts
   --  must all error out rather than produce a wrong answer.
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
   begin
      Diana.Interpreter.Run                                       -- pragma Assert (1 = 2)
        (Seq ([Assert_Stmt (Bin (Op_Eq, Lit (1), Lit (2)))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Assertion_Error =>
         Put_Line ("    'pragma Assert (1 = 2)' -> " & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run                                       -- Double (-1): Pre fails
        (Block_Stmt ([Double_Decl], [Print (Sub_Call (Double_Name, [Lit (-1)]))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Assertion_Error =>
         Put_Line ("    'Double (-1)'           -> " & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run                                       -- V := 3: predicate fails
        (Block_Stmt
           ([Subtype_Decl (Even_Type, [Even_Predicate]),
             Typed_Var (V_Def, Even_Type, Lit (4))],
            [Assign (V_Def, Lit (3))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Assertion_Error =>
         Put_Line ("    'V := 3' (odd)          -> " & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run                                       -- Balance := -1: invariant fails
        (Block_Stmt
           ([Type_Decl (Account_Type, Add (B.Record_Type), [Account_Invariant]),
             Typed_Var (Acct_Def, Account_Type, Rec ([Field_Assoc (Balance, Lit (5))]))],
            [Assign (Acct_Def, Rec ([Field_Assoc (Balance, Lit (-1))]))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Assertion_Error =>
         Put_Line ("    'Acct.Balance = -1'     -> " & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run                                       -- Bad_Abs (-5): case fails
        (Block_Stmt ([Bad_Abs_Decl], [Print (Sub_Call (Bad_Abs_Name, [Lit (-5)]))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Assertion_Error =>
         Put_Line ("    'Bad_Abs (-5)'          -> " & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run                                       -- Stuck (5): variant fails
        (Block_Stmt ([Stuck_Decl], [Print (Sub_Call (Stuck_Name, [Lit (5)]))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Assertion_Error =>
         Put_Line ("    'Stuck (5)' (recursion) -> " & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run                                       -- Bad_Inc: X = X'Old + 1 fails
        (Block_Stmt ([Bad_Inc_Decl],
           [Assign (A_Def, Lit (10)), Call_Proc (Bad_Inc_Name, [Ref (A_Def)])]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Assertion_Error =>
         Put_Line ("    'Bad_Inc (A)' (X'Old+2) -> " & Ada.Exceptions.Exception_Message (E));
   end;
   declare
      --  an "is separate" subprogram whose subunit was never supplied
      Detached : constant Cursor :=
        Add (B.Subprogram_Name (Spelling      => SU.To_Unbounded_String ("Detached"),
                                Specification => Func_Spec ([]),
                                Completion    => Add (B.Stub)));
   begin
      Diana.Interpreter.Run (Seq ([Print (Sub_Call (Detached, []))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Interpretation_Error =>
         Put_Line ("    'Detached' (is separate) -> "
                   & Ada.Exceptions.Exception_Message (E));
   end;
   begin
      Diana.Interpreter.Run                                       -- raise with no handler
        (Seq ([Raise_Exc (My_Error, Str_Lit ("boom"))]));
      Put_Line ("    (unexpected) completed without error");
   exception
      when E : Diana.Interpreter.Unhandled_Exception =>
         Put_Line ("    'raise My_Error' (top)  -> " & Ada.Exceptions.Exception_Message (E));
   end;
end Interp_Demo;
