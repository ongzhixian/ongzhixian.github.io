
[int] $saltBytesLength = 8
[uint] $itCountMax = 99999
[byte[]] $saltBytes = $null
[uint] $itCount = 0


function Get-RandomBytes {
    param (
        [int] $length = 1
    )

    Write-Debug "Get-RandomBytes[length] : $length" 

    $result = New-Object byte[] $length

    # ZX:   It sounds good in theory to make RNGCryptoServiceProvider a shared resource.
    #       But it is probably more secure to recreate it each time we need it.
    #       Leave it as it is for the time being, until such a time performance becomes an issue.
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($result)

    return $result
}

if ($null -eq $saltBytes)
{
    $saltBytes = Get-RandomBytes $saltBytesLength
}

$saltBase64 = [Convert]::ToBase64String($saltBytes)

$saltBytes = [Convert]::FromBase64String("BMQv9zCDkAX0Fw==")

Write-Debug "Salt bytes: $saltBytes"
Write-Debug "Salt bytes: $saltBase64"
Write-Debug "It count  : $itCount"

[string] $passPhrase = Read-Host -Prompt "Psst!" -AsSecureString
$passPhrase

$pdb = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($passPhrase, $saltBytes, 5555)
$pdb -eq $null

$key    = $pdb.GetBytes(10)
$keyBase64 = [Convert]::ToBase64String($key)
"keyBase64      = $keyBase64"


# return @{
#     "saltBase64"= $saltBase64;
#     "itCount"   = $itCount;
#     "pdb"       = $pdb;
# }