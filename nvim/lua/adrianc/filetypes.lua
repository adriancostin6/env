-- See :h vim.filetype
vim.filetype.add({
  extension = {
    sbs = 'cpp',
  },
  -- to escape special characters in these patterns use '%'
  pattern = {
    ['SCons.*']   = 'python',
    ['.*%.arxml'] = 'xml',
    ['.*%.c%..*'] = 'c',
    ['.*%.h%..*'] = 'cpp',
  },
})
