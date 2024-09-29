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
      require 'mason-lspconfig'.setup()
      require 'mason-lspconfig'.setup_handlers {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {}
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
