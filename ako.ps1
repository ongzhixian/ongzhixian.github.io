# .Translate

param (
    [Parameter(Mandatory)][string] $Path,
    [string] $OutputPath = $null
)

# Start-of-script
if ($Debug) {
    $DebugPreference = 'Continue'           # Start - display debug messages
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

$outputFileName = [System.IO.Path]::GetFileName($OutputPath)
$outputIsFile = -not [System.String]::IsNullOrWhiteSpace($outputFileName)

Write-Debug "`$Path          [$Path]"
Write-Debug "Input          [$(if ($inputIsFile) {"File"} Else {"Directory"})]"
Write-Debug "In-Path        [$resolvedPath] "

if ($outputIsFile)
{
    $outputDirectoryName = [System.IO.Path]::GetDirectoryName($OutputPath)
    $outputFileName = [System.IO.Path]::GetFileName($resolvedPath)
}
else {
    if ($OutputPath.Length -le 0)
    {
        $outputDirectoryName = [System.IO.Path]::GetDirectoryName($resolvedPath)
        Write-Debug "A - $outputDirectoryName"
    }
    else
    {
        $outputDirectoryName = [System.IO.Path]::GetDirectoryName($OutputPath)    
        Write-Debug "B - $outputDirectoryName"
    }

    $outputFileName = [System.IO.Path]::GetFileName($resolvedPath)

}

# Create folder if it does not already exists
if (-not (Test-Path $outputDirectoryName))
{
    $null = New-Item -Path $outputDirectoryName -ItemType Directory
}


# Handle files
if ($inputIsFile)
{
    if ($outputIsFile)                # File    File    OK
    {
        Write-Debug '# File    File    OK'
        $resolvedOutputPath = (Resolve-Path  $OutputPath).Path 
        # Join-Path (Resolve-Path $outputDirectoryName).Path $outputFileName
        # $outputFileName
        # $outputDirectoryName
        $resolvedOutputPath
    }

    if (-not $outputIsFile)         # File    Dir     OK
    {
        Write-Debug '# File    Dir     OK'
        $inputFileName = [System.IO.Path]::GetFileName($Path)
        $resolvedOutputPath = Join-Path (Resolve-Path $outputDirectoryName).Path $inputFileName
    }

    # $extension = [System.IO.Path]::GetExtension($resolvedPath)
    # $extensionIndex = $resolvedPath.LastIndexOf($extension)
    # $outputFilePath = "$($resolvedPath.Substring(0, $extensionIndex)).html"
    Write-Debug "`$OutputPath    [$OutputPath]"
    Write-Debug "Output         [$(if ($outputIsFile) {"File"} Else {"Directory"})]"
    Write-Debug "Out-Path       [$resolvedOutputPath]"


    $tempDirectoryName = [System.IO.Path]::GetDirectoryName($resolvedOutputPath)
    if (-not (Test-Path $tempDirectoryName))
    {
        $null = New-Item -Path $tempDirectoryName -ItemType Directory
    }

    # Only process ".phtm" files 
    $extension = [System.IO.Path]::GetExtension($resolvedPath)
    if ($extension -eq ".phtm")
    {
        $extension = [System.IO.Path]::GetExtension($resolvedPath)
        $extensionIndex = $resolvedPath.LastIndexOf($extension)
        $outputFilePath = "$($resolvedPath.Substring(0, $extensionIndex)).html"

        $tmpl = Get-Content $resolvedPath -Encoding UTF8 -ReadCount 0 -Raw
        $text = $ExecutionContext.InvokeCommand.ExpandString($tmpl)
        $text | Out-File $outputFilePath
    }
    else 
    {
        # Just copy file
        if ((Join-Path $resolvedPath "") -ne (Join-Path $resolvedOutputPath ""))
        {
            Copy-Item $resolvedPath -Destination $resolvedOutputPath
        }
        else
        {
            Write-Debug "Skip same src/dst;"
        }
        
    }
    Write-Debug "Output filepath [$outputFilePath]"

}
else 
{
    if ($outputIsFile)         # Dir    File     Err
    {
        Write-Debug '# Dir     File    Err'
        Write-Error "Cannot resolve Directory input to file output."
        exit
    }

    if (-not $outputIsFile)  # File    Dir     OK
    {
        Write-Debug '# Dir     Dir     OK'
        $fileList = Get-ChildItem -Path $resolvedPath -Recurse | Where-Object { $_ -is [System.IO.FileInfo] } | Foreach-Object { $_.FullName }

        $fileList | ForEach-Object {
            #"$((Resolve-Path $outputDirectoryName).Path)$($_.Remove(0, $($resolvedPath.Length)))"

            # "TGT $_ vs $resolvedPath"
            # $_.Remove(0, $resolvedPath.Length)
            
            $tempResolvedOutputPath = Join-Path ((Resolve-Path $outputDirectoryName).Path) ($_.Remove(0, $resolvedPath.Length))
            #([System.IO.Path]::GetFileName($_))

            Write-Debug "src [$_] => dst [$tempResolvedOutputPath] "

            $tempDirectoryName = [System.IO.Path]::GetDirectoryName($tempResolvedOutputPath)
            # "`$tempDirectoryName is $tempDirectoryName"
            if (-not (Test-Path $tempDirectoryName))
            {
                $null = New-Item -Path $tempDirectoryName -ItemType Directory
            }

            # Only process ".phtm" files 
            $extension = [System.IO.Path]::GetExtension($_).ToLower()
            if ($extension -eq ".phtm")
            {
                $extension = [System.IO.Path]::GetExtension($tempResolvedOutputPath)
                $extensionIndex = $tempResolvedOutputPath.LastIndexOf($extension)
                $tempResolvedOutputPath = "$($tempResolvedOutputPath.Substring(0, $extensionIndex)).html"

                $tmpl = Get-Content $_ -Encoding UTF8 -ReadCount 0 -Raw
                $text = $ExecutionContext.InvokeCommand.ExpandString($tmpl)
                $text | Out-File $tempResolvedOutputPath
            }
            else 
            {
                # Just copy file
                Copy-Item $_ -Destination $tempResolvedOutputPath
            }
            
        }

        $resolvedOutputPath = "*"
    }
}








Write-Output "All done."

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
