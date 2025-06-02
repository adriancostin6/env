return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig'
    },
    config = function()
      require 'mason'.setup()

      local lspconf = require 'mason-lspconfig'
      lspconf.setup()
      local installed_servers = lspconf.get_installed_servers()
      if not next(installed_servers) then
        print("No language servers are installed, skipping handler setup.")
        return
      end
      -- check that the servers we configure manually are installed
      local manually_configured_servers = { 'lua_ls', 'jdtls' }
      for k,v in pairs(manually_configured_servers) do
        if not installed_servers[k] then
          return
        end
      end
      lspconf.setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          local server = require("lspconfig")[server_name]
          server.setup {}
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `lua_ls`:
        ['lua_ls'] = function ()
          require'lspconfig'.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' }
                },
              },
            },
          }
        end,
        ['jdtls'] = function () end
      }
    end
  },
  -- Java is a special boi: 
  -- See https://www.reddit.com/r/neovim/comments/12gaetp/how_to_use_nvimjdtls_for_java_and_nvimlspconfig/
  -- Also see cmds.lua
  { 'mfussenegger/nvim-jdtls' },
}
