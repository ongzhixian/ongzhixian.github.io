# My profile PowerShell Core

# Common functions; These functions should be deterministic

function title { (Get-Host).UI.RawUI.WindowTitle = $args }

function prompt {
    $branchName = $(git branch --show-current)
    "`e[32m$env:USERDOMAIN>$env:USERNAME`e[39m $PWD $(if ($LASTEXITCODE -eq 0) { "`e[36m($branchName)`e[39m" })`nPS> "
}


# Settings

title "PS$($Host.Version.Major)"
#$Host.UI.RawUI.WindowTitle = "PS$($Host.Version.Major)"