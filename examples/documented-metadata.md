---
# Custom Highlight Filter Configuration
# Use with: pandoc --from markdown+mark --lua-filter custom-highlight.lua --standalone

# Highlight colors (use color names or hex values like '#ff9900')
highlight-color: 'orange'                    # Background color for ==highlighted text==
highlight-background-color: 'lightyellow'    # Optional: override background specifically
highlight-text-color: 'darkblue'             # Optional: text color inside highlights

# Use 'none' or 'transparent' for no background (text color only)
# highlight-color: 'none'
# highlight-text-color: 'red'

# Name label configuration
name-label-emoji: false                      # Set to 'true' for email-friendly emoji mode
                                             # false = Font Awesome icons (auto-included)
                                             # true = Unicode emoji 👤 (no external CSS)

# Note: Font Awesome CSS is automatically included for HTML output
# LaTeX fontawesome5 package is automatically included for PDF output
---

# Your Document

This is ==highlighted text== in orange.

[name=Alice] wrote this section.
