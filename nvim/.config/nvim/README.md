# Neovim config

Minimal, native-first Neovim config (Neovim **0.12+**). No meta-distro — every
option, keymap, and plugin is explicit. Plugins are managed by the built-in
**`vim.pack`**; LSP uses the native **`vim.lsp.config`/`vim.lsp.enable`** API.

## Bootstrap (fresh machine)

```sh
# from the repo root (this dir is a stow package)
stow nvim
nvim                       # vim.pack installs every plugin on first launch
```

Then, once inside Neovim, install the formatters/linters that aren't LSP servers:

```vim
:MasonInstall prettierd stylua shfmt clang-format shellcheck
```

LSP servers themselves are installed automatically by `mason-lspconfig`
(`ensure_installed` in `lua/config/lsp.lua`).

## Per-machine requirements

- **Neovim ≥ 0.12**, `git`, `curl`, `tar`, a **C compiler** (parser builds).
- **`tree-sitter` CLI ≥ 0.26.1** — required by nvim-treesitter `main`.
  Arch: `pacman -S tree-sitter-cli` · macOS: `brew install tree-sitter`.
- **Node.js** — for the TypeScript / Vue / JSON / YAML language servers.
- A **clipboard tool**: Linux/X11 `xclip` or `xsel`; macOS `pbcopy` (built in).
- A **Nerd Font** for icons.

## Layout

```
init.lua                  -- entry; requires the modules below in strict order
lua/
├── config/
│   ├── options.lua       -- vim.opt settings
│   ├── keymaps.lua       -- editor + LSP keymaps (non-plugin)
│   ├── autocmds.lua      -- yank highlight, autoread/checktime
│   └── lsp.lua           -- vim.lsp.config/enable, mason, schemas, vue hybrid
└── plugins/
    ├── pack.lua          -- the single vim.pack manifest (what is installed)
    └── *.lua             -- one setup module per plugin (imperative, not specs)
snippets/                 -- custom LuaSnip snippets (vscode format)
```

Each `plugins/*.lua` runs its plugin's `setup{}` and defines that plugin's own
keymaps. They are **not** spec tables (that was lazy.nvim) — `init.lua` `require`s
each one explicitly.

## Updating & reproducibility

- `:packupdate` — update all plugins and rewrite `nvim-pack-lock.json`.
- `:packupdate ++lockfile` — restore the locked revisions.
- Commit `nvim-pack-lock.json` to pin exact plugin revisions across machines.

## Key bindings (highlights)

Leader is `<Space>`. `:WhichKey` / press `<leader>` to browse everything.

| Keys | Action |
| --- | --- |
| `<leader>ff` / `<leader>fg` / `<leader><space>` | find files / grep / smart find |
| `<leader>e` / `<leader>E` | explorer (cwd) / reveal current file |
| `<leader>cf` | format buffer / selection |
| `<leader>ca` `<leader>cr` `<leader>cR` | code action / rename symbol / rename file |
| `gd` `gy` `grr` `K` | definition / type def / references / hover |
| `s` `S` | flash jump / treesitter jump |
| `gsa` `gsd` `gsr` | surround add / delete / replace |
| `<leader>gg` `<leader>gb` `<leader>gB` | lazygit / blame line / open on remote |
| `<S-h>` `<S-l>` `<leader>bd` | prev / next / delete buffer |
| `<leader>r*` | refactor (extract/inline; `<leader>rr` menu) |
| `<C-h/j/k/l>` | move between nvim splits and tmux panes |
