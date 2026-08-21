-- Editor-level keymaps + LSP extras. Plugin-specific maps live in each
-- plugins/*.lua module. Leader is set in init.lua.
local map = vim.keymap.set

-- ── Editor ────────────────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
-- Normal/visual only: insert-mode <C-s> is native signature-help (see LSP
-- section below) and stays untouched. Terminal-side, Ctrl-S is XOFF flow
-- control by default — `stty -ixon` in .zshrc is what lets this key through.
map({ "n", "x" }, "<C-s>", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Splits (window navigation <C-hjkl> is provided by vim-tmux-navigator).
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split below" })

-- Resize windows with Ctrl + arrows.
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window taller" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window shorter" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window narrower" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window wider" })

-- Keep the selection when re-indenting in visual mode.
map("x", "<", "<gv", { desc = "Indent left, keep selection" })
map("x", ">", ">gv", { desc = "Indent right, keep selection" })

-- Keep the cursor centred on half-page jumps and search results.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- ── LSP (buffer-local, set when a server attaches) ────────────────────────────
-- Native 0.12 defaults already exist and are NOT redefined:
--   grn rename · gra code action · grr references · gri implementation
--   grt type definition · gO document symbol · K hover · <C-s> signature (insert)
--   ]d / [d next/prev diagnostic
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
  callback = function(ev)
    local o = function(desc)
      return { buffer = ev.buf, desc = desc }
    end
    -- Navigation (definitions/type-defs route through the snacks picker).
    map("n", "gd", function() Snacks.picker.lsp_definitions() end, o("Goto definition"))
    map("n", "gD", vim.lsp.buf.declaration, o("Goto declaration"))
    map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, o("Goto type definition"))
    -- Code actions (mirrors of the native gr* maps under the <leader>c group).
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, o("Code action"))
    map("n", "<leader>cr", vim.lsp.buf.rename, o("Rename symbol"))
    map("n", "<leader>cd", vim.diagnostic.open_float, o("Line diagnostics"))
    map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", o("LSP info"))
    map("n", "<leader>ci", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
    end, o("Toggle inlay hints"))
  end,
})

-- ESLint "fix all" (no-op unless the eslint server is attached). Replaces the
-- nvim-lint workflow — all diagnostics flow through LSP now.
map("n", "<leader>cE", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
    apply = true,
  })
end, { desc = "ESLint fix all" })
