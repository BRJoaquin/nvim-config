-- ============================================================================
-- Plugin manifest — the SINGLE source of truth for what is installed.
-- Uses Neovim's native vim.pack (no lazy.nvim, no bootstrap clone).
--
-- Fresh machine: clone the dotfiles, `stow nvim`, launch `nvim`. vim.pack
-- installs everything below on first start (synchronously, so the require()
-- calls in init.lua resolve immediately).
--
-- Reproducibility: vim.pack writes a lockfile at ~/.config/nvim/nvim-pack-lock.json.
-- Commit it to pin exact revisions across machines.
--   :packupdate            update all plugins + rewrite the lockfile
--   :packupdate ++lockfile restore the locked revisions
--
-- Versioning: `version` pins a branch / tag / commit, or a semver range. Where
-- it is omitted we track the repo's default branch — weaker than a hard pin,
-- accepted for minimalism. Pin a tag/commit here to freeze a plugin.
-- ============================================================================

vim.pack.add({
  -- Colorscheme
  { src = "https://github.com/folke/tokyonight.nvim" }, -- colorscheme (style "night")

  -- Shared libraries (pulled in as dependencies, not configured directly)
  { src = "https://github.com/nvim-lua/plenary.nvim" }, -- Lua stdlib (async/fs/job) — dep of neo-tree
  { src = "https://github.com/MunifTanjim/nui.nvim" }, -- UI component toolkit — dep of neo-tree
  { src = "https://github.com/lewis6991/async.nvim" }, -- async primitives — dep of refactoring.nvim

  -- mini.nvim: one repo → mini.ai (textobjects) / mini.surround /
  -- mini.diff (git gutter) / mini.icons. (Org moved from echasnovski → nvim-mini.)
  { src = "https://github.com/nvim-mini/mini.nvim" },

  -- Treesitter — MAIN branch (the rewrite). version='main' is REQUIRED: the repo
  -- default branch is still the legacy 'master'.
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" }, -- parsers → highlight/fold/indent
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" }, -- function/class textobject queries (used by mini.ai)

  -- LSP — native vim.lsp.config/enable; nvim-lspconfig only ships server defs.
  { src = "https://github.com/neovim/nvim-lspconfig" }, -- server definitions (lsp/*.lua) for vim.lsp
  { src = "https://github.com/mason-org/mason.nvim" }, -- installer for LSP servers / formatters / linters
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- bridges mason ↔ lspconfig; auto-installs enabled servers
  { src = "https://github.com/folke/lazydev.nvim" }, -- Neovim Lua API completion/types for lua_ls
  { src = "https://github.com/b0o/SchemaStore.nvim" }, -- JSON/YAML schema catalog for jsonls/yamlls

  -- Completion + snippets.
  -- blink.cmp pinned to v1.x: a tag pin makes it auto-download the prebuilt Rust
  -- fuzzy matcher (no build step). Do NOT add blink.lib — that is v2/main only.
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") }, -- completion engine
  { src = "https://github.com/L3MON4D3/LuaSnip" }, -- snippet engine (driven by blink)
  { src = "https://github.com/rafamadriz/friendly-snippets" }, -- community snippet collection

  -- Editing / motions
  { src = "https://github.com/folke/flash.nvim" }, -- jump anywhere on screen with `s`
  { src = "https://github.com/folke/ts-comments.nvim" }, -- correct commentstring per treesitter region (JSX/Vue)
  { src = "https://github.com/ThePrimeagen/refactoring.nvim" }, -- extract/inline refactors

  -- UI
  { src = "https://github.com/folke/snacks.nvim" }, -- toolkit: picker, notifier, scroll, lazygit, gitbrowse, rename…
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" }, -- file explorer sidebar
  { src = "https://github.com/nvim-lualine/lualine.nvim" }, -- statusline
  { src = "https://github.com/akinsho/bufferline.nvim" }, -- buffer tabs along the top
  { src = "https://github.com/folke/which-key.nvim" }, -- popup of pending keybindings

  -- Formatting
  { src = "https://github.com/stevearc/conform.nvim" }, -- formatter dispatcher (prettier/stylua/shfmt/…)

  -- Navigation
  { src = "https://github.com/christoomey/vim-tmux-navigator" }, -- unified <C-hjkl> across nvim splits & tmux panes

  -- Practice: `:VimBeGood` — motion drills (runs entirely inside nvim, unlike
  -- vimgolf which needs a keystroke log format nvim can't produce).
  { src = "https://github.com/ThePrimeagen/vim-be-good" },
})
