.PHONY: test clean

test: expected.html
	@pandoc --from markdown+mark \
		--lua-filter custom-highlight.lua \
		--output actual.html \
		sample.md
	@diff -u expected.html actual.html && echo "Test passed!" || \
		(echo "Test failed: output differs from expected.html"; exit 1)

expected.html:
	@pandoc --from markdown+mark \
		--lua-filter custom-highlight.lua \
		--output expected.html \
		sample.md

clean:
	rm -f actual.html
