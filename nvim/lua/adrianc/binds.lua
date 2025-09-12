local  binds = {}

function binds.general()
    vim.keymap.set('n', '<leader><space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
end

function binds.lsp(opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader><space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
end

binds.telescope = {
  {
      "<leader>b",
      "<cmd>Telescope buffers theme=ivy<cr>",
      desc = "Buffers"
  },
  {
      "<leader>g",
      "<cmd>Telescope live_grep theme=ivy<cr>",
      desc = "Live Grep"
  },
  {
      "<leader>c",
      "<cmd>Telescope command_history theme=ivy<cr>",
      desc = "Command History"
  },
  {
      "<leader>h",
      "<cmd>Telescope oldfiles theme=ivy<cr>",
      desc = "Recent"
  },
  {
      "<leader>f",
      "<cmd>Telescope find_files theme=ivy<cr>",
      desc = "Find File"
  },
  {
      "<leader>s",
      "<cmd>Telescope grep_string theme=ivy<cr>",
      desc = "Grep String"
  },
}

return binds
