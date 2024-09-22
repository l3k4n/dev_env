local function exec_vim_cmd(command)
  local ok, err = pcall(vim.cmd, command)
  -- remove unecessary part of error
  local err_msg = tostring(err):match(".*nvim_exec2%(%): Vim%(.*%):(.*)")

  if not ok then vim.api.nvim_err_writeln(err_msg) end
end

local function toggle_fugitive()
  -- get all fugitive buffers
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(win);
    local buf_name = vim.api.nvim_buf_get_name(bufnr);
    if buf_name and buf_name:sub(1, 11) == "fugitive://" and buf_name:find(".git") then
      table.insert(bufs, bufnr)
    end
  end

  if next(bufs) == nil then
    exec_vim_cmd("Git")
  else
    -- delte all fugitive buffers
    for _, bufnr in ipairs(bufs) do
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end
  end
end

vim.keymap.set('n', '<leader>g', toggle_fugitive, { noremap = true, silent = true })
