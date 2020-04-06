# My profile PowerShell Core

# Common functions; These functions should be deterministic
function title { (Get-Host).UI.RawUI.WindowTitle = $args }
# TODO: prompt function?