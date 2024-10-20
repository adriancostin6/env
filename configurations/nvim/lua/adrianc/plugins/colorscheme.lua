local theme = function(dark, light)
    return os.getenv("SYSTEM_THEME") == 'dark' and dark or light
end

return {

  -- everforest
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    --config = function()
    --  require("everforest").setup({
    --    -- Your config here
    --  })
    --end,
    config = function()
        vim.cmd.colorscheme('everforest')
    end
  },

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  -- rose pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
        vim.cmd.colorscheme(theme('rose-pine', 'rose-pine-dawn'))
    end
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
        octo = true,
      },
    },
    config = function()
        vim.cmd.colorscheme(theme('catppuccin-frappe', 'catppuccin-latte'))
    end
  },
}
