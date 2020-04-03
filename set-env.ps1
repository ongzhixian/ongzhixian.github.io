<#
  .SYNOPSIS
  Set path for _powerShell script folder.

  .DESCRIPTION
  Adds path for _powerShell script folder to $env:Path if its not in there already.
#>

param (
    [switch]$Debug = $false
)

if ($Debug) {
    $DebugPreference = 'Continue'           # Start - display debug messages
}
# Start script

# Set Window title
# (Get-Host).UI.RawUI.WindowTitle = "PS"


# Get current location (pwd) and define $scriptsPath
$rootPath = Get-Location | ForEach-Object { $_.Path }
$scriptsPath = Join-Path -Path $rootPath -ChildPath "_powerShell"
Write-Debug "`$scriptsPath  is $scriptsPath" 


# Determine if scriptsPath is already set
$isSet = $env:Path -like "*$scriptsPath*"
Write-Debug "`$isSet        is $isSet"

# If is set already, exit
if ($isSet) {
    Write-Debug "Path is defined in `$env:Path; skipped." 
    exit
} 

# Append to $env:Path depending on whether $env:Path ends with semi-colon (;)
if ($env:Path -match ";$") {        # if ends with semi-colon
    $env:Path += "$scriptsPath"
} else {                            # if not ends with semi-colon
    $env:Path += ";$scriptsPath"
}
Write-Debug "`$env:Path set." 


# End script

if ($Debug) {
    $DebugPreference = 'SilentlyContinue'   # End   - display debug messages
}
