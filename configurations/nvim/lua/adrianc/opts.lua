vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.backup          = false
vim.opt.clipboard       = 'unnamedplus'
vim.opt.cursorline      = true
vim.opt.expandtab       = true
vim.opt.list            = true
vim.opt.shiftwidth      = 4
vim.opt.softtabstop     = 4
vim.opt.swapfile        = false
vim.opt.tabstop         = 4
vim.opt.termguicolors   = true
vim.opt.undodir         = vim.fn.stdpath('cache') .. '/undo'
vim.opt.undofile        = true
vim.opt.wrap            = false
vim.opt.writebackup     = false

vim.opt.nu              = false
vim.opt.rnu             = false
vim.o.signcolumn        = 'no'

vim.opt.completeopt = { 'menu' }

vim.opt.listchars = {
    tab         = '»»',
    trail       = '·',
    extends     = '◣',
    precedes    = '◢',
    nbsp        = '○',
    eol         = '↵',
}

vim.wo.colorcolumn      = '80'
