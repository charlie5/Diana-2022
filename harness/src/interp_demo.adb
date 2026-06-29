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

   --  The symbol table: operators and defining occurrences, built once.
   Op_Plus : constant Cursor := Add (B.Op_Plus);
   Op_Le   : constant Cursor := Add (B.Op_Less_Equal);
   Sum_Def : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("Sum")));
   N_Def   : constant Cursor :=
     Add (B.Variable_Name (Spelling => SU.To_Unbounded_String ("N")));
   Put_Def : constant Cursor :=
     Add (B.Subprogram_Name (Spelling => SU.To_Unbounded_String ("Put_Line")));

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
      Items : Node_List;
   begin
      Items.Append (Add (B.Positional_Association (Value => Arg)));
      return Add (B.Procedure_Call
                    (Prefix  => Add (B.Used_Name (Definition => Put_Def)),
                     Actuals => Add (B.Association_S (List => Items))));
   end Print;

   Program : constant Cursor :=
     Seq ([Assign (Sum_Def, Lit (0)),
           Assign (N_Def,   Lit (1)),
           While_Do (Bin (Op_Le, Ref (N_Def), Lit (5)),
                     Seq ([Assign (Sum_Def, Bin (Op_Plus, Ref (Sum_Def), Ref (N_Def))),
                           Assign (N_Def,   Bin (Op_Plus, Ref (N_Def),   Lit (1)))])),
           Print (Ref (Sum_Def))]);
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
