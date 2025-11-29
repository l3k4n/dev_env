local function live_grep_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end
  --
  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end

  -- Defines the command that will be used for `live_grep` and `grep_string`
  -- pickers.
  -- Hint: Make sure that color is currently set to `never` because we do
  -- not yet interpret color codes
  -- Hint 2: Make sure that these options are in your changes arguments:
  --   "--no-heading", "--with-filename", "--line-number", "--column"
  -- because we need them so the ripgrep output is in the correct format.
  --
  -- Default: {
  --   "rg",
  --   "--color=never",
  --   "--no-heading",
  --   "--with-filename",
  --   "--line-number",
  --   "--column",
  --   "--smart-case"
  -- }

  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

local function live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

local function fuzzy_find_current_buf()
  local telescope_ui = require('telescope.themes').get_dropdown({ previewer = false })
  require('telescope.builtin').current_buffer_fuzzy_find(telescope_ui)
end

local function nmap(key, func, desc)
  if desc then
    desc = 'Telescope: ' .. desc
  end
  vim.keymap.set('n', '<leader><space>', function()
    require('telescope.builtin').buffers()
  end, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', key, func, { desc = desc })
end


return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        winblend = 10,
        mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false } },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--follow"
        }
      }

    })
    pcall(telescope.load_extension, 'fzf')

    -- all telescope keybindins
    nmap('<leader><space>', require('telescope.builtin').buffers, '[ ] Find existing buffers')
    nmap('<leader>?', require('telescope.builtin').oldfiles, '[?] Find recently opened files')
    nmap('<leader>/', fuzzy_find_current_buf, '[/] Fuzzily search in current buffer')
    nmap('<leader>sf', require('telescope.builtin').find_files, '[S]earch [F]iles')
    nmap('<leader>sh', require('telescope.builtin').help_tags, '[S]earch [H]elp')
    nmap('<leader>sw', require('telescope.builtin').grep_string, '[S]earch current [W]ord')
    nmap('<leader>sg', require('telescope.builtin').live_grep, '[S]earch by [G]rep')
    nmap('<leader>sd', require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics')
    nmap('<leader>sr', require('telescope.builtin').resume, '[S]earch [R]esume')
    nmap('<leader>sG', live_grep_git_root, '[S]earch by [G]rep on Git Root')
    nmap('<leader>s/', live_grep_open_files, '[S]earch [/] in Open Files')
  end
}
