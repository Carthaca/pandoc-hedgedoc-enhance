# Name Label Test Cases

This document tests the [name=] feature for user attribution labels.

## Basic Name

A simple name label: [name=Maurice]

## Multiple Names

Collaboration between [name=Alice] and [name=Bob] on this section.

## Name with Spaces

Full names work too: [name=Jean-Paul Sartre]

## Unicode Names

International support: [name=José] and [name=李明]

## Names in Different Contexts

- List item by [name=Charlie]
- Another item by [name=Diana]

1. First point by [name=Eve]
2. Second point by [name=Frank]

> Quote attributed to [name=Grace]

This paragraph has contributions from [name=Helen] and [name=Ivan] in the same line.

## Malformed Patterns

These should remain unchanged:

- Empty name: [name=]
- Unclosed bracket: [name=Someone
- No opening bracket: name=Something]
- Just brackets: [name]
- Wrong format: [username=Bob]
