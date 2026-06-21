# DIANA Revision 3 — detailed per-node attribute lists

Exact node attribute signatures transcribed from §2 "Definition of the Diana Domain" of the
public-domain DIANA Reference Manual, Revision 3 (`references/DIANA_Rev3_ADA128232.pdf`).
Organised by Ada 83 LRM section, as the manual is. Notation: `node => as_… ; lx_… ; sm_… ; cd_…`
(structural / lexical / semantic / code attributes). Classes are `UPPER_CASE`, nodes `lower_case`.

**Status:** complete — covers §2.0 – §13 plus the predefined environment and the `Diana_Concrete`
refinement (PDF pp. 40–87). Companion to `DIANA_Rev3_distilled.md` (the class skeleton).

## Root + private types
- `Structure Diana Root COMPILATION`.
- Six implementation-defined private types: `source_position`, `comments`, `symbol_rep`,
  `value` (static-expression value; may indicate "no value"), `operator` (enum of all operators),
  `number_rep` (numeric-literal representation).
- `void => ;` (no attributes — the universal empty node).

## 2.3 Identifiers (no concrete syntax)
- `ID ::= DEF_ID | USED_ID` · `OP ::= DEF_OP | USED_OP` · `DESIGNATOR ::= ID | OP`
- `DEF_OCCURRENCE ::= DEF_ID | DEF_OP | DEF_CHAR`

## 2.8 Pragmas
- `pragma => as_id: ID (a used_name_id), as_param_assoc_s: PARAM_ASSOC_S ; lx_srcpos, lx_comments`
- `param_assoc_s => as_list: Seq Of PARAM_ASSOC ; lx_srcpos, lx_comments`

## 3.1 Declarations
- `DECL ::= constant | var | number | type | subtype | subprogram_decl | package_decl | task_decl | generic | exception | deferred_constant`
- `DECL ::= pragma`

## 3.2 Objects and named numbers  `[OBJECT_DEF ::= EXP_VOID; EXP_VOID ::= EXP | void; TYPE_SPEC ::= CONSTRAINED]`
- `constant => as_id_s: ID_S (const_id seq), as_type_spec: TYPE_SPEC, as_object_def: OBJECT_DEF ; lx_srcpos, lx_comments`
- `var      => as_id_s: ID_S (var_id seq), as_type_spec: TYPE_SPEC, as_object_def: OBJECT_DEF ; lx_srcpos, lx_comments`
- `var_id   => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC, sm_address: EXP_VOID, sm_obj_def: OBJECT_DEF`
- `const_id => lx_srcpos, lx_comments, lx_symrep ; sm_address: EXP_VOID, sm_obj_type: TYPE_SPEC, sm_obj_def: OBJECT_DEF, sm_first: DEF_OCCURRENCE (deferred)`
- `number   => as_id_s: ID_S (number_id seq), as_exp: EXP ; lx_srcpos, lx_comments`
- `number_id=> lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC (universal), sm_init_exp: EXP`
- `id_s => as_list: Seq Of ID ; lx_srcpos, lx_comments`

## 3.3.1 Type declarations
- `type    => as_id: ID (type_id / l_private_type_id / private_type_id), as_dscrmt_var_s: DSCRMT_VAR_S, as_type_spec: TYPE_SPEC ; lx_srcpos, lx_comments`
- `type_id => lx_srcpos, lx_comments, lx_symrep ; sm_type_spec: TYPE_SPEC, sm_first: DEF_OCCURRENCE`
- `TYPE_SPEC ::= enum_literal_s | integer | fixed | float | array | record | access | derived` (+ CONSTRAINED, FORMAL_TYPE_SPEC, private forms, universals, void)

## 3.3.2 Subtype declarations
- `subtype    => as_id: ID, as_constrained: CONSTRAINED ; lx_srcpos, lx_comments`
- `subtype_id => lx_srcpos, lx_comments, lx_symrep ; sm_type_spec: CONSTRAINED`
- `constrained => as_name: NAME, as_constraint: CONSTRAINT ; lx_srcpos, lx_comments ; sm_type_struct: TYPE_SPEC, sm_base_type: TYPE_SPEC, sm_constraint: CONSTRAINT ; cd_impl_size: Integer`
- `CONSTRAINT ::= RANGE | float | fixed | dscrt_range_s | dscrmt_aggregate | void`

## 3.4 Derived types
- `derived => as_constrained: CONSTRAINED ; lx_srcpos, lx_comments ; sm_size: EXP_VOID, sm_actual_delta: Rational, sm_packing: Boolean, sm_controlled: Boolean, sm_storage_size: EXP_VOID ; cd_impl_size: Integer`

## 3.5 Scalar / ranges  `[RANGE ::= range | attribute | attribute_call]`
- `range => as_exp1: EXP, as_exp2: EXP ; lx_srcpos, lx_comments ; sm_base_type: TYPE_SPEC`

## 3.5.1 Enumeration types  `[ENUM_LITERAL ::= enum_id | def_char]`
- `enum_literal_s => as_list: Seq Of ENUM_LITERAL ; lx_srcpos, lx_comments ; sm_size: EXP_VOID ; cd_impl_size: Integer`
- `enum_id  => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC (the enum_literal_s), sm_pos: Integer (base-0 position), sm_rep: Integer (user rep value)`
- `def_char => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC, sm_pos: Integer, sm_rep: Integer`

## 3.5.4 Integer types
- `integer => as_range: RANGE ; lx_srcpos, lx_comments ; sm_size: EXP_VOID, sm_type_struct: TYPE_SPEC, sm_base_type: TYPE_SPEC ; cd_impl_size: Integer`

## 3.5.7 Floating point  `[RANGE_VOID ::= RANGE | void]`
- `float => as_exp: EXP, as_range_void: RANGE_VOID ; lx_srcpos, lx_comments ; sm_size: EXP_VOID, sm_type_struct: TYPE_SPEC, sm_base_type: TYPE_SPEC ; cd_impl_size: Integer`

## 3.5.9 Fixed point
- `fixed => as_exp: EXP, as_range_void: RANGE_VOID ; lx_srcpos, lx_comments ; sm_size: EXP_VOID, sm_actual_delta: Rational, sm_bits: Integer, sm_base_type: TYPE_SPEC ; cd_impl_size: Integer`

## 3.6 Array types  `[DSCRT_RANGE ::= index | constrained | RANGE]`
- `array => as_dscrt_range_s: DSCRT_RANGE_S, as_constrained: CONSTRAINED (component subtype) ; lx_srcpos, lx_comments ; sm_size: EXP_VOID, sm_packing: Boolean`
- `dscrt_range_s => as_list: Seq Of DSCRT_RANGE ; lx_srcpos, lx_comments`
- `index => as_name: NAME ; lx_srcpos, lx_comments`

## 3.7 Record types  `[REP_VOID ::= REP | void; COMP ::= var | variant_part | null_comp | pragma]`
- `record => as_list: Seq Of COMP ; lx_srcpos, lx_comments ; sm_size: EXP_VOID, sm_discriminants: DSCRMT_VAR_S, sm_packing: Boolean, sm_record_spec: REP_VOID`
- `null_comp => lx_srcpos, lx_comments`
- `comp_id => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC, sm_init_exp: EXP_VOID, sm_comp_spec: COMP_REP_VOID`

## 3.7.1 Discriminants
- `dscrmt_var_s => as_list: Seq Of DSCRMT_VAR ; lx_srcpos, lx_comments`
- `dscrmt_var   => as_id_s: ID_S (dscrmt_id seq), as_name: NAME, as_object_def: OBJECT_DEF ; lx_srcpos, lx_comments`
- `dscrmt_id    => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC, sm_init_exp: EXP_VOID, sm_first: DEF_OCCURRENCE, sm_comp_spec: COMP_REP_VOID`

## 3.7.2 Discriminant constraints
- `dscrmt_aggregate => as_list: Seq Of COMP_ASSOC ; lx_srcpos, lx_comments ; sm_normalized_comp_s: EXP_S`

## 3.7.3 Variant parts
- `variant_part => as_name: NAME, as_variant_s: VARIANT_S ; lx_srcpos, lx_comments`
- `variant_s => as_list: Seq Of VARIANT ; lx_srcpos, lx_comments`
- `choice_s  => as_list: Seq Of CHOICE ; lx_srcpos, lx_comments`
- `variant   => as_choice_s: CHOICE_S, as_record: INNER_RECORD ; lx_srcpos, lx_comments`
- `inner_record => as_list: Seq Of COMP ; lx_srcpos, lx_comments`
- `CHOICE ::= EXP | DSCRT_RANGE | others` · `others => lx_srcpos, lx_comments`

## 3.8 Access types
- `access => as_constrained: CONSTRAINED ; lx_srcpos, lx_comments ; sm_size: EXP_VOID, sm_storage_size: EXP_VOID, sm_controlled: Boolean`

## 3.8.1 Incomplete types
- `TYPE_SPEC ::= void` (the incomplete type's spec is `void` until completed).

## 3.9 Declarative parts  `[ITEM ::= DECL | subprogram_body | package_body | task_body]`
- `DECL ::= REP | use` (representation clauses and use clauses are declarations)
- `item_s => as_list: Seq Of ITEM ; lx_srcpos, lx_comments`

## 4.1 Names  `[NAME ::= DESIGNATOR | used_char | indexed | slice | selected | all | attribute | attribute_call | function_call]`
- `used_object_id => lx_srcpos, lx_comments, lx_symrep ; sm_exp_type: TYPE_SPEC, sm_defn: DEF_OCCURRENCE, sm_value: value`
- `used_name_id   => lx_srcpos, lx_comments, lx_symrep ; sm_defn: DEF_OCCURRENCE`
- `used_bltn_id   => lx_srcpos, lx_comments, lx_symrep ; sm_operator: operator`
- `used_op        => lx_srcpos, lx_comments, lx_symrep ; sm_defn: DEF_OCCURRENCE`
- `used_bltn_op   => lx_srcpos, lx_comments, lx_symrep ; sm_operator: operator`
- `used_char      => lx_srcpos, lx_comments, lx_symrep ; sm_defn: DEF_OCCURRENCE, sm_exp_type: TYPE_SPEC, sm_value: value`

## 4.1.1 Indexed components
- `exp_s   => as_list: Seq Of EXP ; lx_srcpos, lx_comments`
- `indexed => as_name: NAME, as_exp_s: EXP_S ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC`

## 4.1.2 Slices
- `slice => as_name: NAME, as_dscrt_range: DSCRT_RANGE ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_constraint: CONSTRAINT`

## 4.1.3 Selected components  `[DESIGNATOR_CHAR ::= DESIGNATOR | used_char]`
- `selected => as_name: NAME, as_designator_char: DESIGNATOR_CHAR ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC`
- `all      => as_name: NAME ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC`  (for `name.all`)

## 4.1.4 Attributes
- `attribute      => as_name: NAME, as_id: ID (used_name_id → predefined attr_id) ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value`
- `attribute_call => as_name: NAME, as_exp: EXP ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value`  (attribute with an argument)

## 4.2 Literals
- The enumeration literal in an expression is a `used_object_id` or `used_char` whose `sm_defn` points to an `enum_id`/`def_char`. (numeric_literal, string_literal, null_access → 4.4.)

## 4.3 Aggregates  `[COMP_ASSOC ::= named | EXP]`
- `aggregate => as_list: Seq Of COMP_ASSOC ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_constraint: CONSTRAINT, sm_normalized_comp_s: EXP_S`
- `named     => as_choice_s: CHOICE_S, as_exp: EXP ; lx_srcpos, lx_comments`

## 4.4 Expressions (short-circuit + membership only; other operators are function_call)
- `binary => as_exp1: EXP, as_binary_op: BINARY_OP, as_exp2: EXP ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC (Boolean), sm_value: value`
- `BINARY_OP ::= SHORT_CIRCUIT_OP` · `SHORT_CIRCUIT_OP ::= and_then | or_else` (each `=> lx_srcpos, lx_comments`)
- `membership => as_exp: EXP, as_membership_op: MEMBERSHIP_OP, as_type_range: TYPE_RANGE ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC (Boolean), sm_value: value`
- `TYPE_RANGE ::= RANGE | NAME` · `MEMBERSHIP_OP ::= in_op | not_in` (each `=> lx_srcpos, lx_comments`)

## 4.4.C/D Literals and parenthesized  `[EXP ::= NAME | numeric_literal | null_access | aggregate | string_literal | allocator | conversion | qualified | parenthesized]`
- `parenthesized   => as_exp: EXP ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value`
- `numeric_literal => lx_srcpos, lx_comments, lx_numrep: number_rep ; sm_exp_type: TYPE_SPEC, sm_value: value`
- `string_literal  => lx_srcpos, lx_comments, lx_symrep ; sm_exp_type: TYPE_SPEC, sm_constraint: CONSTRAINT, sm_value: value`
- `null_access     => lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value`

## 4.5 Operators
No new nodes: all operators are encoded as `function_call`; the operator set is defined in the `Diana_Concrete` refinement (the private `operator` type).

## 4.6 / 4.7 / 4.8 Conversions, qualified expressions, allocators  `[EXP_CONSTRAINED ::= EXP | CONSTRAINED]`
- `conversion => as_name: NAME, as_exp: EXP ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value`
- `qualified  => as_name: NAME, as_exp: EXP ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value`
- `allocator  => as_exp_constrained: EXP_CONSTRAINED ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value`

## 5.1 Statements  `[STM ::= null_stm|assign|procedure_call|exit|return|goto|entry_call|delay|abort|raise|code | if|case|named_stm|LOOP|block|accept|select|cond_entry|timed_entry | labeled | pragma]`
- `stm_s    => as_list: Seq Of STM ; lx_srcpos, lx_comments`
- `labeled  => as_id_s: ID_S (label_id seq), as_stm: STM ; lx_srcpos, lx_comments`
- `label_id => lx_srcpos, lx_comments, lx_symrep ; sm_stm: STM (always the 'labeled')`
- `null_stm => lx_srcpos, lx_comments`

## 5.2 Assignment
- `assign => as_name: NAME, as_exp: EXP ; lx_srcpos, lx_comments`

## 5.3 If statements
- `if          => as_list: Seq Of COND_CLAUSE ; lx_srcpos, lx_comments`
- `cond_clause => as_exp_void: EXP_VOID (void for the else arm), as_stm_s: STM_S ; lx_srcpos, lx_comments`

## 5.4 Case statements  `[ALTERNATIVE ::= alternative | pragma]`
- `case          => as_exp: EXP, as_alternative_s: ALTERNATIVE_S ; lx_srcpos, lx_comments`
- `alternative_s => as_list: Seq Of ALTERNATIVE ; lx_srcpos, lx_comments`
- `alternative   => as_choice_s: CHOICE_S, as_stm_s: STM_S ; lx_srcpos, lx_comments`

## 5.5 Loop statements  `[LOOP ::= loop; ITERATION ::= void | for | reverse | while]`
- `named_stm    => as_id: ID (named_stm_id), as_stm: STM (a 'loop' or 'block') ; lx_srcpos, lx_comments`
- `named_stm_id => lx_srcpos, lx_comments, lx_symrep ; sm_stm: STM (always the 'named_stm')`
- `loop         => as_iteration: ITERATION, as_stm_s: STM_S ; lx_srcpos, lx_comments`
- `for / reverse => as_id: ID (iteration_id), as_dscrt_range: DSCRT_RANGE ; lx_srcpos, lx_comments`
- `iteration_id => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC`
- `while        => as_exp: EXP ; lx_srcpos, lx_comments`

## 5.6 Block statements
- `block => as_item_s: ITEM_S, as_stm_s: STM_S, as_alternative_s: ALTERNATIVE_S (exception handlers) ; lx_srcpos, lx_comments`

## 5.7 / 5.8 / 5.9 Exit, return, goto  `[NAME_VOID ::= NAME | void]`
- `exit   => as_name_void: NAME_VOID, as_exp_void: EXP_VOID (when-condition) ; lx_srcpos, lx_comments ; sm_stm: LOOP (computed even if unnamed)`
- `return => as_exp_void: EXP_VOID ; lx_srcpos, lx_comments`
- `goto   => as_name: NAME ; lx_srcpos, lx_comments`

## 6.1 Subprogram declarations  `[SUBPROGRAM_DEF ::= void here; LOCATION ::= EXP_VOID | pragma_id; SUBP_BODY_DESC ::= block|stub|instantiation|FORMAL_SUBPROG_DEF|rename|LANGUAGE|void; LANGUAGE ::= argument_id]`
- `subprogram_decl => as_designator: DESIGNATOR, as_header: HEADER, as_subprogram_def: SUBPROGRAM_DEF ; lx_srcpos, lx_comments`
- `proc_id / function_id / def_op => lx_srcpos, lx_comments, lx_symrep ; sm_spec: HEADER, sm_body: SUBP_BODY_DESC, sm_location: LOCATION, sm_stub: DEF_OCCURRENCE, sm_first: DEF_OCCURRENCE`

## 6.1.B Subprogram specification  `[HEADER ::= procedure | function]`
- `procedure => as_param_s: PARAM_S ; lx_srcpos, lx_comments`
- `function  => as_param_s: PARAM_S, as_name_void: NAME_VOID (result; void for instantiation) ; lx_srcpos, lx_comments`

## 6.1.C Formal part  `[PARAM ::= in | in_out | out]`
- `param_s => as_list: Seq Of PARAM ; lx_srcpos, lx_comments`
- `in      => as_id_s: ID_S (in_id seq), as_name: NAME, as_exp_void: EXP_VOID (default) ; lx_srcpos, lx_comments, lx_default: Boolean`
- `in_out  => as_id_s: ID_S (in_out_id seq), as_name: NAME, as_exp_void: EXP_VOID (always void) ; lx_srcpos, lx_comments`
- `out     => as_id_s: ID_S (out_id seq), as_name: NAME, as_exp_void: EXP_VOID (always void) ; lx_srcpos, lx_comments`
- `in_id      => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC, sm_init_exp: EXP_VOID, sm_first: DEF_OCCURRENCE`
- `in_out_id  => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC, sm_first: DEF_OCCURRENCE`
- `out_id     => lx_srcpos, lx_comments, lx_symrep ; sm_obj_type: TYPE_SPEC, sm_first: DEF_OCCURRENCE`

## 6.3 Subprogram bodies  `[BLOCK_STUB ::= block | stub]`
- `subprogram_body => as_designator: DESIGNATOR (proc_id/function_id/def_op), as_header: HEADER, as_block_stub: BLOCK_STUB ; lx_srcpos, lx_comments`

## 6.4 Subprogram calls  `[PARAM_ASSOC ::= EXP | assoc; ACTUAL ::= EXP]`
- `procedure_call => as_name: NAME, as_param_assoc_s: PARAM_ASSOC_S ; lx_srcpos, lx_comments ; sm_normalized_param_s: EXP_S`
- `function_call  => as_name: NAME, as_param_assoc_s: PARAM_ASSOC_S ; lx_srcpos, lx_comments ; sm_exp_type: TYPE_SPEC, sm_value: value, sm_normalized_param_s: EXP_S, lx_prefix: Boolean`
- `assoc          => as_designator: DESIGNATOR, as_actual: ACTUAL ; lx_srcpos, lx_comments`

## 7.1 Packages  `[PACKAGE_DEF / PACKAGE_SPEC ::= package_spec; PACK_BODY_DESC ::= block|stub|rename|instantiation|void]`
- `package_decl => as_id: ID (package_id), as_package_def: PACKAGE_DEF ; lx_srcpos, lx_comments`
- `package_id   => lx_srcpos, lx_comments, lx_symrep ; sm_spec: PACKAGE_SPEC, sm_body: PACK_BODY_DESC, sm_address: EXP_VOID, sm_stub: DEF_OCCURRENCE, sm_first: DEF_OCCURRENCE`
- `package_spec => as_decl_s1: DECL_S (visible), as_decl_s2: DECL_S (private) ; lx_srcpos, lx_comments`
- `decl_s       => as_list: Seq Of DECL ; lx_srcpos, lx_comments`
- `package_body => as_id: ID (package_id), as_block_stub: BLOCK_STUB ; lx_srcpos, lx_comments`

## 7.4 Private types and deferred constants  `[TYPE_SPEC ::= private | l_private]`
- `private / l_private => lx_srcpos, lx_comments ; sm_discriminants: DSCRMT_VAR_S`
- `private_type_id / l_private_type_id => lx_srcpos, lx_comments, lx_symrep ; sm_type_spec: TYPE_SPEC (the complete/full type)`
- `deferred_constant => as_id_s: ID_S (const_id seq), as_name: NAME ; lx_srcpos, lx_comments`

## 8.4 / 8.5 Use clauses and renaming  `[OBJECT_DEF / EXCEPTION_DEF / PACKAGE_DEF / SUBPROGRAM_DEF ::= rename]`
- `use    => as_list: Seq Of NAME ; lx_srcpos, lx_comments`
- `rename => as_name: NAME ; lx_srcpos, lx_comments`  (one node; the enclosing `*_DEF` class distinguishes what is renamed)

## 9.1 Tasks  `[TASK_DEF ::= task_spec; TYPE_SPEC ::= task_spec; BLOCK_STUB_VOID ::= block | stub | void]`
- `task_decl    => as_id: ID (a var_id), as_task_def: TASK_DEF ; lx_srcpos, lx_comments`
- `task_spec    => as_decl_s: DECL_S ; lx_srcpos, lx_comments ; sm_body: BLOCK_STUB_VOID (void only under separate compilation), sm_address: EXP_VOID, sm_storage_size: EXP_VOID`
- `task_body    => as_id: ID (task_body_id), as_block_stub: BLOCK_STUB ; lx_srcpos, lx_comments`
- `task_body_id => lx_srcpos, lx_comments, lx_symrep ; sm_type_spec: TYPE_SPEC, sm_body: BLOCK_STUB_VOID, sm_first: DEF_OCCURRENCE, sm_stub: DEF_OCCURRENCE`

## 9.5 Entries, entry calls, accept  `[HEADER ::= entry; DSCRT_RANGE_VOID ::= DSCRT_RANGE | void]`
- `entry      => as_dscrt_range_void: DSCRT_RANGE_VOID (family index), as_param_s: PARAM_S ; lx_srcpos, lx_comments`
- `entry_id   => lx_srcpos, lx_comments, lx_symrep ; sm_spec: HEADER, sm_address: EXP_VOID`
- `entry_call => as_name: NAME (indexed for an entry family), as_param_assoc_s: PARAM_ASSOC_S ; lx_srcpos, lx_comments ; sm_normalized_param_s: EXP_S`
- `accept     => as_name: NAME, as_param_s: PARAM_S, as_stm_s: STM_S ; lx_srcpos, lx_comments`

## 9.6 Delay
- `delay => as_exp: EXP ; lx_srcpos, lx_comments`

## 9.7 Select statements  `[SELECT_CLAUSE ::= select_clause | pragma]`
- `select        => as_select_clause_s: SELECT_CLAUSE_S, as_stm_s: STM_S (else part) ; lx_srcpos, lx_comments`
- `select_clause_s => as_list: Seq Of SELECT_CLAUSE ; lx_srcpos, lx_comments`
- `select_clause => as_exp_void: EXP_VOID (guard), as_stm_s: STM_S (first stm is accept or delay) ; lx_srcpos, lx_comments`
- `terminate     => lx_srcpos, lx_comments`  (`STM ::= terminate`)
- `cond_entry    => as_stm_s1: STM_S (first stm is entry_call), as_stm_s2: STM_S (else) ; lx_srcpos, lx_comments`
- `timed_entry   => as_stm_s1: STM_S (first stm is entry_call), as_stm_s2: STM_S (first stm is delay) ; lx_srcpos, lx_comments`

## 9.10 Abort  `[NAME_S ::= name_s]`
- `name_s => as_list: Seq Of NAME ; lx_srcpos, lx_comments`
- `abort  => as_name_s: NAME_S ; lx_srcpos, lx_comments`

## 10.1 Compilation units  `[UNIT_BODY ::= package_body | package_decl | subunit | generic | subprogram_body | subprogram_decl | void; CONTEXT_ELEM ::= pragma | use | with]`
- `compilation => as_list: Seq Of COMP_UNIT ; lx_srcpos, lx_comments`
- `comp_unit   => as_context: CONTEXT, as_unit_body: UNIT_BODY, as_pragma_s: PRAGMA_S ; lx_srcpos, lx_comments`
- `pragma_s    => as_list: Seq Of PRAGMA ; lx_srcpos, lx_comments`
- `context     => as_list: Seq Of CONTEXT_ELEM ; lx_srcpos, lx_comments`
- `with        => as_list: Seq Of NAME ; lx_srcpos, lx_comments`
- (`UNIT_BODY` is `void` only when the comp_unit is just pragmas.)

## 10.2 Subunits  `[SUBUNIT_BODY ::= subprogram_body | package_body | task_body; BLOCK_STUB ::= stub]`
- `subunit => as_name: NAME (parent), as_subunit_body: SUBUNIT_BODY ; lx_srcpos, lx_comments`
- `stub    => lx_srcpos, lx_comments`

## 11 Exceptions  `[EXCEPTION_DEF ::= void (here)]`
- `exception    => as_id_s: ID_S (exception_id seq), as_exception_def: EXCEPTION_DEF ; lx_srcpos, lx_comments`
- `exception_id => lx_srcpos, lx_comments, lx_symrep ; sm_exception_def: EXCEPTION_DEF`
- `raise        => as_name_void: NAME_VOID ; lx_srcpos, lx_comments`

## 12.1 Generic declarations  `[GENERIC_HEADER ::= procedure | function | package_spec; GENERIC_PARAM ::= in | in_out | type | subprogram_decl]`
- `generic    => as_id: ID (generic_id), as_generic_param_s: GENERIC_PARAM_S, as_generic_header: GENERIC_HEADER ; lx_srcpos, lx_comments`
- `generic_id => lx_srcpos, lx_comments, lx_symrep ; sm_generic_param_s: GENERIC_PARAM_S, sm_spec: GENERIC_HEADER, sm_body: BLOCK_STUB_VOID, sm_first: DEF_OCCURRENCE, sm_stub: DEF_OCCURRENCE`
- `generic_param_s => as_list: Seq Of GENERIC_PARAM ; lx_srcpos, lx_comments`
- Formal subprograms: `SUBPROGRAM_DEF ::= FORMAL_SUBPROG_DEF` · `FORMAL_SUBPROG_DEF ::= NAME | box | no_default` (`box`, `no_default` each `=> lx_srcpos, lx_comments`)
- Formal types: `TYPE_SPEC ::= FORMAL_TYPE_SPEC` · `FORMAL_TYPE_SPEC ::= formal_dscrt (<>) | formal_integer (range <>) | formal_fixed (delta <>) | formal_float (digits <>)` (each `=> lx_srcpos, lx_comments`)

## 12.3 Generic instantiation  `[SUBPROGRAM_DEF / PACKAGE_DEF ::= instantiation; GENERIC_ASSOC ::= assoc | ACTUAL]`
- `instantiation   => as_name: NAME, as_generic_assoc_s: GENERIC_ASSOC_S ; lx_srcpos, lx_comments ; sm_decl_s: DECL_S (the expanded spec declarations)`
- `generic_assoc_s => as_list: Seq Of GENERIC_ASSOC ; lx_srcpos, lx_comments`

## 13 Representation clauses  `[REP ::= simple_rep | address | record_rep; COMP_REP ::= comp_rep | pragma; ALIGNMENT ::= alignment]`
- `simple_rep => as_name: NAME, as_exp: EXP ; lx_srcpos, lx_comments`  (length clause **and** enumeration representation clause — both collapse here)
- `record_rep => as_name: NAME, as_alignment: ALIGNMENT, as_comp_rep_s: COMP_REP_S ; lx_srcpos, lx_comments`
- `alignment  => as_pragma_s: PRAGMA_S, as_exp_void: EXP_VOID ; lx_srcpos, lx_comments`
- `comp_rep_s => as_list: Seq Of COMP_REP ; lx_srcpos, lx_comments`
- `comp_rep   => as_name: NAME, as_exp: EXP, as_range: RANGE ; lx_srcpos, lx_comments`
- `address    => as_name: NAME, as_exp: EXP ; lx_srcpos, lx_comments`  (address clause, 13.5)
- `code       => as_name: NAME, as_exp: EXP ; lx_srcpos, lx_comments`  (machine-code insertion, 13.8)
- §14 I/O: no special nodes — I/O is ordinary procedure/function calls.

## Predefined environment  `[DEF_ID ::= attr_id | pragma_id | ARGUMENT; ARGUMENT ::= argument_id]`
- `attr_id     => lx_symrep: symbol_rep`
- `argument_id => lx_symrep: symbol_rep`
- `pragma_id   => as_list: Seq Of ARGUMENT ; lx_symrep: symbol_rep`
- `TYPE_SPEC ::= universal_integer | universal_fixed | universal_real` (each `=> ;`)

## `Diana_Concrete` refinement — operator set and value model
`Structure Diana_Concrete Refines Diana`. Binds the six private types to user packages (`For source_position Use USERPK.SOURCE_POSITION;` etc.) and defines external representations. Two classes worth lifting into DIANA_2022:
- `OP_CLASS` (external rep of `operator`; the full Ada operator enumeration, all attribute-less nodes):
  `and, or, xor, eq (=), ne (/=), lt (<), le (<=), gt (>), ge (>=), plus (+), minus (-), cat (&), unary_plus (+), unary_minus (-), abs, not, mult (*), div (/), mod, rem, exp (**)`.
- `VAL_CLASS` (external rep of `value`):
  `no_value => ;` · `string_value => str_val: String` · `bool_value => boo_val: Boolean` · `int_value => int_val: Integer` · `real_value => rtn_val: Rational`.
