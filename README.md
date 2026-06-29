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
  runs `G`'s body with its generic formals bound to the instance's actuals (formal
  **objects** to values, formal **subprograms** to actual subprograms that calls in
  the template dispatch to, formal **types** erased — one body runs over each
  actual type, e.g. `Are_Equal` instantiated for `Integer` and `String`, including
  formal **interface** types (programmed to via their operations), formal
  **derived** types (whose inherited parent operations the body uses directly), and
  formal **scalar** types (`range <>`, ordered, so the body compares them) — and
  formal **packages** bound to an actual instance, so `P.Member` resolves through
  it; with **defaults** for omitted object/subprogram formals and **`in out`**
  formal objects that alias an actual variable) — and generic packages:
  `package I is new G (Actuals)`
  elaborates `G`'s visible declarations into a fresh instance scope (nestable in a
  block), with `I.Member` and `I.Sub (...)` resolving through it; and child generic
  packages (`package C is new I.Child (Actuals)`), whose instance nests in the
  parent instance's scope so the child sees the parent's members by simple name.
- **Subunits:** a subprogram declared `is separate` raises until its subunit body
  is supplied; once the stub is completed in place, calling it runs the subunit.
- **Scoping:** a lexical scope chain; locals shadow outer names.
- **Contracts** (runtime-checked, raising on violation): `pragma Assert`, `Pre`,
  `Post` (with `'Old` and `'Result`), `Predicate`, `Type_Invariant`,
  `Contract_Cases`, and `Subprogram_Variant`; plus bare re-raise and
  `Exception_Message`.

`harness/diana_harness` demonstrates the separate-compilation machinery: it
builds a unit that references a not-yet-compiled unit, **errors out** on the
missing compilation, then **merges** the compilation in and resolves the
reference in place — shown for a plain object unit, a separately-compiled
**generic package** that a second compilation instantiates, a separately-compiled
**child generic package** (`Buffers.Bounded`) that is rejected until its parent is
compiled, then resolved through its compound-name instantiation, a
**nested generic package** (`Registry.Cache`) where one merge of the enclosing
package resolves both halves of the compound-name instantiation, and a
**child package of a generic package** (`Tables.Sorted`) used through a parent
instance (`new T_Inst.Sorted`), where the prefix resolves locally and only the
selector is the cross-unit reference to the separately-compiled child generic, and
a **grandchild generic package** (`Graphics.Drivers.Pool`) — three separately-compiled
units whose doubly-nested-selected-name instantiation resolves as the chain is
merged top-down, and a **subunit** (`Engine.Process`, an `is separate` body) whose
body stub is completed in place by `Merge_Subunit` — including a **subunit of a
generic package** (`Allocators.Free`), where the generic is resolved via its
instantiation and its body's separate subunit is completed once present, and a
**subunit of a child generic package** (`Containers.Vectors.Reserve`) — a child
generic loaded beneath its parent whose body's separate subunit is then completed,
a **subunit of a nested generic package** (`Sessions.Pool.Evict`), where the
nested generic is no unit of its own so its subunit completes a stub in the
enclosing compilation, a **subunit of a subunit** (`Driver.Run.Step`), where
a merged subunit is itself a loaded unit whose own separate subunit is then completed,
a **subunit of a grandchild generic package** (`Hardware.Devices.Queue.Push`), a
generic grandchild three units deep whose body's separate subunit is completed once
the chain is present, a **subunit of a subunit of a generic package**
(`Logger.Rotate.Archive`), a two-level subunit chain rooted at a generic package,
a **subunit of a child package of a generic package** (`Vault.Sealed.Unlock`),
where the child-of-a-generic is used through a parent instance and its body's
separate subunit is then completed, and a **subunit of a grandchild package of a
generic package** (`Geometry.Shapes.Solids.Render`), a generic grandchild reached
through two instance levels whose body's separate subunit is then completed.

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
