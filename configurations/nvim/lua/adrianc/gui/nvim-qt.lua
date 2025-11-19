vim.g.adrianc_nvim_qt = {
    fullscreen = false,
    fontsize = 14,
    font_name = 'Iosevka\\ NF:h'
}

local toggle_fullscreen = function ()
    vim.g.adrianc_nvim_qt.fullscreen = not vim.g.adrianc_nvim_qt.fullscreen

    if vim.g.adrianc_nvim_qt.fullscreen then
        return '1'
    else
        return '0'
    end
end

--vim.cmd('call GuiWindowFullScreen(' .. toggle_fullscreen() ..')')
vim.keymap.set('n', '<F11>', ':call GuiWindowFullScreen(' .. toggle_fullscreen() ..')<CR>')

--vim.cmd('GuiPopupmenu 0')
--vim.cmd('GuiTabline 0')
--vim.cmd('GuiRenderLigatures 1')
--vim.cmd('call GuiWindowMaximized(1)')

local create_font_adjuster = function(up)
    local fontsize = 14

    return function()
        if up then
            fontsize = fontsize + 1
        else
            fontsize = fontsize - 1
        end

        return fontsize
    end
end

local font_name = 'Iosevka\\ NF:h'
local adjust_font_up = create_font_adjuster(true)
local adjust_font_down = create_font_adjuster(false)
vim.keymap.set("n", "<C-=>", ':execute "GuiFont! ' .. font_name .. adjust_font_up() ..'"<CR>')
vim.keymap.set("n", "<C-->", ':execute "GuiFont! ' .. font_name .. adjust_font_down() ..'"<CR>')

--let s:fontsize = 12
--function! AdjustFontSize(amount)
--  let s:fontsize = s:fontsize+a:amount
--  " append :l here for al light font
--  :execute "GuiFont! Iosevka\ NF:h" . s:fontsize
--endfunction
--
--" Scrollwheel increase/decrease fontsize
--noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
--noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
--inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
--inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a
--
--" In normal mode, pressing numpad's+ increases the font
--noremap <kPlus> :call AdjustFontSize(1)<CR>
--noremap <kMinus> :call AdjustFontSize(-1)<CR>
--
--" In insert mode, pressing ctrl + numpad's+ increases the font
--inoremap <C-kPlus> <Esc>:call AdjustFontSize(1)<CR>a
--inoremap <C-kMinus> <Esc>:call AdjustFontSize(-1)<CR>a
