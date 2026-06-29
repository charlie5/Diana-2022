--  Diana.Builders — value constructors for every concrete node.
--
--  GENERATED from spec/DIANA_2022.idl by tools/gen_api.pl.  DO NOT EDIT.
--
--  Each function builds one node VALUE from its attributes (own + inherited,
--  all defaulted); append it to the tree to get a cursor (e.g. via
--  Diana.Library.Add_Child).  Build bottom-up: construct child nodes first,
--  then pass their cursors into the enclosing node's constructor.

pragma Style_Checks (Off);

with Diana.Nodes;

package Diana.Builders is

   function Compilation
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Units           : Cursor := No_Element)
      return Diana.Nodes.Compilation
   is (Source_Position => Source_Position,
       Comments => Comments,
       Units => Units);

   function Compilation_Unit
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Context         : Cursor := No_Element;
      Library_Item    : Cursor := No_Element)
      return Diana.Nodes.Compilation_Unit
   is (Source_Position => Source_Position,
       Comments => Comments,
       Context => Context,
       Library_Item => Library_Item);

   function Semantic_Property
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Identity        : Cursor := No_Element;
      Class_Wide      : Boolean := False;
      Value           : Cursor := No_Element;
      Origin          : Cursor := No_Element)
      return Diana.Nodes.Semantic_Property
   is (Source_Position => Source_Position,
       Comments => Comments,
       Identity => Identity,
       Class_Wide => Class_Wide,
       Value => Value,
       Origin => Origin);

   function Subunit
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Parent          : Cursor := No_Element;
      Completion      : Cursor := No_Element)
      return Diana.Nodes.Subunit
   is (Source_Position => Source_Position,
       Comments => Comments,
       Parent => Parent,
       Completion => Completion);

   function Entry_Body
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Family_Index    : Cursor := No_Element;
      Parameters      : Cursor := No_Element;
      Barrier         : Cursor := No_Element;
      Completion      : Cursor := No_Element)
      return Diana.Nodes.Entry_Body
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Family_Index => Family_Index,
       Parameters => Parameters,
       Barrier => Barrier,
       Completion => Completion);

   function Subprogram_Body
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Designator      : Cursor := No_Element;
      Header          : Cursor := No_Element;
      Completion      : Cursor := No_Element)
      return Diana.Nodes.Subprogram_Body
   is (Source_Position => Source_Position,
       Comments => Comments,
       Designator => Designator,
       Header => Header,
       Completion => Completion);

   function Package_Body
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Completion      : Cursor := No_Element)
      return Diana.Nodes.Package_Body
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Completion => Completion);

   function Task_Body
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Completion      : Cursor := No_Element)
      return Diana.Nodes.Task_Body
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Completion => Completion);

   function Protected_Body
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Operations      : Cursor := No_Element)
      return Diana.Nodes.Protected_Body
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Operations => Operations);

   function With_Clause
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element;
      Is_Limited      : Boolean := False;
      Is_Private      : Boolean := False)
      return Diana.Nodes.With_Clause
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names,
       Is_Limited => Is_Limited,
       Is_Private => Is_Private);

   function Context_Use_Clause
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element)
      return Diana.Nodes.Context_Use_Clause
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names);

   function Context_Pragma
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Pragma_Item     : Cursor := No_Element)
      return Diana.Nodes.Context_Pragma
   is (Source_Position => Source_Position,
       Comments => Comments,
       Pragma_Item => Pragma_Item);

   function Number_Declaration
     (Source_Position         : Diana.Source_Position := No_Position;
      Comments                : Diana.Comments := SU.Null_Unbounded_String;
      Properties              : Cursor := No_Element;
      Names                   : Cursor := No_Element;
      Static_Value_Expression : Cursor := No_Element)
      return Diana.Nodes.Number_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Names => Names,
       Static_Value_Expression => Static_Value_Expression);

   function Constant_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Names           : Cursor := No_Element;
      Object_Subtype  : Cursor := No_Element;
      Initialization  : Cursor := No_Element)
      return Diana.Nodes.Constant_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Names => Names,
       Object_Subtype => Object_Subtype,
       Initialization => Initialization);

   function Variable_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Names           : Cursor := No_Element;
      Object_Subtype  : Cursor := No_Element;
      Initialization  : Cursor := No_Element)
      return Diana.Nodes.Variable_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Names => Names,
       Object_Subtype => Object_Subtype,
       Initialization => Initialization);

   function Type_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Name            : Cursor := No_Element;
      Discriminants   : Cursor := No_Element;
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Type_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Name => Name,
       Discriminants => Discriminants,
       Definition => Definition);

   function Subtype_Declaration
     (Source_Position         : Diana.Source_Position := No_Position;
      Comments                : Diana.Comments := SU.Null_Unbounded_String;
      Properties              : Cursor := No_Element;
      Name                    : Cursor := No_Element;
      Subtype_Mark_Constraint : Cursor := No_Element)
      return Diana.Nodes.Subtype_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Name => Name,
       Subtype_Mark_Constraint => Subtype_Mark_Constraint);

   function Subprogram_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Designator      : Cursor := No_Element;
      Header          : Cursor := No_Element;
      Completion      : Cursor := No_Element)
      return Diana.Nodes.Subprogram_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Designator => Designator,
       Header => Header,
       Completion => Completion);

   function Package_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Name            : Cursor := No_Element;
      Completion      : Cursor := No_Element)
      return Diana.Nodes.Package_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Name => Name,
       Completion => Completion);

   function Task_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Name            : Cursor := No_Element;
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Task_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Name => Name,
       Definition => Definition);

   function Generic_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Name            : Cursor := No_Element;
      Formals         : Cursor := No_Element;
      Specification   : Cursor := No_Element)
      return Diana.Nodes.Generic_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Name => Name,
       Formals => Formals,
       Specification => Specification);

   function Exception_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Names           : Cursor := No_Element)
      return Diana.Nodes.Exception_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Names => Names);

   function Deferred_Constant_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Names           : Cursor := No_Element;
      Subtype_Mark    : Cursor := No_Element)
      return Diana.Nodes.Deferred_Constant_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Names => Names,
       Subtype_Mark => Subtype_Mark);

   function Renaming_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Renamed         : Cursor := No_Element)
      return Diana.Nodes.Renaming_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Renamed => Renamed);

   function Generic_Instantiation
     (Source_Position       : Diana.Source_Position := No_Position;
      Comments              : Diana.Comments := SU.Null_Unbounded_String;
      Properties            : Cursor := No_Element;
      Generic_Unit          : Cursor := No_Element;
      Associations          : Cursor := No_Element;
      Expanded_Declarations : Cursor := No_Element)
      return Diana.Nodes.Generic_Instantiation
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Generic_Unit => Generic_Unit,
       Associations => Associations,
       Expanded_Declarations => Expanded_Declarations);

   function Use_Clause
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Names           : Cursor := No_Element)
      return Diana.Nodes.Use_Clause
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Names => Names);

   function Declaration_Pragma
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Pragma_Item     : Cursor := No_Element)
      return Diana.Nodes.Declaration_Pragma
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Pragma_Item => Pragma_Item);

   function Defining_Operator
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Location         : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element)
      return Diana.Nodes.Defining_Operator
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Specification => Specification,
       Completion => Completion,
       Location => Location,
       Stub => Stub,
       First_Definition => First_Definition);

   function Defining_Character
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type     : Cursor := No_Element;
      Position        : Integer := 0;
      Representation  : Integer := 0)
      return Diana.Nodes.Defining_Character
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Position => Position,
       Representation => Representation);

   function Enumeration_Literal_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type     : Cursor := No_Element;
      Position        : Integer := 0;
      Representation  : Integer := 0)
      return Diana.Nodes.Enumeration_Literal_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Position => Position,
       Representation => Representation);

   function Entry_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Specification   : Cursor := No_Element;
      Address         : Cursor := No_Element)
      return Diana.Nodes.Entry_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Specification => Specification,
       Address => Address);

   function Exception_Name
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      First_Definition : Cursor := No_Element)
      return Diana.Nodes.Exception_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       First_Definition => First_Definition);

   function Iteration_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type     : Cursor := No_Element)
      return Diana.Nodes.Iteration_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type);

   function Variable_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type     : Cursor := No_Element;
      Address         : Cursor := No_Element;
      Object_Def      : Cursor := No_Element)
      return Diana.Nodes.Variable_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Address => Address,
       Object_Def => Object_Def);

   function Constant_Name
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type      : Cursor := No_Element;
      Address          : Cursor := No_Element;
      Object_Def       : Cursor := No_Element;
      First_Definition : Cursor := No_Element)
      return Diana.Nodes.Constant_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Address => Address,
       Object_Def => Object_Def,
       First_Definition => First_Definition);

   function Number_Name
     (Source_Position         : Diana.Source_Position := No_Position;
      Comments                : Diana.Comments := SU.Null_Unbounded_String;
      Spelling                : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type             : Cursor := No_Element;
      Static_Value_Expression : Cursor := No_Element)
      return Diana.Nodes.Number_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Static_Value_Expression => Static_Value_Expression);

   function Component_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type     : Cursor := No_Element;
      Initialization  : Cursor := No_Element;
      Component_Spec  : Cursor := No_Element)
      return Diana.Nodes.Component_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Initialization => Initialization,
       Component_Spec => Component_Spec);

   function Discriminant_Name
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type      : Cursor := No_Element;
      Initialization   : Cursor := No_Element;
      First_Definition : Cursor := No_Element;
      Component_Spec   : Cursor := No_Element)
      return Diana.Nodes.Discriminant_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Initialization => Initialization,
       First_Definition => First_Definition,
       Component_Spec => Component_Spec);

   function Parameter_Name
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Object_Type      : Cursor := No_Element;
      Default          : Cursor := No_Element;
      First_Definition : Cursor := No_Element)
      return Diana.Nodes.Parameter_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Object_Type => Object_Type,
       Default => Default,
       First_Definition => First_Definition);

   function Full_Type_Name
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Spelling           : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Type_Specification : Cursor := No_Element;
      First_Definition   : Cursor := No_Element)
      return Diana.Nodes.Full_Type_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Type_Specification => Type_Specification,
       First_Definition => First_Definition);

   function Subtype_Name
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Spelling           : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Type_Specification : Cursor := No_Element)
      return Diana.Nodes.Subtype_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Type_Specification => Type_Specification);

   function Private_Type_Name
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Spelling           : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Type_Specification : Cursor := No_Element)
      return Diana.Nodes.Private_Type_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Type_Specification => Type_Specification);

   function Subprogram_Name
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Location         : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element)
      return Diana.Nodes.Subprogram_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Specification => Specification,
       Completion => Completion,
       Location => Location,
       Stub => Stub,
       First_Definition => First_Definition);

   function Package_Name
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Address          : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element)
      return Diana.Nodes.Package_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Specification => Specification,
       Completion => Completion,
       Address => Address,
       Stub => Stub,
       First_Definition => First_Definition);

   function Generic_Name
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Spelling         : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Formals          : Cursor := No_Element;
      Specification    : Cursor := No_Element;
      Completion       : Cursor := No_Element;
      Stub             : Cursor := No_Element;
      First_Definition : Cursor := No_Element)
      return Diana.Nodes.Generic_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Formals => Formals,
       Specification => Specification,
       Completion => Completion,
       Stub => Stub,
       First_Definition => First_Definition);

   function Task_Body_Name
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Spelling           : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Type_Specification : Cursor := No_Element;
      Completion         : Cursor := No_Element;
      Stub               : Cursor := No_Element;
      First_Definition   : Cursor := No_Element)
      return Diana.Nodes.Task_Body_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Type_Specification => Type_Specification,
       Completion => Completion,
       Stub => Stub,
       First_Definition => First_Definition);

   function Statement_Label_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Statement       : Cursor := No_Element)
      return Diana.Nodes.Statement_Label_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Statement => Statement);

   function Loop_Block_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Statement       : Cursor := No_Element)
      return Diana.Nodes.Loop_Block_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Statement => Statement);

   function Attribute_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String)
      return Diana.Nodes.Attribute_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling);

   function Pragma_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Arguments       : Cursor := No_Element)
      return Diana.Nodes.Pragma_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Arguments => Arguments);

   function Argument_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String)
      return Diana.Nodes.Argument_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling);

   function Builtin_Operator_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Spelling        : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Operator        : Cursor := No_Element)
      return Diana.Nodes.Builtin_Operator_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Spelling => Spelling,
       Operator => Operator);

   function Numeric_Literal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Literal_Image   : Diana.Number_Rep := SU.Null_Unbounded_String)
      return Diana.Nodes.Numeric_Literal
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Literal_Image => Literal_Image);

   function String_Literal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Literal_Image   : Diana.Symbol_Rep := SU.Null_Unbounded_String;
      Constraint      : Cursor := No_Element)
      return Diana.Nodes.String_Literal
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Literal_Image => Literal_Image,
       Constraint => Constraint);

   function Null_Literal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value))
      return Diana.Nodes.Null_Literal
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value);

   function Aggregate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Associations    : Cursor := No_Element;
      Square_Brackets : Boolean := False;
      Normalized      : Cursor := No_Element)
      return Diana.Nodes.Aggregate
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Associations => Associations,
       Square_Brackets => Square_Brackets,
       Normalized => Normalized);

   function Delta_Aggregate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Base            : Cursor := No_Element;
      Deltas          : Cursor := No_Element)
      return Diana.Nodes.Delta_Aggregate
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Base => Base,
       Deltas => Deltas);

   function Container_Aggregate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Associations    : Cursor := No_Element)
      return Diana.Nodes.Container_Aggregate
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Associations => Associations);

   function Qualified_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Target          : Cursor := No_Element;
      Operand         : Cursor := No_Element)
      return Diana.Nodes.Qualified_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Target => Target,
       Operand => Operand);

   function Type_Conversion
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Target          : Cursor := No_Element;
      Operand         : Cursor := No_Element)
      return Diana.Nodes.Type_Conversion
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Target => Target,
       Operand => Operand);

   function Parenthesized_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Operand         : Cursor := No_Element)
      return Diana.Nodes.Parenthesized_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Operand => Operand);

   function Short_Circuit
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Left            : Cursor := No_Element;
      Operator        : Cursor := No_Element;
      Right           : Cursor := No_Element)
      return Diana.Nodes.Short_Circuit
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Left => Left,
       Operator => Operator,
       Right => Right);

   function Membership
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Operand         : Cursor := No_Element;
      Operator        : Cursor := No_Element;
      Choices         : Cursor := No_Element)
      return Diana.Nodes.Membership
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Operand => Operand,
       Operator => Operator,
       Choices => Choices);

   function Quantified_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Quantifier      : Cursor := No_Element;
      Iterator        : Cursor := No_Element;
      Predicate       : Cursor := No_Element)
      return Diana.Nodes.Quantified_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Quantifier => Quantifier,
       Iterator => Iterator,
       Predicate => Predicate);

   function Declare_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Declarations    : Cursor := No_Element;
      Result          : Cursor := No_Element)
      return Diana.Nodes.Declare_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Declarations => Declarations,
       Result => Result);

   function Reduction_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Value_Sequence  : Cursor := No_Element;
      Reducer         : Cursor := No_Element;
      Initial_Value   : Cursor := No_Element;
      Is_Parallel     : Boolean := False)
      return Diana.Nodes.Reduction_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Value_Sequence => Value_Sequence,
       Reducer => Reducer,
       Initial_Value => Initial_Value,
       Is_Parallel => Is_Parallel);

   function Raise_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Exception_Name  : Cursor := No_Element;
      Message         : Cursor := No_Element)
      return Diana.Nodes.Raise_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Exception_Name => Exception_Name,
       Message => Message);

   function Qualified_Allocator
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Value           : Cursor := No_Element)
      return Diana.Nodes.Qualified_Allocator
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Value => Value);

   function Subtype_Allocator
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type    : Cursor := No_Element;
      Static_Value       : Diana.Static_Value := (Kind => No_Value);
      Subtype_Indication : Cursor := No_Element)
      return Diana.Nodes.Subtype_Allocator
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Subtype_Indication => Subtype_Indication);

   function And_Then
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.And_Then
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Or_Else
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Or_Else
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Membership_Value
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Value           : Cursor := No_Element)
      return Diana.Nodes.Membership_Value
   is (Source_Position => Source_Position,
       Comments => Comments,
       Value => Value);

   function Membership_Range
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Range_Item      : Cursor := No_Element)
      return Diana.Nodes.Membership_Range
   is (Source_Position => Source_Position,
       Comments => Comments,
       Range_Item => Range_Item);

   function Membership_Subtype
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Subtype_Mark    : Cursor := No_Element)
      return Diana.Nodes.Membership_Subtype
   is (Source_Position => Source_Position,
       Comments => Comments,
       Subtype_Mark => Subtype_Mark);

   function In_Set
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.In_Set
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Not_In_Set
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Not_In_Set
   is (Source_Position => Source_Position,
       Comments => Comments);

   function If_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Clauses         : Cursor := No_Element)
      return Diana.Nodes.If_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Clauses => Clauses);

   function Case_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Selector        : Cursor := No_Element;
      Alternatives    : Cursor := No_Element)
      return Diana.Nodes.Case_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Selector => Selector,
       Alternatives => Alternatives);

   function Expression_Clause
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Condition       : Cursor := No_Element;
      Result          : Cursor := No_Element)
      return Diana.Nodes.Expression_Clause
   is (Source_Position => Source_Position,
       Comments => Comments,
       Condition => Condition,
       Result => Result);

   function Expression_Alternative
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Choices         : Cursor := No_Element;
      Result          : Cursor := No_Element)
      return Diana.Nodes.Expression_Alternative
   is (Source_Position => Source_Position,
       Comments => Comments,
       Choices => Choices,
       Result => Result);

   function For_All
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.For_All
   is (Source_Position => Source_Position,
       Comments => Comments);

   function For_Some
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.For_Some
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Range_Iterator
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Parameter       : Cursor := No_Element;
      Discrete_Range  : Cursor := No_Element;
      Reverse_Order   : Boolean := False;
      Filter          : Cursor := No_Element)
      return Diana.Nodes.Range_Iterator
   is (Source_Position => Source_Position,
       Comments => Comments,
       Parameter => Parameter,
       Discrete_Range => Discrete_Range,
       Reverse_Order => Reverse_Order,
       Filter => Filter);

   function Container_Iterator
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Parameter       : Cursor := No_Element;
      Iterable        : Cursor := No_Element;
      Reverse_Order   : Boolean := False;
      Filter          : Cursor := No_Element)
      return Diana.Nodes.Container_Iterator
   is (Source_Position => Source_Position,
       Comments => Comments,
       Parameter => Parameter,
       Iterable => Iterable,
       Reverse_Order => Reverse_Order,
       Filter => Filter);

   function Used_Object
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Used_Object
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Definition => Definition);

   function Used_Builtin
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type  : Cursor := No_Element;
      Static_Value     : Diana.Static_Value := (Kind => No_Value);
      Builtin_Operator : Cursor := No_Element)
      return Diana.Nodes.Used_Builtin
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Builtin_Operator => Builtin_Operator);

   function Indexed_Component
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Prefix          : Cursor := No_Element;
      Indices         : Cursor := No_Element)
      return Diana.Nodes.Indexed_Component
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Prefix => Prefix,
       Indices => Indices);

   function Slice
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Prefix          : Cursor := No_Element;
      Discrete_Range  : Cursor := No_Element)
      return Diana.Nodes.Slice
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Prefix => Prefix,
       Discrete_Range => Discrete_Range);

   function Selected_Component
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Prefix          : Cursor := No_Element;
      Selector        : Cursor := No_Element)
      return Diana.Nodes.Selected_Component
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Prefix => Prefix,
       Selector => Selector);

   function Dereference
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Prefix          : Cursor := No_Element)
      return Diana.Nodes.Dereference
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Prefix => Prefix);

   function Attribute_Reference
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Prefix          : Cursor := No_Element;
      Attribute       : Cursor := No_Element)
      return Diana.Nodes.Attribute_Reference
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Prefix => Prefix,
       Attribute => Attribute);

   function Attribute_Call
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Prefix          : Cursor := No_Element;
      Argument        : Cursor := No_Element)
      return Diana.Nodes.Attribute_Call
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Prefix => Prefix,
       Argument => Argument);

   function Function_Call
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type    : Cursor := No_Element;
      Static_Value       : Diana.Static_Value := (Kind => No_Value);
      Prefix             : Cursor := No_Element;
      Actuals            : Cursor := No_Element;
      Is_Prefix_Notation : Boolean := False;
      Normalized_Actuals : Cursor := No_Element)
      return Diana.Nodes.Function_Call
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Prefix => Prefix,
       Actuals => Actuals,
       Is_Prefix_Notation => Is_Prefix_Notation,
       Normalized_Actuals => Normalized_Actuals);

   function Target_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value))
      return Diana.Nodes.Target_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value);

   function Used_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Used_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Definition => Definition);

   function Used_Character
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Used_Character
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Definition => Definition);

   function Used_Operator
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression_Type : Cursor := No_Element;
      Static_Value    : Diana.Static_Value := (Kind => No_Value);
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Used_Operator
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression_Type => Expression_Type,
       Static_Value => Static_Value,
       Definition => Definition);

   function Positional_Association
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Value           : Cursor := No_Element)
      return Diana.Nodes.Positional_Association
   is (Source_Position => Source_Position,
       Comments => Comments,
       Value => Value);

   function Named_Association
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Choices         : Cursor := No_Element;
      Actual          : Cursor := No_Element)
      return Diana.Nodes.Named_Association
   is (Source_Position => Source_Position,
       Comments => Comments,
       Choices => Choices,
       Actual => Actual);

   function Iterated_Association
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Iterator        : Cursor := No_Element;
      Result          : Cursor := No_Element)
      return Diana.Nodes.Iterated_Association
   is (Source_Position => Source_Position,
       Comments => Comments,
       Iterator => Iterator,
       Result => Result);

   function Null_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Null_Statement
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Assignment
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Target          : Cursor := No_Element;
      Source          : Cursor := No_Element)
      return Diana.Nodes.Assignment
   is (Source_Position => Source_Position,
       Comments => Comments,
       Target => Target,
       Source => Source);

   function Procedure_Call
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Prefix             : Cursor := No_Element;
      Actuals            : Cursor := No_Element;
      Normalized_Actuals : Cursor := No_Element)
      return Diana.Nodes.Procedure_Call
   is (Source_Position => Source_Position,
       Comments => Comments,
       Prefix => Prefix,
       Actuals => Actuals,
       Normalized_Actuals => Normalized_Actuals);

   function Exit_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Loop_Name       : Cursor := No_Element;
      Condition       : Cursor := No_Element)
      return Diana.Nodes.Exit_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Loop_Name => Loop_Name,
       Condition => Condition);

   function Return_Statement
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Returned_Object    : Cursor := No_Element;
      Handled_Statements : Cursor := No_Element)
      return Diana.Nodes.Return_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Returned_Object => Returned_Object,
       Handled_Statements => Handled_Statements);

   function Goto_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Target          : Cursor := No_Element)
      return Diana.Nodes.Goto_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Target => Target);

   function If_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Clauses         : Cursor := No_Element)
      return Diana.Nodes.If_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Clauses => Clauses);

   function Case_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Selector        : Cursor := No_Element;
      Alternatives    : Cursor := No_Element)
      return Diana.Nodes.Case_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Selector => Selector,
       Alternatives => Alternatives);

   function Loop_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Iteration       : Cursor := No_Element;
      Statements      : Cursor := No_Element)
      return Diana.Nodes.Loop_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Iteration => Iteration,
       Statements => Statements);

   function Block_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Block           : Cursor := No_Element)
      return Diana.Nodes.Block_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Block => Block);

   function Labeled_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Labels          : Cursor := No_Element;
      Statement       : Cursor := No_Element)
      return Diana.Nodes.Labeled_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Labels => Labels,
       Statement => Statement);

   function Raise_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Exception_Name  : Cursor := No_Element;
      Message         : Cursor := No_Element)
      return Diana.Nodes.Raise_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Exception_Name => Exception_Name,
       Message => Message);

   function Delay_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Expression      : Cursor := No_Element;
      Until_Form      : Boolean := False)
      return Diana.Nodes.Delay_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Expression => Expression,
       Until_Form => Until_Form);

   function Accept_Statement
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Entry_Name         : Cursor := No_Element;
      Entry_Index        : Cursor := No_Element;
      Parameters         : Cursor := No_Element;
      Handled_Statements : Cursor := No_Element;
      Handlers           : Cursor := No_Element)
      return Diana.Nodes.Accept_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Entry_Name => Entry_Name,
       Entry_Index => Entry_Index,
       Parameters => Parameters,
       Handled_Statements => Handled_Statements,
       Handlers => Handlers);

   function Entry_Call
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Prefix             : Cursor := No_Element;
      Actuals            : Cursor := No_Element;
      Normalized_Actuals : Cursor := No_Element)
      return Diana.Nodes.Entry_Call
   is (Source_Position => Source_Position,
       Comments => Comments,
       Prefix => Prefix,
       Actuals => Actuals,
       Normalized_Actuals => Normalized_Actuals);

   function Requeue_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Target          : Cursor := No_Element;
      With_Abort      : Boolean := False)
      return Diana.Nodes.Requeue_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Target => Target,
       With_Abort => With_Abort);

   function Abort_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Tasks           : Cursor := No_Element)
      return Diana.Nodes.Abort_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Tasks => Tasks);

   function Parallel_Block
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Arms            : Cursor := No_Element)
      return Diana.Nodes.Parallel_Block
   is (Source_Position => Source_Position,
       Comments => Comments,
       Arms => Arms);

   function Statement_Pragma
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Pragma_Item     : Cursor := No_Element)
      return Diana.Nodes.Statement_Pragma
   is (Source_Position => Source_Position,
       Comments => Comments,
       Pragma_Item => Pragma_Item);

   function Conditional_Clause
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Condition       : Cursor := No_Element;
      Statements      : Cursor := No_Element)
      return Diana.Nodes.Conditional_Clause
   is (Source_Position => Source_Position,
       Comments => Comments,
       Condition => Condition,
       Statements => Statements);

   function Case_Alternative
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Choices         : Cursor := No_Element;
      Statements      : Cursor := No_Element)
      return Diana.Nodes.Case_Alternative
   is (Source_Position => Source_Position,
       Comments => Comments,
       Choices => Choices,
       Statements => Statements);

   function Alternative_Pragma
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Pragma_Item     : Cursor := No_Element)
      return Diana.Nodes.Alternative_Pragma
   is (Source_Position => Source_Position,
       Comments => Comments,
       Pragma_Item => Pragma_Item);

   function Exception_Handler
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Choice_Parameter : Cursor := No_Element;
      Choices          : Cursor := No_Element;
      Statements       : Cursor := No_Element)
      return Diana.Nodes.Exception_Handler
   is (Source_Position => Source_Position,
       Comments => Comments,
       Choice_Parameter => Choice_Parameter,
       Choices => Choices,
       Statements => Statements);

   function No_Iteration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.No_Iteration
   is (Source_Position => Source_Position,
       Comments => Comments);

   function While_Loop
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Condition       : Cursor := No_Element)
      return Diana.Nodes.While_Loop
   is (Source_Position => Source_Position,
       Comments => Comments,
       Condition => Condition);

   function For_Loop
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Iterator        : Cursor := No_Element;
      Parallelism     : Cursor := No_Element)
      return Diana.Nodes.For_Loop
   is (Source_Position => Source_Position,
       Comments => Comments,
       Iterator => Iterator,
       Parallelism => Parallelism);

   function Sequential
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Sequential
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Parallel_Chunked
     (Source_Position     : Diana.Source_Position := No_Position;
      Comments            : Diana.Comments := SU.Null_Unbounded_String;
      Chunk_Specification : Cursor := No_Element)
      return Diana.Nodes.Parallel_Chunked
   is (Source_Position => Source_Position,
       Comments => Comments,
       Chunk_Specification => Chunk_Specification);

   function Selective_Accept
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Alternatives    : Cursor := No_Element;
      Else_Statements : Cursor := No_Element)
      return Diana.Nodes.Selective_Accept
   is (Source_Position => Source_Position,
       Comments => Comments,
       Alternatives => Alternatives,
       Else_Statements => Else_Statements);

   function Conditional_Entry_Call
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Entry_Call      : Cursor := No_Element;
      Call_Statements : Cursor := No_Element;
      Else_Statements : Cursor := No_Element)
      return Diana.Nodes.Conditional_Entry_Call
   is (Source_Position => Source_Position,
       Comments => Comments,
       Entry_Call => Entry_Call,
       Call_Statements => Call_Statements,
       Else_Statements => Else_Statements);

   function Timed_Entry_Call
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Entry_Call       : Cursor := No_Element;
      Call_Statements  : Cursor := No_Element;
      Delay_Statement  : Cursor := No_Element;
      Delay_Statements : Cursor := No_Element)
      return Diana.Nodes.Timed_Entry_Call
   is (Source_Position => Source_Position,
       Comments => Comments,
       Entry_Call => Entry_Call,
       Call_Statements => Call_Statements,
       Delay_Statement => Delay_Statement,
       Delay_Statements => Delay_Statements);

   function Asynchronous_Select
     (Source_Position       : Diana.Source_Position := No_Position;
      Comments              : Diana.Comments := SU.Null_Unbounded_String;
      Trigger               : Cursor := No_Element;
      Triggering_Statements : Cursor := No_Element;
      Abortable_Statements  : Cursor := No_Element)
      return Diana.Nodes.Asynchronous_Select
   is (Source_Position => Source_Position,
       Comments => Comments,
       Trigger => Trigger,
       Triggering_Statements => Triggering_Statements,
       Abortable_Statements => Abortable_Statements);

   function Accept_Alternative
     (Source_Position  : Diana.Source_Position := No_Position;
      Comments         : Diana.Comments := SU.Null_Unbounded_String;
      Guard            : Cursor := No_Element;
      Accept_Statement : Cursor := No_Element;
      Statements       : Cursor := No_Element)
      return Diana.Nodes.Accept_Alternative
   is (Source_Position => Source_Position,
       Comments => Comments,
       Guard => Guard,
       Accept_Statement => Accept_Statement,
       Statements => Statements);

   function Delay_Alternative
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Guard           : Cursor := No_Element;
      Delay_Statement : Cursor := No_Element;
      Statements      : Cursor := No_Element)
      return Diana.Nodes.Delay_Alternative
   is (Source_Position => Source_Position,
       Comments => Comments,
       Guard => Guard,
       Delay_Statement => Delay_Statement,
       Statements => Statements);

   function Terminate_Alternative
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Guard           : Cursor := No_Element)
      return Diana.Nodes.Terminate_Alternative
   is (Source_Position => Source_Position,
       Comments => Comments,
       Guard => Guard);

   function Select_Alternative_Pragma
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Pragma_Item     : Cursor := No_Element)
      return Diana.Nodes.Select_Alternative_Pragma
   is (Source_Position => Source_Position,
       Comments => Comments,
       Pragma_Item => Pragma_Item);

   function Parallel_Arm
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Statements      : Cursor := No_Element)
      return Diana.Nodes.Parallel_Arm
   is (Source_Position => Source_Position,
       Comments => Comments,
       Statements => Statements);

   function Derived_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Parent          : Cursor := No_Element)
      return Diana.Nodes.Derived_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Parent => Parent);

   function Class_Wide_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Root_Type       : Cursor := No_Element)
      return Diana.Nodes.Class_Wide_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Root_Type => Root_Type);

   function Private_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Discriminants   : Cursor := No_Element;
      Ancestor        : Cursor := No_Element;
      Progenitors     : Cursor := No_Element;
      Is_Tagged       : Boolean := False;
      Is_Limited      : Boolean := False;
      Is_Abstract     : Boolean := False)
      return Diana.Nodes.Private_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Discriminants => Discriminants,
       Ancestor => Ancestor,
       Progenitors => Progenitors,
       Is_Tagged => Is_Tagged,
       Is_Limited => Is_Limited,
       Is_Abstract => Is_Abstract);

   function Incomplete_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Is_Tagged       : Boolean := False)
      return Diana.Nodes.Incomplete_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Is_Tagged => Is_Tagged);

   function Constrained_Spec
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Mark            : Cursor := No_Element;
      Constraint      : Cursor := No_Element)
      return Diana.Nodes.Constrained_Spec
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Mark => Mark,
       Constraint => Constraint);

   function Void
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Void
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Universal_Integer
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Universal_Integer
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Universal_Real
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Universal_Real
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Universal_Fixed
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Universal_Fixed
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Enumeration_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Literals        : Cursor := No_Element)
      return Diana.Nodes.Enumeration_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Literals => Literals);

   function Signed_Integer_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Bounds          : Cursor := No_Element)
      return Diana.Nodes.Signed_Integer_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Bounds => Bounds);

   function Modular_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Modulus         : Cursor := No_Element)
      return Diana.Nodes.Modular_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Modulus => Modulus);

   function Floating_Point_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Digits_Value    : Cursor := No_Element;
      Real_Range      : Cursor := No_Element)
      return Diana.Nodes.Floating_Point_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Digits_Value => Digits_Value,
       Real_Range => Real_Range);

   function Ordinary_Fixed_Point_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Delta_Value     : Cursor := No_Element;
      Real_Range      : Cursor := No_Element)
      return Diana.Nodes.Ordinary_Fixed_Point_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Delta_Value => Delta_Value,
       Real_Range => Real_Range);

   function Decimal_Fixed_Point_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Delta_Value     : Cursor := No_Element;
      Digits_Value    : Cursor := No_Element;
      Real_Range      : Cursor := No_Element)
      return Diana.Nodes.Decimal_Fixed_Point_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Delta_Value => Delta_Value,
       Digits_Value => Digits_Value,
       Real_Range => Real_Range);

   function Access_To_Object
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Designated      : Cursor := No_Element;
      Access_Kind     : Cursor := No_Element;
      Is_Anonymous    : Boolean := False)
      return Diana.Nodes.Access_To_Object
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Designated => Designated,
       Access_Kind => Access_Kind,
       Is_Anonymous => Is_Anonymous);

   function Access_To_Subprogram
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Profile         : Cursor := No_Element;
      Is_Protected    : Boolean := False;
      Is_Anonymous    : Boolean := False)
      return Diana.Nodes.Access_To_Subprogram
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Profile => Profile,
       Is_Protected => Is_Protected,
       Is_Anonymous => Is_Anonymous);

   function Pool_Specific
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Pool_Specific
   is (Source_Position => Source_Position,
       Comments => Comments);

   function General_Access_All
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.General_Access_All
   is (Source_Position => Source_Position,
       Comments => Comments);

   function General_Access_Constant
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.General_Access_Constant
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Array_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Index_Ranges    : Cursor := No_Element;
      Is_Constrained  : Boolean := False;
      Component       : Cursor := No_Element)
      return Diana.Nodes.Array_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Index_Ranges => Index_Ranges,
       Is_Constrained => Is_Constrained,
       Component => Component);

   function Record_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Components      : Cursor := No_Element)
      return Diana.Nodes.Record_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Components => Components);

   function Tagged_Record_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Ancestor        : Cursor := No_Element;
      Progenitors     : Cursor := No_Element;
      Components      : Cursor := No_Element)
      return Diana.Nodes.Tagged_Record_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Ancestor => Ancestor,
       Progenitors => Progenitors,
       Components => Components);

   function Interface_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Progenitors     : Cursor := No_Element;
      Kind            : Cursor := No_Element)
      return Diana.Nodes.Interface_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Progenitors => Progenitors,
       Kind => Kind);

   function Task_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Task_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Definition => Definition);

   function Protected_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Protected_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Definition => Definition);

   function Ordinary_Interface
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Ordinary_Interface
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Limited_Interface
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Limited_Interface
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Synchronized_Interface
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Synchronized_Interface
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Task_Interface
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Task_Interface
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Protected_Interface
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Protected_Interface
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Protected_Specification
     (Source_Position      : Diana.Source_Position := No_Position;
      Comments             : Diana.Comments := SU.Null_Unbounded_String;
      Visible_Declarations : Cursor := No_Element;
      Private_Declarations : Cursor := No_Element)
      return Diana.Nodes.Protected_Specification
   is (Source_Position => Source_Position,
       Comments => Comments,
       Visible_Declarations => Visible_Declarations,
       Private_Declarations => Private_Declarations);

   function Component_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element;
      Object_Subtype  : Cursor := No_Element;
      Initialization  : Cursor := No_Element)
      return Diana.Nodes.Component_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names,
       Object_Subtype => Object_Subtype,
       Initialization => Initialization);

   function Variant_Part
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Discriminant    : Cursor := No_Element;
      Variants        : Cursor := No_Element)
      return Diana.Nodes.Variant_Part
   is (Source_Position => Source_Position,
       Comments => Comments,
       Discriminant => Discriminant,
       Variants => Variants);

   function Null_Component
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Null_Component
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Component_Pragma
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Pragma_Item     : Cursor := No_Element)
      return Diana.Nodes.Component_Pragma
   is (Source_Position => Source_Position,
       Comments => Comments,
       Pragma_Item => Pragma_Item);

   function Variant
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Choices         : Cursor := No_Element;
      Components      : Cursor := No_Element)
      return Diana.Nodes.Variant
   is (Source_Position => Source_Position,
       Comments => Comments,
       Choices => Choices,
       Components => Components);

   function Discriminant_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Discriminant_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Index_Constraint
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Ranges          : Cursor := No_Element)
      return Diana.Nodes.Index_Constraint
   is (Source_Position => Source_Position,
       Comments => Comments,
       Ranges => Ranges);

   function Discriminant_Constraint
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Associations    : Cursor := No_Element;
      Normalized      : Cursor := No_Element)
      return Diana.Nodes.Discriminant_Constraint
   is (Source_Position => Source_Position,
       Comments => Comments,
       Associations => Associations,
       Normalized => Normalized);

   function Discrete_Subtype
     (Source_Position    : Diana.Source_Position := No_Position;
      Comments           : Diana.Comments := SU.Null_Unbounded_String;
      Subtype_Indication : Cursor := No_Element)
      return Diana.Nodes.Discrete_Subtype
   is (Source_Position => Source_Position,
       Comments => Comments,
       Subtype_Indication => Subtype_Indication);

   function Range_Bounds
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Lower           : Cursor := No_Element;
      Upper           : Cursor := No_Element)
      return Diana.Nodes.Range_Bounds
   is (Source_Position => Source_Position,
       Comments => Comments,
       Lower => Lower,
       Upper => Upper);

   function Range_Attribute
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Prefix          : Cursor := No_Element)
      return Diana.Nodes.Range_Attribute
   is (Source_Position => Source_Position,
       Comments => Comments,
       Prefix => Prefix);

   function Float_Constraint
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Digits_Value    : Cursor := No_Element;
      Real_Range      : Cursor := No_Element)
      return Diana.Nodes.Float_Constraint
   is (Source_Position => Source_Position,
       Comments => Comments,
       Digits_Value => Digits_Value,
       Real_Range => Real_Range);

   function Fixed_Constraint
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Delta_Value     : Cursor := No_Element;
      Real_Range      : Cursor := No_Element)
      return Diana.Nodes.Fixed_Constraint
   is (Source_Position => Source_Position,
       Comments => Comments,
       Delta_Value => Delta_Value,
       Real_Range => Real_Range);

   function Procedure_Header
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Parameters      : Cursor := No_Element)
      return Diana.Nodes.Procedure_Header
   is (Source_Position => Source_Position,
       Comments => Comments,
       Parameters => Parameters);

   function Function_Header
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Parameters      : Cursor := No_Element;
      Result_Subtype  : Cursor := No_Element)
      return Diana.Nodes.Function_Header
   is (Source_Position => Source_Position,
       Comments => Comments,
       Parameters => Parameters,
       Result_Subtype => Result_Subtype);

   function Entry_Header
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Family_Index    : Cursor := No_Element;
      Parameters      : Cursor := No_Element)
      return Diana.Nodes.Entry_Header
   is (Source_Position => Source_Position,
       Comments => Comments,
       Family_Index => Family_Index,
       Parameters => Parameters);

   function In_Parameter
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element;
      Type_Mark       : Cursor := No_Element;
      Default         : Cursor := No_Element;
      Is_Aliased      : Boolean := False)
      return Diana.Nodes.In_Parameter
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names,
       Type_Mark => Type_Mark,
       Default => Default,
       Is_Aliased => Is_Aliased);

   function Out_Parameter
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element;
      Type_Mark       : Cursor := No_Element;
      Is_Aliased      : Boolean := False)
      return Diana.Nodes.Out_Parameter
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names,
       Type_Mark => Type_Mark,
       Is_Aliased => Is_Aliased);

   function In_Out_Parameter
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element;
      Type_Mark       : Cursor := No_Element;
      Is_Aliased      : Boolean := False)
      return Diana.Nodes.In_Out_Parameter
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names,
       Type_Mark => Type_Mark,
       Is_Aliased => Is_Aliased);

   function Named_Subtype
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Mark            : Cursor := No_Element)
      return Diana.Nodes.Named_Subtype
   is (Source_Position => Source_Position,
       Comments => Comments,
       Mark => Mark);

   function Anonymous_Access
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Anonymous_Access
   is (Source_Position => Source_Position,
       Comments => Comments,
       Definition => Definition);

   function Package_Specification
     (Source_Position      : Diana.Source_Position := No_Position;
      Comments             : Diana.Comments := SU.Null_Unbounded_String;
      Visible_Declarations : Cursor := No_Element;
      Private_Declarations : Cursor := No_Element)
      return Diana.Nodes.Package_Specification
   is (Source_Position => Source_Position,
       Comments => Comments,
       Visible_Declarations => Visible_Declarations,
       Private_Declarations => Private_Declarations);

   function Block
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Declarations    : Cursor := No_Element;
      Statements      : Cursor := No_Element;
      Handlers        : Cursor := No_Element)
      return Diana.Nodes.Block
   is (Source_Position => Source_Position,
       Comments => Comments,
       Declarations => Declarations,
       Statements => Statements,
       Handlers => Handlers);

   function Stub
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Stub
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Unit_Instantiation
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Instance        : Cursor := No_Element)
      return Diana.Nodes.Unit_Instantiation
   is (Source_Position => Source_Position,
       Comments => Comments,
       Instance => Instance);

   function Unit_Renaming
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Renamed         : Cursor := No_Element)
      return Diana.Nodes.Unit_Renaming
   is (Source_Position => Source_Position,
       Comments => Comments,
       Renamed => Renamed);

   function Language_Binding
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Convention      : Cursor := No_Element)
      return Diana.Nodes.Language_Binding
   is (Source_Position => Source_Position,
       Comments => Comments,
       Convention => Convention);

   function Renaming
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Renamed         : Cursor := No_Element)
      return Diana.Nodes.Renaming
   is (Source_Position => Source_Position,
       Comments => Comments,
       Renamed => Renamed);

   function Task_Specification
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Declarations    : Cursor := No_Element)
      return Diana.Nodes.Task_Specification
   is (Source_Position => Source_Position,
       Comments => Comments,
       Declarations => Declarations);

   function Entry_Index_Definition
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Parameter       : Cursor := No_Element;
      Discrete_Range  : Cursor := No_Element)
      return Diana.Nodes.Entry_Index_Definition
   is (Source_Position => Source_Position,
       Comments => Comments,
       Parameter => Parameter,
       Discrete_Range => Discrete_Range);

   function Generic_Subprogram_Header
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Profile         : Cursor := No_Element)
      return Diana.Nodes.Generic_Subprogram_Header
   is (Source_Position => Source_Position,
       Comments => Comments,
       Profile => Profile);

   function Generic_Formal_Object
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element;
      Mode            : Cursor := No_Element;
      Subtype_Mark    : Cursor := No_Element;
      Default         : Cursor := No_Element)
      return Diana.Nodes.Generic_Formal_Object
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names,
       Mode => Mode,
       Subtype_Mark => Subtype_Mark,
       Default => Default);

   function Generic_Formal_Type_Declaration
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Definition      : Cursor := No_Element)
      return Diana.Nodes.Generic_Formal_Type_Declaration
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Definition => Definition);

   function Generic_Formal_Subprogram
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Specification   : Cursor := No_Element;
      Default         : Cursor := No_Element)
      return Diana.Nodes.Generic_Formal_Subprogram
   is (Source_Position => Source_Position,
       Comments => Comments,
       Specification => Specification,
       Default => Default);

   function Generic_Formal_Package
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Template        : Cursor := No_Element;
      Actuals         : Cursor := No_Element;
      Is_Box          : Boolean := False)
      return Diana.Nodes.Generic_Formal_Package
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Template => Template,
       Actuals => Actuals,
       Is_Box => Is_Box);

   function Generic_In
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Generic_In
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Generic_In_Out
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Generic_In_Out
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Default_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Subprogram      : Cursor := No_Element)
      return Diana.Nodes.Default_Name
   is (Source_Position => Source_Position,
       Comments => Comments,
       Subprogram => Subprogram);

   function Box
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Box
   is (Source_Position => Source_Position,
       Comments => Comments);

   function No_Default
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.No_Default
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Formal_Derived_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Parent          : Cursor := No_Element;
      Progenitors     : Cursor := No_Element;
      Is_Tagged       : Boolean := False;
      Is_Limited      : Boolean := False;
      Is_Abstract     : Boolean := False;
      Is_Synchronized : Boolean := False)
      return Diana.Nodes.Formal_Derived_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Parent => Parent,
       Progenitors => Progenitors,
       Is_Tagged => Is_Tagged,
       Is_Limited => Is_Limited,
       Is_Abstract => Is_Abstract,
       Is_Synchronized => Is_Synchronized);

   function Formal_Private_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Discriminants   : Cursor := No_Element;
      Is_Tagged       : Boolean := False;
      Is_Limited      : Boolean := False;
      Is_Abstract     : Boolean := False;
      Is_Synchronized : Boolean := False)
      return Diana.Nodes.Formal_Private_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Discriminants => Discriminants,
       Is_Tagged => Is_Tagged,
       Is_Limited => Is_Limited,
       Is_Abstract => Is_Abstract,
       Is_Synchronized => Is_Synchronized);

   function Formal_Incomplete_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Is_Tagged       : Boolean := False)
      return Diana.Nodes.Formal_Incomplete_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Is_Tagged => Is_Tagged);

   function Formal_Discrete
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Formal_Discrete
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Formal_Signed_Integer
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Formal_Signed_Integer
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Formal_Modular
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Formal_Modular
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Formal_Floating_Point
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Formal_Floating_Point
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Formal_Ordinary_Fixed
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Formal_Ordinary_Fixed
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Formal_Decimal_Fixed
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element)
      return Diana.Nodes.Formal_Decimal_Fixed
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties);

   function Formal_Access_To_Object
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Designated      : Cursor := No_Element;
      Access_Kind     : Cursor := No_Element)
      return Diana.Nodes.Formal_Access_To_Object
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Designated => Designated,
       Access_Kind => Access_Kind);

   function Formal_Access_To_Subprogram
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Profile         : Cursor := No_Element)
      return Diana.Nodes.Formal_Access_To_Subprogram
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Profile => Profile);

   function Formal_Array_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Index_Ranges    : Cursor := No_Element;
      Component       : Cursor := No_Element)
      return Diana.Nodes.Formal_Array_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Index_Ranges => Index_Ranges,
       Component => Component);

   function Formal_Interface_Type
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Progenitors     : Cursor := No_Element;
      Kind            : Cursor := No_Element)
      return Diana.Nodes.Formal_Interface_Type
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Progenitors => Progenitors,
       Kind => Kind);

   function From_Aspect
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.From_Aspect
   is (Source_Position => Source_Position,
       Comments => Comments);

   function From_Attribute_Clause
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.From_Attribute_Clause
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Value           : Cursor := No_Element)
      return Diana.Nodes.Aspect_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Value => Value);

   function Contract_Case_List
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Cases           : Cursor := No_Element)
      return Diana.Nodes.Contract_Case_List
   is (Source_Position => Source_Position,
       Comments => Comments,
       Cases => Cases);

   function Contract_Case
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Guard           : Cursor := No_Element;
      Consequence     : Cursor := No_Element)
      return Diana.Nodes.Contract_Case
   is (Source_Position => Source_Position,
       Comments => Comments,
       Guard => Guard,
       Consequence => Consequence);

   function Other_Property
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Property_Name   : Cursor := No_Element)
      return Diana.Nodes.Other_Property
   is (Source_Position => Source_Position,
       Comments => Comments,
       Property_Name => Property_Name);

   function Aspect_Pre
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Pre
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Post
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Post
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Type_Invariant
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Type_Invariant
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Predicate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Predicate
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Static_Predicate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Static_Predicate
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Dynamic_Predicate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Dynamic_Predicate
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Contract_Cases
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Contract_Cases
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Default_Initial_Condition
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Default_Initial_Condition
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Subprogram_Variant
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Subprogram_Variant
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Global
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Global
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Depends
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Depends
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Relaxed_Initialization
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Relaxed_Initialization
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Stable_Properties
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Stable_Properties
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Size
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Size
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Object_Size
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Object_Size
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Component_Size
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Component_Size
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Alignment
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Alignment
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Bit_Order
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Bit_Order
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Scalar_Storage_Order
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Scalar_Storage_Order
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Pack
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Pack
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Address
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Address
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Storage_Size
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Storage_Size
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Storage_Pool
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Storage_Pool
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Default_Storage_Pool
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Default_Storage_Pool
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Small
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Small
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Machine_Radix
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Machine_Radix
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Default_Value
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Default_Value
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Default_Component_Value
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Default_Component_Value
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Atomic
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Atomic
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Volatile
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Volatile
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Atomic_Components
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Atomic_Components
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Volatile_Components
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Volatile_Components
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Independent
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Independent
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Independent_Components
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Independent_Components
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_External_Tag
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_External_Tag
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Discard_Names
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Discard_Names
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Convention
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Convention
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Import
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Import
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Export
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Export
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_External_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_External_Name
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Link_Name
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Link_Name
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Pure
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Pure
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Preelaborate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Preelaborate
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Elaborate_Body
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Elaborate_Body
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Remote_Types
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Remote_Types
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Remote_Call_Interface
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Remote_Call_Interface
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Shared_Passive
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Shared_Passive
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Inline
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Inline
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_No_Return
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_No_Return
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Priority
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Priority
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Interrupt_Priority
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Interrupt_Priority
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_CPU
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_CPU
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Dispatching_Domain
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Dispatching_Domain
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Attach_Handler
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Attach_Handler
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Interrupt_Handler
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Interrupt_Handler
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Exclusive_Functions
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Exclusive_Functions
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Constant_Indexing
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Constant_Indexing
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Variable_Indexing
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Variable_Indexing
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Default_Iterator
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Default_Iterator
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Iterator_Element
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Iterator_Element
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Iterator_View
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Iterator_View
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Aggregate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Aggregate
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Iterable
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Iterable
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Integer_Literal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Integer_Literal
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Real_Literal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Real_Literal
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_String_Literal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_String_Literal
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Read
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Read
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Write
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Write
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Input
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Input
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Output
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Output
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Aspect_Put_Image
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Aspect_Put_Image
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Record_Representation
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Name            : Cursor := No_Element;
      Alignment       : Cursor := No_Element;
      Component_Reps  : Cursor := No_Element)
      return Diana.Nodes.Record_Representation
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Name => Name,
       Alignment => Alignment,
       Component_Reps => Component_Reps);

   function Address_Clause
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Name            : Cursor := No_Element;
      Address         : Cursor := No_Element)
      return Diana.Nodes.Address_Clause
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Name => Name,
       Address => Address);

   function Code_Statement
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Properties      : Cursor := No_Element;
      Subtype_Mark    : Cursor := No_Element;
      Aggregate       : Cursor := No_Element)
      return Diana.Nodes.Code_Statement
   is (Source_Position => Source_Position,
       Comments => Comments,
       Properties => Properties,
       Subtype_Mark => Subtype_Mark,
       Aggregate => Aggregate);

   function Component_Rep
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Position        : Cursor := No_Element;
      Bit_Range       : Cursor := No_Element)
      return Diana.Nodes.Component_Rep
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Position => Position,
       Bit_Range => Bit_Range);

   function Pragma_Item
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Name            : Cursor := No_Element;
      Arguments       : Cursor := No_Element)
      return Diana.Nodes.Pragma_Item
   is (Source_Position => Source_Position,
       Comments => Comments,
       Name => Name,
       Arguments => Arguments);

   function Op_And
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_And
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Or
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Or
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Xor
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Xor
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Equal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Equal
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Not_Equal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Not_Equal
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Less
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Less
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Less_Equal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Less_Equal
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Greater
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Greater
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Greater_Equal
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Greater_Equal
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Plus
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Plus
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Minus
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Minus
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Concatenate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Concatenate
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Unary_Plus
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Unary_Plus
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Unary_Minus
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Unary_Minus
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Absolute
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Absolute
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Not
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Not
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Multiply
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Multiply
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Divide
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Divide
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Modulo
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Modulo
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Remainder
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Remainder
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Op_Exponentiate
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Op_Exponentiate
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Compilation_Unit_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Compilation_Unit_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Context_Element_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Context_Element_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Declaration_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Declaration_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Item_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Item_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Defining_Name_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Defining_Name_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Name_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Name_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Expression_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Expression_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Association_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Association_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Statement_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Statement_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Alternative_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Alternative_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Choice_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Choice_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Membership_Choice_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Membership_Choice_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Conditional_Clause_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Conditional_Clause_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Expression_Clause_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Expression_Clause_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Expression_Alternative_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Expression_Alternative_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Select_Alternative_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Select_Alternative_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Parallel_Arm_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Parallel_Arm_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Contract_Case_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Contract_Case_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Component_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Component_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Variant_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Variant_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Discrete_Range_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Discrete_Range_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Parameter_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Parameter_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Generic_Formal_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Generic_Formal_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Component_Rep_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Component_Rep_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Semantic_Property_S
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      List            : Node_List := Node_Lists.Empty_Vector)
      return Diana.Nodes.Semantic_Property_S
   is (Source_Position => Source_Position,
       Comments => Comments,
       List => List);

   function Choice_Expression
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Value           : Cursor := No_Element)
      return Diana.Nodes.Choice_Expression
   is (Source_Position => Source_Position,
       Comments => Comments,
       Value => Value);

   function Choice_Range
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Range_Item      : Cursor := No_Element)
      return Diana.Nodes.Choice_Range
   is (Source_Position => Source_Position,
       Comments => Comments,
       Range_Item => Range_Item);

   function Others_Choice
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String)
      return Diana.Nodes.Others_Choice
   is (Source_Position => Source_Position,
       Comments => Comments);

   function Discriminant
     (Source_Position : Diana.Source_Position := No_Position;
      Comments        : Diana.Comments := SU.Null_Unbounded_String;
      Names           : Cursor := No_Element;
      Subtype_Mark    : Cursor := No_Element;
      Default         : Cursor := No_Element)
      return Diana.Nodes.Discriminant
   is (Source_Position => Source_Position,
       Comments => Comments,
       Names => Names,
       Subtype_Mark => Subtype_Mark,
       Default => Default);

end Diana.Builders;
