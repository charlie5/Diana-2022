# DIANA Draft Revision 4 — orientation and Rev 3 → Rev 4 changes

Notes on the public-domain *DIANA Reference Manual, Draft Revision 4* (5 May 1986,
Kathryn L. McKinley & Carl F. Schaefer, Intermetrics, Inc.; DTIC AD-A272792).
Source PDF: `references/DIANA_Rev4_draft_ADA272792.pdf` (327 pp., git-ignored).
It is a **draft** — Chapter 6 (external representation) and Chapter 7 (DIANA-in-Ada
package) are noted as incomplete. Based on Ada-82 (July 1982 LRM), like Rev 3.

## Why it matters for DIANA_2022
Rev 4 is the DIANA maintainers' own re-engineering of Rev 3. Their restructuring moves
(partitioning + attribute hoisting + a deeper class lattice) are exactly the kind of
regularization DIANA_2022 should adopt, so this is a model for *how* to extend cleanly,
not just *what* nodes exist.

## Author-stated changes to the DIANA definition (Preface to this edition)
- **Type/subtype overhaul** — representation of types and subtypes reworked to accord
  better with Ada's own definition of subtypes.
- **Partitioning** — every node and class *except* `void` is now a direct member of
  **no more than one class** (a strict single-parent hierarchy; no multiple class
  membership). This is the biggest structural departure from Rev 3.
- **Hoisting** — attributes are lifted to the highest class where they apply, so common
  attributes (e.g. source position, comments) live on base classes instead of being
  repeated on every node (as they are in Rev 3).
- **Nomenclature regularization** of classes, nodes, and attributes.

## Changes to the manual structure
- Semantic specification (Ch 3) separated from rationale (Ch 4).
- Systematic coverage of DIANA's static semantics.
- Hierarchical class-membership diagrams.
- Several substantial worked examples (Ch 5).
- A node/attribute cross-reference index (Appendix A).

## Document map
- **Ch 1** Introduction (incl. 1.4.1 Notation; 1.2 lists the minimal DIANA operations:
  node-kind query, attribute get/set, node construction, identity/equality, plus the
  `Seq Of` operators — relevant to the harness's node API).
- **Ch 2 — IDL SPECIFICATION** (the complete IDL in one place; the primary target for a
  node-level Rev 3 → Rev 4 diff).
- **Ch 3 — Semantic specification**, organized top-down by class:
  - 3.1 `ALL_DECL` → ITEM, DSCRMT_PARAM_DECL, PARAM, SUBUNIT_BODY, DECL, USE_PRAGMA,
    REP/NAMED_REP, ID_DECL, SIMPLE_RENAME_DECL, UNIT_DECL, NON_GENERIC_DECL,
    ID_S_DECL, EXP_DECL, OBJECT_DECL.
  - 3.2 `DEF_NAME` → PREDEF_NAME, SOURCE_NAME, LABEL_NAME, TYPE_NAME, OBJECT_NAME
    (ENUM_LITERAL, INIT_OBJECT_NAME → VC_NAME/COMP_NAME/PARAM_NAME), UNIT_NAME →
    NON_TASK_NAME → SUBPROG_PACK_NAME → SUBPROG_NAME.
  - 3.3 `TYPE_SPEC` → DERIVABLE_SPEC, PRIVATE_SPEC, FULL_TYPE_SPEC → NON_TASK → SCALAR →
    REAL, UNCONSTRAINED → UNCONSTRAINED_COMPOSITE, CONSTRAINED.
  - 3.4 `TYPE_DEF` → CONSTRAINED_DEF, ARR_ACC_DER_DEF.
  - 3.5 `CONSTRAINT` → DISCRETE_RANGE → RANGE, REAL_CONSTRAINT.
  - 3.6 `UNIT_DESC` → UNIT_KIND, RENAME_INSTANT, GENERIC_PARAM, BODY.
  - 3.7 `HEADER` → SUBP_ENTRY_HEADER.
  - 3.8 `GENERAL_ASSOC` → NAMED_ASSOC, EXP → NAME → DESIGNATOR/USED_OBJECT/USED_NAME,
    NAME_EXP → NAME_VAL, EXP_EXP → AGG_EXP/EXP_VAL → EXP_VAL_EXP → MEMBERSHIP/QUAL_CONV.
  - 3.9 `STM_ELEM` → STM → BLOCK_LOOP, ENTRY_STM, CLAUSES_STM, STM_WITH_EXP →
    STM_WITH_EXP_NAME, STM_WITH_NAME → CALL_STM.
  - 3.10 Miscellaneous: CHOICE, ITERATION/FOR_REV, MEMBERSHIP_OP, SHORT_CIRCUIT_OP,
    ALIGNMENT_CLAUSE, VARIANT_PART, TEST_CLAUSE(_ELEM), ALTERNATIVE_ELEM, COMP_REP_ELEM,
    CONTEXT_ELEM, VARIANT_ELEM, compilation, compilation_unit, comp_list, index.
- **Ch 4** Rationale (design decisions, declarations, names, types/subtypes, constraints,
  expressions, program units, pragmas).
- **Ch 5** Examples · **Ch 6** External representation (incomplete) ·
  **Ch 7** DIANA package in Ada (incomplete).
- **Appendix A** DIANA cross-reference guide · **Appendix B** References.

## Observations vs Rev 3 (from the taxonomy alone)
- Rev 3's `DEF_ID`/`DEF_OP`/`DEF_CHAR` are reorganized under a `DEF_NAME` hierarchy with
  semantic groupings (`SOURCE_NAME` vs `PREDEF_NAME`; the `SUBPROG_PACK_NAME →
  SUBPROG_NAME` chain).
- Expressions/names are unified under `GENERAL_ASSOC`/`EXP`/`NAME` with intermediate
  classes that hoist shared `sm_exp_type`/`sm_value`-style attributes (e.g. `NAME_VAL`,
  `EXP_VAL`, `EXP_VAL_EXP`).
- Statements gain intermediate classes by shape (`STM_WITH_EXP`, `STM_WITH_NAME`,
  `CALL_STM`), again to hoist common attributes.
- Type system is re-cut around derivability/constraint (`DERIVABLE_SPEC`,
  `FULL_TYPE_SPEC`, `UNCONSTRAINED(_COMPOSITE)`, `CONSTRAINED`) rather than Rev 3's flat
  `TYPE_SPEC ::= integer | float | array | record | …`.

**TODO (next):** read Ch 2 (IDL spec) and Appendix A to record the concrete Rev 4 node
set and a node-level Rev 3 → Rev 4 mapping.
