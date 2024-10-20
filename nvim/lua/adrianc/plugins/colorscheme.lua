local theme = function(dark, light)
    return os.getenv("SYSTEM_THEME") == 'dark' and dark or light
end

return {

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    config = function ()
        vim.cmd.colorscheme(theme('catppuccin-frappe', 'catppuccin-latte'))
    end,
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
