# .Translate

param (
    [Parameter(Mandatory)][string] $Path,
    [string] $OutputPath = $null
)

# Start-of-script
if ($Debug) {
    $DebugPreference = 'Continue'           # Start - display debug messages
}


function ParseAndGenerate()
{

}

# Set Window title
# (Get-Host).UI.RawUI.WindowTitle = "PS"

if (-not (Test-Path $Path))
{
    Write-Error "Parameter `$Path is [$Path]; Test-Path failed."
    exit
}

# Resolve path for $Path
$resolvedPath = (Resolve-Path $Path).Path
$inputIsFile = (Get-Item $resolvedPath) -is [System.IO.FileInfo]
Write-Debug "Parameter `$Path is [$Path]; Resolved to [$resolvedPath] ; IsFile: $inputIsFile"



$resolvedOutputPath = (Resolve-Path $OutputPath).Path
$resolvedOutputPath


exit
# Resolve path for $OutputPath
if (-not (Test-Path $OutputPath))
{
    $OutputPath = [System.IO.Path]::GetDirectoryName($resolvedPath)
}



if ($isFile)
{
    
    $fileList = Get-ChildItem -Path $resolvedPath -Recurse
}    
else
{
    Get-ChildItem -Path .\TestSite\ -Recurse | Where-Object { $_ -is [System.IO.FileInfo] } | Foreach-Object { $_.FullName }
    exit
}



# Determine the output file path
$extension = [System.IO.Path]::GetExtension($resolvedPath)
$extensionIndex = $resolvedPath.LastIndexOf($extension)
$outputFilePath = "$($resolvedPath.Substring(0, $extensionIndex)).html"
Write-Debug "Output filepath [$outputFilePath]"


$tmpl = Get-Content $resolvedPath -Encoding UTF8 -ReadCount 0 -Raw
$text = $ExecutionContext.InvokeCommand.ExpandString($tmpl)
#$data = [System.Text.Encoding]::UTF8.GetBytes($text)

#$data | Out-File -Append $outputFilePath
$text | Out-File $outputFilePath



# End-of-script
if ($Debug) {
    $DebugPreference = 'SilentlyContinue'   # End   - display debug messages
}
