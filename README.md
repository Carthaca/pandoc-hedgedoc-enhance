# custom-highlight

Customize the color of highlighted text (`==text==` syntax) and add
user attribution labels (`[name=Someone]` syntax) in pandoc documents.

By default, pandoc converts `==highlighted text==` to HTML's
`<mark>` element or LaTeX's `\hl` command. This filter allows you
to customize the highlight color through metadata.

## Usage

Enable the `mark` extension and apply the filter:

```bash
pandoc --from markdown+mark --lua-filter custom-highlight.lua \
  input.md -o output.html
```

### Configuration

Configure colors through metadata in your markdown document:

```yaml
---
highlight-color: '#ffcc00'
highlight-background-color: '#ffcc00'
highlight-text-color: '#000000'
---
```

#### Options

- `highlight-color`: The highlight color (hex format or color name).
  Default: `#ffff00` (yellow)

- `highlight-background-color`: Background color for the highlight.
  If not set, uses `highlight-color`. This allows you to set
  different colors for HTML and LaTeX outputs.

- `highlight-text-color`: Text color inside the highlight
  (optional). Useful for dark highlights where you need light text.

**Supported color names:**
- Basic: `black`, `white`, `red`, `green`, `blue`, `yellow`, `cyan`, `magenta`, `orange`, `purple`, `pink`, `brown`, `gray`/`grey`
- Light variants: `lightred`, `lightgreen`, `lightblue`, `lightyellow`, `lightcyan`, `lightmagenta`, `lightorange`, `lightpurple`, `lightpink`, `lightgray`/`lightgrey`
- Dark variants: `darkred`, `darkgreen`, `darkblue`, `darkyellow`, `darkcyan`, `darkmagenta`, `darkorange`, `darkpurple`, `darkpink`, `darkgray`/`darkgrey`

You can also use hex colors (e.g., `#ff9900`) or any CSS color value.

### Examples

#### Basic usage with default yellow:

```markdown
This is ==highlighted text== in the document.
```

#### Custom orange highlight:

```yaml
---
highlight-color: 'orange'
---

This is ==highlighted in orange== now.
```

Or using hex:

```yaml
---
highlight-color: '#ff9900'
---
```

#### Dark highlight with light text:

```yaml
---
highlight-background-color: '#2c3e50'
highlight-text-color: '#ffffff'
---

This is ==dark highlighted text== with white text.
```

## User Attribution Labels

The filter also supports HedgeDoc-style user attribution labels using the
`[name=Username]` syntax. This is useful for collaborative documents where you
want to track who wrote or contributed specific sections.

### Basic Usage

```markdown
[name=Alice] suggested this change.

The proposal was drafted by [name=Bob].
```

### Output Formats

- **HTML**: Renders as `<small><i class="fa fa-user"></i> Username</small>`
  - Uses Font Awesome icon (requires Font Awesome CSS)
  - Small text with user icon

- **LaTeX**: Renders as `{\small \faUser\ Username}`
  - Uses fontawesome5 package (must be included in preamble)
  - Small text with user icon

- **Other formats**: Renders as `👤 Username` (Unicode emoji)

### Example Document

```markdown
# Meeting Notes

## Discussion

[name=Sarah Chen] opened the meeting by reviewing Q2 goals.

[name=李明] presented the technical architecture proposal.

[name=José García] shared the new wireframes.

## Action Items

- Schedule follow-up ([name=Sarah Chen])
- Complete documentation ([name=李明])
```

### Format-Specific Requirements

**For HTML output:**
- Include Font Awesome in your document head:
  ```html
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  ```

**For LaTeX output:**
- Include the fontawesome5 package in your preamble:
  ```latex
  \usepackage{fontawesome5}
  ```

## Supported Formats

### Highlighting (`==text==`)

- **HTML**: Adds inline styles to `<mark>` elements
- **LaTeX**: Uses `\colorbox` with RGB colors
- Other formats: Uses default pandoc behavior

### Name Labels (`[name=...]`)

- **HTML**: Formats with Font Awesome icon and small text
- **LaTeX**: Uses fontawesome5 package with `\faUser` icon
- Other formats: Uses Unicode emoji (👤)

## Requirements

### For Highlighting

- Pandoc with `mark` extension enabled (`markdown+mark`)
- For LaTeX output: `xcolor` package (usually included in standard
  LaTeX distributions)

### For Name Labels

- For HTML output: Font Awesome CSS (for user icons)
- For LaTeX output: `fontawesome5` package (for `\faUser` icon)

## License

Apache License 2.0
