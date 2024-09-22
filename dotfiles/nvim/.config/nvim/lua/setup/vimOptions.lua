-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable search highlight after search end
vim.o.hlsearch = false

-- line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Sync clipboard
vim.o.clipboard = 'unnamedplus'

-- Keep signcolumn on by default (mostly for git)
vim.wo.signcolumn = 'yes'

-- mouse
vim.o.mouse = 'a'

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Save undo history
vim.o.undofile = true

-- updating swapfile timeout
vim.o.updatetime = 250

-- keybinding timeout
vim.o.timeoutlen = 300
vim.o.tabstop = 2

-- prevent indentations after line breaks
vim.o.breakindent = false

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.o.tabstop = 2
vim.o.shiftwidth = 2
