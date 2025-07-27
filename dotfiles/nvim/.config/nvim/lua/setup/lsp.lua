vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspKeymaps', {}),
  callback = function(args)
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end
      vim.keymap.set('n', keys, func, { buffer = args.buf, desc = desc })
    end

    local clangd_switch_source_header = function()
      if vim.fn.exists(":LspClangdSwitchSourceHeader") then
        vim.cmd("LspClangdSwitchSourceHeader")
      end
    end

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap('<C-s>', clangd_switch_source_header, '(clangd) Switch between source and header file')
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  end,
})

---@class ServerConfig
---@field cmd string[]|nil
---@field filetypes string[]|nil
---@field settings any|nil

---@class ServerConfigTable
---@field [string] ServerConfig

local M = {}

---@param servers ServerConfigTable
function M.setup_servers(servers)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
      function(server_name)
        local server_config = servers[server_name] or {}
        local setup = {
          capabilities = capabilities,
          settings = server_config.settings,
          filetypes = server_config.filetypes
        }

        -- `setup.cmd` must not be nil
        if (server_config.cmd ~= nil) then
          setup.cmd = server_config.cmd
        end

        vim.lsp.config(server_name, setup)
        vim.lsp.enable(server_name)
      end,
    }
  })
end

return M
