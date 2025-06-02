local theme = function(dark, light)
    return os.getenv("SYSTEM_THEME") == 'dark' and dark or light
end

return {

  -- rose pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function ()
        vim.cmd.colorscheme('rose-pine')
    end,
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      integrations = {
        gitsigns = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        telescope = true,
        treesitter = true,
      },
    },
  },
}
