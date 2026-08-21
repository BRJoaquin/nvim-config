-- ============================================================================
-- LSP — native Neovim 0.12 API (vim.lsp.config / vim.lsp.enable).
--
-- nvim-lspconfig is installed ONLY to ship server definitions (its lsp/*.lua
-- files on the runtimepath). We NEVER call require('lspconfig').xxx.setup{}.
-- mason installs the server binaries; we own the enabled list explicitly.
--
-- Per-machine, install the formatters/linters that are not LSP servers:
--   :MasonInstall prettierd stylua shfmt clang-format shellcheck
-- ============================================================================

-- 1. mason FIRST (mason-lspconfig depends on it being set up).
require("mason").setup()

-- 2. Global defaults for every server: advertise blink's completion
--    capabilities so servers send richer completion items.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- 3. lua_ls — lazydev (step 8) manages the Neovim API library, so we only pin
--    the LuaJIT runtime here.
vim.lsp.config("lua_ls", {
  settings = { Lua = { runtime = { version = "LuaJIT" } } },
})

-- 4. JSON / YAML — feed schemas from SchemaStore.nvim.
local schemastore = require("schemastore")
vim.lsp.config("jsonls", {
  settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } },
})
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" }, -- use SchemaStore.nvim, not the builtin store
      schemas = schemastore.yaml.schemas(),
    },
  },
})

-- 5. Vue + TypeScript hybrid mode.
--    vtsls serves all TypeScript (including inside .vue, via the Vue TS plugin);
--    vue_ls handles .vue template/style. nvim-lspconfig's lsp/vue_ls.lua already
--    ships the tsserver-request forwarder, so vue_ls needs no extra config — we
--    only teach vtsls about the Vue plugin and add 'vue' to its filetypes.
local vue_ls_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
vim.lsp.config("vtsls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_ls_path,
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
})

-- 6. Diagnostics presentation (diagnostics are on by default in 0.12).
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 7. Enable every server (auto-attaches on matching filetypes once its binary
--    exists). This list is the single source of truth for what is enabled.
local servers = {
  "lua_ls",
  "vtsls",
  "vue_ls",
  "clangd",
  "basedpyright",
  "ruff",
  "bashls",
  "sqlls",
  "jsonls",
  "yamlls",
  "taplo",
  "tailwindcss",
  "dockerls",
  "docker_compose_language_service",
  "marksman",
  "eslint",
}
vim.lsp.enable(servers)

-- 8. mason-lspconfig — install the servers above. automatic_enable = false
--    because we call vim.lsp.enable ourselves in step 7 (one owner only).
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_enable = false,
})

-- 9. lazydev — full Neovim/Lua API + plugin types for lua_ls when editing this
--    config. It only attaches to lua_ls buffers internally, so a single eager
--    call is enough (no FileType gating needed).
require("lazydev").setup({
  library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
})
