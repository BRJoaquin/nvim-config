-- mini.nvim modules: icons, ai, surround, diff.
-- mini.icons + the devicons mock MUST run before neo-tree / bufferline / lualine
-- load (they resolve nvim-web-devicons), which is why this module is required
-- early in init.lua.

-- Icons — the single icon provider. The mock makes plugins that hard-require
-- 'nvim-web-devicons' transparently use mini.icons (we don't install devicons).
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Around/inside textobjects. f = function, c = class, via treesitter queries
-- from nvim-treesitter-textobjects. NOTE: assigning 'f' overrides mini.ai's
-- built-in function-CALL textobject — intentional (we want treesitter functions).
local ai = require("mini.ai")
local ts = ai.gen_spec.treesitter

-- g = whole buffer (ported from LazyVim's util.mini.ai_buffer), so `yag`/`vag`
-- act on the entire file. "inner" trims leading/trailing blank lines.
local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end
  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

ai.setup({
  custom_textobjects = {
    f = ts({ a = "@function.outer", i = "@function.inner" }),
    c = ts({ a = "@class.outer", i = "@class.inner" }),
    g = ai_buffer,
  },
})

-- Surround, remapped to the 'gs' prefix so flash can own 's'.
-- (mini.surround has no 'update_n_lines' mapping; n_lines is a plain number.)
require("mini.surround").setup({
  mappings = {
    add = "gsa", -- add surrounding (normal + visual)
    delete = "gsd", -- delete surrounding
    replace = "gsr", -- replace surrounding
    find = "gsf", -- find surrounding (to the right)
    find_left = "gsF", -- find surrounding (to the left)
    highlight = "gsh", -- highlight surrounding
    suffix_last = "l", -- e.g. gsdl → act on the previous match
    suffix_next = "n", -- e.g. gsdn → act on the next match
  },
  n_lines = 20,
})

-- mini.move disabled: Alt+h/l belong to the multiplexer (tmux `bind -n M-h/M-l`,
-- herdr previous_tab/next_tab), so nvim never sees the chord. `<`/`>` in
-- config/keymaps.lua already indent with reselection and `:m` moves lines. To
-- revive it, uncomment — HJKL keeps Alt free, at the cost of visual J (join).
-- require("mini.move").setup({
--   mappings = {
--     left = "H", right = "L", down = "J", up = "K",
--     line_left = "", line_right = "", line_down = "", line_up = "",
--   },
-- })

-- Git diff gutter + hunk operators. Defaults: apply gh, reset gH, hunk
-- textobject gh, navigate [h / ]h (first/last [H / ]H). lualine reads the
-- summary it stores in vim.b.minidiff_summary.
require("mini.diff").setup()
