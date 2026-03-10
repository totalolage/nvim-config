-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "pastelbeans",
  transparency = true,
  hl_add = {
    -- NvChad v2.5 base highlights don't define these by default.
    -- Add them so inactive windows / sidebars can be transparent too.
    Normal = { bg = "NONE" },
    NormalNC = { bg = "NONE" },
    NormalSB = { bg = "NONE" },

    -- Built-in tabline groups are not part of base46 defaults.
    -- Define them explicitly so the tabline stays transparent.
    TabLine = { bg = "NONE", fg = "light_grey" },
    TabLineFill = { bg = "NONE" },
    TabLineSel = { bg = "NONE", fg = "white", bold = true },
  },

  hl_override = {
    -- transparent editor background
    Normal = { bg = "NONE" },

    -- Snacks' window theming is used by the OpenCode pane.
    -- Keep these as overrides (not hl_add) so they win over Snacks defaults.
    SnacksNormal = { bg = "NONE" },
    SnacksNormalNC = { bg = "NONE" },

    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    NormalFloatNC = { bg = "NONE" },
    WinSeparator = { bg = "NONE", fg = "one_bg3" },

    -- tabufline: keep transparent but readable
    TbFill = { bg = "NONE" },
    TbBufOn = { bg = "NONE", fg = "white" },
    TbBufOff = { bg = "NONE", fg = "light_grey" },
    TbBufOnModified = { bg = "NONE", fg = "green" },
    TbBufOffModified = { bg = "NONE", fg = "yellow" },
    TbBufOnClose = { bg = "NONE", fg = "red" },
    TbBufOffClose = { bg = "NONE", fg = "light_grey" },
    TbTabOn = { bg = "NONE", fg = "white", bold = true },
    TbTabOff = { bg = "NONE", fg = "light_grey" },
    TBTabTitle = { bg = "NONE", fg = "blue", bold = true },
    TbTabNewBtn = { bg = "NONE", fg = "blue" },
    TbTabCloseBtn = { bg = "NONE", fg = "red" },
    TbThemeToggleBtn = { bg = "NONE", fg = "purple", bold = true },
    TbCloseAllBufsBtn = { bg = "NONE", fg = "red", bold = true },

    -- transparent floating windows/popups (keep borders readable)
    NormalFloat = { bg = "NONE" },
    FloatBorder = { bg = "NONE", fg = "one_bg3" },
    Pmenu = { bg = "NONE" },
    PmenuSel = { bg = "one_bg2" },
    PmenuSbar = { bg = "NONE" },
    PmenuThumb = { bg = "NONE" },
    CmpPmenu = { bg = "NONE" },
    CmpDoc = { bg = "NONE" },
    CmpDocBorder = { bg = "NONE", fg = "one_bg3" },
    TelescopeNormal = { bg = "NONE" },
    TelescopeBorder = { bg = "NONE", fg = "one_bg3" },
    TelescopePromptNormal = { bg = "NONE" },
    TelescopePromptBorder = { bg = "NONE", fg = "one_bg3" },
    TelescopeResultsNormal = { bg = "NONE" },
    TelescopeResultsBorder = { bg = "NONE", fg = "one_bg3" },
    TelescopePreviewNormal = { bg = "NONE" },
    TelescopePreviewBorder = { bg = "NONE", fg = "one_bg3" },

    LspHoverNormal = { bg = "one_bg" },
    LspHoverBorder = { bg = "one_bg", fg = "one_bg3" },
  },
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  focusable = true,
  winhighlight = "Normal:LspHoverNormal,FloatBorder:LspHoverBorder",
})

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
