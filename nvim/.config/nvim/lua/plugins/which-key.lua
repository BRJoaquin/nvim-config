-- which-key.nvim (v3) — surfaces leader bindings as you type. Mostly here to
-- learn/audit the keymap. Group labels use the v3 add() API (register() is gone).
require("which-key").setup({
  preset = "modern",
  delay = 200,
})

require("which-key").add({
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>q", group = "quit" },
  { "<leader>r", group = "refactor" },
  { "<leader>s", group = "search" },
  { "gs", group = "surround" },
})
