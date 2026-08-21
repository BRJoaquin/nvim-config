-- vim-tmux-navigator — <C-h/j/k/l> move seamlessly between Neovim splits and
-- tmux panes (paired with ~/.config/tmux). The plugin loads eagerly via
-- pack.lua and binds these itself; we re-declare them here so the navigation
-- keys are visible/owned in the config.
local map = vim.keymap.set
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window/pane" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to lower window/pane" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to upper window/pane" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window/pane" })
