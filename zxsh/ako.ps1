$profilePath = $null
$secretFilePath = $null
$secrets = $null

# Module initialization

# Store secrets in the same path as $PROFILE 
$profilePath = [System.IO.Path]::GetDirectoryName($PROFILE)

if ($false -eq [System.IO.Directory]::Exists($profilePath))
{
    New-Item $profilePath -ItemType Directory
}

$secretFilePath = Join-Path $profilePath "zxsh-secrets.txt"
if ([System.IO.File]::Exists($secretFilePath))
{
    # 
    # $fileContent = Get-Content $secretFilePath
    # $secrets = ConvertFrom-Json $fileContent

    $secrets = Import-Clixml -Path $secretFilePath
}
else {
    $secrets = @{}
}

## Module functions

function New-Secret {
    param (
        [string] $key,
        [string] $value = @{}
    )


    Write-Host "`nkey   is $key"
    Write-Host "value is $value`n"
    
    $secrets.Add($key, $value)
}

function Save-Secret {
    $secrets | Export-Clixml -Path $secretFilePath
}






# Main script

Write-Host 
$secrets

# New-Secret "apikey1" "apisecret"
# $secrets

# New-Secret "apikey2"
# $secrets

#Save-Secret

$secrets["apikey2"]



#$fileacl = Import-Clixml -Path .\FileACL.xml

Save-Secret