-- LuaSnip = the snippet engine driven by blink (snippets.preset = "luasnip").
-- Jumping between placeholders is handled by blink's <Tab>/<S-Tab> (default
-- preset), so no extra snippet keymaps are defined here.

-- Load the friendly-snippets corpus (vscode format).
require("luasnip.loaders.from_vscode").lazy_load()
-- Plus our own snippets in ./snippets (mapped to filetypes by snippets/package.json).
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})
