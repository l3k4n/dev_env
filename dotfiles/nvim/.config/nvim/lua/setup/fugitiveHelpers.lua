local function close_all_diff_wins()
  local diff_wins = {}

  -- get all diff windows before closing (closing a diff win disables diff on any other diff win)
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_get_option_value("diff", { win = win_id }) then
      table.insert(diff_wins, win_id)
    end
  end

  -- close the windows
  for _, win_id in ipairs(diff_wins) do
    vim.api.nvim_win_close(win_id, false)
  end
end

local fugitive_buf = nil
local function toggle_fugitive()
  if fugitive_buf and vim.fn.bufexists(fugitive_buf) then
    close_all_diff_wins()
    vim.api.nvim_buf_delete(fugitive_buf, { force = false })
    fugitive_buf = nil
  else
    vim.api.nvim_command("tab Git")
    vim.wo.winfixbuf = true
    fugitive_buf = vim.api.nvim_get_current_buf()
  end
end

vim.keymap.set('n', '<leader>g', toggle_fugitive, { noremap = true, silent = true })
vim.keymap.set('n', 'dq', close_all_diff_wins, { noremap = true })

local pattern = vim.regex("^G\\%[it]\\(\\s.*\\)\\?$")
vim.api.nvim_create_autocmd('CmdlineLeave', {
  pattern = '*',
  callback = function()
    local cmd = vim.fn.getcmdline()
    -- add 'tab' prefix to all git commands
    if pattern and pattern:match_str(cmd) then
      vim.fn.setcmdline("tab " .. cmd)
    end
  end
})
