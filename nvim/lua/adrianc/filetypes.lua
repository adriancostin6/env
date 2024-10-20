-- See :h vim.filetype
vim.filetype.add({
  extension = {
    sbs = 'cpp',
  },
  pattern = {
    ['SCons.*'] = 'python',
    ['.*.c.jinja'] = 'c',
    ['.*.cpp.jinja'] = 'cpp',
    ['.*.h.jinja'] = 'cpp',
  },
})
