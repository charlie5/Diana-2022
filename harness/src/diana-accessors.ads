--  Diana.Accessors — typed reads over the node tree.
--
--  GENERATED from spec/DIANA_2022.idl by tools/gen_api.pl.  DO NOT EDIT.
--
--  For each IDL type T:  Is_T (C) tests the node at cursor C, and As_T (C) is a
--  typed class-wide view of it (read attributes as  As_T (C).Attribute, since
--  the Diana.Nodes record components are public).  As_T raises Constraint_Error
--  if the node is not a T — guard with Is_T.

pragma Style_Checks (Off);

with Diana.Nodes;

package Diana.Accessors is

   function Is_Compilation (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Compilation'Class);
   function As_Compilation (C : Cursor) return Diana.Nodes.Compilation'Class
     is (Diana.Nodes.Compilation'Class (Trees.Element (C)));

   function Is_Compilation_Unit (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Compilation_Unit'Class);
   function As_Compilation_Unit (C : Cursor) return Diana.Nodes.Compilation_Unit'Class
     is (Diana.Nodes.Compilation_Unit'Class (Trees.Element (C)));

   function Is_Context_Element (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Context_Element'Class);
   function As_Context_Element (C : Cursor) return Diana.Nodes.Context_Element'Class
     is (Diana.Nodes.Context_Element'Class (Trees.Element (C)));

   function Is_All_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.All_Declaration'Class);
   function As_All_Declaration (C : Cursor) return Diana.Nodes.All_Declaration'Class
     is (Diana.Nodes.All_Declaration'Class (Trees.Element (C)));

   function Is_Defining_Occurrence (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Defining_Occurrence'Class);
   function As_Defining_Occurrence (C : Cursor) return Diana.Nodes.Defining_Occurrence'Class
     is (Diana.Nodes.Defining_Occurrence'Class (Trees.Element (C)));

   function Is_Type_Spec (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Type_Spec'Class);
   function As_Type_Spec (C : Cursor) return Diana.Nodes.Type_Spec'Class
     is (Diana.Nodes.Type_Spec'Class (Trees.Element (C)));

   function Is_Constraint (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Constraint'Class);
   function As_Constraint (C : Cursor) return Diana.Nodes.Constraint'Class
     is (Diana.Nodes.Constraint'Class (Trees.Element (C)));

   function Is_Header (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Header'Class);
   function As_Header (C : Cursor) return Diana.Nodes.Header'Class
     is (Diana.Nodes.Header'Class (Trees.Element (C)));

   function Is_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Expression'Class);
   function As_Expression (C : Cursor) return Diana.Nodes.Expression'Class
     is (Diana.Nodes.Expression'Class (Trees.Element (C)));

   function Is_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Statement'Class);
   function As_Statement (C : Cursor) return Diana.Nodes.Statement'Class
     is (Diana.Nodes.Statement'Class (Trees.Element (C)));

   function Is_Association (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Association'Class);
   function As_Association (C : Cursor) return Diana.Nodes.Association'Class
     is (Diana.Nodes.Association'Class (Trees.Element (C)));

   function Is_Semantic_Property (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Semantic_Property'Class);
   function As_Semantic_Property (C : Cursor) return Diana.Nodes.Semantic_Property'Class
     is (Diana.Nodes.Semantic_Property'Class (Trees.Element (C)));

   function Is_Element_List (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Element_List'Class);
   function As_Element_List (C : Cursor) return Diana.Nodes.Element_List'Class
     is (Diana.Nodes.Element_List'Class (Trees.Element (C)));

   function Is_Item (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Item'Class);
   function As_Item (C : Cursor) return Diana.Nodes.Item'Class
     is (Diana.Nodes.Item'Class (Trees.Element (C)));

   function Is_Subunit (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Subunit'Class);
   function As_Subunit (C : Cursor) return Diana.Nodes.Subunit'Class
     is (Diana.Nodes.Subunit'Class (Trees.Element (C)));

   function Is_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Declaration'Class);
   function As_Declaration (C : Cursor) return Diana.Nodes.Declaration'Class
     is (Diana.Nodes.Declaration'Class (Trees.Element (C)));

   function Is_Proper_Body (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Proper_Body'Class);
   function As_Proper_Body (C : Cursor) return Diana.Nodes.Proper_Body'Class
     is (Diana.Nodes.Proper_Body'Class (Trees.Element (C)));

   function Is_Entry_Body (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Entry_Body'Class);
   function As_Entry_Body (C : Cursor) return Diana.Nodes.Entry_Body'Class
     is (Diana.Nodes.Entry_Body'Class (Trees.Element (C)));

   function Is_Subprogram_Body (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Subprogram_Body'Class);
   function As_Subprogram_Body (C : Cursor) return Diana.Nodes.Subprogram_Body'Class
     is (Diana.Nodes.Subprogram_Body'Class (Trees.Element (C)));

   function Is_Package_Body (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Package_Body'Class);
   function As_Package_Body (C : Cursor) return Diana.Nodes.Package_Body'Class
     is (Diana.Nodes.Package_Body'Class (Trees.Element (C)));

   function Is_Task_Body (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Task_Body'Class);
   function As_Task_Body (C : Cursor) return Diana.Nodes.Task_Body'Class
     is (Diana.Nodes.Task_Body'Class (Trees.Element (C)));

   function Is_Protected_Body (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Protected_Body'Class);
   function As_Protected_Body (C : Cursor) return Diana.Nodes.Protected_Body'Class
     is (Diana.Nodes.Protected_Body'Class (Trees.Element (C)));

   function Is_With_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.With_Clause'Class);
   function As_With_Clause (C : Cursor) return Diana.Nodes.With_Clause'Class
     is (Diana.Nodes.With_Clause'Class (Trees.Element (C)));

   function Is_Context_Use_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Context_Use_Clause'Class);
   function As_Context_Use_Clause (C : Cursor) return Diana.Nodes.Context_Use_Clause'Class
     is (Diana.Nodes.Context_Use_Clause'Class (Trees.Element (C)));

   function Is_Context_Pragma (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Context_Pragma'Class);
   function As_Context_Pragma (C : Cursor) return Diana.Nodes.Context_Pragma'Class
     is (Diana.Nodes.Context_Pragma'Class (Trees.Element (C)));

   function Is_Object_Or_Number_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Object_Or_Number_Declaration'Class);
   function As_Object_Or_Number_Declaration (C : Cursor) return Diana.Nodes.Object_Or_Number_Declaration'Class
     is (Diana.Nodes.Object_Or_Number_Declaration'Class (Trees.Element (C)));

   function Is_Identifier_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Identifier_Declaration'Class);
   function As_Identifier_Declaration (C : Cursor) return Diana.Nodes.Identifier_Declaration'Class
     is (Diana.Nodes.Identifier_Declaration'Class (Trees.Element (C)));

   function Is_Representation_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Representation_Clause'Class);
   function As_Representation_Clause (C : Cursor) return Diana.Nodes.Representation_Clause'Class
     is (Diana.Nodes.Representation_Clause'Class (Trees.Element (C)));

   function Is_Use_Or_Pragma (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Use_Or_Pragma'Class);
   function As_Use_Or_Pragma (C : Cursor) return Diana.Nodes.Use_Or_Pragma'Class
     is (Diana.Nodes.Use_Or_Pragma'Class (Trees.Element (C)));

   function Is_Object_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Object_Declaration'Class);
   function As_Object_Declaration (C : Cursor) return Diana.Nodes.Object_Declaration'Class
     is (Diana.Nodes.Object_Declaration'Class (Trees.Element (C)));

   function Is_Number_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Number_Declaration'Class);
   function As_Number_Declaration (C : Cursor) return Diana.Nodes.Number_Declaration'Class
     is (Diana.Nodes.Number_Declaration'Class (Trees.Element (C)));

   function Is_Constant_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Constant_Declaration'Class);
   function As_Constant_Declaration (C : Cursor) return Diana.Nodes.Constant_Declaration'Class
     is (Diana.Nodes.Constant_Declaration'Class (Trees.Element (C)));

   function Is_Variable_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Variable_Declaration'Class);
   function As_Variable_Declaration (C : Cursor) return Diana.Nodes.Variable_Declaration'Class
     is (Diana.Nodes.Variable_Declaration'Class (Trees.Element (C)));

   function Is_Type_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Type_Declaration'Class);
   function As_Type_Declaration (C : Cursor) return Diana.Nodes.Type_Declaration'Class
     is (Diana.Nodes.Type_Declaration'Class (Trees.Element (C)));

   function Is_Subtype_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Subtype_Declaration'Class);
   function As_Subtype_Declaration (C : Cursor) return Diana.Nodes.Subtype_Declaration'Class
     is (Diana.Nodes.Subtype_Declaration'Class (Trees.Element (C)));

   function Is_Subprogram_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Subprogram_Declaration'Class);
   function As_Subprogram_Declaration (C : Cursor) return Diana.Nodes.Subprogram_Declaration'Class
     is (Diana.Nodes.Subprogram_Declaration'Class (Trees.Element (C)));

   function Is_Package_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Package_Declaration'Class);
   function As_Package_Declaration (C : Cursor) return Diana.Nodes.Package_Declaration'Class
     is (Diana.Nodes.Package_Declaration'Class (Trees.Element (C)));

   function Is_Task_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Task_Declaration'Class);
   function As_Task_Declaration (C : Cursor) return Diana.Nodes.Task_Declaration'Class
     is (Diana.Nodes.Task_Declaration'Class (Trees.Element (C)));

   function Is_Generic_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Declaration'Class);
   function As_Generic_Declaration (C : Cursor) return Diana.Nodes.Generic_Declaration'Class
     is (Diana.Nodes.Generic_Declaration'Class (Trees.Element (C)));

   function Is_Exception_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Exception_Declaration'Class);
   function As_Exception_Declaration (C : Cursor) return Diana.Nodes.Exception_Declaration'Class
     is (Diana.Nodes.Exception_Declaration'Class (Trees.Element (C)));

   function Is_Deferred_Constant_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Deferred_Constant_Declaration'Class);
   function As_Deferred_Constant_Declaration (C : Cursor) return Diana.Nodes.Deferred_Constant_Declaration'Class
     is (Diana.Nodes.Deferred_Constant_Declaration'Class (Trees.Element (C)));

   function Is_Renaming_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Renaming_Declaration'Class);
   function As_Renaming_Declaration (C : Cursor) return Diana.Nodes.Renaming_Declaration'Class
     is (Diana.Nodes.Renaming_Declaration'Class (Trees.Element (C)));

   function Is_Generic_Instantiation (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Instantiation'Class);
   function As_Generic_Instantiation (C : Cursor) return Diana.Nodes.Generic_Instantiation'Class
     is (Diana.Nodes.Generic_Instantiation'Class (Trees.Element (C)));

   function Is_Use_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Use_Clause'Class);
   function As_Use_Clause (C : Cursor) return Diana.Nodes.Use_Clause'Class
     is (Diana.Nodes.Use_Clause'Class (Trees.Element (C)));

   function Is_Declaration_Pragma (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Declaration_Pragma'Class);
   function As_Declaration_Pragma (C : Cursor) return Diana.Nodes.Declaration_Pragma'Class
     is (Diana.Nodes.Declaration_Pragma'Class (Trees.Element (C)));

   function Is_Defining_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Defining_Name'Class);
   function As_Defining_Name (C : Cursor) return Diana.Nodes.Defining_Name'Class
     is (Diana.Nodes.Defining_Name'Class (Trees.Element (C)));

   function Is_Defining_Operator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Defining_Operator'Class);
   function As_Defining_Operator (C : Cursor) return Diana.Nodes.Defining_Operator'Class
     is (Diana.Nodes.Defining_Operator'Class (Trees.Element (C)));

   function Is_Defining_Character (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Defining_Character'Class);
   function As_Defining_Character (C : Cursor) return Diana.Nodes.Defining_Character'Class
     is (Diana.Nodes.Defining_Character'Class (Trees.Element (C)));

   function Is_Source_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Source_Name'Class);
   function As_Source_Name (C : Cursor) return Diana.Nodes.Source_Name'Class
     is (Diana.Nodes.Source_Name'Class (Trees.Element (C)));

   function Is_Predefined_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Predefined_Name'Class);
   function As_Predefined_Name (C : Cursor) return Diana.Nodes.Predefined_Name'Class
     is (Diana.Nodes.Predefined_Name'Class (Trees.Element (C)));

   function Is_Object_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Object_Name'Class);
   function As_Object_Name (C : Cursor) return Diana.Nodes.Object_Name'Class
     is (Diana.Nodes.Object_Name'Class (Trees.Element (C)));

   function Is_Enumeration_Literal_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Enumeration_Literal_Name'Class);
   function As_Enumeration_Literal_Name (C : Cursor) return Diana.Nodes.Enumeration_Literal_Name'Class
     is (Diana.Nodes.Enumeration_Literal_Name'Class (Trees.Element (C)));

   function Is_Type_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Type_Name'Class);
   function As_Type_Name (C : Cursor) return Diana.Nodes.Type_Name'Class
     is (Diana.Nodes.Type_Name'Class (Trees.Element (C)));

   function Is_Unit_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Unit_Name'Class);
   function As_Unit_Name (C : Cursor) return Diana.Nodes.Unit_Name'Class
     is (Diana.Nodes.Unit_Name'Class (Trees.Element (C)));

   function Is_Label_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Label_Name'Class);
   function As_Label_Name (C : Cursor) return Diana.Nodes.Label_Name'Class
     is (Diana.Nodes.Label_Name'Class (Trees.Element (C)));

   function Is_Entry_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Entry_Name'Class);
   function As_Entry_Name (C : Cursor) return Diana.Nodes.Entry_Name'Class
     is (Diana.Nodes.Entry_Name'Class (Trees.Element (C)));

   function Is_Exception_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Exception_Name'Class);
   function As_Exception_Name (C : Cursor) return Diana.Nodes.Exception_Name'Class
     is (Diana.Nodes.Exception_Name'Class (Trees.Element (C)));

   function Is_Init_Object_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Init_Object_Name'Class);
   function As_Init_Object_Name (C : Cursor) return Diana.Nodes.Init_Object_Name'Class
     is (Diana.Nodes.Init_Object_Name'Class (Trees.Element (C)));

   function Is_Iteration_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Iteration_Name'Class);
   function As_Iteration_Name (C : Cursor) return Diana.Nodes.Iteration_Name'Class
     is (Diana.Nodes.Iteration_Name'Class (Trees.Element (C)));

   function Is_Variable_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Variable_Name'Class);
   function As_Variable_Name (C : Cursor) return Diana.Nodes.Variable_Name'Class
     is (Diana.Nodes.Variable_Name'Class (Trees.Element (C)));

   function Is_Constant_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Constant_Name'Class);
   function As_Constant_Name (C : Cursor) return Diana.Nodes.Constant_Name'Class
     is (Diana.Nodes.Constant_Name'Class (Trees.Element (C)));

   function Is_Number_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Number_Name'Class);
   function As_Number_Name (C : Cursor) return Diana.Nodes.Number_Name'Class
     is (Diana.Nodes.Number_Name'Class (Trees.Element (C)));

   function Is_Component_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Component_Name'Class);
   function As_Component_Name (C : Cursor) return Diana.Nodes.Component_Name'Class
     is (Diana.Nodes.Component_Name'Class (Trees.Element (C)));

   function Is_Discriminant_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discriminant_Name'Class);
   function As_Discriminant_Name (C : Cursor) return Diana.Nodes.Discriminant_Name'Class
     is (Diana.Nodes.Discriminant_Name'Class (Trees.Element (C)));

   function Is_Parameter_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parameter_Name'Class);
   function As_Parameter_Name (C : Cursor) return Diana.Nodes.Parameter_Name'Class
     is (Diana.Nodes.Parameter_Name'Class (Trees.Element (C)));

   function Is_Full_Type_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Full_Type_Name'Class);
   function As_Full_Type_Name (C : Cursor) return Diana.Nodes.Full_Type_Name'Class
     is (Diana.Nodes.Full_Type_Name'Class (Trees.Element (C)));

   function Is_Subtype_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Subtype_Name'Class);
   function As_Subtype_Name (C : Cursor) return Diana.Nodes.Subtype_Name'Class
     is (Diana.Nodes.Subtype_Name'Class (Trees.Element (C)));

   function Is_Private_Type_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Private_Type_Name'Class);
   function As_Private_Type_Name (C : Cursor) return Diana.Nodes.Private_Type_Name'Class
     is (Diana.Nodes.Private_Type_Name'Class (Trees.Element (C)));

   function Is_Subprogram_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Subprogram_Name'Class);
   function As_Subprogram_Name (C : Cursor) return Diana.Nodes.Subprogram_Name'Class
     is (Diana.Nodes.Subprogram_Name'Class (Trees.Element (C)));

   function Is_Package_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Package_Name'Class);
   function As_Package_Name (C : Cursor) return Diana.Nodes.Package_Name'Class
     is (Diana.Nodes.Package_Name'Class (Trees.Element (C)));

   function Is_Generic_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Name'Class);
   function As_Generic_Name (C : Cursor) return Diana.Nodes.Generic_Name'Class
     is (Diana.Nodes.Generic_Name'Class (Trees.Element (C)));

   function Is_Task_Body_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Task_Body_Name'Class);
   function As_Task_Body_Name (C : Cursor) return Diana.Nodes.Task_Body_Name'Class
     is (Diana.Nodes.Task_Body_Name'Class (Trees.Element (C)));

   function Is_Statement_Label_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Statement_Label_Name'Class);
   function As_Statement_Label_Name (C : Cursor) return Diana.Nodes.Statement_Label_Name'Class
     is (Diana.Nodes.Statement_Label_Name'Class (Trees.Element (C)));

   function Is_Loop_Block_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Loop_Block_Name'Class);
   function As_Loop_Block_Name (C : Cursor) return Diana.Nodes.Loop_Block_Name'Class
     is (Diana.Nodes.Loop_Block_Name'Class (Trees.Element (C)));

   function Is_Attribute_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Attribute_Name'Class);
   function As_Attribute_Name (C : Cursor) return Diana.Nodes.Attribute_Name'Class
     is (Diana.Nodes.Attribute_Name'Class (Trees.Element (C)));

   function Is_Pragma_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Pragma_Name'Class);
   function As_Pragma_Name (C : Cursor) return Diana.Nodes.Pragma_Name'Class
     is (Diana.Nodes.Pragma_Name'Class (Trees.Element (C)));

   function Is_Argument_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Argument_Name'Class);
   function As_Argument_Name (C : Cursor) return Diana.Nodes.Argument_Name'Class
     is (Diana.Nodes.Argument_Name'Class (Trees.Element (C)));

   function Is_Builtin_Operator_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Builtin_Operator_Name'Class);
   function As_Builtin_Operator_Name (C : Cursor) return Diana.Nodes.Builtin_Operator_Name'Class
     is (Diana.Nodes.Builtin_Operator_Name'Class (Trees.Element (C)));

   function Is_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Name'Class);
   function As_Name (C : Cursor) return Diana.Nodes.Name'Class
     is (Diana.Nodes.Name'Class (Trees.Element (C)));

   function Is_Numeric_Literal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Numeric_Literal'Class);
   function As_Numeric_Literal (C : Cursor) return Diana.Nodes.Numeric_Literal'Class
     is (Diana.Nodes.Numeric_Literal'Class (Trees.Element (C)));

   function Is_String_Literal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.String_Literal'Class);
   function As_String_Literal (C : Cursor) return Diana.Nodes.String_Literal'Class
     is (Diana.Nodes.String_Literal'Class (Trees.Element (C)));

   function Is_Null_Literal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Null_Literal'Class);
   function As_Null_Literal (C : Cursor) return Diana.Nodes.Null_Literal'Class
     is (Diana.Nodes.Null_Literal'Class (Trees.Element (C)));

   function Is_Aggregate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aggregate'Class);
   function As_Aggregate (C : Cursor) return Diana.Nodes.Aggregate'Class
     is (Diana.Nodes.Aggregate'Class (Trees.Element (C)));

   function Is_Delta_Aggregate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Delta_Aggregate'Class);
   function As_Delta_Aggregate (C : Cursor) return Diana.Nodes.Delta_Aggregate'Class
     is (Diana.Nodes.Delta_Aggregate'Class (Trees.Element (C)));

   function Is_Container_Aggregate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Container_Aggregate'Class);
   function As_Container_Aggregate (C : Cursor) return Diana.Nodes.Container_Aggregate'Class
     is (Diana.Nodes.Container_Aggregate'Class (Trees.Element (C)));

   function Is_Allocator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Allocator'Class);
   function As_Allocator (C : Cursor) return Diana.Nodes.Allocator'Class
     is (Diana.Nodes.Allocator'Class (Trees.Element (C)));

   function Is_Qualified_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Qualified_Expression'Class);
   function As_Qualified_Expression (C : Cursor) return Diana.Nodes.Qualified_Expression'Class
     is (Diana.Nodes.Qualified_Expression'Class (Trees.Element (C)));

   function Is_Type_Conversion (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Type_Conversion'Class);
   function As_Type_Conversion (C : Cursor) return Diana.Nodes.Type_Conversion'Class
     is (Diana.Nodes.Type_Conversion'Class (Trees.Element (C)));

   function Is_Parenthesized_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parenthesized_Expression'Class);
   function As_Parenthesized_Expression (C : Cursor) return Diana.Nodes.Parenthesized_Expression'Class
     is (Diana.Nodes.Parenthesized_Expression'Class (Trees.Element (C)));

   function Is_Short_Circuit (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Short_Circuit'Class);
   function As_Short_Circuit (C : Cursor) return Diana.Nodes.Short_Circuit'Class
     is (Diana.Nodes.Short_Circuit'Class (Trees.Element (C)));

   function Is_Membership (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Membership'Class);
   function As_Membership (C : Cursor) return Diana.Nodes.Membership'Class
     is (Diana.Nodes.Membership'Class (Trees.Element (C)));

   function Is_Conditional_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Conditional_Expression'Class);
   function As_Conditional_Expression (C : Cursor) return Diana.Nodes.Conditional_Expression'Class
     is (Diana.Nodes.Conditional_Expression'Class (Trees.Element (C)));

   function Is_Quantified_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Quantified_Expression'Class);
   function As_Quantified_Expression (C : Cursor) return Diana.Nodes.Quantified_Expression'Class
     is (Diana.Nodes.Quantified_Expression'Class (Trees.Element (C)));

   function Is_Declare_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Declare_Expression'Class);
   function As_Declare_Expression (C : Cursor) return Diana.Nodes.Declare_Expression'Class
     is (Diana.Nodes.Declare_Expression'Class (Trees.Element (C)));

   function Is_Reduction_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Reduction_Expression'Class);
   function As_Reduction_Expression (C : Cursor) return Diana.Nodes.Reduction_Expression'Class
     is (Diana.Nodes.Reduction_Expression'Class (Trees.Element (C)));

   function Is_Raise_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Raise_Expression'Class);
   function As_Raise_Expression (C : Cursor) return Diana.Nodes.Raise_Expression'Class
     is (Diana.Nodes.Raise_Expression'Class (Trees.Element (C)));

   function Is_Qualified_Allocator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Qualified_Allocator'Class);
   function As_Qualified_Allocator (C : Cursor) return Diana.Nodes.Qualified_Allocator'Class
     is (Diana.Nodes.Qualified_Allocator'Class (Trees.Element (C)));

   function Is_Subtype_Allocator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Subtype_Allocator'Class);
   function As_Subtype_Allocator (C : Cursor) return Diana.Nodes.Subtype_Allocator'Class
     is (Diana.Nodes.Subtype_Allocator'Class (Trees.Element (C)));

   function Is_Short_Circuit_Op (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Short_Circuit_Op'Class);
   function As_Short_Circuit_Op (C : Cursor) return Diana.Nodes.Short_Circuit_Op'Class
     is (Diana.Nodes.Short_Circuit_Op'Class (Trees.Element (C)));

   function Is_And_Then (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.And_Then'Class);
   function As_And_Then (C : Cursor) return Diana.Nodes.And_Then'Class
     is (Diana.Nodes.And_Then'Class (Trees.Element (C)));

   function Is_Or_Else (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Or_Else'Class);
   function As_Or_Else (C : Cursor) return Diana.Nodes.Or_Else'Class
     is (Diana.Nodes.Or_Else'Class (Trees.Element (C)));

   function Is_Membership_Choice (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Membership_Choice'Class);
   function As_Membership_Choice (C : Cursor) return Diana.Nodes.Membership_Choice'Class
     is (Diana.Nodes.Membership_Choice'Class (Trees.Element (C)));

   function Is_Membership_Value (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Membership_Value'Class);
   function As_Membership_Value (C : Cursor) return Diana.Nodes.Membership_Value'Class
     is (Diana.Nodes.Membership_Value'Class (Trees.Element (C)));

   function Is_Membership_Range (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Membership_Range'Class);
   function As_Membership_Range (C : Cursor) return Diana.Nodes.Membership_Range'Class
     is (Diana.Nodes.Membership_Range'Class (Trees.Element (C)));

   function Is_Membership_Subtype (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Membership_Subtype'Class);
   function As_Membership_Subtype (C : Cursor) return Diana.Nodes.Membership_Subtype'Class
     is (Diana.Nodes.Membership_Subtype'Class (Trees.Element (C)));

   function Is_Membership_Op (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Membership_Op'Class);
   function As_Membership_Op (C : Cursor) return Diana.Nodes.Membership_Op'Class
     is (Diana.Nodes.Membership_Op'Class (Trees.Element (C)));

   function Is_In_Set (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.In_Set'Class);
   function As_In_Set (C : Cursor) return Diana.Nodes.In_Set'Class
     is (Diana.Nodes.In_Set'Class (Trees.Element (C)));

   function Is_Not_In_Set (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Not_In_Set'Class);
   function As_Not_In_Set (C : Cursor) return Diana.Nodes.Not_In_Set'Class
     is (Diana.Nodes.Not_In_Set'Class (Trees.Element (C)));

   function Is_If_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.If_Expression'Class);
   function As_If_Expression (C : Cursor) return Diana.Nodes.If_Expression'Class
     is (Diana.Nodes.If_Expression'Class (Trees.Element (C)));

   function Is_Case_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Case_Expression'Class);
   function As_Case_Expression (C : Cursor) return Diana.Nodes.Case_Expression'Class
     is (Diana.Nodes.Case_Expression'Class (Trees.Element (C)));

   function Is_Expression_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Expression_Clause'Class);
   function As_Expression_Clause (C : Cursor) return Diana.Nodes.Expression_Clause'Class
     is (Diana.Nodes.Expression_Clause'Class (Trees.Element (C)));

   function Is_Expression_Alternative (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Expression_Alternative'Class);
   function As_Expression_Alternative (C : Cursor) return Diana.Nodes.Expression_Alternative'Class
     is (Diana.Nodes.Expression_Alternative'Class (Trees.Element (C)));

   function Is_Quantifier_Kind (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Quantifier_Kind'Class);
   function As_Quantifier_Kind (C : Cursor) return Diana.Nodes.Quantifier_Kind'Class
     is (Diana.Nodes.Quantifier_Kind'Class (Trees.Element (C)));

   function Is_For_All (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.For_All'Class);
   function As_For_All (C : Cursor) return Diana.Nodes.For_All'Class
     is (Diana.Nodes.For_All'Class (Trees.Element (C)));

   function Is_For_Some (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.For_Some'Class);
   function As_For_Some (C : Cursor) return Diana.Nodes.For_Some'Class
     is (Diana.Nodes.For_Some'Class (Trees.Element (C)));

   function Is_Iterator_Specification (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Iterator_Specification'Class);
   function As_Iterator_Specification (C : Cursor) return Diana.Nodes.Iterator_Specification'Class
     is (Diana.Nodes.Iterator_Specification'Class (Trees.Element (C)));

   function Is_Range_Iterator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Range_Iterator'Class);
   function As_Range_Iterator (C : Cursor) return Diana.Nodes.Range_Iterator'Class
     is (Diana.Nodes.Range_Iterator'Class (Trees.Element (C)));

   function Is_Container_Iterator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Container_Iterator'Class);
   function As_Container_Iterator (C : Cursor) return Diana.Nodes.Container_Iterator'Class
     is (Diana.Nodes.Container_Iterator'Class (Trees.Element (C)));

   function Is_Selector_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Selector_Name'Class);
   function As_Selector_Name (C : Cursor) return Diana.Nodes.Selector_Name'Class
     is (Diana.Nodes.Selector_Name'Class (Trees.Element (C)));

   function Is_Used_Object (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Used_Object'Class);
   function As_Used_Object (C : Cursor) return Diana.Nodes.Used_Object'Class
     is (Diana.Nodes.Used_Object'Class (Trees.Element (C)));

   function Is_Used_Builtin (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Used_Builtin'Class);
   function As_Used_Builtin (C : Cursor) return Diana.Nodes.Used_Builtin'Class
     is (Diana.Nodes.Used_Builtin'Class (Trees.Element (C)));

   function Is_Indexed_Component (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Indexed_Component'Class);
   function As_Indexed_Component (C : Cursor) return Diana.Nodes.Indexed_Component'Class
     is (Diana.Nodes.Indexed_Component'Class (Trees.Element (C)));

   function Is_Slice (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Slice'Class);
   function As_Slice (C : Cursor) return Diana.Nodes.Slice'Class
     is (Diana.Nodes.Slice'Class (Trees.Element (C)));

   function Is_Selected_Component (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Selected_Component'Class);
   function As_Selected_Component (C : Cursor) return Diana.Nodes.Selected_Component'Class
     is (Diana.Nodes.Selected_Component'Class (Trees.Element (C)));

   function Is_Dereference (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Dereference'Class);
   function As_Dereference (C : Cursor) return Diana.Nodes.Dereference'Class
     is (Diana.Nodes.Dereference'Class (Trees.Element (C)));

   function Is_Attribute_Reference (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Attribute_Reference'Class);
   function As_Attribute_Reference (C : Cursor) return Diana.Nodes.Attribute_Reference'Class
     is (Diana.Nodes.Attribute_Reference'Class (Trees.Element (C)));

   function Is_Attribute_Call (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Attribute_Call'Class);
   function As_Attribute_Call (C : Cursor) return Diana.Nodes.Attribute_Call'Class
     is (Diana.Nodes.Attribute_Call'Class (Trees.Element (C)));

   function Is_Function_Call (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Function_Call'Class);
   function As_Function_Call (C : Cursor) return Diana.Nodes.Function_Call'Class
     is (Diana.Nodes.Function_Call'Class (Trees.Element (C)));

   function Is_Target_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Target_Name'Class);
   function As_Target_Name (C : Cursor) return Diana.Nodes.Target_Name'Class
     is (Diana.Nodes.Target_Name'Class (Trees.Element (C)));

   function Is_Used_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Used_Name'Class);
   function As_Used_Name (C : Cursor) return Diana.Nodes.Used_Name'Class
     is (Diana.Nodes.Used_Name'Class (Trees.Element (C)));

   function Is_Used_Character (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Used_Character'Class);
   function As_Used_Character (C : Cursor) return Diana.Nodes.Used_Character'Class
     is (Diana.Nodes.Used_Character'Class (Trees.Element (C)));

   function Is_Used_Operator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Used_Operator'Class);
   function As_Used_Operator (C : Cursor) return Diana.Nodes.Used_Operator'Class
     is (Diana.Nodes.Used_Operator'Class (Trees.Element (C)));

   function Is_Positional_Association (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Positional_Association'Class);
   function As_Positional_Association (C : Cursor) return Diana.Nodes.Positional_Association'Class
     is (Diana.Nodes.Positional_Association'Class (Trees.Element (C)));

   function Is_Named_Association (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Named_Association'Class);
   function As_Named_Association (C : Cursor) return Diana.Nodes.Named_Association'Class
     is (Diana.Nodes.Named_Association'Class (Trees.Element (C)));

   function Is_Iterated_Association (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Iterated_Association'Class);
   function As_Iterated_Association (C : Cursor) return Diana.Nodes.Iterated_Association'Class
     is (Diana.Nodes.Iterated_Association'Class (Trees.Element (C)));

   function Is_Null_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Null_Statement'Class);
   function As_Null_Statement (C : Cursor) return Diana.Nodes.Null_Statement'Class
     is (Diana.Nodes.Null_Statement'Class (Trees.Element (C)));

   function Is_Assignment (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Assignment'Class);
   function As_Assignment (C : Cursor) return Diana.Nodes.Assignment'Class
     is (Diana.Nodes.Assignment'Class (Trees.Element (C)));

   function Is_Procedure_Call (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Procedure_Call'Class);
   function As_Procedure_Call (C : Cursor) return Diana.Nodes.Procedure_Call'Class
     is (Diana.Nodes.Procedure_Call'Class (Trees.Element (C)));

   function Is_Exit_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Exit_Statement'Class);
   function As_Exit_Statement (C : Cursor) return Diana.Nodes.Exit_Statement'Class
     is (Diana.Nodes.Exit_Statement'Class (Trees.Element (C)));

   function Is_Return_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Return_Statement'Class);
   function As_Return_Statement (C : Cursor) return Diana.Nodes.Return_Statement'Class
     is (Diana.Nodes.Return_Statement'Class (Trees.Element (C)));

   function Is_Goto_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Goto_Statement'Class);
   function As_Goto_Statement (C : Cursor) return Diana.Nodes.Goto_Statement'Class
     is (Diana.Nodes.Goto_Statement'Class (Trees.Element (C)));

   function Is_If_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.If_Statement'Class);
   function As_If_Statement (C : Cursor) return Diana.Nodes.If_Statement'Class
     is (Diana.Nodes.If_Statement'Class (Trees.Element (C)));

   function Is_Case_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Case_Statement'Class);
   function As_Case_Statement (C : Cursor) return Diana.Nodes.Case_Statement'Class
     is (Diana.Nodes.Case_Statement'Class (Trees.Element (C)));

   function Is_Loop_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Loop_Statement'Class);
   function As_Loop_Statement (C : Cursor) return Diana.Nodes.Loop_Statement'Class
     is (Diana.Nodes.Loop_Statement'Class (Trees.Element (C)));

   function Is_Block_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Block_Statement'Class);
   function As_Block_Statement (C : Cursor) return Diana.Nodes.Block_Statement'Class
     is (Diana.Nodes.Block_Statement'Class (Trees.Element (C)));

   function Is_Labeled_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Labeled_Statement'Class);
   function As_Labeled_Statement (C : Cursor) return Diana.Nodes.Labeled_Statement'Class
     is (Diana.Nodes.Labeled_Statement'Class (Trees.Element (C)));

   function Is_Raise_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Raise_Statement'Class);
   function As_Raise_Statement (C : Cursor) return Diana.Nodes.Raise_Statement'Class
     is (Diana.Nodes.Raise_Statement'Class (Trees.Element (C)));

   function Is_Delay_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Delay_Statement'Class);
   function As_Delay_Statement (C : Cursor) return Diana.Nodes.Delay_Statement'Class
     is (Diana.Nodes.Delay_Statement'Class (Trees.Element (C)));

   function Is_Accept_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Accept_Statement'Class);
   function As_Accept_Statement (C : Cursor) return Diana.Nodes.Accept_Statement'Class
     is (Diana.Nodes.Accept_Statement'Class (Trees.Element (C)));

   function Is_Entry_Call (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Entry_Call'Class);
   function As_Entry_Call (C : Cursor) return Diana.Nodes.Entry_Call'Class
     is (Diana.Nodes.Entry_Call'Class (Trees.Element (C)));

   function Is_Requeue_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Requeue_Statement'Class);
   function As_Requeue_Statement (C : Cursor) return Diana.Nodes.Requeue_Statement'Class
     is (Diana.Nodes.Requeue_Statement'Class (Trees.Element (C)));

   function Is_Select_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Select_Statement'Class);
   function As_Select_Statement (C : Cursor) return Diana.Nodes.Select_Statement'Class
     is (Diana.Nodes.Select_Statement'Class (Trees.Element (C)));

   function Is_Abort_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Abort_Statement'Class);
   function As_Abort_Statement (C : Cursor) return Diana.Nodes.Abort_Statement'Class
     is (Diana.Nodes.Abort_Statement'Class (Trees.Element (C)));

   function Is_Parallel_Block (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parallel_Block'Class);
   function As_Parallel_Block (C : Cursor) return Diana.Nodes.Parallel_Block'Class
     is (Diana.Nodes.Parallel_Block'Class (Trees.Element (C)));

   function Is_Statement_Pragma (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Statement_Pragma'Class);
   function As_Statement_Pragma (C : Cursor) return Diana.Nodes.Statement_Pragma'Class
     is (Diana.Nodes.Statement_Pragma'Class (Trees.Element (C)));

   function Is_Conditional_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Conditional_Clause'Class);
   function As_Conditional_Clause (C : Cursor) return Diana.Nodes.Conditional_Clause'Class
     is (Diana.Nodes.Conditional_Clause'Class (Trees.Element (C)));

   function Is_Alternative (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Alternative'Class);
   function As_Alternative (C : Cursor) return Diana.Nodes.Alternative'Class
     is (Diana.Nodes.Alternative'Class (Trees.Element (C)));

   function Is_Case_Alternative (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Case_Alternative'Class);
   function As_Case_Alternative (C : Cursor) return Diana.Nodes.Case_Alternative'Class
     is (Diana.Nodes.Case_Alternative'Class (Trees.Element (C)));

   function Is_Alternative_Pragma (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Alternative_Pragma'Class);
   function As_Alternative_Pragma (C : Cursor) return Diana.Nodes.Alternative_Pragma'Class
     is (Diana.Nodes.Alternative_Pragma'Class (Trees.Element (C)));

   function Is_Exception_Handler (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Exception_Handler'Class);
   function As_Exception_Handler (C : Cursor) return Diana.Nodes.Exception_Handler'Class
     is (Diana.Nodes.Exception_Handler'Class (Trees.Element (C)));

   function Is_Iteration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Iteration'Class);
   function As_Iteration (C : Cursor) return Diana.Nodes.Iteration'Class
     is (Diana.Nodes.Iteration'Class (Trees.Element (C)));

   function Is_No_Iteration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.No_Iteration'Class);
   function As_No_Iteration (C : Cursor) return Diana.Nodes.No_Iteration'Class
     is (Diana.Nodes.No_Iteration'Class (Trees.Element (C)));

   function Is_While_Loop (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.While_Loop'Class);
   function As_While_Loop (C : Cursor) return Diana.Nodes.While_Loop'Class
     is (Diana.Nodes.While_Loop'Class (Trees.Element (C)));

   function Is_For_Loop (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.For_Loop'Class);
   function As_For_Loop (C : Cursor) return Diana.Nodes.For_Loop'Class
     is (Diana.Nodes.For_Loop'Class (Trees.Element (C)));

   function Is_Parallel_Specification (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parallel_Specification'Class);
   function As_Parallel_Specification (C : Cursor) return Diana.Nodes.Parallel_Specification'Class
     is (Diana.Nodes.Parallel_Specification'Class (Trees.Element (C)));

   function Is_Sequential (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Sequential'Class);
   function As_Sequential (C : Cursor) return Diana.Nodes.Sequential'Class
     is (Diana.Nodes.Sequential'Class (Trees.Element (C)));

   function Is_Parallel_Chunked (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parallel_Chunked'Class);
   function As_Parallel_Chunked (C : Cursor) return Diana.Nodes.Parallel_Chunked'Class
     is (Diana.Nodes.Parallel_Chunked'Class (Trees.Element (C)));

   function Is_Selective_Accept (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Selective_Accept'Class);
   function As_Selective_Accept (C : Cursor) return Diana.Nodes.Selective_Accept'Class
     is (Diana.Nodes.Selective_Accept'Class (Trees.Element (C)));

   function Is_Conditional_Entry_Call (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Conditional_Entry_Call'Class);
   function As_Conditional_Entry_Call (C : Cursor) return Diana.Nodes.Conditional_Entry_Call'Class
     is (Diana.Nodes.Conditional_Entry_Call'Class (Trees.Element (C)));

   function Is_Timed_Entry_Call (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Timed_Entry_Call'Class);
   function As_Timed_Entry_Call (C : Cursor) return Diana.Nodes.Timed_Entry_Call'Class
     is (Diana.Nodes.Timed_Entry_Call'Class (Trees.Element (C)));

   function Is_Asynchronous_Select (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Asynchronous_Select'Class);
   function As_Asynchronous_Select (C : Cursor) return Diana.Nodes.Asynchronous_Select'Class
     is (Diana.Nodes.Asynchronous_Select'Class (Trees.Element (C)));

   function Is_Select_Alternative (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Select_Alternative'Class);
   function As_Select_Alternative (C : Cursor) return Diana.Nodes.Select_Alternative'Class
     is (Diana.Nodes.Select_Alternative'Class (Trees.Element (C)));

   function Is_Accept_Alternative (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Accept_Alternative'Class);
   function As_Accept_Alternative (C : Cursor) return Diana.Nodes.Accept_Alternative'Class
     is (Diana.Nodes.Accept_Alternative'Class (Trees.Element (C)));

   function Is_Delay_Alternative (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Delay_Alternative'Class);
   function As_Delay_Alternative (C : Cursor) return Diana.Nodes.Delay_Alternative'Class
     is (Diana.Nodes.Delay_Alternative'Class (Trees.Element (C)));

   function Is_Terminate_Alternative (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Terminate_Alternative'Class);
   function As_Terminate_Alternative (C : Cursor) return Diana.Nodes.Terminate_Alternative'Class
     is (Diana.Nodes.Terminate_Alternative'Class (Trees.Element (C)));

   function Is_Select_Alternative_Pragma (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Select_Alternative_Pragma'Class);
   function As_Select_Alternative_Pragma (C : Cursor) return Diana.Nodes.Select_Alternative_Pragma'Class
     is (Diana.Nodes.Select_Alternative_Pragma'Class (Trees.Element (C)));

   function Is_Parallel_Arm (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parallel_Arm'Class);
   function As_Parallel_Arm (C : Cursor) return Diana.Nodes.Parallel_Arm'Class
     is (Diana.Nodes.Parallel_Arm'Class (Trees.Element (C)));

   function Is_Scalar_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Scalar_Type'Class);
   function As_Scalar_Type (C : Cursor) return Diana.Nodes.Scalar_Type'Class
     is (Diana.Nodes.Scalar_Type'Class (Trees.Element (C)));

   function Is_Access_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Access_Type'Class);
   function As_Access_Type (C : Cursor) return Diana.Nodes.Access_Type'Class
     is (Diana.Nodes.Access_Type'Class (Trees.Element (C)));

   function Is_Composite_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Composite_Type'Class);
   function As_Composite_Type (C : Cursor) return Diana.Nodes.Composite_Type'Class
     is (Diana.Nodes.Composite_Type'Class (Trees.Element (C)));

   function Is_Derived_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Derived_Type'Class);
   function As_Derived_Type (C : Cursor) return Diana.Nodes.Derived_Type'Class
     is (Diana.Nodes.Derived_Type'Class (Trees.Element (C)));

   function Is_Class_Wide_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Class_Wide_Type'Class);
   function As_Class_Wide_Type (C : Cursor) return Diana.Nodes.Class_Wide_Type'Class
     is (Diana.Nodes.Class_Wide_Type'Class (Trees.Element (C)));

   function Is_Private_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Private_Type'Class);
   function As_Private_Type (C : Cursor) return Diana.Nodes.Private_Type'Class
     is (Diana.Nodes.Private_Type'Class (Trees.Element (C)));

   function Is_Incomplete_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Incomplete_Type'Class);
   function As_Incomplete_Type (C : Cursor) return Diana.Nodes.Incomplete_Type'Class
     is (Diana.Nodes.Incomplete_Type'Class (Trees.Element (C)));

   function Is_Generic_Formal_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Formal_Type'Class);
   function As_Generic_Formal_Type (C : Cursor) return Diana.Nodes.Generic_Formal_Type'Class
     is (Diana.Nodes.Generic_Formal_Type'Class (Trees.Element (C)));

   function Is_Constrained_Spec (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Constrained_Spec'Class);
   function As_Constrained_Spec (C : Cursor) return Diana.Nodes.Constrained_Spec'Class
     is (Diana.Nodes.Constrained_Spec'Class (Trees.Element (C)));

   function Is_Universal_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Universal_Type'Class);
   function As_Universal_Type (C : Cursor) return Diana.Nodes.Universal_Type'Class
     is (Diana.Nodes.Universal_Type'Class (Trees.Element (C)));

   function Is_Void (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Void'Class);
   function As_Void (C : Cursor) return Diana.Nodes.Void'Class
     is (Diana.Nodes.Void'Class (Trees.Element (C)));

   function Is_Universal_Integer (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Universal_Integer'Class);
   function As_Universal_Integer (C : Cursor) return Diana.Nodes.Universal_Integer'Class
     is (Diana.Nodes.Universal_Integer'Class (Trees.Element (C)));

   function Is_Universal_Real (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Universal_Real'Class);
   function As_Universal_Real (C : Cursor) return Diana.Nodes.Universal_Real'Class
     is (Diana.Nodes.Universal_Real'Class (Trees.Element (C)));

   function Is_Universal_Fixed (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Universal_Fixed'Class);
   function As_Universal_Fixed (C : Cursor) return Diana.Nodes.Universal_Fixed'Class
     is (Diana.Nodes.Universal_Fixed'Class (Trees.Element (C)));

   function Is_Discrete_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discrete_Type'Class);
   function As_Discrete_Type (C : Cursor) return Diana.Nodes.Discrete_Type'Class
     is (Diana.Nodes.Discrete_Type'Class (Trees.Element (C)));

   function Is_Real_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Real_Type'Class);
   function As_Real_Type (C : Cursor) return Diana.Nodes.Real_Type'Class
     is (Diana.Nodes.Real_Type'Class (Trees.Element (C)));

   function Is_Enumeration_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Enumeration_Type'Class);
   function As_Enumeration_Type (C : Cursor) return Diana.Nodes.Enumeration_Type'Class
     is (Diana.Nodes.Enumeration_Type'Class (Trees.Element (C)));

   function Is_Integer_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Integer_Type'Class);
   function As_Integer_Type (C : Cursor) return Diana.Nodes.Integer_Type'Class
     is (Diana.Nodes.Integer_Type'Class (Trees.Element (C)));

   function Is_Signed_Integer_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Signed_Integer_Type'Class);
   function As_Signed_Integer_Type (C : Cursor) return Diana.Nodes.Signed_Integer_Type'Class
     is (Diana.Nodes.Signed_Integer_Type'Class (Trees.Element (C)));

   function Is_Modular_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Modular_Type'Class);
   function As_Modular_Type (C : Cursor) return Diana.Nodes.Modular_Type'Class
     is (Diana.Nodes.Modular_Type'Class (Trees.Element (C)));

   function Is_Floating_Point_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Floating_Point_Type'Class);
   function As_Floating_Point_Type (C : Cursor) return Diana.Nodes.Floating_Point_Type'Class
     is (Diana.Nodes.Floating_Point_Type'Class (Trees.Element (C)));

   function Is_Fixed_Point_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Fixed_Point_Type'Class);
   function As_Fixed_Point_Type (C : Cursor) return Diana.Nodes.Fixed_Point_Type'Class
     is (Diana.Nodes.Fixed_Point_Type'Class (Trees.Element (C)));

   function Is_Ordinary_Fixed_Point_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Ordinary_Fixed_Point_Type'Class);
   function As_Ordinary_Fixed_Point_Type (C : Cursor) return Diana.Nodes.Ordinary_Fixed_Point_Type'Class
     is (Diana.Nodes.Ordinary_Fixed_Point_Type'Class (Trees.Element (C)));

   function Is_Decimal_Fixed_Point_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Decimal_Fixed_Point_Type'Class);
   function As_Decimal_Fixed_Point_Type (C : Cursor) return Diana.Nodes.Decimal_Fixed_Point_Type'Class
     is (Diana.Nodes.Decimal_Fixed_Point_Type'Class (Trees.Element (C)));

   function Is_Access_To_Object (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Access_To_Object'Class);
   function As_Access_To_Object (C : Cursor) return Diana.Nodes.Access_To_Object'Class
     is (Diana.Nodes.Access_To_Object'Class (Trees.Element (C)));

   function Is_Access_To_Subprogram (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Access_To_Subprogram'Class);
   function As_Access_To_Subprogram (C : Cursor) return Diana.Nodes.Access_To_Subprogram'Class
     is (Diana.Nodes.Access_To_Subprogram'Class (Trees.Element (C)));

   function Is_Object_Access_Kind (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Object_Access_Kind'Class);
   function As_Object_Access_Kind (C : Cursor) return Diana.Nodes.Object_Access_Kind'Class
     is (Diana.Nodes.Object_Access_Kind'Class (Trees.Element (C)));

   function Is_Pool_Specific (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Pool_Specific'Class);
   function As_Pool_Specific (C : Cursor) return Diana.Nodes.Pool_Specific'Class
     is (Diana.Nodes.Pool_Specific'Class (Trees.Element (C)));

   function Is_General_Access_All (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.General_Access_All'Class);
   function As_General_Access_All (C : Cursor) return Diana.Nodes.General_Access_All'Class
     is (Diana.Nodes.General_Access_All'Class (Trees.Element (C)));

   function Is_General_Access_Constant (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.General_Access_Constant'Class);
   function As_General_Access_Constant (C : Cursor) return Diana.Nodes.General_Access_Constant'Class
     is (Diana.Nodes.General_Access_Constant'Class (Trees.Element (C)));

   function Is_Array_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Array_Type'Class);
   function As_Array_Type (C : Cursor) return Diana.Nodes.Array_Type'Class
     is (Diana.Nodes.Array_Type'Class (Trees.Element (C)));

   function Is_Record_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Record_Type'Class);
   function As_Record_Type (C : Cursor) return Diana.Nodes.Record_Type'Class
     is (Diana.Nodes.Record_Type'Class (Trees.Element (C)));

   function Is_Tagged_Record_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Tagged_Record_Type'Class);
   function As_Tagged_Record_Type (C : Cursor) return Diana.Nodes.Tagged_Record_Type'Class
     is (Diana.Nodes.Tagged_Record_Type'Class (Trees.Element (C)));

   function Is_Interface_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Interface_Type'Class);
   function As_Interface_Type (C : Cursor) return Diana.Nodes.Interface_Type'Class
     is (Diana.Nodes.Interface_Type'Class (Trees.Element (C)));

   function Is_Task_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Task_Type'Class);
   function As_Task_Type (C : Cursor) return Diana.Nodes.Task_Type'Class
     is (Diana.Nodes.Task_Type'Class (Trees.Element (C)));

   function Is_Protected_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Protected_Type'Class);
   function As_Protected_Type (C : Cursor) return Diana.Nodes.Protected_Type'Class
     is (Diana.Nodes.Protected_Type'Class (Trees.Element (C)));

   function Is_Interface_Kind (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Interface_Kind'Class);
   function As_Interface_Kind (C : Cursor) return Diana.Nodes.Interface_Kind'Class
     is (Diana.Nodes.Interface_Kind'Class (Trees.Element (C)));

   function Is_Ordinary_Interface (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Ordinary_Interface'Class);
   function As_Ordinary_Interface (C : Cursor) return Diana.Nodes.Ordinary_Interface'Class
     is (Diana.Nodes.Ordinary_Interface'Class (Trees.Element (C)));

   function Is_Limited_Interface (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Limited_Interface'Class);
   function As_Limited_Interface (C : Cursor) return Diana.Nodes.Limited_Interface'Class
     is (Diana.Nodes.Limited_Interface'Class (Trees.Element (C)));

   function Is_Synchronized_Interface (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Synchronized_Interface'Class);
   function As_Synchronized_Interface (C : Cursor) return Diana.Nodes.Synchronized_Interface'Class
     is (Diana.Nodes.Synchronized_Interface'Class (Trees.Element (C)));

   function Is_Task_Interface (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Task_Interface'Class);
   function As_Task_Interface (C : Cursor) return Diana.Nodes.Task_Interface'Class
     is (Diana.Nodes.Task_Interface'Class (Trees.Element (C)));

   function Is_Protected_Interface (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Protected_Interface'Class);
   function As_Protected_Interface (C : Cursor) return Diana.Nodes.Protected_Interface'Class
     is (Diana.Nodes.Protected_Interface'Class (Trees.Element (C)));

   function Is_Protected_Definition (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Protected_Definition'Class);
   function As_Protected_Definition (C : Cursor) return Diana.Nodes.Protected_Definition'Class
     is (Diana.Nodes.Protected_Definition'Class (Trees.Element (C)));

   function Is_Protected_Specification (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Protected_Specification'Class);
   function As_Protected_Specification (C : Cursor) return Diana.Nodes.Protected_Specification'Class
     is (Diana.Nodes.Protected_Specification'Class (Trees.Element (C)));

   function Is_Component (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Component'Class);
   function As_Component (C : Cursor) return Diana.Nodes.Component'Class
     is (Diana.Nodes.Component'Class (Trees.Element (C)));

   function Is_Component_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Component_Declaration'Class);
   function As_Component_Declaration (C : Cursor) return Diana.Nodes.Component_Declaration'Class
     is (Diana.Nodes.Component_Declaration'Class (Trees.Element (C)));

   function Is_Variant_Part (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Variant_Part'Class);
   function As_Variant_Part (C : Cursor) return Diana.Nodes.Variant_Part'Class
     is (Diana.Nodes.Variant_Part'Class (Trees.Element (C)));

   function Is_Null_Component (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Null_Component'Class);
   function As_Null_Component (C : Cursor) return Diana.Nodes.Null_Component'Class
     is (Diana.Nodes.Null_Component'Class (Trees.Element (C)));

   function Is_Component_Pragma (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Component_Pragma'Class);
   function As_Component_Pragma (C : Cursor) return Diana.Nodes.Component_Pragma'Class
     is (Diana.Nodes.Component_Pragma'Class (Trees.Element (C)));

   function Is_Variant (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Variant'Class);
   function As_Variant (C : Cursor) return Diana.Nodes.Variant'Class
     is (Diana.Nodes.Variant'Class (Trees.Element (C)));

   function Is_Discriminant_Part (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discriminant_Part'Class);
   function As_Discriminant_Part (C : Cursor) return Diana.Nodes.Discriminant_Part'Class
     is (Diana.Nodes.Discriminant_Part'Class (Trees.Element (C)));

   function Is_Discriminant_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discriminant_S'Class);
   function As_Discriminant_S (C : Cursor) return Diana.Nodes.Discriminant_S'Class
     is (Diana.Nodes.Discriminant_S'Class (Trees.Element (C)));

   function Is_Discrete_Range (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discrete_Range'Class);
   function As_Discrete_Range (C : Cursor) return Diana.Nodes.Discrete_Range'Class
     is (Diana.Nodes.Discrete_Range'Class (Trees.Element (C)));

   function Is_Index_Constraint (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Index_Constraint'Class);
   function As_Index_Constraint (C : Cursor) return Diana.Nodes.Index_Constraint'Class
     is (Diana.Nodes.Index_Constraint'Class (Trees.Element (C)));

   function Is_Real_Constraint (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Real_Constraint'Class);
   function As_Real_Constraint (C : Cursor) return Diana.Nodes.Real_Constraint'Class
     is (Diana.Nodes.Real_Constraint'Class (Trees.Element (C)));

   function Is_Discriminant_Constraint (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discriminant_Constraint'Class);
   function As_Discriminant_Constraint (C : Cursor) return Diana.Nodes.Discriminant_Constraint'Class
     is (Diana.Nodes.Discriminant_Constraint'Class (Trees.Element (C)));

   function Is_Scalar_Range (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Scalar_Range'Class);
   function As_Scalar_Range (C : Cursor) return Diana.Nodes.Scalar_Range'Class
     is (Diana.Nodes.Scalar_Range'Class (Trees.Element (C)));

   function Is_Discrete_Subtype (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discrete_Subtype'Class);
   function As_Discrete_Subtype (C : Cursor) return Diana.Nodes.Discrete_Subtype'Class
     is (Diana.Nodes.Discrete_Subtype'Class (Trees.Element (C)));

   function Is_Range_Bounds (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Range_Bounds'Class);
   function As_Range_Bounds (C : Cursor) return Diana.Nodes.Range_Bounds'Class
     is (Diana.Nodes.Range_Bounds'Class (Trees.Element (C)));

   function Is_Range_Attribute (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Range_Attribute'Class);
   function As_Range_Attribute (C : Cursor) return Diana.Nodes.Range_Attribute'Class
     is (Diana.Nodes.Range_Attribute'Class (Trees.Element (C)));

   function Is_Float_Constraint (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Float_Constraint'Class);
   function As_Float_Constraint (C : Cursor) return Diana.Nodes.Float_Constraint'Class
     is (Diana.Nodes.Float_Constraint'Class (Trees.Element (C)));

   function Is_Fixed_Constraint (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Fixed_Constraint'Class);
   function As_Fixed_Constraint (C : Cursor) return Diana.Nodes.Fixed_Constraint'Class
     is (Diana.Nodes.Fixed_Constraint'Class (Trees.Element (C)));

   function Is_Procedure_Header (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Procedure_Header'Class);
   function As_Procedure_Header (C : Cursor) return Diana.Nodes.Procedure_Header'Class
     is (Diana.Nodes.Procedure_Header'Class (Trees.Element (C)));

   function Is_Function_Header (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Function_Header'Class);
   function As_Function_Header (C : Cursor) return Diana.Nodes.Function_Header'Class
     is (Diana.Nodes.Function_Header'Class (Trees.Element (C)));

   function Is_Entry_Header (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Entry_Header'Class);
   function As_Entry_Header (C : Cursor) return Diana.Nodes.Entry_Header'Class
     is (Diana.Nodes.Entry_Header'Class (Trees.Element (C)));

   function Is_Parameter (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parameter'Class);
   function As_Parameter (C : Cursor) return Diana.Nodes.Parameter'Class
     is (Diana.Nodes.Parameter'Class (Trees.Element (C)));

   function Is_In_Parameter (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.In_Parameter'Class);
   function As_In_Parameter (C : Cursor) return Diana.Nodes.In_Parameter'Class
     is (Diana.Nodes.In_Parameter'Class (Trees.Element (C)));

   function Is_Out_Parameter (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Out_Parameter'Class);
   function As_Out_Parameter (C : Cursor) return Diana.Nodes.Out_Parameter'Class
     is (Diana.Nodes.Out_Parameter'Class (Trees.Element (C)));

   function Is_In_Out_Parameter (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.In_Out_Parameter'Class);
   function As_In_Out_Parameter (C : Cursor) return Diana.Nodes.In_Out_Parameter'Class
     is (Diana.Nodes.In_Out_Parameter'Class (Trees.Element (C)));

   function Is_Parameter_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parameter_Type'Class);
   function As_Parameter_Type (C : Cursor) return Diana.Nodes.Parameter_Type'Class
     is (Diana.Nodes.Parameter_Type'Class (Trees.Element (C)));

   function Is_Named_Subtype (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Named_Subtype'Class);
   function As_Named_Subtype (C : Cursor) return Diana.Nodes.Named_Subtype'Class
     is (Diana.Nodes.Named_Subtype'Class (Trees.Element (C)));

   function Is_Anonymous_Access (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Anonymous_Access'Class);
   function As_Anonymous_Access (C : Cursor) return Diana.Nodes.Anonymous_Access'Class
     is (Diana.Nodes.Anonymous_Access'Class (Trees.Element (C)));

   function Is_Package_Specification (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Package_Specification'Class);
   function As_Package_Specification (C : Cursor) return Diana.Nodes.Package_Specification'Class
     is (Diana.Nodes.Package_Specification'Class (Trees.Element (C)));

   function Is_Unit_Completion (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Unit_Completion'Class);
   function As_Unit_Completion (C : Cursor) return Diana.Nodes.Unit_Completion'Class
     is (Diana.Nodes.Unit_Completion'Class (Trees.Element (C)));

   function Is_Block (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Block'Class);
   function As_Block (C : Cursor) return Diana.Nodes.Block'Class
     is (Diana.Nodes.Block'Class (Trees.Element (C)));

   function Is_Stub (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Stub'Class);
   function As_Stub (C : Cursor) return Diana.Nodes.Stub'Class
     is (Diana.Nodes.Stub'Class (Trees.Element (C)));

   function Is_Unit_Instantiation (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Unit_Instantiation'Class);
   function As_Unit_Instantiation (C : Cursor) return Diana.Nodes.Unit_Instantiation'Class
     is (Diana.Nodes.Unit_Instantiation'Class (Trees.Element (C)));

   function Is_Unit_Renaming (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Unit_Renaming'Class);
   function As_Unit_Renaming (C : Cursor) return Diana.Nodes.Unit_Renaming'Class
     is (Diana.Nodes.Unit_Renaming'Class (Trees.Element (C)));

   function Is_Formal_Subprogram_Default (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Subprogram_Default'Class);
   function As_Formal_Subprogram_Default (C : Cursor) return Diana.Nodes.Formal_Subprogram_Default'Class
     is (Diana.Nodes.Formal_Subprogram_Default'Class (Trees.Element (C)));

   function Is_Language_Binding (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Language_Binding'Class);
   function As_Language_Binding (C : Cursor) return Diana.Nodes.Language_Binding'Class
     is (Diana.Nodes.Language_Binding'Class (Trees.Element (C)));

   function Is_Renaming (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Renaming'Class);
   function As_Renaming (C : Cursor) return Diana.Nodes.Renaming'Class
     is (Diana.Nodes.Renaming'Class (Trees.Element (C)));

   function Is_Task_Definition (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Task_Definition'Class);
   function As_Task_Definition (C : Cursor) return Diana.Nodes.Task_Definition'Class
     is (Diana.Nodes.Task_Definition'Class (Trees.Element (C)));

   function Is_Task_Specification (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Task_Specification'Class);
   function As_Task_Specification (C : Cursor) return Diana.Nodes.Task_Specification'Class
     is (Diana.Nodes.Task_Specification'Class (Trees.Element (C)));

   function Is_Entry_Index_Specification (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Entry_Index_Specification'Class);
   function As_Entry_Index_Specification (C : Cursor) return Diana.Nodes.Entry_Index_Specification'Class
     is (Diana.Nodes.Entry_Index_Specification'Class (Trees.Element (C)));

   function Is_Entry_Index_Definition (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Entry_Index_Definition'Class);
   function As_Entry_Index_Definition (C : Cursor) return Diana.Nodes.Entry_Index_Definition'Class
     is (Diana.Nodes.Entry_Index_Definition'Class (Trees.Element (C)));

   function Is_Generic_Header (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Header'Class);
   function As_Generic_Header (C : Cursor) return Diana.Nodes.Generic_Header'Class
     is (Diana.Nodes.Generic_Header'Class (Trees.Element (C)));

   function Is_Generic_Subprogram_Header (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Subprogram_Header'Class);
   function As_Generic_Subprogram_Header (C : Cursor) return Diana.Nodes.Generic_Subprogram_Header'Class
     is (Diana.Nodes.Generic_Subprogram_Header'Class (Trees.Element (C)));

   function Is_Generic_Formal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Formal'Class);
   function As_Generic_Formal (C : Cursor) return Diana.Nodes.Generic_Formal'Class
     is (Diana.Nodes.Generic_Formal'Class (Trees.Element (C)));

   function Is_Generic_Formal_Object (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Formal_Object'Class);
   function As_Generic_Formal_Object (C : Cursor) return Diana.Nodes.Generic_Formal_Object'Class
     is (Diana.Nodes.Generic_Formal_Object'Class (Trees.Element (C)));

   function Is_Generic_Formal_Type_Declaration (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Formal_Type_Declaration'Class);
   function As_Generic_Formal_Type_Declaration (C : Cursor) return Diana.Nodes.Generic_Formal_Type_Declaration'Class
     is (Diana.Nodes.Generic_Formal_Type_Declaration'Class (Trees.Element (C)));

   function Is_Generic_Formal_Subprogram (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Formal_Subprogram'Class);
   function As_Generic_Formal_Subprogram (C : Cursor) return Diana.Nodes.Generic_Formal_Subprogram'Class
     is (Diana.Nodes.Generic_Formal_Subprogram'Class (Trees.Element (C)));

   function Is_Generic_Formal_Package (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Formal_Package'Class);
   function As_Generic_Formal_Package (C : Cursor) return Diana.Nodes.Generic_Formal_Package'Class
     is (Diana.Nodes.Generic_Formal_Package'Class (Trees.Element (C)));

   function Is_Generic_Object_Mode (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Object_Mode'Class);
   function As_Generic_Object_Mode (C : Cursor) return Diana.Nodes.Generic_Object_Mode'Class
     is (Diana.Nodes.Generic_Object_Mode'Class (Trees.Element (C)));

   function Is_Generic_In (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_In'Class);
   function As_Generic_In (C : Cursor) return Diana.Nodes.Generic_In'Class
     is (Diana.Nodes.Generic_In'Class (Trees.Element (C)));

   function Is_Generic_In_Out (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_In_Out'Class);
   function As_Generic_In_Out (C : Cursor) return Diana.Nodes.Generic_In_Out'Class
     is (Diana.Nodes.Generic_In_Out'Class (Trees.Element (C)));

   function Is_Default_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Default_Name'Class);
   function As_Default_Name (C : Cursor) return Diana.Nodes.Default_Name'Class
     is (Diana.Nodes.Default_Name'Class (Trees.Element (C)));

   function Is_Box (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Box'Class);
   function As_Box (C : Cursor) return Diana.Nodes.Box'Class
     is (Diana.Nodes.Box'Class (Trees.Element (C)));

   function Is_No_Default (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.No_Default'Class);
   function As_No_Default (C : Cursor) return Diana.Nodes.No_Default'Class
     is (Diana.Nodes.No_Default'Class (Trees.Element (C)));

   function Is_Formal_Scalar_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Scalar_Type'Class);
   function As_Formal_Scalar_Type (C : Cursor) return Diana.Nodes.Formal_Scalar_Type'Class
     is (Diana.Nodes.Formal_Scalar_Type'Class (Trees.Element (C)));

   function Is_Formal_Access_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Access_Type'Class);
   function As_Formal_Access_Type (C : Cursor) return Diana.Nodes.Formal_Access_Type'Class
     is (Diana.Nodes.Formal_Access_Type'Class (Trees.Element (C)));

   function Is_Formal_Composite_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Composite_Type'Class);
   function As_Formal_Composite_Type (C : Cursor) return Diana.Nodes.Formal_Composite_Type'Class
     is (Diana.Nodes.Formal_Composite_Type'Class (Trees.Element (C)));

   function Is_Formal_Derived_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Derived_Type'Class);
   function As_Formal_Derived_Type (C : Cursor) return Diana.Nodes.Formal_Derived_Type'Class
     is (Diana.Nodes.Formal_Derived_Type'Class (Trees.Element (C)));

   function Is_Formal_Private_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Private_Type'Class);
   function As_Formal_Private_Type (C : Cursor) return Diana.Nodes.Formal_Private_Type'Class
     is (Diana.Nodes.Formal_Private_Type'Class (Trees.Element (C)));

   function Is_Formal_Incomplete_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Incomplete_Type'Class);
   function As_Formal_Incomplete_Type (C : Cursor) return Diana.Nodes.Formal_Incomplete_Type'Class
     is (Diana.Nodes.Formal_Incomplete_Type'Class (Trees.Element (C)));

   function Is_Formal_Discrete (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Discrete'Class);
   function As_Formal_Discrete (C : Cursor) return Diana.Nodes.Formal_Discrete'Class
     is (Diana.Nodes.Formal_Discrete'Class (Trees.Element (C)));

   function Is_Formal_Signed_Integer (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Signed_Integer'Class);
   function As_Formal_Signed_Integer (C : Cursor) return Diana.Nodes.Formal_Signed_Integer'Class
     is (Diana.Nodes.Formal_Signed_Integer'Class (Trees.Element (C)));

   function Is_Formal_Modular (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Modular'Class);
   function As_Formal_Modular (C : Cursor) return Diana.Nodes.Formal_Modular'Class
     is (Diana.Nodes.Formal_Modular'Class (Trees.Element (C)));

   function Is_Formal_Floating_Point (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Floating_Point'Class);
   function As_Formal_Floating_Point (C : Cursor) return Diana.Nodes.Formal_Floating_Point'Class
     is (Diana.Nodes.Formal_Floating_Point'Class (Trees.Element (C)));

   function Is_Formal_Ordinary_Fixed (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Ordinary_Fixed'Class);
   function As_Formal_Ordinary_Fixed (C : Cursor) return Diana.Nodes.Formal_Ordinary_Fixed'Class
     is (Diana.Nodes.Formal_Ordinary_Fixed'Class (Trees.Element (C)));

   function Is_Formal_Decimal_Fixed (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Decimal_Fixed'Class);
   function As_Formal_Decimal_Fixed (C : Cursor) return Diana.Nodes.Formal_Decimal_Fixed'Class
     is (Diana.Nodes.Formal_Decimal_Fixed'Class (Trees.Element (C)));

   function Is_Formal_Access_To_Object (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Access_To_Object'Class);
   function As_Formal_Access_To_Object (C : Cursor) return Diana.Nodes.Formal_Access_To_Object'Class
     is (Diana.Nodes.Formal_Access_To_Object'Class (Trees.Element (C)));

   function Is_Formal_Access_To_Subprogram (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Access_To_Subprogram'Class);
   function As_Formal_Access_To_Subprogram (C : Cursor) return Diana.Nodes.Formal_Access_To_Subprogram'Class
     is (Diana.Nodes.Formal_Access_To_Subprogram'Class (Trees.Element (C)));

   function Is_Formal_Array_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Array_Type'Class);
   function As_Formal_Array_Type (C : Cursor) return Diana.Nodes.Formal_Array_Type'Class
     is (Diana.Nodes.Formal_Array_Type'Class (Trees.Element (C)));

   function Is_Formal_Interface_Type (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Formal_Interface_Type'Class);
   function As_Formal_Interface_Type (C : Cursor) return Diana.Nodes.Formal_Interface_Type'Class
     is (Diana.Nodes.Formal_Interface_Type'Class (Trees.Element (C)));

   function Is_Property_Origin (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Property_Origin'Class);
   function As_Property_Origin (C : Cursor) return Diana.Nodes.Property_Origin'Class
     is (Diana.Nodes.Property_Origin'Class (Trees.Element (C)));

   function Is_From_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.From_Aspect'Class);
   function As_From_Aspect (C : Cursor) return Diana.Nodes.From_Aspect'Class
     is (Diana.Nodes.From_Aspect'Class (Trees.Element (C)));

   function Is_From_Attribute_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.From_Attribute_Clause'Class);
   function As_From_Attribute_Clause (C : Cursor) return Diana.Nodes.From_Attribute_Clause'Class
     is (Diana.Nodes.From_Attribute_Clause'Class (Trees.Element (C)));

   function Is_Property_Value (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Property_Value'Class);
   function As_Property_Value (C : Cursor) return Diana.Nodes.Property_Value'Class
     is (Diana.Nodes.Property_Value'Class (Trees.Element (C)));

   function Is_Aspect_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Expression'Class);
   function As_Aspect_Expression (C : Cursor) return Diana.Nodes.Aspect_Expression'Class
     is (Diana.Nodes.Aspect_Expression'Class (Trees.Element (C)));

   function Is_Contract_Case_List (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Contract_Case_List'Class);
   function As_Contract_Case_List (C : Cursor) return Diana.Nodes.Contract_Case_List'Class
     is (Diana.Nodes.Contract_Case_List'Class (Trees.Element (C)));

   function Is_Contract_Case (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Contract_Case'Class);
   function As_Contract_Case (C : Cursor) return Diana.Nodes.Contract_Case'Class
     is (Diana.Nodes.Contract_Case'Class (Trees.Element (C)));

   function Is_Property_Identity (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Property_Identity'Class);
   function As_Property_Identity (C : Cursor) return Diana.Nodes.Property_Identity'Class
     is (Diana.Nodes.Property_Identity'Class (Trees.Element (C)));

   function Is_Contract_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Contract_Aspect'Class);
   function As_Contract_Aspect (C : Cursor) return Diana.Nodes.Contract_Aspect'Class
     is (Diana.Nodes.Contract_Aspect'Class (Trees.Element (C)));

   function Is_Representation_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Representation_Aspect'Class);
   function As_Representation_Aspect (C : Cursor) return Diana.Nodes.Representation_Aspect'Class
     is (Diana.Nodes.Representation_Aspect'Class (Trees.Element (C)));

   function Is_Interfacing_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Interfacing_Aspect'Class);
   function As_Interfacing_Aspect (C : Cursor) return Diana.Nodes.Interfacing_Aspect'Class
     is (Diana.Nodes.Interfacing_Aspect'Class (Trees.Element (C)));

   function Is_Categorization_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Categorization_Aspect'Class);
   function As_Categorization_Aspect (C : Cursor) return Diana.Nodes.Categorization_Aspect'Class
     is (Diana.Nodes.Categorization_Aspect'Class (Trees.Element (C)));

   function Is_Concurrency_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Concurrency_Aspect'Class);
   function As_Concurrency_Aspect (C : Cursor) return Diana.Nodes.Concurrency_Aspect'Class
     is (Diana.Nodes.Concurrency_Aspect'Class (Trees.Element (C)));

   function Is_Iteration_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Iteration_Aspect'Class);
   function As_Iteration_Aspect (C : Cursor) return Diana.Nodes.Iteration_Aspect'Class
     is (Diana.Nodes.Iteration_Aspect'Class (Trees.Element (C)));

   function Is_Literal_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Literal_Aspect'Class);
   function As_Literal_Aspect (C : Cursor) return Diana.Nodes.Literal_Aspect'Class
     is (Diana.Nodes.Literal_Aspect'Class (Trees.Element (C)));

   function Is_Stream_Aspect (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Stream_Aspect'Class);
   function As_Stream_Aspect (C : Cursor) return Diana.Nodes.Stream_Aspect'Class
     is (Diana.Nodes.Stream_Aspect'Class (Trees.Element (C)));

   function Is_Other_Property (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Other_Property'Class);
   function As_Other_Property (C : Cursor) return Diana.Nodes.Other_Property'Class
     is (Diana.Nodes.Other_Property'Class (Trees.Element (C)));

   function Is_Aspect_Pre (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Pre'Class);
   function As_Aspect_Pre (C : Cursor) return Diana.Nodes.Aspect_Pre'Class
     is (Diana.Nodes.Aspect_Pre'Class (Trees.Element (C)));

   function Is_Aspect_Post (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Post'Class);
   function As_Aspect_Post (C : Cursor) return Diana.Nodes.Aspect_Post'Class
     is (Diana.Nodes.Aspect_Post'Class (Trees.Element (C)));

   function Is_Aspect_Type_Invariant (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Type_Invariant'Class);
   function As_Aspect_Type_Invariant (C : Cursor) return Diana.Nodes.Aspect_Type_Invariant'Class
     is (Diana.Nodes.Aspect_Type_Invariant'Class (Trees.Element (C)));

   function Is_Aspect_Predicate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Predicate'Class);
   function As_Aspect_Predicate (C : Cursor) return Diana.Nodes.Aspect_Predicate'Class
     is (Diana.Nodes.Aspect_Predicate'Class (Trees.Element (C)));

   function Is_Aspect_Static_Predicate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Static_Predicate'Class);
   function As_Aspect_Static_Predicate (C : Cursor) return Diana.Nodes.Aspect_Static_Predicate'Class
     is (Diana.Nodes.Aspect_Static_Predicate'Class (Trees.Element (C)));

   function Is_Aspect_Dynamic_Predicate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Dynamic_Predicate'Class);
   function As_Aspect_Dynamic_Predicate (C : Cursor) return Diana.Nodes.Aspect_Dynamic_Predicate'Class
     is (Diana.Nodes.Aspect_Dynamic_Predicate'Class (Trees.Element (C)));

   function Is_Aspect_Contract_Cases (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Contract_Cases'Class);
   function As_Aspect_Contract_Cases (C : Cursor) return Diana.Nodes.Aspect_Contract_Cases'Class
     is (Diana.Nodes.Aspect_Contract_Cases'Class (Trees.Element (C)));

   function Is_Aspect_Default_Initial_Condition (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Default_Initial_Condition'Class);
   function As_Aspect_Default_Initial_Condition (C : Cursor) return Diana.Nodes.Aspect_Default_Initial_Condition'Class
     is (Diana.Nodes.Aspect_Default_Initial_Condition'Class (Trees.Element (C)));

   function Is_Aspect_Subprogram_Variant (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Subprogram_Variant'Class);
   function As_Aspect_Subprogram_Variant (C : Cursor) return Diana.Nodes.Aspect_Subprogram_Variant'Class
     is (Diana.Nodes.Aspect_Subprogram_Variant'Class (Trees.Element (C)));

   function Is_Aspect_Global (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Global'Class);
   function As_Aspect_Global (C : Cursor) return Diana.Nodes.Aspect_Global'Class
     is (Diana.Nodes.Aspect_Global'Class (Trees.Element (C)));

   function Is_Aspect_Depends (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Depends'Class);
   function As_Aspect_Depends (C : Cursor) return Diana.Nodes.Aspect_Depends'Class
     is (Diana.Nodes.Aspect_Depends'Class (Trees.Element (C)));

   function Is_Aspect_Relaxed_Initialization (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Relaxed_Initialization'Class);
   function As_Aspect_Relaxed_Initialization (C : Cursor) return Diana.Nodes.Aspect_Relaxed_Initialization'Class
     is (Diana.Nodes.Aspect_Relaxed_Initialization'Class (Trees.Element (C)));

   function Is_Aspect_Stable_Properties (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Stable_Properties'Class);
   function As_Aspect_Stable_Properties (C : Cursor) return Diana.Nodes.Aspect_Stable_Properties'Class
     is (Diana.Nodes.Aspect_Stable_Properties'Class (Trees.Element (C)));

   function Is_Aspect_Size (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Size'Class);
   function As_Aspect_Size (C : Cursor) return Diana.Nodes.Aspect_Size'Class
     is (Diana.Nodes.Aspect_Size'Class (Trees.Element (C)));

   function Is_Aspect_Object_Size (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Object_Size'Class);
   function As_Aspect_Object_Size (C : Cursor) return Diana.Nodes.Aspect_Object_Size'Class
     is (Diana.Nodes.Aspect_Object_Size'Class (Trees.Element (C)));

   function Is_Aspect_Component_Size (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Component_Size'Class);
   function As_Aspect_Component_Size (C : Cursor) return Diana.Nodes.Aspect_Component_Size'Class
     is (Diana.Nodes.Aspect_Component_Size'Class (Trees.Element (C)));

   function Is_Aspect_Alignment (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Alignment'Class);
   function As_Aspect_Alignment (C : Cursor) return Diana.Nodes.Aspect_Alignment'Class
     is (Diana.Nodes.Aspect_Alignment'Class (Trees.Element (C)));

   function Is_Aspect_Bit_Order (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Bit_Order'Class);
   function As_Aspect_Bit_Order (C : Cursor) return Diana.Nodes.Aspect_Bit_Order'Class
     is (Diana.Nodes.Aspect_Bit_Order'Class (Trees.Element (C)));

   function Is_Aspect_Scalar_Storage_Order (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Scalar_Storage_Order'Class);
   function As_Aspect_Scalar_Storage_Order (C : Cursor) return Diana.Nodes.Aspect_Scalar_Storage_Order'Class
     is (Diana.Nodes.Aspect_Scalar_Storage_Order'Class (Trees.Element (C)));

   function Is_Aspect_Pack (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Pack'Class);
   function As_Aspect_Pack (C : Cursor) return Diana.Nodes.Aspect_Pack'Class
     is (Diana.Nodes.Aspect_Pack'Class (Trees.Element (C)));

   function Is_Aspect_Address (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Address'Class);
   function As_Aspect_Address (C : Cursor) return Diana.Nodes.Aspect_Address'Class
     is (Diana.Nodes.Aspect_Address'Class (Trees.Element (C)));

   function Is_Aspect_Storage_Size (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Storage_Size'Class);
   function As_Aspect_Storage_Size (C : Cursor) return Diana.Nodes.Aspect_Storage_Size'Class
     is (Diana.Nodes.Aspect_Storage_Size'Class (Trees.Element (C)));

   function Is_Aspect_Storage_Pool (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Storage_Pool'Class);
   function As_Aspect_Storage_Pool (C : Cursor) return Diana.Nodes.Aspect_Storage_Pool'Class
     is (Diana.Nodes.Aspect_Storage_Pool'Class (Trees.Element (C)));

   function Is_Aspect_Default_Storage_Pool (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Default_Storage_Pool'Class);
   function As_Aspect_Default_Storage_Pool (C : Cursor) return Diana.Nodes.Aspect_Default_Storage_Pool'Class
     is (Diana.Nodes.Aspect_Default_Storage_Pool'Class (Trees.Element (C)));

   function Is_Aspect_Small (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Small'Class);
   function As_Aspect_Small (C : Cursor) return Diana.Nodes.Aspect_Small'Class
     is (Diana.Nodes.Aspect_Small'Class (Trees.Element (C)));

   function Is_Aspect_Machine_Radix (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Machine_Radix'Class);
   function As_Aspect_Machine_Radix (C : Cursor) return Diana.Nodes.Aspect_Machine_Radix'Class
     is (Diana.Nodes.Aspect_Machine_Radix'Class (Trees.Element (C)));

   function Is_Aspect_Default_Value (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Default_Value'Class);
   function As_Aspect_Default_Value (C : Cursor) return Diana.Nodes.Aspect_Default_Value'Class
     is (Diana.Nodes.Aspect_Default_Value'Class (Trees.Element (C)));

   function Is_Aspect_Default_Component_Value (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Default_Component_Value'Class);
   function As_Aspect_Default_Component_Value (C : Cursor) return Diana.Nodes.Aspect_Default_Component_Value'Class
     is (Diana.Nodes.Aspect_Default_Component_Value'Class (Trees.Element (C)));

   function Is_Aspect_Atomic (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Atomic'Class);
   function As_Aspect_Atomic (C : Cursor) return Diana.Nodes.Aspect_Atomic'Class
     is (Diana.Nodes.Aspect_Atomic'Class (Trees.Element (C)));

   function Is_Aspect_Volatile (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Volatile'Class);
   function As_Aspect_Volatile (C : Cursor) return Diana.Nodes.Aspect_Volatile'Class
     is (Diana.Nodes.Aspect_Volatile'Class (Trees.Element (C)));

   function Is_Aspect_Atomic_Components (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Atomic_Components'Class);
   function As_Aspect_Atomic_Components (C : Cursor) return Diana.Nodes.Aspect_Atomic_Components'Class
     is (Diana.Nodes.Aspect_Atomic_Components'Class (Trees.Element (C)));

   function Is_Aspect_Volatile_Components (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Volatile_Components'Class);
   function As_Aspect_Volatile_Components (C : Cursor) return Diana.Nodes.Aspect_Volatile_Components'Class
     is (Diana.Nodes.Aspect_Volatile_Components'Class (Trees.Element (C)));

   function Is_Aspect_Independent (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Independent'Class);
   function As_Aspect_Independent (C : Cursor) return Diana.Nodes.Aspect_Independent'Class
     is (Diana.Nodes.Aspect_Independent'Class (Trees.Element (C)));

   function Is_Aspect_Independent_Components (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Independent_Components'Class);
   function As_Aspect_Independent_Components (C : Cursor) return Diana.Nodes.Aspect_Independent_Components'Class
     is (Diana.Nodes.Aspect_Independent_Components'Class (Trees.Element (C)));

   function Is_Aspect_External_Tag (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_External_Tag'Class);
   function As_Aspect_External_Tag (C : Cursor) return Diana.Nodes.Aspect_External_Tag'Class
     is (Diana.Nodes.Aspect_External_Tag'Class (Trees.Element (C)));

   function Is_Aspect_Discard_Names (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Discard_Names'Class);
   function As_Aspect_Discard_Names (C : Cursor) return Diana.Nodes.Aspect_Discard_Names'Class
     is (Diana.Nodes.Aspect_Discard_Names'Class (Trees.Element (C)));

   function Is_Aspect_Convention (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Convention'Class);
   function As_Aspect_Convention (C : Cursor) return Diana.Nodes.Aspect_Convention'Class
     is (Diana.Nodes.Aspect_Convention'Class (Trees.Element (C)));

   function Is_Aspect_Import (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Import'Class);
   function As_Aspect_Import (C : Cursor) return Diana.Nodes.Aspect_Import'Class
     is (Diana.Nodes.Aspect_Import'Class (Trees.Element (C)));

   function Is_Aspect_Export (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Export'Class);
   function As_Aspect_Export (C : Cursor) return Diana.Nodes.Aspect_Export'Class
     is (Diana.Nodes.Aspect_Export'Class (Trees.Element (C)));

   function Is_Aspect_External_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_External_Name'Class);
   function As_Aspect_External_Name (C : Cursor) return Diana.Nodes.Aspect_External_Name'Class
     is (Diana.Nodes.Aspect_External_Name'Class (Trees.Element (C)));

   function Is_Aspect_Link_Name (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Link_Name'Class);
   function As_Aspect_Link_Name (C : Cursor) return Diana.Nodes.Aspect_Link_Name'Class
     is (Diana.Nodes.Aspect_Link_Name'Class (Trees.Element (C)));

   function Is_Aspect_Pure (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Pure'Class);
   function As_Aspect_Pure (C : Cursor) return Diana.Nodes.Aspect_Pure'Class
     is (Diana.Nodes.Aspect_Pure'Class (Trees.Element (C)));

   function Is_Aspect_Preelaborate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Preelaborate'Class);
   function As_Aspect_Preelaborate (C : Cursor) return Diana.Nodes.Aspect_Preelaborate'Class
     is (Diana.Nodes.Aspect_Preelaborate'Class (Trees.Element (C)));

   function Is_Aspect_Elaborate_Body (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Elaborate_Body'Class);
   function As_Aspect_Elaborate_Body (C : Cursor) return Diana.Nodes.Aspect_Elaborate_Body'Class
     is (Diana.Nodes.Aspect_Elaborate_Body'Class (Trees.Element (C)));

   function Is_Aspect_Remote_Types (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Remote_Types'Class);
   function As_Aspect_Remote_Types (C : Cursor) return Diana.Nodes.Aspect_Remote_Types'Class
     is (Diana.Nodes.Aspect_Remote_Types'Class (Trees.Element (C)));

   function Is_Aspect_Remote_Call_Interface (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Remote_Call_Interface'Class);
   function As_Aspect_Remote_Call_Interface (C : Cursor) return Diana.Nodes.Aspect_Remote_Call_Interface'Class
     is (Diana.Nodes.Aspect_Remote_Call_Interface'Class (Trees.Element (C)));

   function Is_Aspect_Shared_Passive (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Shared_Passive'Class);
   function As_Aspect_Shared_Passive (C : Cursor) return Diana.Nodes.Aspect_Shared_Passive'Class
     is (Diana.Nodes.Aspect_Shared_Passive'Class (Trees.Element (C)));

   function Is_Aspect_Inline (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Inline'Class);
   function As_Aspect_Inline (C : Cursor) return Diana.Nodes.Aspect_Inline'Class
     is (Diana.Nodes.Aspect_Inline'Class (Trees.Element (C)));

   function Is_Aspect_No_Return (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_No_Return'Class);
   function As_Aspect_No_Return (C : Cursor) return Diana.Nodes.Aspect_No_Return'Class
     is (Diana.Nodes.Aspect_No_Return'Class (Trees.Element (C)));

   function Is_Aspect_Priority (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Priority'Class);
   function As_Aspect_Priority (C : Cursor) return Diana.Nodes.Aspect_Priority'Class
     is (Diana.Nodes.Aspect_Priority'Class (Trees.Element (C)));

   function Is_Aspect_Interrupt_Priority (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Interrupt_Priority'Class);
   function As_Aspect_Interrupt_Priority (C : Cursor) return Diana.Nodes.Aspect_Interrupt_Priority'Class
     is (Diana.Nodes.Aspect_Interrupt_Priority'Class (Trees.Element (C)));

   function Is_Aspect_CPU (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_CPU'Class);
   function As_Aspect_CPU (C : Cursor) return Diana.Nodes.Aspect_CPU'Class
     is (Diana.Nodes.Aspect_CPU'Class (Trees.Element (C)));

   function Is_Aspect_Dispatching_Domain (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Dispatching_Domain'Class);
   function As_Aspect_Dispatching_Domain (C : Cursor) return Diana.Nodes.Aspect_Dispatching_Domain'Class
     is (Diana.Nodes.Aspect_Dispatching_Domain'Class (Trees.Element (C)));

   function Is_Aspect_Attach_Handler (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Attach_Handler'Class);
   function As_Aspect_Attach_Handler (C : Cursor) return Diana.Nodes.Aspect_Attach_Handler'Class
     is (Diana.Nodes.Aspect_Attach_Handler'Class (Trees.Element (C)));

   function Is_Aspect_Interrupt_Handler (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Interrupt_Handler'Class);
   function As_Aspect_Interrupt_Handler (C : Cursor) return Diana.Nodes.Aspect_Interrupt_Handler'Class
     is (Diana.Nodes.Aspect_Interrupt_Handler'Class (Trees.Element (C)));

   function Is_Aspect_Exclusive_Functions (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Exclusive_Functions'Class);
   function As_Aspect_Exclusive_Functions (C : Cursor) return Diana.Nodes.Aspect_Exclusive_Functions'Class
     is (Diana.Nodes.Aspect_Exclusive_Functions'Class (Trees.Element (C)));

   function Is_Aspect_Constant_Indexing (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Constant_Indexing'Class);
   function As_Aspect_Constant_Indexing (C : Cursor) return Diana.Nodes.Aspect_Constant_Indexing'Class
     is (Diana.Nodes.Aspect_Constant_Indexing'Class (Trees.Element (C)));

   function Is_Aspect_Variable_Indexing (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Variable_Indexing'Class);
   function As_Aspect_Variable_Indexing (C : Cursor) return Diana.Nodes.Aspect_Variable_Indexing'Class
     is (Diana.Nodes.Aspect_Variable_Indexing'Class (Trees.Element (C)));

   function Is_Aspect_Default_Iterator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Default_Iterator'Class);
   function As_Aspect_Default_Iterator (C : Cursor) return Diana.Nodes.Aspect_Default_Iterator'Class
     is (Diana.Nodes.Aspect_Default_Iterator'Class (Trees.Element (C)));

   function Is_Aspect_Iterator_Element (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Iterator_Element'Class);
   function As_Aspect_Iterator_Element (C : Cursor) return Diana.Nodes.Aspect_Iterator_Element'Class
     is (Diana.Nodes.Aspect_Iterator_Element'Class (Trees.Element (C)));

   function Is_Aspect_Iterator_View (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Iterator_View'Class);
   function As_Aspect_Iterator_View (C : Cursor) return Diana.Nodes.Aspect_Iterator_View'Class
     is (Diana.Nodes.Aspect_Iterator_View'Class (Trees.Element (C)));

   function Is_Aspect_Aggregate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Aggregate'Class);
   function As_Aspect_Aggregate (C : Cursor) return Diana.Nodes.Aspect_Aggregate'Class
     is (Diana.Nodes.Aspect_Aggregate'Class (Trees.Element (C)));

   function Is_Aspect_Iterable (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Iterable'Class);
   function As_Aspect_Iterable (C : Cursor) return Diana.Nodes.Aspect_Iterable'Class
     is (Diana.Nodes.Aspect_Iterable'Class (Trees.Element (C)));

   function Is_Aspect_Integer_Literal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Integer_Literal'Class);
   function As_Aspect_Integer_Literal (C : Cursor) return Diana.Nodes.Aspect_Integer_Literal'Class
     is (Diana.Nodes.Aspect_Integer_Literal'Class (Trees.Element (C)));

   function Is_Aspect_Real_Literal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Real_Literal'Class);
   function As_Aspect_Real_Literal (C : Cursor) return Diana.Nodes.Aspect_Real_Literal'Class
     is (Diana.Nodes.Aspect_Real_Literal'Class (Trees.Element (C)));

   function Is_Aspect_String_Literal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_String_Literal'Class);
   function As_Aspect_String_Literal (C : Cursor) return Diana.Nodes.Aspect_String_Literal'Class
     is (Diana.Nodes.Aspect_String_Literal'Class (Trees.Element (C)));

   function Is_Aspect_Read (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Read'Class);
   function As_Aspect_Read (C : Cursor) return Diana.Nodes.Aspect_Read'Class
     is (Diana.Nodes.Aspect_Read'Class (Trees.Element (C)));

   function Is_Aspect_Write (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Write'Class);
   function As_Aspect_Write (C : Cursor) return Diana.Nodes.Aspect_Write'Class
     is (Diana.Nodes.Aspect_Write'Class (Trees.Element (C)));

   function Is_Aspect_Input (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Input'Class);
   function As_Aspect_Input (C : Cursor) return Diana.Nodes.Aspect_Input'Class
     is (Diana.Nodes.Aspect_Input'Class (Trees.Element (C)));

   function Is_Aspect_Output (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Output'Class);
   function As_Aspect_Output (C : Cursor) return Diana.Nodes.Aspect_Output'Class
     is (Diana.Nodes.Aspect_Output'Class (Trees.Element (C)));

   function Is_Aspect_Put_Image (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Aspect_Put_Image'Class);
   function As_Aspect_Put_Image (C : Cursor) return Diana.Nodes.Aspect_Put_Image'Class
     is (Diana.Nodes.Aspect_Put_Image'Class (Trees.Element (C)));

   function Is_Record_Representation (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Record_Representation'Class);
   function As_Record_Representation (C : Cursor) return Diana.Nodes.Record_Representation'Class
     is (Diana.Nodes.Record_Representation'Class (Trees.Element (C)));

   function Is_Address_Clause (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Address_Clause'Class);
   function As_Address_Clause (C : Cursor) return Diana.Nodes.Address_Clause'Class
     is (Diana.Nodes.Address_Clause'Class (Trees.Element (C)));

   function Is_Code_Statement (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Code_Statement'Class);
   function As_Code_Statement (C : Cursor) return Diana.Nodes.Code_Statement'Class
     is (Diana.Nodes.Code_Statement'Class (Trees.Element (C)));

   function Is_Component_Rep (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Component_Rep'Class);
   function As_Component_Rep (C : Cursor) return Diana.Nodes.Component_Rep'Class
     is (Diana.Nodes.Component_Rep'Class (Trees.Element (C)));

   function Is_Pragma_Item (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Pragma_Item'Class);
   function As_Pragma_Item (C : Cursor) return Diana.Nodes.Pragma_Item'Class
     is (Diana.Nodes.Pragma_Item'Class (Trees.Element (C)));

   function Is_Operator (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Operator'Class);
   function As_Operator (C : Cursor) return Diana.Nodes.Operator'Class
     is (Diana.Nodes.Operator'Class (Trees.Element (C)));

   function Is_Op_And (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_And'Class);
   function As_Op_And (C : Cursor) return Diana.Nodes.Op_And'Class
     is (Diana.Nodes.Op_And'Class (Trees.Element (C)));

   function Is_Op_Or (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Or'Class);
   function As_Op_Or (C : Cursor) return Diana.Nodes.Op_Or'Class
     is (Diana.Nodes.Op_Or'Class (Trees.Element (C)));

   function Is_Op_Xor (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Xor'Class);
   function As_Op_Xor (C : Cursor) return Diana.Nodes.Op_Xor'Class
     is (Diana.Nodes.Op_Xor'Class (Trees.Element (C)));

   function Is_Op_Equal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Equal'Class);
   function As_Op_Equal (C : Cursor) return Diana.Nodes.Op_Equal'Class
     is (Diana.Nodes.Op_Equal'Class (Trees.Element (C)));

   function Is_Op_Not_Equal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Not_Equal'Class);
   function As_Op_Not_Equal (C : Cursor) return Diana.Nodes.Op_Not_Equal'Class
     is (Diana.Nodes.Op_Not_Equal'Class (Trees.Element (C)));

   function Is_Op_Less (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Less'Class);
   function As_Op_Less (C : Cursor) return Diana.Nodes.Op_Less'Class
     is (Diana.Nodes.Op_Less'Class (Trees.Element (C)));

   function Is_Op_Less_Equal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Less_Equal'Class);
   function As_Op_Less_Equal (C : Cursor) return Diana.Nodes.Op_Less_Equal'Class
     is (Diana.Nodes.Op_Less_Equal'Class (Trees.Element (C)));

   function Is_Op_Greater (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Greater'Class);
   function As_Op_Greater (C : Cursor) return Diana.Nodes.Op_Greater'Class
     is (Diana.Nodes.Op_Greater'Class (Trees.Element (C)));

   function Is_Op_Greater_Equal (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Greater_Equal'Class);
   function As_Op_Greater_Equal (C : Cursor) return Diana.Nodes.Op_Greater_Equal'Class
     is (Diana.Nodes.Op_Greater_Equal'Class (Trees.Element (C)));

   function Is_Op_Plus (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Plus'Class);
   function As_Op_Plus (C : Cursor) return Diana.Nodes.Op_Plus'Class
     is (Diana.Nodes.Op_Plus'Class (Trees.Element (C)));

   function Is_Op_Minus (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Minus'Class);
   function As_Op_Minus (C : Cursor) return Diana.Nodes.Op_Minus'Class
     is (Diana.Nodes.Op_Minus'Class (Trees.Element (C)));

   function Is_Op_Concatenate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Concatenate'Class);
   function As_Op_Concatenate (C : Cursor) return Diana.Nodes.Op_Concatenate'Class
     is (Diana.Nodes.Op_Concatenate'Class (Trees.Element (C)));

   function Is_Op_Unary_Plus (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Unary_Plus'Class);
   function As_Op_Unary_Plus (C : Cursor) return Diana.Nodes.Op_Unary_Plus'Class
     is (Diana.Nodes.Op_Unary_Plus'Class (Trees.Element (C)));

   function Is_Op_Unary_Minus (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Unary_Minus'Class);
   function As_Op_Unary_Minus (C : Cursor) return Diana.Nodes.Op_Unary_Minus'Class
     is (Diana.Nodes.Op_Unary_Minus'Class (Trees.Element (C)));

   function Is_Op_Absolute (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Absolute'Class);
   function As_Op_Absolute (C : Cursor) return Diana.Nodes.Op_Absolute'Class
     is (Diana.Nodes.Op_Absolute'Class (Trees.Element (C)));

   function Is_Op_Not (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Not'Class);
   function As_Op_Not (C : Cursor) return Diana.Nodes.Op_Not'Class
     is (Diana.Nodes.Op_Not'Class (Trees.Element (C)));

   function Is_Op_Multiply (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Multiply'Class);
   function As_Op_Multiply (C : Cursor) return Diana.Nodes.Op_Multiply'Class
     is (Diana.Nodes.Op_Multiply'Class (Trees.Element (C)));

   function Is_Op_Divide (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Divide'Class);
   function As_Op_Divide (C : Cursor) return Diana.Nodes.Op_Divide'Class
     is (Diana.Nodes.Op_Divide'Class (Trees.Element (C)));

   function Is_Op_Modulo (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Modulo'Class);
   function As_Op_Modulo (C : Cursor) return Diana.Nodes.Op_Modulo'Class
     is (Diana.Nodes.Op_Modulo'Class (Trees.Element (C)));

   function Is_Op_Remainder (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Remainder'Class);
   function As_Op_Remainder (C : Cursor) return Diana.Nodes.Op_Remainder'Class
     is (Diana.Nodes.Op_Remainder'Class (Trees.Element (C)));

   function Is_Op_Exponentiate (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Op_Exponentiate'Class);
   function As_Op_Exponentiate (C : Cursor) return Diana.Nodes.Op_Exponentiate'Class
     is (Diana.Nodes.Op_Exponentiate'Class (Trees.Element (C)));

   function Is_Compilation_Unit_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Compilation_Unit_S'Class);
   function As_Compilation_Unit_S (C : Cursor) return Diana.Nodes.Compilation_Unit_S'Class
     is (Diana.Nodes.Compilation_Unit_S'Class (Trees.Element (C)));

   function Is_Context_Element_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Context_Element_S'Class);
   function As_Context_Element_S (C : Cursor) return Diana.Nodes.Context_Element_S'Class
     is (Diana.Nodes.Context_Element_S'Class (Trees.Element (C)));

   function Is_Declaration_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Declaration_S'Class);
   function As_Declaration_S (C : Cursor) return Diana.Nodes.Declaration_S'Class
     is (Diana.Nodes.Declaration_S'Class (Trees.Element (C)));

   function Is_Item_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Item_S'Class);
   function As_Item_S (C : Cursor) return Diana.Nodes.Item_S'Class
     is (Diana.Nodes.Item_S'Class (Trees.Element (C)));

   function Is_Defining_Name_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Defining_Name_S'Class);
   function As_Defining_Name_S (C : Cursor) return Diana.Nodes.Defining_Name_S'Class
     is (Diana.Nodes.Defining_Name_S'Class (Trees.Element (C)));

   function Is_Name_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Name_S'Class);
   function As_Name_S (C : Cursor) return Diana.Nodes.Name_S'Class
     is (Diana.Nodes.Name_S'Class (Trees.Element (C)));

   function Is_Expression_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Expression_S'Class);
   function As_Expression_S (C : Cursor) return Diana.Nodes.Expression_S'Class
     is (Diana.Nodes.Expression_S'Class (Trees.Element (C)));

   function Is_Association_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Association_S'Class);
   function As_Association_S (C : Cursor) return Diana.Nodes.Association_S'Class
     is (Diana.Nodes.Association_S'Class (Trees.Element (C)));

   function Is_Statement_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Statement_S'Class);
   function As_Statement_S (C : Cursor) return Diana.Nodes.Statement_S'Class
     is (Diana.Nodes.Statement_S'Class (Trees.Element (C)));

   function Is_Alternative_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Alternative_S'Class);
   function As_Alternative_S (C : Cursor) return Diana.Nodes.Alternative_S'Class
     is (Diana.Nodes.Alternative_S'Class (Trees.Element (C)));

   function Is_Choice_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Choice_S'Class);
   function As_Choice_S (C : Cursor) return Diana.Nodes.Choice_S'Class
     is (Diana.Nodes.Choice_S'Class (Trees.Element (C)));

   function Is_Membership_Choice_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Membership_Choice_S'Class);
   function As_Membership_Choice_S (C : Cursor) return Diana.Nodes.Membership_Choice_S'Class
     is (Diana.Nodes.Membership_Choice_S'Class (Trees.Element (C)));

   function Is_Conditional_Clause_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Conditional_Clause_S'Class);
   function As_Conditional_Clause_S (C : Cursor) return Diana.Nodes.Conditional_Clause_S'Class
     is (Diana.Nodes.Conditional_Clause_S'Class (Trees.Element (C)));

   function Is_Expression_Clause_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Expression_Clause_S'Class);
   function As_Expression_Clause_S (C : Cursor) return Diana.Nodes.Expression_Clause_S'Class
     is (Diana.Nodes.Expression_Clause_S'Class (Trees.Element (C)));

   function Is_Expression_Alternative_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Expression_Alternative_S'Class);
   function As_Expression_Alternative_S (C : Cursor) return Diana.Nodes.Expression_Alternative_S'Class
     is (Diana.Nodes.Expression_Alternative_S'Class (Trees.Element (C)));

   function Is_Select_Alternative_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Select_Alternative_S'Class);
   function As_Select_Alternative_S (C : Cursor) return Diana.Nodes.Select_Alternative_S'Class
     is (Diana.Nodes.Select_Alternative_S'Class (Trees.Element (C)));

   function Is_Parallel_Arm_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parallel_Arm_S'Class);
   function As_Parallel_Arm_S (C : Cursor) return Diana.Nodes.Parallel_Arm_S'Class
     is (Diana.Nodes.Parallel_Arm_S'Class (Trees.Element (C)));

   function Is_Contract_Case_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Contract_Case_S'Class);
   function As_Contract_Case_S (C : Cursor) return Diana.Nodes.Contract_Case_S'Class
     is (Diana.Nodes.Contract_Case_S'Class (Trees.Element (C)));

   function Is_Component_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Component_S'Class);
   function As_Component_S (C : Cursor) return Diana.Nodes.Component_S'Class
     is (Diana.Nodes.Component_S'Class (Trees.Element (C)));

   function Is_Variant_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Variant_S'Class);
   function As_Variant_S (C : Cursor) return Diana.Nodes.Variant_S'Class
     is (Diana.Nodes.Variant_S'Class (Trees.Element (C)));

   function Is_Discrete_Range_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discrete_Range_S'Class);
   function As_Discrete_Range_S (C : Cursor) return Diana.Nodes.Discrete_Range_S'Class
     is (Diana.Nodes.Discrete_Range_S'Class (Trees.Element (C)));

   function Is_Parameter_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Parameter_S'Class);
   function As_Parameter_S (C : Cursor) return Diana.Nodes.Parameter_S'Class
     is (Diana.Nodes.Parameter_S'Class (Trees.Element (C)));

   function Is_Generic_Formal_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Generic_Formal_S'Class);
   function As_Generic_Formal_S (C : Cursor) return Diana.Nodes.Generic_Formal_S'Class
     is (Diana.Nodes.Generic_Formal_S'Class (Trees.Element (C)));

   function Is_Component_Rep_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Component_Rep_S'Class);
   function As_Component_Rep_S (C : Cursor) return Diana.Nodes.Component_Rep_S'Class
     is (Diana.Nodes.Component_Rep_S'Class (Trees.Element (C)));

   function Is_Semantic_Property_S (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Semantic_Property_S'Class);
   function As_Semantic_Property_S (C : Cursor) return Diana.Nodes.Semantic_Property_S'Class
     is (Diana.Nodes.Semantic_Property_S'Class (Trees.Element (C)));

   function Is_Choice (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Choice'Class);
   function As_Choice (C : Cursor) return Diana.Nodes.Choice'Class
     is (Diana.Nodes.Choice'Class (Trees.Element (C)));

   function Is_Choice_Expression (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Choice_Expression'Class);
   function As_Choice_Expression (C : Cursor) return Diana.Nodes.Choice_Expression'Class
     is (Diana.Nodes.Choice_Expression'Class (Trees.Element (C)));

   function Is_Choice_Range (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Choice_Range'Class);
   function As_Choice_Range (C : Cursor) return Diana.Nodes.Choice_Range'Class
     is (Diana.Nodes.Choice_Range'Class (Trees.Element (C)));

   function Is_Others_Choice (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Others_Choice'Class);
   function As_Others_Choice (C : Cursor) return Diana.Nodes.Others_Choice'Class
     is (Diana.Nodes.Others_Choice'Class (Trees.Element (C)));

   function Is_Discriminant (C : Cursor) return Boolean
     is (Trees.Element (C) in Diana.Nodes.Discriminant'Class);
   function As_Discriminant (C : Cursor) return Diana.Nodes.Discriminant'Class
     is (Diana.Nodes.Discriminant'Class (Trees.Element (C)));

end Diana.Accessors;
