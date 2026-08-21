-- bufferline.nvim — buffer tabs. Icons via mini.icons (mocked in mini.lua).
-- A "pinned" group lets us close all non-pinned buffers as a group (<leader>bP).
require("bufferline").setup({
  options = {
    -- Reserve space for the neo-tree sidebar so buffer tabs start beside it,
    -- not underneath it.
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left",
        separator = true,
      },
    },
    groups = {
      items = { require("bufferline.groups").builtin.pinned:with({ icon = "" }) },
    },
  },
})

local map = vim.keymap.set
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle pin" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
map("n", "<leader>bP", function() require("bufferline.groups").action("ungrouped", "close") end, { desc = "Close non-pinned buffers" })
-- Delete the buffer while keeping the window layout intact.
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
