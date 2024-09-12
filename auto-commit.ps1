

# Путь к вашему локальному репозиторию
$repoPath = "C:\Users\adozz\Documents\Master2426"
# Сообщение для коммита
$commitMessage = "Auto commit - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Функция для выполнения git команд
function CommitAndPush {
    Write-Host "Changes detected, committing and pushing..."
    cd $repoPath
    git add .
    git commit -m $commitMessage
    git push origin main
}

# Отслеживание изменений в директории репозитория
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repoPath
$watcher.IncludeSubdirectories = $true
$watcher.Filter = "*.*"
$watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName, [System.IO.NotifyFilters]::LastWrite




# Действие при изменении файлов
$action = {
    # Исключаем изменения в папке .git
    if ($Event.SourceEventArgs.FullPath -notmatch "\\.git") {
        CommitAndPush
    } else {
        Write-Host "Ignoring changes in .git directory."
    }
}

# Подписка на события изменений
Register-ObjectEvent $watcher Changed -Action $action
Register-ObjectEvent $watcher Created -Action $action
Register-ObjectEvent $watcher Deleted -Action $action
Register-ObjectEvent $watcher Renamed -Action $action

# Запуск отслеживания
$watcher.EnableRaisingEvents = $true

# Скрипт будет работать, пока вы не закроете сессию PowerShell
Write-Host "Monitoring changes in $repoPath. Press [Ctrl+C] to stop."
while ($true) {
    Start-Sleep -Seconds 10
}

