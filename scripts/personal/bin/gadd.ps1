. $HOME/env/scripts/windows/personal/src/git.ps1

$files = Git-FuzzyStatus

foreach($file in $files) {
    git add $file
}
