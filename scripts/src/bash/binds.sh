# VI keybinds
bind -m vi-insert '"\C-l":clear-screen'
bind -m vi-insert '"\C-a":beginning-of-line'
bind -m vi-insert '"\C-e":end-of-line'
bind -m vi-insert '"\C-w":backward-kill-word'
bind -m vi-insert '"\C-k":kill-line'

# FZF integrations
bind '"\C-g":"rg_edit\n"'
bind '"\C-f":"fzf_edit\n"'
