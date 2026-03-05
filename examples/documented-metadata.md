---
# Custom Highlight Filter Configuration
# Use with: pandoc --from markdown+mark --lua-filter custom-highlight.lua

# Highlight colors (use color names or hex values like '#ff9900')
highlight-color: 'orange'                    # Background color for ==highlighted text==
highlight-background-color: 'lightyellow'    # Optional: override background specifically
highlight-text-color: 'darkblue'             # Optional: text color inside highlights

# Use 'none' or 'transparent' for no background (text color only)
# highlight-color: 'none'
# highlight-text-color: 'red'

# Name label configuration
name-label-emoji: false                      # Set to 'true' for email-friendly emoji mode
                                             # false = Font Awesome icons (default)
                                             # true = Unicode emoji 👤

# Font Awesome CSS (required if name-label-emoji is false)
header-includes: |
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
---

# Your Document

This is ==highlighted text== in orange.

[name=Alice] wrote this section.
