-- See :h vim.filetype
vim.filetype.add({
  extension = {
    sbs = 'cpp',
  },
  pattern = {
    ['SCons.*'] = 'python',
    ['.*.c..*'] = 'c',
    ['.*.h..*'] = 'cpp',
  },
})
