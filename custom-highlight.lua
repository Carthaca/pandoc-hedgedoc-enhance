--[[
custom-highlight – customize the color of highlighted text (==text==)
                    and add HedgeDoc-style user attribution labels

Copyright 2026 SAP SE or an SAP affiliate company and contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]

local stringify = pandoc.utils.stringify

-- Color name to hex mapping
local color_names = {
  -- Basic colors
  black = '#000000',
  white = '#ffffff',
  red = '#ff0000',
  green = '#00ff00',
  blue = '#0000ff',
  yellow = '#ffff00',
  cyan = '#00ffff',
  magenta = '#ff00ff',

  -- Extended colors
  orange = '#ffa500',
  purple = '#800080',
  pink = '#ffc0cb',
  brown = '#a52a2a',
  gray = '#808080',
  grey = '#808080',

  -- Light variants
  lightred = '#ffcccc',
  lightgreen = '#ccffcc',
  lightblue = '#ccccff',
  lightyellow = '#ffffcc',
  lightcyan = '#ccffff',
  lightmagenta = '#ffccff',
  lightorange = '#ffe4cc',
  lightpurple = '#e6ccff',
  lightpink = '#ffe6f0',
  lightgray = '#d3d3d3',
  lightgrey = '#d3d3d3',

  -- Dark variants
  darkred = '#8b0000',
  darkgreen = '#006400',
  darkblue = '#00008b',
  darkyellow = '#cccc00',
  darkcyan = '#008b8b',
  darkmagenta = '#8b008b',
  darkorange = '#ff8c00',
  darkpurple = '#4b0082',
  darkpink = '#c71585',
  darkgray = '#a9a9a9',
  darkgrey = '#a9a9a9',
}

-- Add special value to disable background
color_names['none'] = 'none'
color_names['transparent'] = 'transparent'

-- Convert color name to hex, or return original if already hex
local function resolve_color(color)
  if not color then return nil end

  -- Remove whitespace and convert to lowercase
  local normalized = color:lower():gsub('%s+', '')

  -- Check if it's a color name
  if color_names[normalized] then
    return color_names[normalized]
  end

  -- Return as-is (assume it's hex or CSS color)
  return color
end

-- Default configuration
local config = {
  color = '#ffff00',           -- Default yellow
  background_color = nil,      -- Use foreground color as background by default
  text_color = nil,           -- Text color (optional)
}

-- Read configuration from metadata
local function read_config(meta)
  if meta['highlight-color'] then
    config.color = resolve_color(stringify(meta['highlight-color']))
  end
  if meta['highlight-background-color'] then
    config.background_color = resolve_color(stringify(meta['highlight-background-color']))
  end
  if meta['highlight-text-color'] then
    config.text_color = resolve_color(stringify(meta['highlight-text-color']))
  end
end

-- Generate HTML for highlighted text
local function html_highlight(content)
  local bg_color = config.background_color or config.color
  local style = ''

  -- Only add background if not 'none' or 'transparent'
  if bg_color ~= 'none' and bg_color ~= 'transparent' then
    style = string.format('background-color: %s;', bg_color)
  end

  if config.text_color then
    if #style > 0 then
      style = style .. ' '
    end
    style = style .. string.format('color: %s;', config.text_color)
  end

  -- Use span if no background, mark if there's background
  local tag = (bg_color == 'none' or bg_color == 'transparent') and 'span' or 'mark'

  if #style > 0 then
    local html = string.format('<%s style="%s">', tag, style)
    return {
      pandoc.RawInline('html', html)
    }, content, {
      pandoc.RawInline('html', string.format('</%s>', tag))
    }
  else
    -- No styling needed, return content as-is
    return {}, content, {}
  end
end

-- Generate LaTeX for highlighted text
local function latex_highlight(content)
  local bg_color = config.background_color or config.color

  -- Convert hex color to RGB if needed
  local function hex_to_rgb(hex)
    if hex == 'none' or hex == 'transparent' then
      return nil
    end
    hex = hex:gsub('#', '')
    if #hex == 6 then
      local r = tonumber(hex:sub(1, 2), 16) / 255
      local g = tonumber(hex:sub(3, 4), 16) / 255
      local b = tonumber(hex:sub(5, 6), 16) / 255
      return string.format('%.3f,%.3f,%.3f', r, g, b)
    end
    return '1,1,0' -- fallback to yellow
  end

  local rgb = hex_to_rgb(bg_color)
  local text_rgb = config.text_color and hex_to_rgb(config.text_color)

  -- Only text color, no background
  if not rgb and text_rgb then
    local latex_begin = string.format('\\textcolor[rgb]{%s}{', text_rgb)
    return {
      pandoc.RawInline('latex', latex_begin)
    }, content, {
      pandoc.RawInline('latex', '}')
    }
  end

  -- Only background, no text color
  if rgb and not text_rgb then
    local latex_begin = string.format('\\colorbox[rgb]{%s}{', rgb)
    return {
      pandoc.RawInline('latex', latex_begin)
    }, content, {
      pandoc.RawInline('latex', '}')
    }
  end

  -- Both background and text color
  if rgb and text_rgb then
    local latex_begin = string.format('\\colorbox[rgb]{%s}{\\textcolor[rgb]{%s}{', rgb, text_rgb)
    return {
      pandoc.RawInline('latex', latex_begin)
    }, content, {
      pandoc.RawInline('latex', '}}')
    }
  end

  -- No styling
  return {}, content, {}
end

-- Process Span elements with class "mark"
local function process_mark(span)
  -- Check if this is a mark span
  if not span.classes:includes('mark') then
    return nil
  end

  -- Get the content
  local content = span.content

  -- Generate format-specific output
  if FORMAT:match 'html' then
    local prefix, _, suffix = html_highlight(content)
    return pandoc.Span(
      pandoc.List:new(prefix) .. content .. pandoc.List:new(suffix)
    )
  elseif FORMAT:match 'latex' then
    local prefix, _, suffix = latex_highlight(content)
    return pandoc.Span(
      pandoc.List:new(prefix) .. content .. pandoc.List:new(suffix)
    )
  end

  -- For other formats, leave unchanged
  return nil
end

-- Parse [name=Something] pattern from text
-- Returns: name (string or nil), remaining_text (string)
local function parse_name_pattern(text)
  local name = text:match('%[name=([^%]]+)%]')
  if name and name ~= '' then
    -- Remove the [name=...] pattern from the text
    local remaining = text:gsub('%[name=[^%]]+%]', '', 1)
    return name, remaining
  end
  return nil, text
end

-- Escape HTML special characters to prevent injection
local function escape_html(text)
  return text:gsub('&', '&amp;')
             :gsub('<', '&lt;')
             :gsub('>', '&gt;')
             :gsub('"', '&quot;')
             :gsub("'", '&#39;')
end

-- Escape LaTeX special characters to prevent injection
local function escape_latex(text)
  return text:gsub('\\', '\\textbackslash{}')
             :gsub('{', '\\{')
             :gsub('}', '\\}')
             :gsub('%$', '\\$')
             :gsub('&', '\\&')
             :gsub('#', '\\#')
             :gsub('_', '\\_')
             :gsub('%%', '\\%')
             :gsub('~', '\\textasciitilde{}')
             :gsub('%^', '\\textasciicircum{}')
end

-- Generate format-specific output for name labels
-- Returns: Pandoc inline element for the name label
local function format_name_label(name)
  if FORMAT:match 'html' then
    local html = string.format('<small><i class="fa fa-user"></i> %s</small>', escape_html(name))
    return pandoc.RawInline('html', html)
  elseif FORMAT:match 'latex' then
    local latex = string.format('{\\small \\faUser\\ %s}', escape_latex(name))
    return pandoc.RawInline('latex', latex)
  else
    -- For other formats, use Unicode emoji
    return pandoc.Str('👤 ' .. name)
  end
end

-- Process inline elements to detect and replace [name=...] patterns
local function process_name_labels(inlines)
  local result = pandoc.List:new()
  local i = 1

  while i <= #inlines do
    local elem = inlines[i]

    if elem.t == 'Str' then
      local text = elem.text

      -- Check if this starts a [name=...] pattern
      local start_bracket = text:match('^(.*%[name=.*)$')

      if start_bracket then
        -- Collect text across multiple elements until we find the closing bracket
        local accumulated = text
        local j = i + 1
        local found_end = accumulated:match('%]')

        -- Look ahead to collect full pattern across Str and Space elements
        while not found_end and j <= #inlines do
          local next_elem = inlines[j]
          if next_elem.t == 'Str' then
            accumulated = accumulated .. next_elem.text
            found_end = accumulated:match('%]')
            j = j + 1
          elseif next_elem.t == 'Space' then
            accumulated = accumulated .. ' '
            j = j + 1
          else
            -- Hit something else, stop looking
            break
          end
        end

        -- Try to extract the pattern from accumulated text
        local before, pattern, after = accumulated:match('^(.-)(%[name=[^%]]+%])(.*)$')

        if pattern then
          -- Add text before pattern
          if before and #before > 0 then
            result:insert(pandoc.Str(before))
          end

          -- Parse and format the name
          local name = pattern:match('%[name=([^%]]+)%]')
          if name and #name > 0 then
            result:insert(format_name_label(name))
          else
            -- Malformed pattern, keep original
            result:insert(pandoc.Str(pattern))
          end

          -- Add text after pattern
          if after and #after > 0 then
            result:insert(pandoc.Str(after))
          end

          -- Skip the elements we've processed
          i = j
        else
          -- No valid pattern found, keep original
          result:insert(elem)
          i = i + 1
        end
      else
        -- No pattern start, keep as-is
        result:insert(elem)
        i = i + 1
      end
    else
      -- Not a Str element, keep as-is
      result:insert(elem)
      i = i + 1
    end
  end

  return result
end

-- Return the filter
return {
  { Meta = read_config },
  { Span = process_mark },
  { Inlines = process_name_labels }
}
