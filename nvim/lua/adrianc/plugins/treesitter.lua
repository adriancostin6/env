return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
--      { "<c-space>", desc = "Increment selection" },
--      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "arduino",
        "awk",
        "bash",
        "c",
        "c_sharp",
        "cmake",
        "comment",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "fortran",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "html",
        "java",
        "javascript",
        "json",
--        "latex",
        "lua",
        "luadoc",
        "luap",
        "make",
        "markdown",
        "markdown_inline",
        "matlab",
        "pascal",
        "perl",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
