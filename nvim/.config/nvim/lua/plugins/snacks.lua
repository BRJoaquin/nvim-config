-- snacks.nvim — only these modules enabled (each value must be a table):
--   picker (find/grep), animate, scroll, notifier (toasts), quickfile.
-- git / gitbrowse / lazygit / rename are command-driven (no setup opts needed).
-- The native cmdline/messages UI is kept (no input/cmdline module enabled).
require("snacks").setup({
  picker = { ui_select = true }, -- route vim.ui.select (used by refactoring) through the picker
  animate = { fps = 240 }, -- global animation framerate; matched to the 240Hz monitor
  scroll = {}, -- smooth scrolling (uses the animate fps above)
  notifier = {},
  quickfile = {},
})

local map = vim.keymap.set

-- Project root of the current file (its git root), falling back to the cwd when
-- not in a repo. Scopes the find/grep pickers to the current project instead of
-- wherever nvim happened to be launched.
local function root()
  return Snacks.git.get_root() or vim.uv.cwd()
end

-- ── Find (scoped to the current project) ──────────────────────────────────────
-- hidden = true on every fs picker: this stow dotfiles repo lives under .config/
-- (a hidden dir), which rg/fd skip by default. (.git stays excluded; gitignored
-- files stay hidden.)
map("n", "<leader><space>", function() Snacks.picker.smart({ cwd = root(), filter = { cwd = true }, hidden = true }) end, { desc = "Smart find (project)" })
map("n", "<leader>ff", function() Snacks.picker.files({ cwd = root(), hidden = true }) end, { desc = "Find files (project)" })
map("n", "<leader>fg", function() Snacks.picker.grep({ cwd = root(), hidden = true }) end, { desc = "Grep (project)" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files (all projects)" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), hidden = true }) end, { desc = "Find config file" })
map({ "n", "x" }, "<leader>/", function() Snacks.picker.grep({ cwd = root(), hidden = true }) end, { desc = "Grep (project)" })

-- ── Search ──────────────────────────────────────────────────────────────────
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help pages" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })

-- ── Git ───────────────────────────────────────────────────────────────────────
map("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git blame line" })
map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git browse (open on remote)" })
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit file history" })

-- ── Code ──────────────────────────────────────────────────────────────────────
map("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename file (LSP-aware)" })
