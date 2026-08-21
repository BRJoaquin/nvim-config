-- conform.nvim — formatting, MANUAL only (no format-on-save).
-- stop_after_first runs the first available formatter (prettierd, else prettier).
-- Install the CLIs per machine: :MasonInstall prettierd stylua shfmt clang-format
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    vue = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    jsonc = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    python = { "ruff_format" },
    lua = { "stylua" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },
  default_format_opts = { lsp_format = "fallback" },
  notify_on_error = true,
})

-- Manual format: whole buffer (normal) or the selection (visual — conform uses
-- the selected range automatically).
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer / selection" })
