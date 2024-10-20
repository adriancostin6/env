return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    branch = 'main',
    lazy = false,
    config = function()
      parsers = {
        'vim', 'vimdoc',
        'lua', 'luadoc',
        'markdown', 'markdown_inline',
        'query', 'diff',
        'gitcommit', 'gitignore', 'git_rebase', 'git_config', 'gitattributes',
        'java', 'javadoc',
        'html', 'javascript', 'typescript',
        'python', 'bash', 'powershell',
        'c', 'doxygen',
      }
      require('nvim-treesitter').install(parsers)

      local function try_attach(buf, language)
        if not vim.treesitter.language.add(language) then
          return
        end
        vim.treesitter.start(buf,language)
        -- folds, provided by Neovim
        --vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        --vim.wo.foldmethod = 'expr'
        -- indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local lang = vim.treesitter.language.get_lang(filetype)

          if not lang then
            return
          end

          local installed = require('nvim-treesitter').get_installed('parsers')
          if vim.tbl_contains(installed, lang) then
            try_attach(buf, lang)
          elseif vim.tbl_contains(available, lang) then
            require('nvim-treesitter').install(lang):await(function() 
              try_attach(buf, lang) 
            end)
          else
            try_attach(buf, lang)
          end
        end,
      })
    end,
  },
}
