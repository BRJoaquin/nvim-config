-- ts-comments.nvim — fixes 'commentstring' per treesitter region so commenting
-- is correct inside JSX/TSX and Vue SFCs.
-- The commenting operators themselves (gcc, gc{motion}, gc in visual) are NATIVE
-- to Neovim since 0.10 — this plugin only corrects the comment syntax.
require("ts-comments").setup({})
