-- Editor options. Loaded first, before plugins.
local opt = vim.opt

-- ── UI / display ────────────────────────────────────────────────────────────
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes" -- always show the sign column (no text shift on diag/git)
opt.termguicolors = true -- 24-bit color (required by tokyonight)
opt.cursorline = true -- highlight the line the cursor is on
opt.scrolloff = 4 -- keep 4 lines of context above/below the cursor
opt.wrap = false -- no soft line wrapping
opt.cmdheight = 0 -- hide the command line when idle (expands on demand for : and messages)

-- ── Splits ──────────────────────────────────────────────────────────────────
opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below

-- ── Search ──────────────────────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase = true -- case-sensitive only when the query has a capital

-- ── Editing / indentation (4-space, expand tabs) ──────────────────────────────
opt.expandtab = true -- insert spaces when pressing <Tab>
opt.shiftwidth = 4 -- indentation amount
opt.tabstop = 4 -- existing tabs render as 4 columns
opt.softtabstop = 4 -- <Tab>/<BS> operate in 4-space steps

-- ── Behaviour ─────────────────────────────────────────────────────────────────
opt.mouse = "a"
opt.confirm = true -- prompt to save instead of failing :q on a dirty buffer
opt.updatetime = 200 -- faster CursorHold (drives checktime + diagnostics float)
opt.timeoutlen = 300 -- which-key pops after 300ms
opt.completeopt = "menu,menuone,noselect"
opt.autoread = true -- re-read files changed outside Neovim (see autocmds.lua)
opt.foldlevel = 99 -- start with all treesitter folds open

-- ── Persistence: keep undo history, but no swap/backup files ──────────────────
-- No swap/backup keeps file inodes stable, which preserves the stow symlinks
-- when saving.
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- ── Clipboard: yanks go to the system clipboard ───────────────────────────────
-- Needs a provider per machine: Linux/X11 → xclip or xsel; macOS → pbcopy
-- (built in). Without one this silently falls back to the unnamed register.
opt.clipboard = "unnamedplus"

-- Force xclip over xsel on X11: nvim auto-detects xsel first, but xsel 1.2.1
-- never completes large (~>16KB) selection transfers to Chromium 149+, which
-- hangs the browser tab on paste and blocks all later pastes until restart.
if vim.env.DISPLAY and vim.fn.executable("xclip") == 1 then
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = { "xclip", "-quiet", "-i", "-selection", "clipboard" },
      ["*"] = { "xclip", "-quiet", "-i", "-selection", "primary" },
    },
    paste = {
      ["+"] = { "xclip", "-o", "-selection", "clipboard" },
      ["*"] = { "xclip", "-o", "-selection", "primary" },
    },
    cache_enabled = true,
  }
end
