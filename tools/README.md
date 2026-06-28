# tools — spec invariant checkers

Small Perl scripts that verify structural invariants of `spec/DIANA_2022.idl`.
Run them after editing the spec.

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
