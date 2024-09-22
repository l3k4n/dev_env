return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      changedelete = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      changedelete = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
    },
    diff_opts = {

      -- • "minimal"    spend extra time to generate the
      --                smallest possible diff
      -- • "patience"   patience diff algorithm
      -- • "histogram"  histogram diff algorithm
      algorithm = 'histogram',
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- Navigation
      map({ 'n', 'v' }, ']h', function()
        if vim.wo.diff then return ']h' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'Jump to next hunk' })
      map({ 'n', 'v' }, '[h', function()
        if vim.wo.diff then return '[h' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true, desc = 'Jump to previous hunk' })
      --
      -- Actions
      map('n', '<leader>hf', gs.stage_buffer, { desc = 'git Stage buffer' })
      map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
        { desc = 'stage git hunk' })
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
    end,
  },
}
