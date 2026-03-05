.PHONY: test clean

test:
	@echo "Running test suite..."
	@cd tests && ./test-name-labels.sh
	@cd tests && ./test-integration.sh
	@echo "All tests passed!"

clean:
	@rm -f tests/actual-*.html tests/actual-*.tex tests/actual-*.txt
