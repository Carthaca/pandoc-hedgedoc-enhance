# Release v1.0.0 - HedgeDoc-Enhanced Pandoc Filter

## 🎉 Initial Release

A Pandoc Lua filter that brings HedgeDoc-style features to your markdown documents with zero configuration.

## ✨ Features

### Custom Highlight Colors
- Use `==highlighted text==` with custom colors
- Support for **46 named colors**: `red`, `green`, `blue`, `orange`, `lightyellow`, `darkblue`, etc.
- Or use hex colors: `#ff9900`
- Configure background and text colors independently
- Text-only mode (no background): set `highlight-color: 'none'`

### User Attribution Labels
- HedgeDoc-style `[name=Someone]` syntax
- **HTML**: Font Awesome user icon + name (automatically included)
- **LaTeX**: fontawesome5 `\faUser` icon (automatically included)
- **Email-friendly mode**: Unicode emoji 👤 (set `name-label-emoji: true`)

### Zero Configuration
- **No manual setup required!**
- Font Awesome CSS automatically included for HTML
- LaTeX fontawesome5 package automatically included
- Just run pandoc with the filter

## 📦 Installation

```bash
# Clone the repository
git clone https://github.com/Carthaca/pandoc-hedgedoc-enhance.git

# Or download custom-highlight.lua directly
curl -O https://raw.githubusercontent.com/Carthaca/pandoc-hedgedoc-enhance/main/custom-highlight.lua
```

## 🚀 Quick Start

```bash
# Basic usage
pandoc --from markdown+mark \
  --lua-filter custom-highlight.lua \
  --standalone \
  input.md -o output.html
```

**Example markdown:**
```markdown
---
highlight-color: 'orange'
---

# Meeting Notes

[name=Alice] suggested we ==highlight important sections== in orange.

Action items by [name=Bob]:
- Deploy to staging
- Run ==integration tests==
```

## 📚 Documentation

See [README.md](README.md) for:
- Complete configuration options
- All supported color names
- Email-friendly mode for HTML emails
- Examples for HTML, LaTeX, and PDF output
- Integration with existing workflows

## 🧪 Tested & Production Ready

- ✅ Comprehensive test suite (unit + integration tests)
- ✅ Security: Input escaping for HTML and LaTeX
- ✅ Unicode support (Chinese, Arabic, emoji, etc.)
- ✅ Works with pandoc 2.x and 3.x
- ✅ Compatible with Quarto

## 📋 What's Included

- `custom-highlight.lua` - The filter
- `README.md` - Complete documentation
- `examples/` - Example documents
- `tests/` - Test suite
- `docs/` - Design documents

## 💡 Use Cases

- Collaborative meeting notes with attributions
- Technical documentation with highlighted warnings/tips
- HTML emails with colored text and attributions
- Academic papers with color-coded annotations
- Code review comments in markdown

## 🐛 Known Limitations

- Font Awesome CDN requires internet connection (use `name-label-emoji: true` for offline)
- LaTeX fontawesome5 package must be installed (included in most distributions)

## 🙏 Acknowledgments

Inspired by [HedgeDoc](https://hedgedoc.org/)'s collaborative markdown editor.

## 📜 License

Apache License 2.0

---

**Full Changelog**: https://github.com/Carthaca/pandoc-hedgedoc-enhance/commits/v1.0.0
