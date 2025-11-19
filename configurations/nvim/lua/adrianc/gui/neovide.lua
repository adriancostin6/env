if not vim.g.neovide then
    return
end

vim.opt.guifont = { 'Iosevka', 'h14' }

-- Resize
vim.keymap.set("n", "<F10>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
vim.keymap.set("n", "<F9>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
vim.keymap.set("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")

-- Toggle fullscreen
vim.g.neovide_fullscreen = true
vim.keymap.set('n', '<F11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end)

