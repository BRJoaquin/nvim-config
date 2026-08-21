# nvim-config

My Neovim configuration as a standalone [GNU Stow](https://www.gnu.org/software/stow/)
package — made to be cloned on any machine (e.g. a classroom Ubuntu box) and
running in three commands.

Minimal, native-first config for **Neovim 0.12+**: plugins via the built-in
`vim.pack`, LSP via the native `vim.lsp.config`/`vim.lsp.enable` API. See
[`nvim/.config/nvim/README.md`](nvim/.config/nvim/README.md) for the full
layout, keymaps, and plugin details.

## Quick start

```sh
git clone https://github.com/BRJoaquin/nvim-config.git
cd nvim-config
stow nvim          # symlinks nvim/.config/nvim -> ~/.config/nvim
nvim               # vim.pack installs every plugin on first launch
```

> If you already have a `~/.config/nvim`, move it aside first:
> `mv ~/.config/nvim ~/.config/nvim.bak`

## Fresh Ubuntu setup

Everything the config needs on a clean Ubuntu machine:

### 1. Neovim ≥ 0.12

The `apt` package is too old. Use the official tarball (or the
[unstable PPA](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)):

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
source ~/.bashrc
nvim --version   # must be 0.12 or newer
```

### 2. System packages

```sh
sudo apt update
sudo apt install -y git curl tar unzip stow build-essential xclip nodejs npm
```

- `build-essential` — C compiler for treesitter parser builds
- `xclip` — system clipboard integration (X11; use `wl-clipboard` on Wayland)
- `nodejs`/`npm` — TypeScript / Vue / JSON / YAML language servers

### 3. tree-sitter CLI ≥ 0.26.1

Required by nvim-treesitter `main`:

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
- **lazygit** for `<leader>gg` (not in Ubuntu's apt; see
  [installation instructions](https://github.com/jesseduffield/lazygit#installation)).
- `<C-s>` (save) is swallowed by terminal flow control by default — add
  `stty -ixon` to your `~/.bashrc`/`~/.zshrc` to let it through
  (`<leader>w` saves regardless).
- The `<C-h/j/k/l>` pane-navigation keys integrate with **tmux** via
  vim-tmux-navigator, but work fine as plain split navigation without it.
