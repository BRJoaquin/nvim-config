-- ============================================================================
-- Neovim entry point.
-- Minimal, native-first (Neovim 0.12+). Plugin manager = vim.pack (no LazyVim).
-- Load order below is STRICT: each step assumes the previous one ran.
-- ============================================================================

-- Leader keys must be set BEFORE any plugin/keymap is defined, so every
-- <leader> mapping created during setup resolves to the right key.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 1. Editor options (some are read by plugins at setup time).
require("config.options")

-- 2. Declare/install all plugins (single vim.pack manifest). vim.pack installs
--    anything missing synchronously, so every require() below resolves.
require("plugins.pack")

-- 3. Colorscheme early, so all later UI is themed from the start.
require("plugins.colorscheme")

-- 4. mini FIRST: it sets up mini.icons and mocks nvim-web-devicons, which
--    neo-tree / bufferline / lualine must see BEFORE they load.
require("plugins.mini")

-- 5. Remaining plugin setup modules.
require("plugins.treesitter")
require("plugins.luasnip") -- snippet engine; must precede blink (luasnip preset)
require("plugins.blink")
require("plugins.flash")
require("plugins.neo-tree")
require("plugins.snacks")
require("plugins.lualine")
require("plugins.bufferline")
require("plugins.conform")
require("plugins.refactoring")
require("plugins.ts-comments")
require("plugins.tmux-navigator")
require("plugins.which-key")

-- 6. LSP: native vim.lsp.config/enable + mason. Needs blink (capabilities) and
--    snacks (LSP keymaps route through its picker), both loaded above.
require("config.lsp")

-- 7. Editor-level + extra LSP keymaps not tied to a single plugin.
require("config.keymaps")

-- 8. Autocmds (yank highlight, autoread/checktime).
require("config.autocmds")
