-- neo-tree.nvim — file explorer. Icons come from mini.icons (mocked as
-- nvim-web-devicons in mini.lua, which loads first).
require("neo-tree").setup({
  enable_git_status = true, -- (default) runs `git status --ignored`; tags ignored files so the highlight below can fire
  window = {
    mappings = {
      ["l"] = "open", -- expand directory / open file
      ["h"] = "close_node", -- collapse directory
    },
  },
  default_component_configs = {
    name = {
      use_git_status_colors = true, -- (default) color filenames by git status, including the gitignored group
    },
    git_status = {
      symbols = {
        ignored = "◌", -- gutter glyph on gitignored files (default is blank); colored by NeoTreeGitIgnored below
      },
    },
  },
  filesystem = {
    follow_current_file = { enabled = true }, -- defaults to false; reveal the open file
    use_libuv_file_watcher = true, -- defaults to false; OS file watchers auto-refresh the tree (and git status) on external changes
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false, -- show gitignored files (NOTE the trailing 'd' — `hide_gitignore` is silently ignored)
      hide_hidden = false,
    },
    commands = {
      -- Must live under filesystem.commands, not top-level `commands`: neo-tree
      -- merges the top-level table into each source with tbl_extend("keep", ...),
      -- which silently drops any key (like "open") the source already defines.
      -- Nesting it here merges with "force" instead, so this override wins.
      --
      -- Binary files (pdf, images, docx, zip, ...) aren't editable text; hand
      -- them to the OS opener instead of loading garbage into a buffer. Detect
      -- "binary" via `file`'s encoding guess rather than a hardcoded extension
      -- list, since that generalizes to any format. Empty files report as
      -- "binary" too (no bytes to sniff), so exempt size 0 or `a`-created files
      -- would get punted to xdg-open instead of opening for editing.
      open = function(state)
        local node = state.tree:get_node()
        local stat = node.type == "file" and vim.uv.fs_stat(node.path)
        local is_binary = stat
          and stat.size > 0
          and vim.trim(vim.fn.system({ "file", "--brief", "--mime-encoding", node.path })) == "binary"
        if is_binary then
          local _, err = vim.ui.open(node.path)
          if err then
            vim.notify("Could not open " .. node.path .. ": " .. err, vim.log.levels.ERROR)
          else
            vim.notify("Opened " .. vim.fs.basename(node.path) .. " in system app")
          end
        else
          require("neo-tree.sources.filesystem.commands").open(state)
        end
      end,
    },
  },
})

-- Make gitignored files visually distinct. neo-tree paints their filenames with
-- the NeoTreeGitIgnored group, which by default links to the dim dotfile gray —
-- identical to plain dotfiles, so "ignored" doesn't stand out. Override it with
-- the theme's Comment color + italic. Re-applied on every :colorscheme so it
-- survives theme reloads (this runs after neo-tree's own ColorScheme handler).
local function style_gitignored()
  local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
  vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = comment.fg, italic = true })
end
style_gitignored()
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Keep neo-tree gitignored files dim + italic across theme reloads",
  callback = style_gitignored,
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal_force_cwd<cr>", { desc = "Explorer (cwd)" })
vim.keymap.set("n", "<leader>E", "<cmd>Neotree reveal<cr>", { desc = "Explorer (reveal file)" })
