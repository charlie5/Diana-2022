# DIANA_2022

An updated, **backwards-compatible DIANA intermediate representation for
Ada 2022**, written in the Wulf/Lamb/Nestor IDL, plus an **interpretive test
harness** (Ada 2022 / GNAT) that builds, merges, and *executes* DIANA trees.

DIANA (Descriptive Intermediate Attributed Notation for Ada) is a *semantic* IR
— an attributed abstract syntax tree with cross-links — not a parse tree. Nodes
represent meaningful Ada constructs. This project modernises the historical
DIANA Rev 3/4 design for Ada 2022 and demonstrates it with a working harness.

## Quick start

Requires **GNAT / gprbuild** and **perl**.

```sh
make check    # the one-command verification:
              #   spec invariants -> generated files in sync -> build -> run demos
make run      # just run the two demos
make build    # just gprbuild
make gen      # regenerate the generated Ada after a spec change
make clean
```

`make check` passes when the spec is structurally sound, the committed generated
Ada matches what the generators produce, the harness builds with no errors, and
both demos run.

## What's here

```
spec/
  DIANA_2022.idl                the canonical IR spec (single-parent, verified)
  DIANA_2022_Compatibility.idl  the Rev 3/4 short-name "Renames" alias layer
tools/
  gen_nodes.pl                  spec -> Diana.Nodes (the tagged-type node set)
  gen_api.pl                    spec -> Diana.Builders + Diana.Accessors
  check_partition.pl            invariant: each node/class has one parent
  check_resolve.pl              invariant: every referenced name is defined
harness/
  diana_harness.gpr             GNAT project (builds both demos)
  src/diana.ads                 foundation: the node root + the library tree
  src/diana-nodes.ads           GENERATED: the full node set (436 tagged types)
  src/diana-builders.ads        GENERATED: a value constructor per node
  src/diana-accessors.ads       GENERATED: Is_T / As_T per type
  src/diana-loading.ads         library bookkeeping nodes (not part of the IR)
  src/diana-library.adb         the program library: stub / merge / error-out
  src/diana-interpreter.adb     the tree interpreter
  src/diana_harness.adb         demo: separate compilation + builder/accessor
  src/interp_demo.adb           demo: build small programs and execute them
Makefile                        make check | build | run | gen | clean
references/                     DIANA Rev 3/4 manuals + distillations
Initial_instructions.md         the authoritative requirements and style rules
```

## How it fits together

```
spec/DIANA_2022.idl
   │  gen_nodes.pl  ─→  Diana.Nodes        (IDL class -> abstract type,
   │                                         IDL node  -> concrete leaf;
   │                                         single inheritance = single parent)
   │  gen_api.pl    ─→  Diana.Builders     (build trees bottom-up)
   │                ─→  Diana.Accessors    (typed reads: As_T (C).Attribute)
   ├─ Diana.Library      a forest of compilation subtrees; a with'ed-but-unloaded
   │                     unit is a Pending_Unit stub recording its referrers, and
   │                     Merge fixes them up in place; Require_All_Resolved errors
   │                     out if any stub remains
   └─ Diana.Interpreter  walks a tree through the accessors and runs it
```

Everything lives in one `Ada.Containers.Indefinite_Multiway_Trees` of
`Diana.Node'Class`: structural parent/child edges are tree edges, and semantic
cross-links are tree `Cursor`s (the in-memory form of a symbolic external
label). The full node set is **generated** from the spec; only the few
bookkeeping kinds the library needs are hand-written.

## The IDL dialect

The IR is specified in the **Wulf/Lamb/Nestor IDL** (an abstract-data-type
specification language) — **not CORBA IDL**. Classes are alternations
(`EXP ::= leaf | tree ;`), nodes have order-independent attributes
(`tree => left : EXP, right : EXP ;`), and the whole IR is one `Structure`. See
`CLAUDE.md` and the DIANA Rev 3 manual (`references/`) for the full notation.

DIANA_2022 modernises the conventions: `Camel_Case` full-word identifiers (the
Rev 3/4 short names live behind the `Renames` compatibility layer), no attribute
prefixes (the structural/lexical/semantic/code classification is shown by
grouping and comments), and a single-parent hierarchy with shared attributes
hoisted to the highest applicable class.

## What the interpreter executes

`harness/interp_demo` builds small DIANA programs with `Diana.Builders` and runs
them through `Diana.Interpreter`. Between them the interpreter covers:

- **Values:** integer, real (with promotion), boolean, string (`&`), access
  (`new`, `.all`, `null`, aliasing), and array / record aggregates with value
  semantics (indexing, selection, component assignment, and the
  `'First`/`'Last`/`'Length` attributes), and the scalar/enumeration attributes
  `'Succ`/`'Pred`/`'Pos`/`'Val`.
- **Statements:** assignment, `if`, `while`, range `for`, container `for ... of`
  (over an array's elements or a record's components, with the Ada 2022 `when`
  filter), `case` (over integers or enumerations — an enumeration value carries
  its position *and* name, so it compares/iterates as an integer but prints by
  name), block statements with local
  declarations, `exit` (incl. named), `goto` + labels, `raise` + exception
  handlers (incl. `when E : ...` occurrence parameters, bare re-raise, and
  `Exception_Name`/`Exception_Message`), `Put_Line`.
- **Subprograms:** `in` / `out` / `in out` parameters with copy-back, recursion
  over a call stack, and nested subprograms that close over their enclosing
  activation (static links).
- **Generics:** generic-subprogram instantiation — `function F is new G (Actuals)`
  runs `G`'s body with its generic formal objects bound to the instance's actuals
  — and generic packages: `package I is new G (Actuals)` elaborates `G`'s visible
  declarations into a fresh instance scope (nestable in a block), with `I.Member`
  and `I.Sub (...)` resolving through it.
- **Scoping:** a lexical scope chain; locals shadow outer names.
- **Contracts** (runtime-checked, raising on violation): `pragma Assert`, `Pre`,
  `Post` (with `'Old` and `'Result`), `Predicate`, `Type_Invariant`,
  `Contract_Cases`, and `Subprogram_Variant`; plus bare re-raise and
  `Exception_Message`.

`harness/diana_harness` demonstrates the separate-compilation machinery: it
builds a unit that references a not-yet-compiled unit, **errors out** on the
missing compilation, then **merges** the compilation in and resolves the
reference in place.

## Harness requirements

The harness meets the three requirements from `Initial_instructions.md`:

1. **Execute a given DIANA tree** — `Diana.Interpreter`.
2. **Error out when execution cannot complete** — a missing separate compilation
   (`Missing_Compilation`), an unexecutable tree (`Interpretation_Error`), a
   failed contract (`Assertion_Error`), or an unhandled exception
   (`Unhandled_Exception`).
3. **Merge in separately-compiled DIANA** — `Diana.Library.Merge`.

## Status

The spec is substantially complete and verified; the harness builds with no
warnings and `make check` is green. The generated node set and builder/accessor
API are regenerable from the spec. See `CLAUDE.md` for design decisions and the
current open items.

## References

Public-domain sources (large PDFs are git-ignored; fetch locally as needed):

- DIANA Rev 3: <https://apps.dtic.mil/sti/pdfs/ADA128232.pdf>
- DIANA Rev 4 (draft): <https://apps.dtic.mil/sti/tr/pdf/ADA272792.pdf>
- IDL (Wulf/Lamb/Nestor): Queen's University technical report
- Ada 2022 RM: <http://www.ada-auth.org/standards/22rm_w_amd1/RM-Final.pdf>
- Canonical reference: Goos, Wulf, Evans, Butler (eds.), *DIANA: An Intermediate
  Language for Ada*, LNCS 161, Springer-Verlag, 1983.

## License

MIT — see `LICENSE`.
