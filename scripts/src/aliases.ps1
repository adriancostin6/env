Set-Alias -Name ll      -Value Invoke-EzaFull
Set-Alias -Name ls      -Value Invoke-Eza
Set-Alias -Name v       -Value Invoke-Neovim
Set-Alias -Name vi      -Value Invoke-NeovimNoConfig
Set-Alias -Name vim     -Value Invoke-Neovim
Set-Alias -Name gs      -Value Invoke-GitStatus
Set-Alias -Name gsu     -Value Invoke-GitStatusModified
Set-Alias -Name gls     -Value Invoke-GitLog
Set-Alias -Name glo     -Value Invoke-GitLogOneline
Set-Alias -Name gll     -Value Invoke-GitLogFull
Set-Alias -Name gadd    -Value Invoke-FuzzyGitAdd
Set-Alias -Name gblame  -Value Invoke-FuzzyGitBlame
# these are getting out of hand, might be worth having a wrapper function
# something like g fuzzy fix, g fuzzy reword? more words suck, maybe we can make
# an fzf menu instead...
Set-Alias -Name gfix    -Value Invoke-GitFixup
Set-Alias -Name gffix   -Value Invoke-FuzzyGitFixup
Set-Alias -Name gfixr   -Value Invoke-GitFixupReword
Set-Alias -Name gffixr  -Value Invoke-FuzzyGitFixupReword
Set-Alias -Name gfixa   -Value Invoke-GitFixupAmend
Set-Alias -Name gffixa  -Value Invoke-FuzzyGitFixupAmend
