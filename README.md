# nvim-config

My Neovim configuration as a standalone [GNU Stow](https://www.gnu.org/software/stow/)
package — made to be cloned on any machine (e.g. a classroom Ubuntu box) and
running in three commands.

Minimal, native-first config for **Neovim 0.12+**: plugins via the built-in
`vim.pack`, LSP via the native `vim.lsp.config`/`vim.lsp.enable` API. Pickers
are snacks.nvim (pure Lua — **no fzf needed**), backed by ripgrep for grep. See
[`nvim/.config/nvim/README.md`](nvim/.config/nvim/README.md) for the full
layout, keymaps, and plugin details.

## Quick start (dependencies already installed)

```sh
git clone https://github.com/BRJoaquin/nvim-config.git
cd nvim-config
stow nvim          # symlinks nvim/.config/nvim -> ~/.config/nvim
nvim               # vim.pack installs every plugin on first launch
```

> If you already have a `~/.config/nvim`, move it aside first:
> `mv ~/.config/nvim ~/.config/nvim.bak`

## Fresh machine setup

### 1. System packages

**Ubuntu / Debian** (apt):

```sh
sudo apt update
sudo apt install -y git curl tar unzip stow build-essential ripgrep fd-find xclip nodejs npm
```

**Arch** (pacman):

```sh
sudo pacman -S --needed git curl tar unzip stow base-devel ripgrep fd xclip nodejs npm neovim tree-sitter-cli
```

**macOS** (brew):

```sh
brew install git stow ripgrep fd node neovim tree-sitter
```

What each is for:

- `build-essential` / `base-devel` — C compiler for treesitter parser builds
- `ripgrep` — grep picker (`<leader>fg`, `<leader>/`)
- `fd` — faster file listing for the file picker (optional; falls back to
  ripgrep). Ubuntu names the binary `fdfind`, so link it:
  `mkdir -p ~/.local/bin && ln -s "$(command -v fdfind)" ~/.local/bin/fd`
- `xclip` — system clipboard on X11 (Wayland: install `wl-clipboard` instead)
- `nodejs`/`npm` — TypeScript / Vue / JSON / YAML language servers

### 2. Neovim ≥ 0.12 (Ubuntu/Debian only)

Arch and brew already installed a new-enough Neovim above. Ubuntu's `apt`
package is too old — use the official tarball:

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
source ~/.bashrc
nvim --version   # must be 0.12 or newer
```

### 3. tree-sitter CLI ≥ 0.26.1 (Ubuntu/Debian only)

Arch and brew already installed it above. Required by nvim-treesitter `main`:

```sh
sudo npm install -g tree-sitter-cli
```

### 4. Clone, stow, launch

```sh
git clone https://github.com/BRJoaquin/nvim-config.git
cd nvim-config
stow nvim
nvim
```

First launch installs all plugins (pinned by `nvim-pack-lock.json`) and
`mason-lspconfig` auto-installs the LSP servers. Then, inside Neovim, install
the formatters/linters that aren't LSP servers:

```vim
:MasonInstall prettierd stylua shfmt clang-format shellcheck
```

### 5. Nice-to-haves

- A **Nerd Font** for icons (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)),
  set as your terminal font.
- **lazygit** for `<leader>gg` — Arch: `sudo pacman -S lazygit` ·
  macOS: `brew install lazygit` · Ubuntu: not in apt, see
  [installation instructions](https://github.com/jesseduffield/lazygit#installation).
- `<C-s>` (save) is swallowed by terminal flow control by default — add
  `stty -ixon` to your `~/.bashrc`/`~/.zshrc` to let it through
  (`<leader>w` saves regardless).
- The `<C-h/j/k/l>` pane-navigation keys integrate with **tmux** via
  vim-tmux-navigator, but work fine as plain split navigation without it.
