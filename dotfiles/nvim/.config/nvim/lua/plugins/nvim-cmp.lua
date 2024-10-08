return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup({})

    cmp.setup({
      enabled = function()
        local context = require("cmp.config.context")
        if vim.api.nvim_get_mode().mode == 'c' then
          -- keep completion if in command mode
          return true
        else
          local in_comment = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
          local in_string = context.in_treesitter_capture("string") or context.in_syntax_group("String")
          local in_char = context.in_treesitter_capture("character") or context.in_syntax_group("Character")
          -- disable completions for comment, string and char
          return not in_comment and not in_string and not in_char
        end
      end,
      completion = { completeopt = 'menu,menuone,noinsert', },
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
      window = {
        completion = {
          border = "rounded",
          scrollbar = false,
          winhighlight = "Normal:CmpNormal,FloatBorder:CmpFloatBorderComp,Search:None",
          winblend = 10,
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:CmpNormal,FloatBorder:CmpFloatBorderDoc,Search:None",
          winblend = 10,
        }
      },
      mapping = cmp.mapping.preset.insert {
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      },
    })
  end
}
