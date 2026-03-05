#!/bin/bash

# Integration test script for combined [name=] and ==highlight== features
# Tests that both features work correctly when used together

set -e

FILTER="custom-highlight.lua"
INPUT="test-integration.md"
ACTUAL_HTML="actual-integration-html.html"
ACTUAL_LATEX="actual-integration-latex.tex"

echo "Testing integration of [name=] and ==highlight== features..."
echo ""

# Test HTML output
echo "Testing HTML output..."
pandoc --from markdown+mark \
    --lua-filter "$FILTER" \
    --to html \
    --output "$ACTUAL_HTML" \
    "$INPUT"

HTML_PASS=true

# Check for highlight with custom color
if grep -qz '<mark style="background-color: #ffcc00;">important' "$ACTUAL_HTML" && \
   grep -q 'text</mark>' "$ACTUAL_HTML"; then
    echo "✓ Custom highlight color found"
else
    echo "✗ Custom highlight color not found"
    echo "Expected: <mark style=\"background-color: #ffcc00;\">important text</mark>"
    grep -n "important" "$ACTUAL_HTML" || echo "(text not found)"
    HTML_PASS=false
fi

# Check for name label with Font Awesome icon
if grep -q '<small><i class="fa fa-user"></i>' "$ACTUAL_HTML"; then
    echo "✓ Name label with Font Awesome icon found"
else
    echo "✗ Name label with Font Awesome icon not found"
    echo "Expected: <small><i class=\"fa fa-user\"></i>"
    grep -n "Alice\|Bob\|Charlie" "$ACTUAL_HTML" | head -5 || echo "(names not found)"
    HTML_PASS=false
fi

# Check for specific name labels
if grep -q '<small><i class="fa fa-user"></i> Alice</small>' "$ACTUAL_HTML"; then
    echo "✓ Alice name label found"
else
    echo "✗ Alice name label not found"
    HTML_PASS=false
fi

if grep -q '<small><i class="fa fa-user"></i> Bob</small>' "$ACTUAL_HTML"; then
    echo "✓ Bob name label found"
else
    echo "✗ Bob name label not found"
    HTML_PASS=false
fi

# Check for combined usage (highlight and name in same line)
if grep -qz '<mark style="background-color: #ffcc00;">This' "$ACTUAL_HTML" && \
   grep -q 'is highlighted</mark>' "$ACTUAL_HTML"; then
    echo "✓ Combined usage: highlight found in bullet point"
else
    echo "✗ Combined usage: highlight not found in bullet point"
    HTML_PASS=false
fi

# Check for Unicode name with highlight
if grep -q '<small><i class="fa fa-user"></i> 李明</small>' "$ACTUAL_HTML" && \
   grep -q '<mark style="background-color: #ffcc00;">注意这个问题</mark>' "$ACTUAL_HTML"; then
    echo "✓ Unicode name and highlight found"
else
    echo "✗ Unicode name and highlight not found"
    HTML_PASS=false
fi

if [ "$HTML_PASS" = true ]; then
    echo ""
    echo "✓ HTML integration test PASSED!"
else
    echo ""
    echo "✗ HTML integration test FAILED!"
fi
echo ""

# Test LaTeX output
echo "Testing LaTeX output..."
pandoc --from markdown+mark \
    --lua-filter "$FILTER" \
    --to latex \
    --output "$ACTUAL_LATEX" \
    "$INPUT"

LATEX_PASS=true

# Check for highlight with custom color in LaTeX
if grep -q '\\colorbox\[rgb\]{1.000,0.800,0.000}{important text}' "$ACTUAL_LATEX"; then
    echo "✓ LaTeX custom highlight color found"
else
    echo "✗ LaTeX custom highlight color not found"
    echo "Expected: \\colorbox[rgb]{1.000,0.800,0.000}{important text}"
    grep -n "important text" "$ACTUAL_LATEX" || echo "(text not found)"
    LATEX_PASS=false
fi

# Check for name label with Font Awesome icon in LaTeX
if grep -q '\\faUser' "$ACTUAL_LATEX"; then
    echo "✓ LaTeX name label with Font Awesome icon found"
else
    echo "✗ LaTeX name label with Font Awesome icon not found"
    echo "Expected: \\faUser"
    grep -n "Alice\|Bob\|Charlie" "$ACTUAL_LATEX" | head -5 || echo "(names not found)"
    LATEX_PASS=false
fi

# Check for specific name labels in LaTeX
if grep -q '{\\small \\faUser\\ Alice}' "$ACTUAL_LATEX"; then
    echo "✓ LaTeX Alice name label found"
else
    echo "✗ LaTeX Alice name label not found"
    LATEX_PASS=false
fi

if grep -q '{\\small \\faUser\\ Bob}' "$ACTUAL_LATEX"; then
    echo "✓ LaTeX Bob name label found"
else
    echo "✗ LaTeX Bob name label not found"
    LATEX_PASS=false
fi

# Check for combined usage in LaTeX
if grep -q '\\colorbox\[rgb\]{1.000,0.800,0.000}{This is' "$ACTUAL_LATEX" && \
   grep -q 'highlighted}' "$ACTUAL_LATEX"; then
    echo "✓ LaTeX combined usage: highlight found in bullet point"
else
    echo "✗ LaTeX combined usage: highlight not found in bullet point"
    LATEX_PASS=false
fi

# Check for Unicode name with highlight in LaTeX
if grep -q '{\\small \\faUser\\ 李明}' "$ACTUAL_LATEX" && \
   grep -q '\\colorbox\[rgb\]{1.000,0.800,0.000}{注意这个问题}' "$ACTUAL_LATEX"; then
    echo "✓ LaTeX Unicode name and highlight found"
else
    echo "✗ LaTeX Unicode name and highlight not found"
    LATEX_PASS=false
fi

if [ "$LATEX_PASS" = true ]; then
    echo ""
    echo "✓ LaTeX integration test PASSED!"
else
    echo ""
    echo "✗ LaTeX integration test FAILED!"
fi
echo ""

# Summary
echo "================================"
echo "Integration Test Summary:"
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
echo "================================"

# Exit with error if any test failed
if [ "$HTML_PASS" = true ] && [ "$LATEX_PASS" = true ]; then
    echo ""
    echo "All integration tests passed! ✓"
    exit 0
else
    echo ""
    echo "Some integration tests failed."
    exit 1
fi
