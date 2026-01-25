-- Retro Phosphor colorscheme - dark green/orange CRT aesthetic
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.g.colors_name = "retro-phosphor"
vim.o.termguicolors = true

local c = {
    bg = "#0a0f0a",
    bg_light = "#0d1a0d",
    bg_highlight = "#1a3320",
    fg = "#a0c4a0",
    fg_dim = "#7a9a7a",
    fg_dark = "#5a7a5a",
    orange = "#ff9500",
    orange_dim = "#cc7700",
    orange_bright = "#ffaa33",
    green_bright = "#c8e0c8",
    red = "#ff6b35",
    cyan = "#7fbf9f",
    comment = "#5a7a5a",
    line_nr = "#3a5a3a",
    visual = "#1a3d1a",
    none = "NONE",
}

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hl("Normal", { fg = c.fg, bg = c.none }) -- transparent background
hl("NormalFloat", { fg = c.fg, bg = c.bg_light })
hl("FloatBorder", { fg = c.fg_dark, bg = c.bg_light })
hl("Cursor", { fg = c.bg, bg = c.orange })
hl("CursorLine", { bg = c.bg_light })
hl("CursorLineNr", { fg = c.orange, bold = true })
hl("LineNr", { fg = c.line_nr })
hl("SignColumn", { bg = c.none })
hl("VertSplit", { fg = c.fg_dark })
hl("WinSeparator", { fg = c.fg_dark })
hl("StatusLine", { fg = c.fg, bg = c.bg_light })
hl("StatusLineNC", { fg = c.fg_dark, bg = c.bg_light })
hl("TabLine", { fg = c.fg_dim, bg = c.bg_light })
hl("TabLineFill", { bg = c.bg_light })
hl("TabLineSel", { fg = c.orange, bg = c.bg, bold = true })
hl("Pmenu", { fg = c.fg, bg = c.bg_light })
hl("PmenuSel", { fg = c.bg, bg = c.orange })
hl("PmenuSbar", { bg = c.bg_light })
hl("PmenuThumb", { bg = c.fg_dark })
hl("Visual", { bg = c.visual })
hl("VisualNOS", { bg = c.visual })
hl("Search", { fg = c.bg, bg = c.orange })
hl("IncSearch", { fg = c.bg, bg = c.green_bright })
hl("CurSearch", { fg = c.bg, bg = c.orange_bright })
hl("MatchParen", { fg = c.orange_bright, bold = true, underline = true })
hl("Folded", { fg = c.comment, bg = c.bg_light })
hl("FoldColumn", { fg = c.comment })
hl("NonText", { fg = c.fg_dark })
hl("SpecialKey", { fg = c.fg_dark })
hl("Whitespace", { fg = c.bg_highlight })
hl("EndOfBuffer", { fg = c.bg_light })
hl("Directory", { fg = c.cyan })
hl("Title", { fg = c.orange, bold = true })
hl("ErrorMsg", { fg = c.red, bold = true })
hl("WarningMsg", { fg = c.orange })
hl("ModeMsg", { fg = c.fg, bold = true })
hl("MoreMsg", { fg = c.cyan })
hl("Question", { fg = c.cyan })
hl("WildMenu", { fg = c.bg, bg = c.orange })

-- Diagnostics
hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.orange })
hl("DiagnosticInfo", { fg = c.cyan })
hl("DiagnosticHint", { fg = c.fg_dim })
hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.orange })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.cyan })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.fg_dim })

-- Diff
hl("DiffAdd", { fg = c.green_bright, bg = c.bg_highlight })
hl("DiffChange", { fg = c.orange, bg = c.bg_light })
hl("DiffDelete", { fg = c.red, bg = c.bg_light })
hl("DiffText", { fg = c.orange_bright, bg = c.bg_highlight })

-- Syntax
hl("Comment", { fg = c.comment, italic = true })
hl("Constant", { fg = c.orange })
hl("String", { fg = c.fg_dim })
hl("Character", { fg = c.fg_dim })
hl("Number", { fg = c.orange_bright })
hl("Boolean", { fg = c.orange })
hl("Float", { fg = c.orange_bright })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.green_bright })
hl("Statement", { fg = c.orange })
hl("Conditional", { fg = c.orange })
hl("Repeat", { fg = c.orange })
hl("Label", { fg = c.orange_dim })
hl("Operator", { fg = c.fg })
hl("Keyword", { fg = c.orange })
hl("Exception", { fg = c.red })
hl("PreProc", { fg = c.orange_dim })
hl("Include", { fg = c.orange_dim })
hl("Define", { fg = c.orange_dim })
hl("Macro", { fg = c.orange_dim })
hl("PreCondit", { fg = c.orange_dim })
hl("Type", { fg = c.cyan })
hl("StorageClass", { fg = c.orange })
hl("Structure", { fg = c.cyan })
hl("Typedef", { fg = c.cyan })
hl("Special", { fg = c.orange })
hl("SpecialChar", { fg = c.orange })
hl("Tag", { fg = c.orange })
hl("Delimiter", { fg = c.fg_dim })
hl("SpecialComment", { fg = c.comment })
hl("Debug", { fg = c.red })
hl("Underlined", { underline = true })
hl("Ignore", { fg = c.bg_light })
hl("Error", { fg = c.red, bold = true })
hl("Todo", { fg = c.bg, bg = c.orange, bold = true })

-- Treesitter
hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.orange_dim })
hl("@variable.parameter", { fg = c.fg })
hl("@variable.member", { fg = c.fg })
hl("@constant", { fg = c.orange })
hl("@constant.builtin", { fg = c.orange })
hl("@constant.macro", { fg = c.orange })
hl("@module", { fg = c.fg_dim })
hl("@label", { fg = c.orange_dim })
hl("@string", { fg = c.fg_dim })
hl("@string.escape", { fg = c.orange })
hl("@string.special", { fg = c.orange })
hl("@character", { fg = c.fg_dim })
hl("@number", { fg = c.orange_bright })
hl("@boolean", { fg = c.orange })
hl("@float", { fg = c.orange_bright })
hl("@function", { fg = c.green_bright })
hl("@function.builtin", { fg = c.green_bright })
hl("@function.call", { fg = c.green_bright })
hl("@function.macro", { fg = c.orange_dim })
hl("@function.method", { fg = c.green_bright })
hl("@function.method.call", { fg = c.green_bright })
hl("@constructor", { fg = c.cyan })
hl("@keyword", { fg = c.orange })
hl("@keyword.function", { fg = c.orange })
hl("@keyword.operator", { fg = c.orange })
hl("@keyword.return", { fg = c.orange })
hl("@keyword.conditional", { fg = c.orange })
hl("@keyword.repeat", { fg = c.orange })
hl("@keyword.import", { fg = c.orange_dim })
hl("@keyword.exception", { fg = c.red })
hl("@operator", { fg = c.fg })
hl("@punctuation.delimiter", { fg = c.fg_dim })
hl("@punctuation.bracket", { fg = c.fg_dim })
hl("@punctuation.special", { fg = c.orange })
hl("@comment", { fg = c.comment, italic = true })
hl("@type", { fg = c.cyan })
hl("@type.builtin", { fg = c.cyan })
hl("@type.definition", { fg = c.cyan })
hl("@type.qualifier", { fg = c.orange })
hl("@attribute", { fg = c.orange_dim })
hl("@property", { fg = c.fg })
hl("@tag", { fg = c.orange })
hl("@tag.attribute", { fg = c.fg_dim })
hl("@tag.delimiter", { fg = c.fg_dark })

-- LSP
hl("LspReferenceText", { bg = c.bg_highlight })
hl("LspReferenceRead", { bg = c.bg_highlight })
hl("LspReferenceWrite", { bg = c.bg_highlight })
hl("LspSignatureActiveParameter", { fg = c.orange, bold = true })
hl("LspInlayHint", { fg = c.comment, bg = c.bg_light })

-- Telescope
hl("TelescopeNormal", { fg = c.fg, bg = c.bg_light })
hl("TelescopeBorder", { fg = c.fg_dark, bg = c.bg_light })
hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg_light })
hl("TelescopePromptBorder", { fg = c.orange, bg = c.bg_light })
hl("TelescopePromptTitle", { fg = c.bg, bg = c.orange })
hl("TelescopePreviewTitle", { fg = c.bg, bg = c.fg_dark })
hl("TelescopeResultsTitle", { fg = c.bg, bg = c.fg_dark })
hl("TelescopeSelection", { fg = c.orange, bg = c.visual })
hl("TelescopeSelectionCaret", { fg = c.orange })
hl("TelescopeMatching", { fg = c.orange_bright, bold = true })

-- Git signs
hl("GitSignsAdd", { fg = c.green_bright })
hl("GitSignsChange", { fg = c.orange })
hl("GitSignsDelete", { fg = c.red })

-- Indent blankline
hl("IblIndent", { fg = c.bg_highlight })
hl("IblScope", { fg = c.fg_dark })

-- Notify
hl("NotifyBackground", { bg = c.bg })
hl("NotifyERRORBorder", { fg = c.red })
hl("NotifyWARNBorder", { fg = c.orange })
hl("NotifyINFOBorder", { fg = c.fg_dark })
hl("NotifyDEBUGBorder", { fg = c.comment })
hl("NotifyTRACEBorder", { fg = c.comment })
hl("NotifyERRORIcon", { fg = c.red })
hl("NotifyWARNIcon", { fg = c.orange })
hl("NotifyINFOIcon", { fg = c.cyan })
hl("NotifyDEBUGIcon", { fg = c.comment })
hl("NotifyTRACEIcon", { fg = c.comment })
hl("NotifyERRORTitle", { fg = c.red })
hl("NotifyWARNTitle", { fg = c.orange })
hl("NotifyINFOTitle", { fg = c.cyan })
hl("NotifyDEBUGTitle", { fg = c.comment })
hl("NotifyTRACETitle", { fg = c.comment })
