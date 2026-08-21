-- nvim-treesitter MAIN branch (the rewrite). There is no configs.setup{} and
-- nothing is auto-enabled: we install parsers, then start treesitter ourselves.
--
-- Requires the `tree-sitter` CLI (>= 0.26.1) + a C compiler on PATH to build
-- parsers. Arch: `pacman -S tree-sitter-cli`; macOS: `brew install tree-sitter`.

-- nvim-treesitter main ships its highlight/textobject queries under
-- <plugin>/runtime/queries/. vim.pack only puts the plugin ROOT on the
-- runtimepath, not its runtime/ subdir, so highlights.scm is never found and
-- nothing highlights. Add runtime/ to the rtp so the queries resolve.
local ts_init = vim.api.nvim_get_runtime_file("lua/nvim-treesitter/init.lua", false)[1]
if ts_init then
  vim.opt.runtimepath:append(vim.fn.fnamemodify(ts_init, ":h:h:h") .. "/runtime")
end

local parsers = {
  "javascript", "typescript", "tsx", "vue", "cpp", "c", "python",
  "sql", "bash", "lua", "json", "yaml", "toml", "markdown",
  "markdown_inline", "html", "css", "vimdoc", "query", "diff", "git_config",
}

-- install() is async + idempotent (skips parsers already present), so running it
-- every startup is safe and cheap. First run compiles them in the background;
-- reopen a file once it finishes if highlighting isn't active yet.
require("nvim-treesitter").install(parsers)

-- Textobjects (main): mini.ai reads its query files (queries/<lang>/textobjects.scm)
-- via core treesitter, so we only need the plugin installed. We don't map its
-- own select/move keys.
require("nvim-treesitter-textobjects").setup({})

-- Enable highlighting + folding + indentation per filetype.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(args)
    -- start() resolves the parser from the buffer's filetype (handles
    -- help→vimdoc, sh→bash, typescriptreact→tsx, …); pcall skips filetypes
    -- with no installed parser.
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    -- Treesitter folding (built-in foldexpr) — folds open by default (foldlevel=99).
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
    -- Treesitter indentation (experimental).
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
