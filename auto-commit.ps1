$repoPath = "C:\Users\adozz\Documents\Master2426"
$commitMessage = "Auto commit - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"


function CommitAndPush {
    Write-Host "Changes detected, committing and pushing..."
    cd $repoPath
    git add .
    git commit -m $commitMessage
    git push origin main
}


$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repoPath
$watcher.IncludeSubdirectories = $true
$watcher.Filter = "*.*"
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName, [System.IO.NotifyFilters]::LastWrite


$action = {
    if ($Event.SourceEventArgs.FullPath -notmatch "\\.git") {
        CommitAndPush
    } 
}

Register-ObjectEvent $watcher Changed -Action $action
Register-ObjectEvent $watcher Created -Action $action
Register-ObjectEvent $watcher Deleted -Action $action
Register-ObjectEvent $watcher Renamed -Action $action

$watcher.EnableRaisingEvents = $true


Write-Host "Monitoring changes in $repoPath. Press [Ctrl+C] to stop."
while ($true) {
    Start-Sleep -Seconds 5
}

