Write-Host "start"
while ($true) 
{
    break
}
Write-Host "Sleep"
New-Event -SourceIdentifier zxsh -MessageData "ako Test message $(Get-Date)"
Start-Sleep 5
