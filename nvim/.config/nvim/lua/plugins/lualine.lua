-- lualine.nvim — statusline. The diff component reads mini.diff's buffer-local
-- summary (gitsigns is not installed); the branch component detects git itself.

-- Map mini.diff's vim.b.minidiff_summary (add/change/delete) to lualine's diff
-- field names (added/modified/removed). Guard for nil: the summary may be unset
-- before mini.diff attaches a source.
local function minidiff_source()
  local s = vim.b.minidiff_summary
  if s then
    return { added = s.add, modified = s.change, removed = s.delete }
  end
end

-- Macro recording indicator. cmdheight=0 hides Neovim's native "recording @q"
-- message, so surface it on the statusline instead. Returns "" (component is
-- hidden) when not recording.
local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "recording @" .. reg
end

-- Refresh lualine the moment recording starts/stops so the indicator updates
-- immediately instead of on the next redraw. RecordingLeave fires *before*
-- reg_recording() clears, so defer the refresh one tick to read the new state.
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  callback = function()
    vim.schedule(function()
      require("lualine").refresh()
    end)
  end,
})

require("lualine").setup({
  options = {
    theme = "tokyonight",
    globalstatus = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      { "diff", source = minidiff_source },
      { "diagnostics", sources = { "nvim_lsp" } },
    },
    lualine_c = {
      { "filename", path = 1 },
    },
    lualine_x = {
      -- Macro recording on the right in orange — matches the pre-refactor
      -- LazyVim/noice look ("recording @q", Constant color).
      { macro_recording, color = function() return { fg = Snacks.util.color("Constant") } end },
      "searchcount", -- [2/10] while a search is active (cmdheight=0 hides the native count)
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
