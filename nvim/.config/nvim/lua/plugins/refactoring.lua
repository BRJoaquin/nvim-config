-- refactoring.nvim — treesitter-based refactors. The string API
-- refactor("Extract Function") was removed; use the dedicated functions with
-- expr=true (they return a motion). select_refactor() opens a menu via
-- vim.ui.select, which snacks owns (see snacks.lua → picker.ui_select).
require("refactoring").setup({})

local r = require("refactoring")
local map = vim.keymap.set
-- All ops work in normal + visual mode; expr = true is required.
map({ "n", "x" }, "<leader>re", function() return r.extract_func() end, { desc = "Extract function", expr = true })
map({ "n", "x" }, "<leader>rf", function() return r.extract_func_to_file() end, { desc = "Extract function to file", expr = true })
map({ "n", "x" }, "<leader>rv", function() return r.extract_var() end, { desc = "Extract variable", expr = true })
map({ "n", "x" }, "<leader>ri", function() return r.inline_var() end, { desc = "Inline variable", expr = true })
map({ "n", "x" }, "<leader>rI", function() return r.inline_func() end, { desc = "Inline function", expr = true })
map({ "n", "x" }, "<leader>rr", function() r.select_refactor() end, { desc = "Select refactor" })
