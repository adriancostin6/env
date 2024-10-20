-- See :h vim.filetype
vim.filetype.add({
  extension = {
    sbs = 'cpp',
  },
  -- to escape special characters in these patterns use '%'
  pattern = {
    ['SCons.*']     = 'python',
    ['.*%.arxml']   = 'xml',

    -- handle weird language-like files (code generation)
    ['.*%.c%..*']   = 'c',
    ['.*%.h%..*']   = 'cpp',
    ['.*%.cpp%..*'] = 'cpp',
    ['.*%.py%..*'] = 'python',
  },
})
