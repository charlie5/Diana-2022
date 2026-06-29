--  Diana.Nodes — the DIANA_2022 node set.
--
--  GENERATED from spec/DIANA_2022.idl by tools/gen_nodes.pl.  DO NOT EDIT BY
--  HAND; re-run the generator after changing the spec.
--
--  436 tagged types (82 abstract classes, 354 concrete nodes).  Every IDL
--  class is an abstract type and every IDL node a concrete leaf, single-parent
--  per the spec; node/class references are Cursors and "Seq Of" is a Node_List.
--  See tools/gen_nodes.pl for the full mapping.

pragma Style_Checks (Off);

package Diana.Nodes is

   type Compilation is new Node with record
      Units : Cursor := No_Element;
   end record;
   type Compilation_Unit is new Node with record
      Context      : Cursor := No_Element;
      Library_Item : Cursor := No_Element;
   end record;
   type Context_Element is abstract new Node with null record;
   type All_Declaration is abstract new Node with null record;
   type Defining_Occurrence is abstract new Node with record
      Spelling : Diana.Symbol_Rep;
   end record;
   type Type_Spec is abstract new Node with record
      Properties : Cursor := No_Element;
   end record;
   type Constraint is abstract new Node with null record;
   type Header is abstract new Node with null record;
   type Expression is abstract new Node with record
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value;
   end record;
   type Statement is abstract new Node with null record;
   type Association is abstract new Node with null record;
   type Semantic_Property is new Node with record
      Identity   : Cursor := No_Element;
      Class_Wide : Boolean := False;
      Value      : Cursor := No_Element;
      Origin     : Cursor := No_Element;
   end record;
   type Element_List is abstract new Node with null record;
   type Item is abstract new All_Declaration with null record;
   type Subunit is new All_Declaration with record
      Parent     : Cursor := No_Element;
      Completion : Cursor := No_Element;
   end record;
   type Declaration is abstract new Item with record
      Properties : Cursor := No_Element;
   end record;
   type Proper_Body is abstract new Item with null record;
   type Entry_Body is new Item with record
      Name         : Cursor := No_Element;
      Family_Index : Cursor := No_Element;
      Parameters   : Cursor := No_Element;
      Barrier      : Cursor := No_Element;
      Completion   : Cursor := No_Element;
   end record;
   type Subprogram_Body is new Proper_Body with record
      Designator : Cursor := No_Element;
      Header     : Cursor := No_Element;
      Completion : Cursor := No_Element;
   end record;
   type Package_Body is new Proper_Body with record
      Name       : Cursor := No_Element;
      Completion : Cursor := No_Element;
   end record;
   type Task_Body is new Proper_Body with record
      Name       : Cursor := No_Element;
      Completion : Cursor := No_Element;
   end record;
   type Protected_Body is new Proper_Body with record
      Name       : Cursor := No_Element;
      Operations : Cursor := No_Element;
   end record;
   type With_Clause is new Context_Element with record
      Names      : Cursor := No_Element;
      Is_Limited : Boolean := False;
      Is_Private : Boolean := False;
   end record;
   type Context_Use_Clause is new Context_Element with record
      Names : Cursor := No_Element;
   end record;
   type Context_Pragma is new Context_Element with record
      Pragma_Item : Cursor := No_Element;
   end record;
   type Object_Or_Number_Declaration is abstract new Declaration with null record;
   type Identifier_Declaration is abstract new Declaration with null record;
   type Representation_Clause is abstract new Declaration with null record;
   type Use_Or_Pragma is abstract new Declaration with null record;
   type Object_Declaration is abstract new Object_Or_Number_Declaration with null record;
   type Number_Declaration is new Object_Or_Number_Declaration with record
      Names                   : Cursor := No_Element;
      Static_Value_Expression : Cursor := No_Element;
   end record;
   type Constant_Declaration is new Object_Declaration with record
      Names          : Cursor := No_Element;
      Object_Subtype : Cursor := No_Element;
      Initialization : Cursor := No_Element;
   end record;
   type Variable_Declaration is new Object_Declaration with record
      Names          : Cursor := No_Element;
      Object_Subtype : Cursor := No_Element;
      Initialization : Cursor := No_Element;
   end record;
   type Type_Declaration is new Identifier_Declaration with record
      Name          : Cursor := No_Element;
      Discriminants : Cursor := No_Element;
      Definition    : Cursor := No_Element;
   end record;
   type Subtype_Declaration is new Identifier_Declaration with record
      Name                    : Cursor := No_Element;
      Subtype_Mark_Constraint : Cursor := No_Element;
   end record;
   type Subprogram_Declaration is new Identifier_Declaration with record
      Designator : Cursor := No_Element;
      Header     : Cursor := No_Element;
      Completion : Cursor := No_Element;
   end record;
   type Package_Declaration is new Identifier_Declaration with record
      Name       : Cursor := No_Element;
      Completion : Cursor := No_Element;
   end record;
   type Task_Declaration is new Identifier_Declaration with record
      Name       : Cursor := No_Element;
      Definition : Cursor := No_Element;
   end record;
   type Generic_Declaration is new Identifier_Declaration with record
      Name          : Cursor := No_Element;
      Formals       : Cursor := No_Element;
      Specification : Cursor := No_Element;
   end record;
   type Exception_Declaration is new Identifier_Declaration with record
      Names : Cursor := No_Element;
   end record;
   type Deferred_Constant_Declaration is new Identifier_Declaration with record
      Names        : Cursor := No_Element;
      Subtype_Mark : Cursor := No_Element;
   end record;
   type Renaming_Declaration is new Identifier_Declaration with record
      Renamed : Cursor := No_Element;
   end record;
   type Generic_Instantiation is new Identifier_Declaration with record
      Generic_Unit          : Cursor := No_Element;
      Associations          : Cursor := No_Element;
      Expanded_Declarations : Cursor := No_Element;
   end record;
   type Use_Clause is new Use_Or_Pragma with record
      Names : Cursor := No_Element;
   end record;
   type Declaration_Pragma is new Use_Or_Pragma with record
      Pragma_Item : Cursor := No_Element;
   end record;
   type Defining_Name is abstract new Defining_Occurrence with null record;
   type Defining_Operator is new Defining_Occurrence with record
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Location         : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
   end record;
   type Defining_Character is new Defining_Occurrence with record
      Object_Type    : Cursor := No_Element;
      Position       : Integer := 0;
      Representation : Integer := 0;
   end record;
   type Source_Name is abstract new Defining_Name with null record;
   type Predefined_Name is abstract new Defining_Name with null record;
   type Object_Name is abstract new Source_Name with null record;
   type Enumeration_Literal_Name is new Source_Name with record
      Object_Type    : Cursor := No_Element;
      Position       : Integer := 0;
      Representation : Integer := 0;
   end record;
   type Type_Name is abstract new Source_Name with null record;
   type Unit_Name is abstract new Source_Name with null record;
   type Label_Name is abstract new Source_Name with null record;
   type Entry_Name is new Source_Name with record
      Specification : Cursor := No_Element;
      Address       : Cursor := No_Element;
   end record;
   type Exception_Name is new Source_Name with record
      First_Definition : Cursor := No_Element;
   end record;
   type Init_Object_Name is abstract new Object_Name with null record;
   type Iteration_Name is new Object_Name with record
      Object_Type : Cursor := No_Element;
   end record;
   type Variable_Name is new Init_Object_Name with record
      Object_Type : Cursor := No_Element;
      Address     : Cursor := No_Element;
      Object_Def  : Cursor := No_Element;
   end record;
   type Constant_Name is new Init_Object_Name with record
      Object_Type      : Cursor := No_Element;
      Address          : Cursor := No_Element;
      Object_Def       : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
   end record;
   type Number_Name is new Init_Object_Name with record
      Object_Type             : Cursor := No_Element;
      Static_Value_Expression : Cursor := No_Element;
   end record;
   type Component_Name is new Init_Object_Name with record
      Object_Type    : Cursor := No_Element;
      Initialization : Cursor := No_Element;
      Component_Spec : Cursor := No_Element;
   end record;
   type Discriminant_Name is new Init_Object_Name with record
      Object_Type      : Cursor := No_Element;
      Initialization   : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
      Component_Spec   : Cursor := No_Element;
   end record;
   type Parameter_Name is new Init_Object_Name with record
      Object_Type      : Cursor := No_Element;
      Default          : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
   end record;
   type Full_Type_Name is new Type_Name with record
      Type_Specification : Cursor := No_Element;
      First_Definition   : Cursor := No_Element;
   end record;
   type Subtype_Name is new Type_Name with record
      Type_Specification : Cursor := No_Element;
   end record;
   type Private_Type_Name is new Type_Name with record
      Type_Specification : Cursor := No_Element;
   end record;
   type Subprogram_Name is new Unit_Name with record
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Location         : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
   end record;
   type Package_Name is new Unit_Name with record
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Address          : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
   end record;
   type Generic_Name is new Unit_Name with record
      Formals          : Cursor := No_Element;
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
   end record;
   type Task_Body_Name is new Unit_Name with record
      Type_Specification : Cursor := No_Element;
      Completion         : Cursor := No_Element;
      Stub               : Cursor := No_Element;
      First_Definition   : Cursor := No_Element;
   end record;
   type Statement_Label_Name is new Label_Name with record
      Statement : Cursor := No_Element;
   end record;
   type Loop_Block_Name is new Label_Name with record
      Statement : Cursor := No_Element;
   end record;
   type Attribute_Name is new Predefined_Name with null record;
   type Pragma_Name is new Predefined_Name with record
      Arguments : Cursor := No_Element;
   end record;
   type Argument_Name is new Predefined_Name with null record;
   type Builtin_Operator_Name is new Predefined_Name with record
      Operator : Cursor := No_Element;
   end record;
   type Name is abstract new Expression with null record;
   type Numeric_Literal is new Expression with record
      Literal_Image : Diana.Number_Rep;
   end record;
   type String_Literal is new Expression with record
      Literal_Image : Diana.Symbol_Rep;
      Constraint    : Cursor := No_Element;
   end record;
   type Null_Literal is new Expression with null record;
   type Aggregate is new Expression with record
      Associations    : Cursor := No_Element;
      Square_Brackets : Boolean := False;
      Normalized      : Cursor := No_Element;
   end record;
   type Delta_Aggregate is new Expression with record
      Base   : Cursor := No_Element;
      Deltas : Cursor := No_Element;
   end record;
   type Container_Aggregate is new Expression with record
      Associations : Cursor := No_Element;
   end record;
   type Allocator is abstract new Expression with null record;
   type Qualified_Expression is new Expression with record
      Target  : Cursor := No_Element;
      Operand : Cursor := No_Element;
   end record;
   type Type_Conversion is new Expression with record
      Target  : Cursor := No_Element;
      Operand : Cursor := No_Element;
   end record;
   type Parenthesized_Expression is new Expression with record
      Operand : Cursor := No_Element;
   end record;
   type Short_Circuit is new Expression with record
      Left     : Cursor := No_Element;
      Operator : Cursor := No_Element;
      Right    : Cursor := No_Element;
   end record;
   type Membership is new Expression with record
      Operand  : Cursor := No_Element;
      Operator : Cursor := No_Element;
      Choices  : Cursor := No_Element;
   end record;
   type Conditional_Expression is abstract new Expression with null record;
   type Quantified_Expression is new Expression with record
      Quantifier : Cursor := No_Element;
      Iterator   : Cursor := No_Element;
      Predicate  : Cursor := No_Element;
   end record;
   type Declare_Expression is new Expression with record
      Declarations : Cursor := No_Element;
      Result       : Cursor := No_Element;
   end record;
   type Reduction_Expression is new Expression with record
      Value_Sequence : Cursor := No_Element;
      Reducer        : Cursor := No_Element;
      Initial_Value  : Cursor := No_Element;
      Is_Parallel    : Boolean := False;
   end record;
   type Raise_Expression is new Expression with record
      Exception_Name : Cursor := No_Element;
      Message        : Cursor := No_Element;
   end record;
   type Qualified_Allocator is new Allocator with record
      Value : Cursor := No_Element;
   end record;
   type Subtype_Allocator is new Allocator with record
      Subtype_Indication : Cursor := No_Element;
   end record;
   type Short_Circuit_Op is abstract new Node with null record;
   type And_Then is new Short_Circuit_Op with null record;
   type Or_Else is new Short_Circuit_Op with null record;
   type Membership_Choice is abstract new Node with null record;
   type Membership_Value is new Membership_Choice with record
      Value : Cursor := No_Element;
   end record;
   type Membership_Range is new Membership_Choice with record
      Range_Item : Cursor := No_Element;
   end record;
   type Membership_Subtype is new Membership_Choice with record
      Subtype_Mark : Cursor := No_Element;
   end record;
   type Membership_Op is abstract new Node with null record;
   type In_Set is new Membership_Op with null record;
   type Not_In_Set is new Membership_Op with null record;
   type If_Expression is new Conditional_Expression with record
      Clauses : Cursor := No_Element;
   end record;
   type Case_Expression is new Conditional_Expression with record
      Selector     : Cursor := No_Element;
      Alternatives : Cursor := No_Element;
   end record;
   type Expression_Clause is new Node with record
      Condition : Cursor := No_Element;
      Result    : Cursor := No_Element;
   end record;
   type Expression_Alternative is new Node with record
      Choices : Cursor := No_Element;
      Result  : Cursor := No_Element;
   end record;
   type Quantifier_Kind is abstract new Node with null record;
   type For_All is new Quantifier_Kind with null record;
   type For_Some is new Quantifier_Kind with null record;
   type Iterator_Specification is abstract new Node with null record;
   type Range_Iterator is new Iterator_Specification with record
      Parameter      : Cursor := No_Element;
      Discrete_Range : Cursor := No_Element;
      Reverse_Order  : Boolean := False;
      Filter         : Cursor := No_Element;
   end record;
   type Container_Iterator is new Iterator_Specification with record
      Parameter     : Cursor := No_Element;
      Iterable      : Cursor := No_Element;
      Reverse_Order : Boolean := False;
      Filter        : Cursor := No_Element;
   end record;
   type Selector_Name is abstract new Name with null record;
   type Used_Object is new Name with record
      Definition : Cursor := No_Element;
   end record;
   type Used_Builtin is new Name with record
      Builtin_Operator : Cursor := No_Element;
   end record;
   type Indexed_Component is new Name with record
      Prefix  : Cursor := No_Element;
      Indices : Cursor := No_Element;
   end record;
   type Slice is new Name with record
      Prefix         : Cursor := No_Element;
      Discrete_Range : Cursor := No_Element;
   end record;
   type Selected_Component is new Name with record
      Prefix   : Cursor := No_Element;
      Selector : Cursor := No_Element;
   end record;
   type Dereference is new Name with record
      Prefix : Cursor := No_Element;
   end record;
   type Attribute_Reference is new Name with record
      Prefix    : Cursor := No_Element;
      Attribute : Cursor := No_Element;
   end record;
   type Attribute_Call is new Name with record
      Prefix   : Cursor := No_Element;
      Argument : Cursor := No_Element;
   end record;
   type Function_Call is new Name with record
      Prefix             : Cursor := No_Element;
      Actuals            : Cursor := No_Element;
      Is_Prefix_Notation : Boolean := False;
      Normalized_Actuals : Cursor := No_Element;
   end record;
   type Target_Name is new Name with null record;
   type Used_Name is new Selector_Name with record
      Definition : Cursor := No_Element;
   end record;
   type Used_Character is new Selector_Name with record
      Definition : Cursor := No_Element;
   end record;
   type Used_Operator is new Selector_Name with record
      Definition : Cursor := No_Element;
   end record;
   type Positional_Association is new Association with record
      Value : Cursor := No_Element;
   end record;
   type Named_Association is new Association with record
      Choices : Cursor := No_Element;
      Actual  : Cursor := No_Element;
   end record;
   type Iterated_Association is new Association with record
      Iterator : Cursor := No_Element;
      Result   : Cursor := No_Element;
   end record;
   type Null_Statement is new Statement with null record;
   type Assignment is new Statement with record
      Target : Cursor := No_Element;
      Source : Cursor := No_Element;
   end record;
   type Procedure_Call is new Statement with record
      Prefix             : Cursor := No_Element;
      Actuals            : Cursor := No_Element;
      Normalized_Actuals : Cursor := No_Element;
   end record;
   type Exit_Statement is new Statement with record
      Loop_Name : Cursor := No_Element;
      Condition : Cursor := No_Element;
   end record;
   type Return_Statement is new Statement with record
      Returned_Object    : Cursor := No_Element;
      Handled_Statements : Cursor := No_Element;
   end record;
   type Goto_Statement is new Statement with record
      Target : Cursor := No_Element;
   end record;
   type If_Statement is new Statement with record
      Clauses : Cursor := No_Element;
   end record;
   type Case_Statement is new Statement with record
      Selector     : Cursor := No_Element;
      Alternatives : Cursor := No_Element;
   end record;
   type Loop_Statement is new Statement with record
      Iteration  : Cursor := No_Element;
      Statements : Cursor := No_Element;
   end record;
   type Block_Statement is new Statement with record
      Block : Cursor := No_Element;
   end record;
   type Labeled_Statement is new Statement with record
      Labels    : Cursor := No_Element;
      Statement : Cursor := No_Element;
   end record;
   type Raise_Statement is new Statement with record
      Exception_Name : Cursor := No_Element;
      Message        : Cursor := No_Element;
   end record;
   type Delay_Statement is new Statement with record
      Expression : Cursor := No_Element;
      Until_Form : Boolean := False;
   end record;
   type Accept_Statement is new Statement with record
      Entry_Name         : Cursor := No_Element;
      Entry_Index        : Cursor := No_Element;
      Parameters         : Cursor := No_Element;
      Handled_Statements : Cursor := No_Element;
      Handlers           : Cursor := No_Element;
   end record;
   type Entry_Call is new Statement with record
      Prefix             : Cursor := No_Element;
      Actuals            : Cursor := No_Element;
      Normalized_Actuals : Cursor := No_Element;
   end record;
   type Requeue_Statement is new Statement with record
      Target     : Cursor := No_Element;
      With_Abort : Boolean := False;
   end record;
   type Select_Statement is abstract new Statement with null record;
   type Abort_Statement is new Statement with record
      Tasks : Cursor := No_Element;
   end record;
   type Parallel_Block is new Statement with record
      Arms : Cursor := No_Element;
   end record;
   type Statement_Pragma is new Statement with record
      Pragma_Item : Cursor := No_Element;
   end record;
   type Conditional_Clause is new Node with record
      Condition  : Cursor := No_Element;
      Statements : Cursor := No_Element;
   end record;
   type Alternative is abstract new Node with null record;
   type Case_Alternative is new Alternative with record
      Choices    : Cursor := No_Element;
      Statements : Cursor := No_Element;
   end record;
   type Alternative_Pragma is new Alternative with record
      Pragma_Item : Cursor := No_Element;
   end record;
   type Exception_Handler is new Alternative with record
      Choice_Parameter : Cursor := No_Element;
      Choices          : Cursor := No_Element;
      Statements       : Cursor := No_Element;
   end record;
   type Iteration is abstract new Node with null record;
   type No_Iteration is new Iteration with null record;
   type While_Loop is new Iteration with record
      Condition : Cursor := No_Element;
   end record;
   type For_Loop is new Iteration with record
      Iterator    : Cursor := No_Element;
      Parallelism : Cursor := No_Element;
   end record;
   type Parallel_Specification is abstract new Node with null record;
   type Sequential is new Parallel_Specification with null record;
   type Parallel_Chunked is new Parallel_Specification with record
      Chunk_Specification : Cursor := No_Element;
   end record;
   type Selective_Accept is new Select_Statement with record
      Alternatives    : Cursor := No_Element;
      Else_Statements : Cursor := No_Element;
   end record;
   type Conditional_Entry_Call is new Select_Statement with record
      Entry_Call      : Cursor := No_Element;
      Call_Statements : Cursor := No_Element;
      Else_Statements : Cursor := No_Element;
   end record;
   type Timed_Entry_Call is new Select_Statement with record
      Entry_Call       : Cursor := No_Element;
      Call_Statements  : Cursor := No_Element;
      Delay_Statement  : Cursor := No_Element;
      Delay_Statements : Cursor := No_Element;
   end record;
   type Asynchronous_Select is new Select_Statement with record
      Trigger               : Cursor := No_Element;
      Triggering_Statements : Cursor := No_Element;
      Abortable_Statements  : Cursor := No_Element;
   end record;
   type Select_Alternative is abstract new Node with null record;
   type Accept_Alternative is new Select_Alternative with record
      Guard            : Cursor := No_Element;
      Accept_Statement : Cursor := No_Element;
      Statements       : Cursor := No_Element;
   end record;
   type Delay_Alternative is new Select_Alternative with record
      Guard           : Cursor := No_Element;
      Delay_Statement : Cursor := No_Element;
      Statements      : Cursor := No_Element;
   end record;
   type Terminate_Alternative is new Select_Alternative with record
      Guard : Cursor := No_Element;
   end record;
   type Select_Alternative_Pragma is new Select_Alternative with record
      Pragma_Item : Cursor := No_Element;
   end record;
   type Parallel_Arm is new Node with record
      Statements : Cursor := No_Element;
   end record;
   type Scalar_Type is abstract new Type_Spec with null record;
   type Access_Type is abstract new Type_Spec with null record;
   type Composite_Type is abstract new Type_Spec with null record;
   type Derived_Type is new Type_Spec with record
      Parent : Cursor := No_Element;
   end record;
   type Class_Wide_Type is new Type_Spec with record
      Root_Type : Cursor := No_Element;
   end record;
   type Private_Type is new Type_Spec with record
      Discriminants : Cursor := No_Element;
      Ancestor      : Cursor := No_Element;
      Progenitors   : Cursor := No_Element;
      Is_Tagged     : Boolean := False;
      Is_Limited    : Boolean := False;
      Is_Abstract   : Boolean := False;
   end record;
   type Incomplete_Type is new Type_Spec with record
      Is_Tagged : Boolean := False;
   end record;
   type Generic_Formal_Type is abstract new Type_Spec with null record;
   type Constrained_Spec is new Type_Spec with record
      Mark       : Cursor := No_Element;
      Constraint : Cursor := No_Element;
   end record;
   type Universal_Type is abstract new Type_Spec with null record;
   type Void is new Node with null record;
   type Universal_Integer is new Universal_Type with null record;
   type Universal_Real is new Universal_Type with null record;
   type Universal_Fixed is new Universal_Type with null record;
   type Discrete_Type is abstract new Scalar_Type with null record;
   type Real_Type is abstract new Scalar_Type with null record;
   type Enumeration_Type is new Discrete_Type with record
      Literals : Cursor := No_Element;
   end record;
   type Integer_Type is abstract new Discrete_Type with null record;
   type Signed_Integer_Type is new Integer_Type with record
      Bounds : Cursor := No_Element;
   end record;
   type Modular_Type is new Integer_Type with record
      Modulus : Cursor := No_Element;
   end record;
   type Floating_Point_Type is new Real_Type with record
      Digits_Value : Cursor := No_Element;
      Real_Range   : Cursor := No_Element;
   end record;
   type Fixed_Point_Type is abstract new Real_Type with null record;
   type Ordinary_Fixed_Point_Type is new Fixed_Point_Type with record
      Delta_Value : Cursor := No_Element;
      Real_Range  : Cursor := No_Element;
   end record;
   type Decimal_Fixed_Point_Type is new Fixed_Point_Type with record
      Delta_Value  : Cursor := No_Element;
      Digits_Value : Cursor := No_Element;
      Real_Range   : Cursor := No_Element;
   end record;
   type Access_To_Object is new Access_Type with record
      Designated   : Cursor := No_Element;
      Access_Kind  : Cursor := No_Element;
      Is_Anonymous : Boolean := False;
   end record;
   type Access_To_Subprogram is new Access_Type with record
      Profile      : Cursor := No_Element;
      Is_Protected : Boolean := False;
      Is_Anonymous : Boolean := False;
   end record;
   type Object_Access_Kind is abstract new Node with null record;
   type Pool_Specific is new Object_Access_Kind with null record;
   type General_Access_All is new Object_Access_Kind with null record;
   type General_Access_Constant is new Object_Access_Kind with null record;
   type Array_Type is new Composite_Type with record
      Index_Ranges   : Cursor := No_Element;
      Is_Constrained : Boolean := False;
      Component      : Cursor := No_Element;
   end record;
   type Record_Type is new Composite_Type with record
      Components : Cursor := No_Element;
   end record;
   type Tagged_Record_Type is new Composite_Type with record
      Ancestor    : Cursor := No_Element;
      Progenitors : Cursor := No_Element;
      Components  : Cursor := No_Element;
   end record;
   type Interface_Type is new Composite_Type with record
      Progenitors : Cursor := No_Element;
      Kind        : Cursor := No_Element;
   end record;
   type Task_Type is new Composite_Type with record
      Definition : Cursor := No_Element;
   end record;
   type Protected_Type is new Composite_Type with record
      Definition : Cursor := No_Element;
   end record;
   type Interface_Kind is abstract new Node with null record;
   type Ordinary_Interface is new Interface_Kind with null record;
   type Limited_Interface is new Interface_Kind with null record;
   type Synchronized_Interface is new Interface_Kind with null record;
   type Task_Interface is new Interface_Kind with null record;
   type Protected_Interface is new Interface_Kind with null record;
   type Protected_Definition is abstract new Node with null record;
   type Protected_Specification is new Protected_Definition with record
      Visible_Declarations : Cursor := No_Element;
      Private_Declarations : Cursor := No_Element;
   end record;
   type Component is abstract new Node with null record;
   type Component_Declaration is new Component with record
      Names          : Cursor := No_Element;
      Object_Subtype : Cursor := No_Element;
      Initialization : Cursor := No_Element;
   end record;
   type Variant_Part is new Component with record
      Discriminant : Cursor := No_Element;
      Variants     : Cursor := No_Element;
   end record;
   type Null_Component is new Component with null record;
   type Component_Pragma is new Component with record
      Pragma_Item : Cursor := No_Element;
   end record;
   type Variant is new Node with record
      Choices    : Cursor := No_Element;
      Components : Cursor := No_Element;
   end record;
   type Discriminant_Part is abstract new Node with null record;
   type Discriminant_S is new Discriminant_Part with record
      List : Node_List;
   end record;
   type Discrete_Range is abstract new Constraint with null record;
   type Index_Constraint is new Constraint with record
      Ranges : Cursor := No_Element;
   end record;
   type Real_Constraint is abstract new Constraint with null record;
   type Discriminant_Constraint is new Constraint with record
      Associations : Cursor := No_Element;
      Normalized   : Cursor := No_Element;
   end record;
   type Scalar_Range is abstract new Discrete_Range with null record;
   type Discrete_Subtype is new Discrete_Range with record
      Subtype_Indication : Cursor := No_Element;
   end record;
   type Range_Bounds is new Scalar_Range with record
      Lower : Cursor := No_Element;
      Upper : Cursor := No_Element;
   end record;
   type Range_Attribute is new Scalar_Range with record
      Prefix : Cursor := No_Element;
   end record;
   type Float_Constraint is new Real_Constraint with record
      Digits_Value : Cursor := No_Element;
      Real_Range   : Cursor := No_Element;
   end record;
   type Fixed_Constraint is new Real_Constraint with record
      Delta_Value : Cursor := No_Element;
      Real_Range  : Cursor := No_Element;
   end record;
   type Procedure_Header is new Header with record
      Parameters : Cursor := No_Element;
   end record;
   type Function_Header is new Header with record
      Parameters     : Cursor := No_Element;
      Result_Subtype : Cursor := No_Element;
   end record;
   type Entry_Header is new Header with record
      Family_Index : Cursor := No_Element;
      Parameters   : Cursor := No_Element;
   end record;
   type Parameter is abstract new Node with null record;
   type In_Parameter is new Parameter with record
      Names      : Cursor := No_Element;
      Type_Mark  : Cursor := No_Element;
      Default    : Cursor := No_Element;
      Is_Aliased : Boolean := False;
   end record;
   type Out_Parameter is new Parameter with record
      Names      : Cursor := No_Element;
      Type_Mark  : Cursor := No_Element;
      Is_Aliased : Boolean := False;
   end record;
   type In_Out_Parameter is new Parameter with record
      Names      : Cursor := No_Element;
      Type_Mark  : Cursor := No_Element;
      Is_Aliased : Boolean := False;
   end record;
   type Parameter_Type is abstract new Node with null record;
   type Named_Subtype is new Parameter_Type with record
      Mark : Cursor := No_Element;
   end record;
   type Anonymous_Access is new Parameter_Type with record
      Definition : Cursor := No_Element;
   end record;
   type Unit_Completion is abstract new Node with null record;
   type Block is new Unit_Completion with record
      Declarations : Cursor := No_Element;
      Statements   : Cursor := No_Element;
      Handlers     : Cursor := No_Element;
   end record;
   type Stub is new Unit_Completion with null record;
   type Unit_Instantiation is new Unit_Completion with record
      Instance : Cursor := No_Element;
   end record;
   type Unit_Renaming is new Unit_Completion with record
      Renamed : Cursor := No_Element;
   end record;
   type Formal_Subprogram_Default is abstract new Unit_Completion with null record;
   type Language_Binding is new Unit_Completion with record
      Convention : Cursor := No_Element;
   end record;
   type Renaming is new Node with record
      Renamed : Cursor := No_Element;
   end record;
   type Task_Definition is abstract new Node with null record;
   type Task_Specification is new Task_Definition with record
      Declarations : Cursor := No_Element;
   end record;
   type Entry_Index_Specification is abstract new Node with null record;
   type Entry_Index_Definition is new Entry_Index_Specification with record
      Parameter      : Cursor := No_Element;
      Discrete_Range : Cursor := No_Element;
   end record;
   type Generic_Header is abstract new Node with null record;
   type Generic_Subprogram_Header is new Generic_Header with record
      Profile : Cursor := No_Element;
   end record;
   type Generic_Formal is abstract new Node with null record;
   type Generic_Formal_Object is new Generic_Formal with record
      Names        : Cursor := No_Element;
      Mode         : Cursor := No_Element;
      Subtype_Mark : Cursor := No_Element;
      Default      : Cursor := No_Element;
   end record;
   type Generic_Formal_Type_Declaration is new Generic_Formal with record
      Name       : Cursor := No_Element;
      Definition : Cursor := No_Element;
   end record;
   type Generic_Formal_Subprogram is new Generic_Formal with record
      Specification : Cursor := No_Element;
      Default       : Cursor := No_Element;
   end record;
   type Generic_Formal_Package is new Generic_Formal with record
      Name     : Cursor := No_Element;
      Template : Cursor := No_Element;
      Actuals  : Cursor := No_Element;
      Is_Box   : Boolean := False;
   end record;
   type Generic_Object_Mode is abstract new Node with null record;
   type Generic_In is new Generic_Object_Mode with null record;
   type Generic_In_Out is new Generic_Object_Mode with null record;
   type Default_Name is new Formal_Subprogram_Default with record
      Subprogram : Cursor := No_Element;
   end record;
   type Box is new Formal_Subprogram_Default with null record;
   type No_Default is new Formal_Subprogram_Default with null record;
   type Formal_Scalar_Type is abstract new Generic_Formal_Type with null record;
   type Formal_Access_Type is abstract new Generic_Formal_Type with null record;
   type Formal_Composite_Type is abstract new Generic_Formal_Type with null record;
   type Formal_Derived_Type is new Generic_Formal_Type with record
      Parent          : Cursor := No_Element;
      Progenitors     : Cursor := No_Element;
      Is_Tagged       : Boolean := False;
      Is_Limited      : Boolean := False;
      Is_Abstract     : Boolean := False;
      Is_Synchronized : Boolean := False;
   end record;
   type Formal_Private_Type is new Generic_Formal_Type with record
      Discriminants   : Cursor := No_Element;
      Is_Tagged       : Boolean := False;
      Is_Limited      : Boolean := False;
      Is_Abstract     : Boolean := False;
      Is_Synchronized : Boolean := False;
   end record;
   type Formal_Incomplete_Type is new Generic_Formal_Type with record
      Is_Tagged : Boolean := False;
   end record;
   type Formal_Discrete is new Formal_Scalar_Type with null record;
   type Formal_Signed_Integer is new Formal_Scalar_Type with null record;
   type Formal_Modular is new Formal_Scalar_Type with null record;
   type Formal_Floating_Point is new Formal_Scalar_Type with null record;
   type Formal_Ordinary_Fixed is new Formal_Scalar_Type with null record;
   type Formal_Decimal_Fixed is new Formal_Scalar_Type with null record;
   type Formal_Access_To_Object is new Formal_Access_Type with record
      Designated  : Cursor := No_Element;
      Access_Kind : Cursor := No_Element;
   end record;
   type Formal_Access_To_Subprogram is new Formal_Access_Type with record
      Profile : Cursor := No_Element;
   end record;
   type Formal_Array_Type is new Formal_Composite_Type with record
      Index_Ranges : Cursor := No_Element;
      Component    : Cursor := No_Element;
   end record;
   type Formal_Interface_Type is new Formal_Composite_Type with record
      Progenitors : Cursor := No_Element;
      Kind        : Cursor := No_Element;
   end record;
   type Property_Origin is abstract new Node with null record;
   type From_Aspect is new Property_Origin with null record;
   type From_Attribute_Clause is new Property_Origin with null record;
   type Property_Value is abstract new Node with null record;
   type Aspect_Expression is new Property_Value with record
      Value : Cursor := No_Element;
   end record;
   type Contract_Case_List is new Property_Value with record
      Cases : Cursor := No_Element;
   end record;
   type Contract_Case is new Node with record
      Guard       : Cursor := No_Element;
      Consequence : Cursor := No_Element;
   end record;
   type Property_Identity is abstract new Node with null record;
   type Contract_Aspect is abstract new Property_Identity with null record;
   type Representation_Aspect is abstract new Property_Identity with null record;
   type Interfacing_Aspect is abstract new Property_Identity with null record;
   type Categorization_Aspect is abstract new Property_Identity with null record;
   type Concurrency_Aspect is abstract new Property_Identity with null record;
   type Iteration_Aspect is abstract new Property_Identity with null record;
   type Literal_Aspect is abstract new Property_Identity with null record;
   type Stream_Aspect is abstract new Property_Identity with null record;
   type Other_Property is new Property_Identity with record
      Property_Name : Cursor := No_Element;
   end record;
   type Aspect_Pre is new Contract_Aspect with null record;
   type Aspect_Post is new Contract_Aspect with null record;
   type Aspect_Type_Invariant is new Contract_Aspect with null record;
   type Aspect_Predicate is new Contract_Aspect with null record;
   type Aspect_Static_Predicate is new Contract_Aspect with null record;
   type Aspect_Dynamic_Predicate is new Contract_Aspect with null record;
   type Aspect_Contract_Cases is new Contract_Aspect with null record;
   type Aspect_Default_Initial_Condition is new Contract_Aspect with null record;
   type Aspect_Subprogram_Variant is new Contract_Aspect with null record;
   type Aspect_Global is new Contract_Aspect with null record;
   type Aspect_Depends is new Contract_Aspect with null record;
   type Aspect_Relaxed_Initialization is new Contract_Aspect with null record;
   type Aspect_Stable_Properties is new Contract_Aspect with null record;
   type Aspect_Size is new Representation_Aspect with null record;
   type Aspect_Object_Size is new Representation_Aspect with null record;
   type Aspect_Component_Size is new Representation_Aspect with null record;
   type Aspect_Alignment is new Representation_Aspect with null record;
   type Aspect_Bit_Order is new Representation_Aspect with null record;
   type Aspect_Scalar_Storage_Order is new Representation_Aspect with null record;
   type Aspect_Pack is new Representation_Aspect with null record;
   type Aspect_Address is new Representation_Aspect with null record;
   type Aspect_Storage_Size is new Representation_Aspect with null record;
   type Aspect_Storage_Pool is new Representation_Aspect with null record;
   type Aspect_Default_Storage_Pool is new Representation_Aspect with null record;
   type Aspect_Small is new Representation_Aspect with null record;
   type Aspect_Machine_Radix is new Representation_Aspect with null record;
   type Aspect_Default_Value is new Representation_Aspect with null record;
   type Aspect_Default_Component_Value is new Representation_Aspect with null record;
   type Aspect_Atomic is new Representation_Aspect with null record;
   type Aspect_Volatile is new Representation_Aspect with null record;
   type Aspect_Atomic_Components is new Representation_Aspect with null record;
   type Aspect_Volatile_Components is new Representation_Aspect with null record;
   type Aspect_Independent is new Representation_Aspect with null record;
   type Aspect_Independent_Components is new Representation_Aspect with null record;
   type Aspect_External_Tag is new Representation_Aspect with null record;
   type Aspect_Discard_Names is new Representation_Aspect with null record;
   type Aspect_Convention is new Interfacing_Aspect with null record;
   type Aspect_Import is new Interfacing_Aspect with null record;
   type Aspect_Export is new Interfacing_Aspect with null record;
   type Aspect_External_Name is new Interfacing_Aspect with null record;
   type Aspect_Link_Name is new Interfacing_Aspect with null record;
   type Aspect_Pure is new Categorization_Aspect with null record;
   type Aspect_Preelaborate is new Categorization_Aspect with null record;
   type Aspect_Elaborate_Body is new Categorization_Aspect with null record;
   type Aspect_Remote_Types is new Categorization_Aspect with null record;
   type Aspect_Remote_Call_Interface is new Categorization_Aspect with null record;
   type Aspect_Shared_Passive is new Categorization_Aspect with null record;
   type Aspect_Inline is new Categorization_Aspect with null record;
   type Aspect_No_Return is new Categorization_Aspect with null record;
   type Aspect_Priority is new Concurrency_Aspect with null record;
   type Aspect_Interrupt_Priority is new Concurrency_Aspect with null record;
   type Aspect_CPU is new Concurrency_Aspect with null record;
   type Aspect_Dispatching_Domain is new Concurrency_Aspect with null record;
   type Aspect_Attach_Handler is new Concurrency_Aspect with null record;
   type Aspect_Interrupt_Handler is new Concurrency_Aspect with null record;
   type Aspect_Exclusive_Functions is new Concurrency_Aspect with null record;
   type Aspect_Constant_Indexing is new Iteration_Aspect with null record;
   type Aspect_Variable_Indexing is new Iteration_Aspect with null record;
   type Aspect_Default_Iterator is new Iteration_Aspect with null record;
   type Aspect_Iterator_Element is new Iteration_Aspect with null record;
   type Aspect_Iterator_View is new Iteration_Aspect with null record;
   type Aspect_Aggregate is new Iteration_Aspect with null record;
   type Aspect_Iterable is new Iteration_Aspect with null record;
   type Aspect_Integer_Literal is new Literal_Aspect with null record;
   type Aspect_Real_Literal is new Literal_Aspect with null record;
   type Aspect_String_Literal is new Literal_Aspect with null record;
   type Aspect_Read is new Stream_Aspect with null record;
   type Aspect_Write is new Stream_Aspect with null record;
   type Aspect_Input is new Stream_Aspect with null record;
   type Aspect_Output is new Stream_Aspect with null record;
   type Aspect_Put_Image is new Stream_Aspect with null record;
   type Record_Representation is new Representation_Clause with record
      Name           : Cursor := No_Element;
      Alignment      : Cursor := No_Element;
      Component_Reps : Cursor := No_Element;
   end record;
   type Address_Clause is new Representation_Clause with record
      Name    : Cursor := No_Element;
      Address : Cursor := No_Element;
   end record;
   type Code_Statement is new Representation_Clause with record
      Subtype_Mark : Cursor := No_Element;
      Aggregate    : Cursor := No_Element;
   end record;
   type Component_Rep is new Node with record
      Name      : Cursor := No_Element;
      Position  : Cursor := No_Element;
      Bit_Range : Cursor := No_Element;
   end record;
   type Pragma_Item is new Node with record
      Name      : Cursor := No_Element;
      Arguments : Cursor := No_Element;
   end record;
   type Operator is abstract new Node with null record;
   type Op_And is new Operator with null record;
   type Op_Or is new Operator with null record;
   type Op_Xor is new Operator with null record;
   type Op_Equal is new Operator with null record;
   type Op_Not_Equal is new Operator with null record;
   type Op_Less is new Operator with null record;
   type Op_Less_Equal is new Operator with null record;
   type Op_Greater is new Operator with null record;
   type Op_Greater_Equal is new Operator with null record;
   type Op_Plus is new Operator with null record;
   type Op_Minus is new Operator with null record;
   type Op_Concatenate is new Operator with null record;
   type Op_Unary_Plus is new Operator with null record;
   type Op_Unary_Minus is new Operator with null record;
   type Op_Absolute is new Operator with null record;
   type Op_Not is new Operator with null record;
   type Op_Multiply is new Operator with null record;
   type Op_Divide is new Operator with null record;
   type Op_Modulo is new Operator with null record;
   type Op_Remainder is new Operator with null record;
   type Op_Exponentiate is new Operator with null record;
   type Compilation_Unit_S is new Element_List with record
      List : Node_List;
   end record;
   type Context_Element_S is new Element_List with record
      List : Node_List;
   end record;
   type Declaration_S is new Element_List with record
      List : Node_List;
   end record;
   type Item_S is new Element_List with record
      List : Node_List;
   end record;
   type Defining_Name_S is new Element_List with record
      List : Node_List;
   end record;
   type Name_S is new Element_List with record
      List : Node_List;
   end record;
   type Expression_S is new Element_List with record
      List : Node_List;
   end record;
   type Association_S is new Element_List with record
      List : Node_List;
   end record;
   type Statement_S is new Element_List with record
      List : Node_List;
   end record;
   type Alternative_S is new Element_List with record
      List : Node_List;
   end record;
   type Choice_S is new Element_List with record
      List : Node_List;
   end record;
   type Membership_Choice_S is new Element_List with record
      List : Node_List;
   end record;
   type Conditional_Clause_S is new Element_List with record
      List : Node_List;
   end record;
   type Expression_Clause_S is new Element_List with record
      List : Node_List;
   end record;
   type Expression_Alternative_S is new Element_List with record
      List : Node_List;
   end record;
   type Select_Alternative_S is new Element_List with record
      List : Node_List;
   end record;
   type Parallel_Arm_S is new Element_List with record
      List : Node_List;
   end record;
   type Contract_Case_S is new Element_List with record
      List : Node_List;
   end record;
   type Component_S is new Element_List with record
      List : Node_List;
   end record;
   type Variant_S is new Element_List with record
      List : Node_List;
   end record;
   type Discrete_Range_S is new Element_List with record
      List : Node_List;
   end record;
   type Parameter_S is new Element_List with record
      List : Node_List;
   end record;
   type Generic_Formal_S is new Element_List with record
      List : Node_List;
   end record;
   type Component_Rep_S is new Element_List with record
      List : Node_List;
   end record;
   type Semantic_Property_S is new Element_List with record
      List : Node_List;
   end record;
   type Choice is abstract new Node with null record;
   type Choice_Expression is new Choice with record
      Value : Cursor := No_Element;
   end record;
   type Choice_Range is new Choice with record
      Range_Item : Cursor := No_Element;
   end record;
   type Others_Choice is new Choice with null record;
   type Discriminant is new Node with record
      Names        : Cursor := No_Element;
      Subtype_Mark : Cursor := No_Element;
      Default      : Cursor := No_Element;
   end record;
   type Package_Specification is new Generic_Header with record
      Visible_Declarations : Cursor := No_Element;
      Private_Declarations : Cursor := No_Element;
   end record;

end Diana.Nodes;
