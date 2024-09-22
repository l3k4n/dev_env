require("setup.vimOptions")

-- ensure lazy.nvim is installed
require("setup.lazy")

-- setup plugins
require('lazy').setup({
  {
    'l3k4n/justmake.nvim',
    config = function()
      local justmake = require('justmake')
      justmake.setup()

      vim.keymap.set('n', '<leader>mr', justmake.run, { desc = "Justmake: run" })
      vim.keymap.set('n', '<leader>mb', justmake.build, { desc = "Justmake: build" })
      vim.keymap.set('n', '<leader>mt', justmake.test, { desc = "Justmake: test" })
      vim.keymap.set('n', '<leader>mc', justmake.clean, { desc = "Justmake: clean" })
    end
  },

  -- Git stuff
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- auto tab size
  'tpope/vim-sleuth',

  -- lsp progress
  'j-hui/fidget.nvim',

  -- toggle comments
  { 'numToStr/Comment.nvim', opts = {} },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'folke/neodev.nvim', opts = {} },
    },
  },

  {
    -- Status line
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Syntax Highlighting, editing, and navigating code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { import = "plugins" }
}, {})

-- prevent movement when space is pressed
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- allow linewise movement between wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format current buffer with LSP' })

-- diagnostics keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>df', ':Gvdiffsplit<CR>', { noremap = true, silent = true })

-- install and configures all lsps provided
require("setup.lsp").setup_servers({
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    }
  },
  clangd = {},
  eslint = {},
  tsserver = {},
  rust_analyzer = {},
})

-- lsp progress
require("fidget").setup({
  notification = {
    window = {
      winblend = 0,
      relative = "editor"
    }
  },
})

require("setup.highlights")
-- Highlighting on yank
require("setup.yankHighlight")
require("setup.highlights")
require("setup.toggleFugitive")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
