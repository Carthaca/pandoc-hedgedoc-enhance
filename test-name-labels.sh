#!/bin/bash

# Test script for [name=] feature
# Following TDD principles - this test should FAIL until feature is implemented

set -e

FILTER="custom-highlight.lua"
INPUT="test-name-labels.md"
EXPECTED_HTML="expected-name-html.html"
EXPECTED_LATEX="expected-name-latex.tex"
ACTUAL_HTML="actual-name-html.html"
ACTUAL_LATEX="actual-name-latex.tex"
ACTUAL_PLAIN="actual-name-plain.txt"

echo "Testing [name=] feature..."
echo ""

# Test HTML output
echo "Testing HTML output..."
pandoc --from markdown \
    --lua-filter "$FILTER" \
    --to html \
    --output "$ACTUAL_HTML" \
    "$INPUT"

if diff -u "$EXPECTED_HTML" "$ACTUAL_HTML" > /dev/null 2>&1; then
    echo "✓ HTML test passed!"
    HTML_PASS=true
else
    echo "✗ HTML test failed!"
    echo "Differences:"
    diff -u "$EXPECTED_HTML" "$ACTUAL_HTML" || true
    HTML_PASS=false
fi
echo ""

# Test LaTeX output
echo "Testing LaTeX output..."
pandoc --from markdown \
    --lua-filter "$FILTER" \
    --to latex \
    --output "$ACTUAL_LATEX" \
    "$INPUT"

if diff -u "$EXPECTED_LATEX" "$ACTUAL_LATEX" > /dev/null 2>&1; then
    echo "✓ LaTeX test passed!"
    LATEX_PASS=true
else
    echo "✗ LaTeX test failed!"
    echo "Differences:"
    diff -u "$EXPECTED_LATEX" "$ACTUAL_LATEX" || true
    LATEX_PASS=false
fi
echo ""

# Test plain text output (should have emoji fallback)
echo "Testing plain text output..."
pandoc --from markdown \
    --lua-filter "$FILTER" \
    --to plain \
    --output "$ACTUAL_PLAIN" \
    "$INPUT"

if grep -q "👤 Maurice" "$ACTUAL_PLAIN"; then
    echo "✓ Plain text test passed! (emoji fallback working)"
    PLAIN_PASS=true
else
    echo "✗ Plain text test failed! (no emoji fallback found)"
    echo "Expected to find '👤 Maurice' in output"
    echo "Actual content around 'Maurice':"
    grep -C 2 "Maurice" "$ACTUAL_PLAIN" || echo "(Maurice not found)"
    PLAIN_PASS=false
fi
echo ""

# Summary
echo "================================"
echo "Test Summary:"
echo "================================"
if [ "$HTML_PASS" = true ]; then
    echo "✓ HTML: PASSED"
else
    echo "✗ HTML: FAILED"
fi

if [ "$LATEX_PASS" = true ]; then
    echo "✓ LaTeX: PASSED"
else
    echo "✗ LaTeX: FAILED"
fi

if [ "$PLAIN_PASS" = true ]; then
    echo "✓ Plain: PASSED"
else
    echo "✗ Plain: FAILED"
fi
echo "================================"

# Exit with error if any test failed
if [ "$HTML_PASS" = true ] && [ "$LATEX_PASS" = true ] && [ "$PLAIN_PASS" = true ]; then
    echo ""
    echo "All tests passed! ✓"
    exit 0
else
    echo ""
    echo "Some tests failed. Feature not yet implemented (expected in TDD)."
    exit 1
fi
