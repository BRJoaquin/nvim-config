-- blink.cmp (v1.x) — completion. Pinned to ^1 in pack.lua so the prebuilt Rust
-- fuzzy matcher auto-downloads (no build step).
--
-- Keymap preset "default": <C-y> accept · <C-n>/<C-p> select · <C-space> docs ·
-- <C-e> hide · <Tab>/<S-Tab> jump snippet · <C-b>/<C-f> scroll docs.
-- <CR> does NOT accept — newline stays a newline (accept is <C-y> only).

---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
  keymap = { preset = "default" },
  appearance = { nerd_font_variant = "mono" },
  completion = { documentation = { auto_show = false } }, -- docs on demand (<C-space>)
  snippets = { preset = "luasnip" },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      -- Neovim API / require() completion when editing Lua config (see lsp.lua).
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
}

require("blink.cmp").setup(opts)
