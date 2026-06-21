# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

The goal is to design an updated, **backwards-compatible DIANA intermediate representation for Ada 2022** (`DIANA_2022`), plus an **interpretive test harness** that can execute a given DIANA tree. DIANA is a *semantic* IR (an attributed abstract syntax tree with cross-links), not a parse tree — nodes represent meaningful Ada constructs, not grammar productions.

## Current state (read before assuming structure)

The repository is at the **design stage**. There is **no source code, build system, or test suite yet**. The substantive work so far lives in two files:

- `Initial_instructions.md` — the authoritative requirements and style rules. Treat it as the spec for this project.
- `Copilot_notes.txt` — a chat transcript with a *draft* `DIANA_2022` core (units, declarations, expressions, statements, unified semantic properties) and a partial type + generic system. It is a starting point, **not** a committed spec, and it is incomplete (concurrency, full expression set, full contracts/aspects, and the harness are all still open). Verify any claim from it against `Initial_instructions.md` before relying on it.

`.gitignore` excludes `*.o` and `*.ali` (GNAT Ada Library Information), indicating the implementation/harness is intended to be **Ada (GNAT)**.

## The IDL dialect — this is a frequent mistake

The IR is specified in the **Wulf/Lamb/Nestor IDL** (an abstract-data-type / specification language), **not CORBA IDL**. Do not write OO `interface { field; }` syntax. Use:

- `Class ::= Variant_A | Variant_B | ...;` — a *strict class* (tagged union). A strict class made entirely of attribute-less node types acts as an enumeration.
- `Node => Attribute_Name : Type;` — declares an attribute on a node type.
- `seq of <Type>` / `set of <Type>` — composite/collection attributes.
- `*_Void ::= <Type> | Void;` with `Void =>;` — the idiom for optional attributes.
- A structure header: `structure DIANA_2022 root Compilation_Unit is ... end;`
- Discriminated Ada records map to a strict class: the discriminant is an attribute on the parent class, each variant is a node type, a `null` variant is an attribute-less node type. (Optional `assert` clauses can tie a variant to a discriminant value.)

## Style rules (from `Initial_instructions.md`)

- **Identifiers:** `Camel_Case` with underscores — initial capitals, underscore-separated, **full words, no abbreviations** (`Object_Declaration`, not `object_decl`; `Subprogram_Body`, not `subp_body`). All-capital acronyms stay capitalized.
- **Provenance comments:** annotate constructs with where they come from — DIANA RM vs the Ada RM.
- Expose the shortened DIANA Rev 3/4 node names via **`RENAMES`**; the full-word names are canonical.

## Core design decisions (non-obvious; keep consistent)

These are deliberate modeling choices that span the whole IR — preserve them:

- **Backwards compatibility** with the original DIANA (Rev 3/4) is a hard requirement.
- **Collapse semantically-equivalent Ada forms into one node.** Example: `return 0;`, `return Value : Integer := 0;`, and the full extended return are all one return construct.
- **Aspects and attribute-definition clauses unify** into a single `Semantic_Property` node (`with Size => 8` and `for T'Size use 8;` are the same semantic property). The node always carries a `Source_Position` and an `Origin` note (`From_Aspect | From_Attribute_Clause`) recording the syntactic source. Attach semantic properties to the declarations/types/subprograms/objects that can legally carry them.
- **The generic formal system mirrors the type system** — formal scalar/composite/access/interface/private types parallel their non-formal counterparts so actuals line up structurally with formals.

## Test harness requirements

When the interpretive harness is built, it must:
- Execute a given DIANA tree, and **error out if execution cannot be completed** (e.g. a missing separate compilation unit).
- Provide a way to **merge in separately-compiled DIANA**.

## Reference sources

Authoritative external specs (not in-repo; fetch when needed):
- Ada 2022 RM: http://www.ada-auth.org/standards/22rm_w_amd1/RM-Final.pdf
- Ada 83 Standard / Rationale: http://archive.adaic.com/standards/83lrm/html/ , http://archive.adaic.com/standards/83rat/html/
- DIANA Rev 3: https://apps.dtic.mil/sti/pdfs/ADA128232.pdf
- DIANA Rev 4 (draft): https://apps.dtic.mil/sti/tr/pdf/ADA272792.pdf
- IDL (Wulf/Lamb/Nestor): https://queensu.scholaris.ca/bitstreams/d5567e9e-f517-452b-b6cb-086fe9744915/download
