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
Write-Debug "`$Path is       [$Path]"
Write-Debug "Input is       [$(if ($inputIsFile) {"File"} Else {"Directory"})]"
Write-Debug "Resolved to    [$resolvedPath] "


$outputFileName = [System.IO.Path]::GetFileName($OutputPath)
$outputIsFile = -not [System.String]::IsNullOrWhiteSpace($outputFileName)

if ($outputIsFile)
{
    $outputDirectoryName = [System.IO.Path]::GetDirectoryName($OutputPath)
}
else {
    $outputDirectoryName = $OutputPath
}



# Create folder if it does not already exists
if (-not (Test-Path $outputDirectoryName))
{
    New-Item -Path $outputDirectoryName -ItemType Directory
    $resolvedDirectory = (Resolve-Path $outputDirectoryName).Path

}

#$resolvedOutputPath = Join-Path (Resolve-Path $outputDirectoryName).Path $outputFileName



""

if ($inputIsFile -and $outputIsFile)                # File    File    OK
{
    Write-Debug '# File    File    OK'
    $resolvedOutputPath = Join-Path (Resolve-Path $outputDirectoryName).Path $outputFileName

    # $tmpl = Get-Content $resolvedPath -Encoding UTF8 -ReadCount 0 -Raw
    # $text = $ExecutionContext.InvokeCommand.ExpandString($tmpl)
    # $text | Out-File $resolvedOutputPath
}

if ($inputIsFile -and (-not $outputIsFile))         # File    Dir     OK
{
    Write-Debug '# File    Dir     OK'
    $inputFileName = [System.IO.Path]::GetFileName($Path)
    $resolvedOutputPath = Join-Path (Resolve-Path $outputDirectoryName).Path $inputFileName
}

if ((-not $inputIsFile) -and $outputIsFile)         # Dir    File     Err
{
    Write-Debug '# Dir     File    Err'
    Write-Error "Cannot resolve Directory input to file output."
    exit
}

if ((-not $inputIsFile) -and (-not $outputIsFile))  # File    Dir     OK
{
    Write-Debug '# Dir     Dir     OK'
    $fileList = Get-ChildItem -Path $resolvedPath -Recurse | Where-Object { $_ -is [System.IO.FileInfo] } | Foreach-Object { $_.FullName }
    #$fileList = Get-ChildItem -Path $resolvedPath -Recurse
    $resolvedPath
    
    (Resolve-Path $outputDirectoryName).Path
    $fileList
    $fileList | ForEach-Object {
        "$((Resolve-Path $outputDirectoryName).Path)$($_.Remove(0, $($resolvedPath.Length + 1)))"
        
        
    }
}


Write-Debug "`$OutputPath is [$OutputPath]"
Write-Debug "Output is      [$(if ($outputIsFile) {"File"} Else {"Directory"})]"
Write-Debug "Resolved to    [$resolvedOutputPath]"

# $outputDirectoryName
# $outputFileName
# $outputIsFile

exit
# $resolvedOutputPath = (Resolve-Path $OutputPath).Path
# $outputIsFile = (Get-Item $resolvedOutputPath) -is [System.IO.FileInfo]



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
