# tools — spec invariant checkers + node generator

Small Perl scripts that work on `spec/DIANA_2022.idl`. Run the checkers after
editing the spec; re-run the generator after a spec change that should reach the
harness.

## Generator

`gen_nodes.pl` emits the Ada package `Diana.Nodes` (the full node set) from the
spec:

```sh
perl tools/gen_nodes.pl > harness/src/diana-nodes.ads   # 435 tagged types
```

Mapping (see the script header for detail): each IDL class (`::=`) becomes an
**abstract** tagged type, each IDL node (`=>`) a **concrete** leaf; a type's
single IDL parent is its Ada parent (orphans and `Void` derive from the root
`Diana.Node`); hoisted class attributes become inherited components. Attribute
types map uniformly — private/scalar types pass through, `Seq Of T` becomes a
`Node_List`, and every node/class reference becomes a `Cursor` (so the only
ordering constraint is parent-before-child). The root `Diana_Node`, the six
private types, and the `Static_Value` value-model are realised by hand in
`harness/src/diana.ads` and are **not** re-emitted. Identifiers colliding with
Ada reserved words get an `_Item` suffix (`Pragma` → `Pragma_Item`, `Range` →
`Range_Item`). The output is committed (so the build needs no Perl) but is
marked generated — do not edit it by hand.

## Checkers

| Script | Invariant | Pass condition |
|---|---|---|
| `check_partition.pl` | **Single parent** — each node/class is a member of at most one class (the `::=` "is-a" hierarchy), except the universal node `void`. | Only `void` is multiply-membered. |
| `check_resolve.pl` | **Referential completeness** — every referenced name (a `::=` alternative or a `=>` attribute type) is defined, or is a basic IDL type / private type / `void`. | All references resolve. |

```sh
perl tools/check_partition.pl     # -> "OK: single-parent ..."
perl tools/check_resolve.pl       # -> "OK: all references resolve."
```

Both default to `spec/DIANA_2022.idl`; pass a path to check another structure
(e.g. `spec/DIANA_2022_Compatibility.idl` once the `Renames` form is processed).
Each exits non-zero on failure, so they can gate a build.
