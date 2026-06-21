# DIANA Revision 3 — distilled node taxonomy

A clean, searchable distillation of the historical DIANA node set, transcribed from the
scanned (public-domain) DIANA Reference Manual, Revision 3 — Appendix IV "Diana Summary"
(doc pp. 171–184), Appendix V "Diana Names" (pp. 185–192), and §3.3 "Name Binding"
(pp. 85–88). Source PDF: `references/DIANA_Rev3_ADA128232.pdf`.

Purpose: this is the canonical historical vocabulary that DIANA_2022 must stay
backwards-compatible with. The short lower-case names below are what the `Renames`
compatibility layer should expose. Section numbers in `[ ]` are Ada 83 LRM sections.
OCR was imperfect on the scan; a few names may need verification against §2 of the manual.

## Conventions (recap)
- **CLASS** names are UPPER_CASE; **node** names are lower_case; *attributes* are prefixed.
- Attribute prefixes: `as_` structural, `lx_` lexical, `sm_` semantic, `cd_` code.
- Nearly every node carries `lx_srcpos: source_position` and `lx_comments: comments`.
  Defining/used identifier nodes also carry `lx_symrep: symbol_rep` (the spelling).
- `_S`/`_s` = sequence idiom; `_VOID` = optional idiom (`X_VOID ::= X | void`).

## Top-level structure
- `COMPILATION ::= compilation` — root. `compilation => as_list: seq of COMP_UNIT`.
- `COMP_UNIT ::= comp_unit`. `comp_unit => as_context: CONTEXT, as_unit_body: UNIT_BODY, as_pragma_s: PRAGMA_S`.
- `CONTEXT ::= context`; `CONTEXT_ELEM ::= with | use | pragma`.
- `UNIT_BODY ::= package_body | package_decl | subunit | generic | subprogram_body | subprogram_decl | void`.

## Declarations
- `DECL ::= constant | var | number | type | subtype | subprogram_decl | package_decl | task_decl | generic | exception | deferred_constant`
- also `DECL ::= REP | use` and `DECL ::= pragma`
- `DECL_S ::= decl_s`; `ITEM ::= DECL | subprogram_body | package_body | task_body`; `ITEM_S ::= item_s`.
- Bodies: `subprogram_body`, `package_body`, `task_body`; `subunit`; stubs via `BLOCK_STUB ::= block | stub`, `BLOCK_STUB_VOID ::= block | stub | void`.

## Defining vs. used occurrences (the symbol table)
- `DEF_OCCURRENCE ::= DEF_ID | DEF_OP | DEF_CHAR`
- `DEF_ID ::= argument_id | attr_id | comp_id | const_id | dscrmt_id | entry_id | enum_id | exception_id | function_id | generic_id | in_id | in_out_id | iteration_id | label_id | l_private_type_id | named_stm_id | number_id | out_id | package_id | pragma_id | private_type_id | proc_id | subtype_id | task_body_id | type_id | var_id`
- `DEF_OP ::= def_op`; `DEF_CHAR ::= def_char`; `ENUM_LITERAL ::= enum_id | def_char`.
- `ID ::= DEF_ID | USED_ID`; `ID_S ::= id_s`.
- `USED_ID ::= used_name_id | used_object_id | used_bltn_id` (uses point back via `sm_defn`).
- `USED_OP ::= used_op | used_bltn_op` (point back via `sm_defn` / `sm_operator`).
- Each `DEF_ID` holds the entity's semantic attributes, e.g. `const_id => sm_address, sm_obj_type, sm_obj_def, sm_first`; `type_id => sm_type_spec, sm_first`; `proc_id`/`function_id => sm_spec: HEADER, sm_body: SUBP_BODY_DESC, sm_location, sm_stub, sm_first`.
- Multiple defining occurrences are tied together by `sm_first` (incomplete/private types, deferred constants, spec+body).

## Names and designators
- `NAME ::= DESIGNATOR | used_char | indexed | slice | selected | all | attribute | attribute_call | function_call`
- `DESIGNATOR ::= ID | OP`; `DESIGNATOR_CHAR ::= DESIGNATOR | used_char`.
- `OP ::= DEF_OP | USED_OP`.
- `NAME_S ::= name_s`; `NAME_VOID ::= NAME | void`.

## Expressions
- `EXP ::= NAME | numeric_literal | null_access | aggregate | string_literal | allocator | conversion | qualified | parenthesized`
- also `EXP ::= aggregate`, `EXP ::= binary`, `EXP ::= membership`
- `EXP_S ::= exp_s`; `EXP_VOID ::= EXP | void`; `EXP_CONSTRAINED ::= EXP CONSTRAINED`.
- `binary => as_exp1, as_binary_op: BINARY_OP, as_exp2`. `BINARY_OP ::= SHORT_CIRCUIT_OP` (and the function-call-encoded arithmetic/relational ops).
- `SHORT_CIRCUIT_OP ::= and_then | or_else`; `MEMBERSHIP_OP ::= in_op | not_in`.
- `function_call => as_name: NAME, as_param_assoc_s: PARAM_ASSOC_S` (encodes ordinary calls *and* overloadable operators; `lx_prefix: Boolean` records infix vs prefix).
- `ACTUAL ::= EXP`; `COMP_ASSOC ::= named | EXP`; `CHOICE ::= EXP | DSCRT_RANGE | others`; `CHOICE_S ::= choice_s`.
- `PARAM_ASSOC ::= EXP | assoc`; `PARAM_ASSOC_S ::= param_assoc_s`.

## Statements
- `STM ::= if | case | named_stm | LOOP | block | accept | select | cond_entry | timed_entry`
- also `STM ::= labeled`, `STM ::= null_stm | assign | procedure_call | exit | return | goto | entry_call | delay | abort | raise | code`, `STM ::= pragma | terminate`
- `STM_S ::= stm_s`; `LOOP ::= loop`.
- `ITERATION ::= void | while | for | reverse`.
- `ALTERNATIVE ::= alternative | pragma`; `ALTERNATIVE_S ::= alternative_s`.
- `COND_CLAUSE ::= cond_clause`; `SELECT_CLAUSE ::= select_clause | pragma`; `SELECT_CLAUSE_S ::= select_clause_s`.

## Types
- `TYPE_SPEC ::= CONSTRAINED | FORMAL_TYPE_SPEC | enum_literal_s | integer | fixed | float | array | record | access | derived`
- also `TYPE_SPEC ::= l_private | private | task_spec | universal_integer | universal_fixed | universal_real | void`
- `CONSTRAINED ::= constrained`; `constrained => as_name: NAME, as_constraint: CONSTRAINT`.
- `CONSTRAINT ::= RANGE | float | fixed | dscrt_range_s | dscrmt_aggregate | void`.
- `RANGE ::= range | attribute | attribute_call`; `RANGE_VOID ::= RANGE | void`; `TYPE_RANGE ::= RANGE | NAME`.
- `DSCRT_RANGE ::= constrained | RANGE`; `DSCRT_RANGE_S ::= dscrt_range_s`; `DSCRT_RANGE_VOID ::= DSCRT_RANGE | void`.
- Records: `record => sm_discriminants: DSCRMT_VAR_S, ...`; `COMP ::= pragma | var | variant_part | null_comp`; `INNER_RECORD ::= inner_record`; `VARIANT ::= variant`; `VARIANT_S ::= variant_s`.
- Discriminants: `DSCRMT_VAR ::= dscrmt_var`; `DSCRMT_VAR_S ::= dscrmt_var_s`.
- Representation: `REP ::= simple_rep | address | record_rep`; `REP_VOID ::= REP | void`; `COMP_REP ::= comp_rep | pragma`; `COMP_REP_S`; `COMP_REP_VOID`; `ALIGNMENT ::= alignment`.

## Subprograms, packages, tasks
- `HEADER ::= entry | function | procedure` (the parameter/result profile).
- `subprogram_decl => as_designator: DESIGNATOR, as_header: HEADER, as_subprogram_def: SUBPROGRAM_DEF`.
- `SUBPROGRAM_DEF ::= FORMAL_SUBPROG_DEF | instantiation | rename | void`.
- `SUBP_BODY_DESC ::= block | stub | instantiation | FORMAL_SUBPROG_DEF | rename | LANGUAGE | void`.
- `PARAM ::= in | in_out | out`; `PARAM_S ::= param_s`.
- `OBJECT_DEF ::= EXP_VOID | rename`.
- `PACKAGE_DEF ::= instantiation | package_spec | rename`; `PACKAGE_SPEC ::= package_spec`; `PACK_BODY_DESC ::= block | stub | rename | instantiation | void`.
- `TASK_DEF ::= task_spec`; `SUBUNIT_BODY ::= subprogram_body | package_body | task_body`.
- `EXCEPTION_DEF ::= rename | void`.
- `LOCATION ::= EXP_VOID | pragma_id`; `LANGUAGE ::= argument_id`.

## Generics (mirror the above)
- `generic => as_id: ID, as_generic_param_s: GENERIC_PARAM_S, as_generic_header: GENERIC_HEADER`.
- `GENERIC_HEADER ::= procedure | function | package_spec`.
- `GENERIC_PARAM ::= in | in_out | type | subprogram_decl`; `GENERIC_PARAM_S ::= generic_param_s`.
- `FORMAL_TYPE_SPEC ::= formal_dscrt | formal_integer | formal_fixed | formal_float` (plus formal private/array/access in §2).
- `FORMAL_SUBPROG_DEF ::= NAME | box | no_default`.
- `instantiation => as_name: NAME, as_generic_assoc_s: GENERIC_ASSOC_S`.
- `GENERIC_ASSOC ::= ACTUAL | assoc`; `GENERIC_ASSOC_S ::= generic_assoc_s`.
- Note: DIANA instantiates only the specification; expanding the body is left to the back end (§3.2.2, §3.6).

## Pragmas
- `PRAGMA ::= pragma`; `PRAGMA_S ::= pragma_s`; `pragma => as_id: ID, as_param_assoc_s: PARAM_ASSOC_S`.
- `ARGUMENT ::= argument_id`.

## Private (implementation-defined) types used as attribute values
`source_position`, `comments`, `symbol_rep`, `value`, `number_rep`, `operator`, `Rational`
(plus the basic IDL types `Boolean`, `Integer`, `String`, `Seq Of`).
