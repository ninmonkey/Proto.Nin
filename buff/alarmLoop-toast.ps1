while ($true) {
    New-BurntToastNotification -Text 'hi'
 (Get-Date).ToShortTimeString()
    Start-Sleep -Seconds (60 * 15)
}