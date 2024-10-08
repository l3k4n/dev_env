-- diff
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#162916' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#331111' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#292213' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#61522b' })
vim.api.nvim_set_hl(0, 'Folded', { bg = '#1a1d29', fg = '#485170' })

-- git signs
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#005500', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#880000', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#785b0e', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsStagedAdd', { link = 'GitSignsAdd' })
vim.api.nvim_set_hl(0, 'GitSignsStagedDelete', { link = 'GitSignsDelete' })
vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { link = 'GitSignsChange' })
vim.api.nvim_set_hl(0, 'GitSignsStagedChangedelete', { link = 'GitSignsChange' })

-- lualine
---@param name string
local function update_lualine_section_bg(name)
  local new_hl = vim.api.nvim_get_hl(0, { name = name });
  new_hl.bg = "#090c0f"
  vim.api.nvim_set_hl(0, name, new_hl)
end
update_lualine_section_bg("lualine_c_normal");
update_lualine_section_bg("lualine_b_replace");
update_lualine_section_bg("lualine_b_command");
update_lualine_section_bg("lualine_b_visual");
update_lualine_section_bg("lualine_b_normal");
update_lualine_section_bg("lualine_b_insert");
