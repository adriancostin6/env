return {
  {
      "mason-org/mason-lspconfig.nvim",
      opts = {},
      dependencies = {
          { "mason-org/mason.nvim", opts = {} },
          "neovim/nvim-lspconfig",
      },
  },
  -- See https://www.reddit.com/r/neovim/comments/12gaetp/how_to_use_nvimjdtls_for_java_and_nvimlspconfig/
  { 'mfussenegger/nvim-jdtls' },
}
