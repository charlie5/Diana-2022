# Makefile — build and verification for the DIANA_2022 project.
#
#   make check   run everything: spec invariants, generated-files sync, build,
#                and both demos (this is the one-command project check)
#   make build   build the harness with gprbuild (both demos)
#   make run     run the two demos
#   make gen     (re)generate the committed Ada from the spec
#   make clean   remove build artifacts
#
# Requires gprbuild (GNAT) and perl.

SPEC      := spec/DIANA_2022.idl
GPR       := harness/diana_harness.gpr
NODES     := harness/src/diana-nodes.ads
BUILDERS  := harness/src/diana-builders.ads
ACCESSORS := harness/src/diana-accessors.ads

.PHONY: check checkers verify-gen build run gen clean

check: checkers verify-gen build run
	@echo
	@echo "=== all checks passed ==="

# Structural invariants of the IR spec (exit non-zero on failure).
checkers:
	@echo "--- spec invariants ---"
	perl tools/check_partition.pl $(SPEC)
	perl tools/check_resolve.pl   $(SPEC)

# The committed generated Ada must match what the generators produce now, so a
# spec edit without re-running the generators (or a hand-edit of generated
# files) is caught here.
verify-gen:
	@echo "--- generated files in sync with the spec ---"
	@perl tools/gen_nodes.pl            $(SPEC) 2>/dev/null | diff -u $(NODES)     - && echo "OK: $(NODES)"
	@perl tools/gen_api.pl builders     $(SPEC) 2>/dev/null | diff -u $(BUILDERS)  - && echo "OK: $(BUILDERS)"
	@perl tools/gen_api.pl accessors    $(SPEC) 2>/dev/null | diff -u $(ACCESSORS) - && echo "OK: $(ACCESSORS)"

build:
	@echo "--- gprbuild ---"
	gprbuild -P $(GPR)

run: build
	@echo "--- diana_harness ---"
	./harness/diana_harness
	@echo
	@echo "--- interp_demo ---"
	./harness/interp_demo

# Overwrite the committed generated files from the current spec + generators.
gen:
	perl tools/gen_nodes.pl         $(SPEC) > $(NODES)
	perl tools/gen_api.pl builders  $(SPEC) > $(BUILDERS)
	perl tools/gen_api.pl accessors $(SPEC) > $(ACCESSORS)

clean:
	gprclean -P $(GPR)
