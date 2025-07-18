function Git-FuzzyStatus {
    $repo_root = git rev-parse --show-toplevel
    $git_status = git status --porcelain | fzf --multi

    $files = [System.Collections.ArrayList]@()
    foreach($line in $git_status) {
        $tokens = $line -split " "
        $file = $tokens[1]
        [void]$files.add("$repo_root/$file")
    }

    return $files
}
