-- flash.nvim — jump motions. We map s/S/r/R + the cmdline toggle below.
-- `s` is owned by flash, which is why mini.surround moved to the `gs` prefix.
-- flash's `char` mode (which would remap f/F/t/T/;/,) is DISABLED so native
-- f/t and ; , repeat keep their standard behaviour.
require("flash").setup({
  modes = { char = { enabled = false } },
})

local map = vim.keymap.set
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
map("o", "r", function() require("flash").remote() end, { desc = "Remote flash" })
map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter search" })
map("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle flash search" })
