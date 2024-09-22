vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#162916' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#331111' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#292213' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#61522b' })

vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#005500', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#880000', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#785b0e', bold = true })

vim.api.nvim_set_hl(0, 'GitSignsStagedAdd', { link = 'GitSignsAdd' })
vim.api.nvim_set_hl(0, 'GitSignsStagedDelete', { link = 'GitSignsDelete' })
vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { link = 'GitSignsChange' })
vim.api.nvim_set_hl(0, 'GitSignsStagedChangedelete', { link = 'GitSignsChange' })

vim.api.nvim_set_hl(0, 'Folded', { bg = '#1a1d29', fg = '#485170' })
