all: deps_opt build

run:
	crystal run src/Darling.cr
build:
	crystal build src/Darling.cr --stats
release:
	crystal build src/Darling.cr --stats --release
test:
	crystal spec
deps:
	crystal deps install
deps_update:
	crystal deps update
deps_opt:
	@[ -d libs/ ] || make deps
doc:
	crystal docs

.PHONY: all run build release test deps deps_update doc
