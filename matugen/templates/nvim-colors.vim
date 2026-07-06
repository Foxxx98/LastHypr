" ╔══════════════════════════════════════════════════════════════════╗
" ║  matugen template — nvim-colors.vim                            ║
" ║  Output: ~/.config/nvim/colors/matugen.vim                     ║
" ║  Regenerated automatically by: matugen image <wallpaper>       ║
" ╚══════════════════════════════════════════════════════════════════╝

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "matugen"

" ── Base ─────────────────────────────────────────────────────────
hi Normal       guibg={{ colors.surface.dark.hex }}               guifg={{ colors.on_surface.dark.hex }}
hi NormalNC     guibg={{ colors.surface_container_low.light.hex }}  guifg={{ colors.on_surface_variant.dark.hex }}
hi NormalFloat  guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.on_surface.dark.hex }}
hi FloatBorder  guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.outline.dark.hex }}
hi FloatTitle   guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.primary.dark.hex }}      gui=bold

" ── Cursor & selection ───────────────────────────────────────────
hi Cursor       guibg={{ colors.primary.dark.hex }}               guifg={{ colors.on_primary.dark.hex }}
hi CursorLine   guibg={{ colors.surface_container_high.dark.hex }} guifg=None
hi CursorLineNr guibg=None                                         guifg={{ colors.primary.dark.hex }}      gui=bold
hi CursorColumn guibg={{ colors.surface_container_high.dark.hex }}
hi Visual       guibg={{ colors.primary_container.dark.hex }}      guifg={{ colors.on_primary_container.dark.hex }}
hi VisualNOS    guibg={{ colors.primary_container.dark.hex }}      guifg={{ colors.on_primary_container.dark.hex }}

" ── Line numbers & columns ───────────────────────────────────────
hi LineNr       guibg=None  guifg={{ colors.outline_variant.dark.hex }}
hi SignColumn   guibg=None  guifg={{ colors.outline_variant.dark.hex }}
hi FoldColumn   guibg=None  guifg={{ colors.outline.dark.hex }}
hi Folded       guibg={{ colors.surface_container.dark.hex }}  guifg={{ colors.on_surface_variant.dark.hex }}
hi ColorColumn  guibg={{ colors.surface_container_high.dark.hex }}

" ── Status & tab line ────────────────────────────────────────────
hi StatusLine   guibg={{ colors.primary.light.hex }}               guifg={{ colors.on_primary.dark.hex }}
hi StatusLineNC guibg={{ colors.primary_container.light.hex }}     guifg={{ colors.on_primary_container.dark.hex }}
hi TabLine      guibg={{ colors.surface_container.dark.hex }}     guifg={{ colors.on_surface_variant.dark.hex }}
hi TabLineSel   guibg={{ colors.primary.dark.hex }}               guifg={{ colors.on_primary.dark.hex }}      gui=bold
hi TabLineFill  guibg={{ colors.surface_container_low.dark.hex }}

" ── Window separators ────────────────────────────────────────────
hi WinSeparator guibg=None  guifg={{ colors.outline_variant.dark.hex }}
hi VertSplit    guibg=None  guifg={{ colors.outline_variant.dark.hex }}

" ── Popup menu (completion) ──────────────────────────────────────
hi Pmenu        guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.on_surface.dark.hex }}
hi PmenuSel     guibg={{ colors.primary.dark.hex }}                guifg={{ colors.on_primary.dark.hex }}
hi PmenuSbar    guibg={{ colors.surface_container_high.dark.hex }}
hi PmenuThumb   guibg={{ colors.primary.dark.hex }}
hi PmenuBorder  guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.outline.dark.hex }}

" ── Search ───────────────────────────────────────────────────────
hi Search       guibg={{ colors.tertiary_container.dark.hex }}     guifg={{ colors.on_tertiary_container.dark.hex }}
hi IncSearch    guibg={{ colors.tertiary.dark.hex }}               guifg={{ colors.on_tertiary.dark.hex }}
hi CurSearch    guibg={{ colors.primary.dark.hex }}                guifg={{ colors.on_primary.dark.hex }}
hi Substitute   guibg={{ colors.error_container.dark.hex }}        guifg={{ colors.on_error_container.dark.hex }}

" ── Messages & prompts ───────────────────────────────────────────
hi MsgArea      guibg={{ colors.surface.dark.hex }}               guifg={{ colors.on_surface.dark.hex }}
hi ModeMsg      guibg=None  guifg={{ colors.primary.dark.hex }}   gui=bold
hi MoreMsg      guibg=None  guifg={{ colors.tertiary.dark.hex }}
hi WarningMsg   guibg=None  guifg={{ colors.secondary.dark.hex }}
hi ErrorMsg     guibg=None  guifg={{ colors.error.dark.hex }}
hi Question     guibg=None  guifg={{ colors.tertiary.dark.hex }}

" ── Syntax ───────────────────────────────────────────────────────
hi Comment      guibg=None  guifg={{ base16.base03.dark.hex }}    gui=italic
hi Delimiter    guibg=None  guifg={{ base16.base05.dark.hex }}
hi Operator     guibg=None  guifg={{ base16.base05.dark.hex }}
hi Todo         guibg=None  guifg={{ base16.base06.dark.hex }}    gui=bold,italic
hi Identifier   guibg=None  guifg={{ base16.base08.dark.hex }}
hi Constant     guibg=None  guifg={{ base16.base09.dark.hex }}
hi Type         guibg=None  guifg={{ base16.base0a.dark.hex }}
hi String       guibg=None  guifg={{ base16.base0b.dark.hex }}
hi Special      guibg=None  guifg={{ base16.base0c.dark.hex }}
hi PreProc      guibg=None  guifg={{ base16.base0c.dark.hex }}
hi Function     guibg=None  guifg={{ base16.base0d.dark.hex }}
hi Statement    guibg=None  guifg={{ base16.base0e.dark.hex }}
hi Keyword      guibg=None  guifg={{ base16.base0e.dark.hex }}    gui=bold
hi Number       guibg=None  guifg={{ base16.base09.dark.hex }}
hi Boolean      guibg=None  guifg={{ base16.base09.dark.hex }}
hi Character    guibg=None  guifg={{ base16.base0b.dark.hex }}

" ── Error & spelling ─────────────────────────────────────────────
hi Error        guibg={{ colors.error_container.dark.hex }}        guifg={{ colors.on_error_container.dark.hex }}
hi SpellBad     guibg=None  guifg={{ colors.error.dark.hex }}      gui=undercurl guisp={{ colors.error.dark.hex }}
hi SpellWarn    guibg=None  guifg={{ colors.secondary.dark.hex }}  gui=undercurl guisp={{ colors.secondary.dark.hex }}
hi SpellCap     guibg=None  guifg={{ colors.tertiary.dark.hex }}   gui=undercurl

" ── Diagnostics ──────────────────────────────────────────────────
hi DiagnosticError          guibg=None  guifg={{ colors.error.dark.hex }}
hi DiagnosticWarn           guibg=None  guifg={{ colors.secondary.dark.hex }}
hi DiagnosticHint           guibg=None  guifg={{ colors.tertiary.dark.hex }}
hi DiagnosticInfo           guibg=None  guifg={{ colors.primary.dark.hex }}
hi DiagnosticOk             guibg=None  guifg={{ base16.base0b.dark.hex }}

hi DiagnosticUnderlineError guibg=None  gui=undercurl guisp={{ colors.error.dark.hex }}
hi DiagnosticUnderlineWarn  guibg=None  gui=undercurl guisp={{ colors.secondary.dark.hex }}
hi DiagnosticUnderlineHint  guibg=None  gui=undercurl guisp={{ colors.tertiary.dark.hex }}
hi DiagnosticUnderlineInfo  guibg=None  gui=undercurl guisp={{ colors.primary.dark.hex }}

hi DiagnosticVirtualTextError guibg={{ colors.error_container.dark.hex }}     guifg={{ colors.on_error_container.dark.hex }}
hi DiagnosticVirtualTextWarn  guibg={{ colors.secondary_container.dark.hex }} guifg={{ colors.on_secondary_container.dark.hex }}
hi DiagnosticVirtualTextHint  guibg={{ colors.tertiary_container.dark.hex }}  guifg={{ colors.on_tertiary_container.dark.hex }}
hi DiagnosticVirtualTextInfo  guibg={{ colors.primary_container.dark.hex }}   guifg={{ colors.on_primary_container.dark.hex }}

hi DiagnosticSignError  guibg=None  guifg={{ colors.error.dark.hex }}
hi DiagnosticSignWarn   guibg=None  guifg={{ colors.secondary.dark.hex }}
hi DiagnosticSignHint   guibg=None  guifg={{ colors.tertiary.dark.hex }}
hi DiagnosticSignInfo   guibg=None  guifg={{ colors.primary.dark.hex }}

" ── Git (gitsigns / diff) ────────────────────────────────────────
hi DiffAdd      guibg={{ colors.tertiary_container.dark.hex }}    guifg={{ colors.on_tertiary_container.dark.hex }}
hi DiffDelete   guibg={{ colors.error_container.dark.hex }}       guifg={{ colors.on_error_container.dark.hex }}
hi DiffChange   guibg={{ colors.secondary_container.dark.hex }}   guifg={{ colors.on_secondary_container.dark.hex }}
hi DiffText     guibg={{ colors.secondary.dark.hex }}             guifg={{ colors.on_secondary.dark.hex }}

hi GitSignsAdd              guibg=None  guifg={{ base16.base0b.dark.hex }}
hi GitSignsChange           guibg=None  guifg={{ colors.secondary.dark.hex }}
hi GitSignsDelete           guibg=None  guifg={{ colors.error.dark.hex }}
hi GitSignsAddNr            guibg=None  guifg={{ base16.base0b.dark.hex }}
hi GitSignsChangeNr         guibg=None  guifg={{ colors.secondary.dark.hex }}
hi GitSignsDeleteNr         guibg=None  guifg={{ colors.error.dark.hex }}

" ── Telescope ────────────────────────────────────────────────────
hi TelescopeNormal          guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.on_surface.dark.hex }}
hi TelescopeBorder          guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.outline.dark.hex }}
hi TelescopePromptNormal    guibg={{ colors.surface_container_high.dark.hex }} guifg={{ colors.on_surface.dark.hex }}
hi TelescopePromptBorder    guibg={{ colors.surface_container_high.dark.hex }} guifg={{ colors.primary.dark.hex }}
hi TelescopePromptTitle     guibg={{ colors.primary.dark.hex }}                guifg={{ colors.on_primary.dark.hex }}      gui=bold
hi TelescopePreviewTitle    guibg={{ colors.tertiary_container.dark.hex }}     guifg={{ colors.on_tertiary_container.dark.hex }} gui=bold
hi TelescopeResultsTitle    guibg={{ colors.surface_container.dark.hex }}      guifg={{ colors.outline.dark.hex }}
hi TelescopeSelection       guibg={{ colors.primary_container.dark.hex }}      guifg={{ colors.on_primary_container.dark.hex }}
hi TelescopeSelectionCaret  guibg={{ colors.primary_container.dark.hex }}      guifg={{ colors.primary.dark.hex }}
hi TelescopeMatching        guibg=None  guifg={{ colors.tertiary.dark.hex }}   gui=bold

" ── Neo-tree ─────────────────────────────────────────────────────
hi NeoTreeNormal            guibg={{ colors.surface_container_low.dark.hex }}  guifg={{ colors.on_surface.dark.hex }}
hi NeoTreeNormalNC          guibg={{ colors.surface_container_low.dark.hex }}  guifg={{ colors.on_surface_variant.dark.hex }}
hi NeoTreeRootName          guibg=None  guifg={{ colors.primary.dark.hex }}    gui=bold
hi NeoTreeDirectoryName     guibg=None  guifg={{ colors.on_surface.dark.hex }}
hi NeoTreeDirectoryIcon     guibg=None  guifg={{ colors.secondary.dark.hex }}
hi NeoTreeFileName          guibg=None  guifg={{ colors.on_surface.dark.hex }}
hi NeoTreeFileIcon          guibg=None  guifg={{ colors.primary.dark.hex }}
hi NeoTreeGitAdded          guibg=None  guifg={{ base16.base0b.dark.hex }}
hi NeoTreeGitModified       guibg=None  guifg={{ colors.secondary.dark.hex }}
hi NeoTreeGitDeleted        guibg=None  guifg={{ colors.error.dark.hex }}
hi NeoTreeIndentMarker      guibg=None  guifg={{ colors.outline_variant.dark.hex }}
hi NeoTreeExpander          guibg=None  guifg={{ colors.outline.dark.hex }}
hi NeoTreeCursorLine        guibg={{ colors.surface_container_high.dark.hex }}

" ── Which-key ────────────────────────────────────────────────────
hi WhichKey         guibg=None  guifg={{ colors.primary.dark.hex }}
hi WhichKeyGroup    guibg=None  guifg={{ colors.tertiary.dark.hex }}
hi WhichKeyDesc     guibg=None  guifg={{ colors.on_surface.dark.hex }}
hi WhichKeySeparator guibg=None guifg={{ colors.outline.dark.hex }}
hi WhichKeyFloat    guibg={{ colors.surface_container.dark.hex }}
hi WhichKeyBorder   guibg={{ colors.surface_container.dark.hex }}  guifg={{ colors.outline.dark.hex }}

" ── nvim-cmp (completion) ────────────────────────────────────────
hi CmpItemAbbr              guibg=None  guifg={{ colors.on_surface.dark.hex }}
hi CmpItemAbbrMatch         guibg=None  guifg={{ colors.primary.dark.hex }}    gui=bold
hi CmpItemAbbrMatchFuzzy    guibg=None  guifg={{ colors.primary.dark.hex }}    gui=bold
hi CmpItemAbbrDeprecated    guibg=None  guifg={{ colors.outline.dark.hex }}    gui=strikethrough
hi CmpItemKind              guibg=None  guifg={{ colors.secondary.dark.hex }}
hi CmpItemMenu              guibg=None  guifg={{ colors.outline.dark.hex }}

" ── Indent guides (indent-blankline) ─────────────────────────────
hi IblIndent    guibg=None  guifg={{ colors.outline_variant.dark.hex }}
hi IblScope     guibg=None  guifg={{ colors.primary.dark.hex }}

" ── Misc UI ──────────────────────────────────────────────────────
hi MatchParen   guibg={{ colors.tertiary_container.dark.hex }}    guifg={{ colors.on_tertiary_container.dark.hex }} gui=bold
hi NonText      guibg=None  guifg={{ colors.outline_variant.dark.hex }}
hi Whitespace   guibg=None  guifg={{ colors.outline_variant.dark.hex }}
hi SpecialKey   guibg=None  guifg={{ colors.outline.dark.hex }}
hi Title        guibg=None  guifg={{ colors.primary.dark.hex }}   gui=bold
hi Directory    guibg=None  guifg={{ colors.primary.dark.hex }}
hi EndOfBuffer  guibg=None  guifg={{ colors.surface_container.dark.hex }}
hi Selection    guibg={{ base16.base02.dark.hex }}
hi WildMenu     guibg={{ colors.primary.dark.hex }}               guifg={{ colors.on_primary.dark.hex }}
hi QuickFixLine guibg={{ colors.primary_container.dark.hex }}     guifg={{ colors.on_primary_container.dark.hex }}
