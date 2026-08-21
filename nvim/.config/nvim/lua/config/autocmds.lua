-- Autocmds not tied to a specific plugin.
-- (Treesitter highlighting lives in plugins/treesitter.lua, next to its setup.)
local augroup = vim.api.nvim_create_augroup

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("user_highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Reload buffers changed on disk (pairs with 'autoread'). Checking on these
-- events makes external edits (git checkout, formatters, etc.) show up promptly.
-- 'autoread' only reloads buffers with NO unsaved changes; :checktime forces the
-- check rather than waiting for the next natural trigger.
vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" },
  {
    group = augroup("user_checktime", { clear = true }),
    callback = function()
      -- Don't run in command-line windows / unnamed buffers where checktime errors.
      if vim.bo.buftype ~= "" then
        return
      end
      vim.cmd("checktime")
    end,
  }
)

-- Tell me when a buffer was reloaded because the file changed underneath it.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup("user_file_changed", { clear = true }),
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.WARN)
  end,
})
