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

$secretFilePath = Join-Path $profilePath "zxsh-secrets.json"
# if ([System.IO.File]::Exists($secretFilePath))
# {
#     # 
#     # $fileContent = Get-Content $secretFilePath
#     # $secrets = ConvertFrom-Json $fileContent

#     $secrets = Import-Clixml -Path $secretFilePath
# }
# else {
#     $secrets = @{}
# }

# Security functions

# public static byte[] CreateRandomSalt(int length)
# {
#     // Create a buffer
#     byte[] randBytes;

#     if (length >= 1)
#     {
#         randBytes = new byte[length];
#     }
#     else
#     {
#         randBytes = new byte[1];
#     }

#     // Create a new RNGCryptoServiceProvider.
#     RNGCryptoServiceProvider rand = new RNGCryptoServiceProvider();

#     // Fill the buffer with random bytes.
#     rand.GetBytes(randBytes);

#     // return the bytes.
#     return randBytes;
# }

function Get-RandomBytes {
    param (
        [int] $length=1
    )

    Write-Debug "Get-RandomBytes[length] : $length" 

    $result = New-Object byte[] $length

    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($result)

    return $result
}

function Get-EncryptedBytes {
    param (
        [System.Security.Cryptography.SymmetricAlgorithm] $alg,
        [string] $plainText
    )

    [System.Security.Cryptography.ICryptoTransform] $encryptor = $null
    [System.IO.MemoryStream] $ms = $null
    [System.Security.Cryptography.CryptoStream] $encryptionStream = $null
    [System.IO.StreamWriter] $sw = $null

    try {
        $encryptor = $alg.CreateEncryptor($alg.Key, $alg.IV)

        $ms = [System.IO.MemoryStream]::new()
        $encryptionStream = [System.Security.Cryptography.CryptoStream]::new($ms, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
        $sw = [System.IO.StreamWriter]::new($encryptionStream)

        $sw.AutoFlush = $true
        $sw.Write($plainText)

        $sw.Flush()
        $sw.Close()
        $encryptionStream.Close()
        $ms.Close()
        
        return $ms.ToArray()
    }
    catch {
        
    }
}

function Get-DecryptedText 
{
    param (
        [System.Security.Cryptography.SymmetricAlgorithm] $alg,
        [byte[]] $cipherBytes
    )

    $plainText = $null
    [System.Security.Cryptography.ICryptoTransform] $decryptor = $null
    [System.IO.MemoryStream] $ms = $null
    [System.Security.Cryptography.CryptoStream] $decryptionStream = $null
    [System.IO.StreamReader] $sr = $null

    try {
        $decryptor = $alg.CreateDecryptor($alg.Key, $alg.IV)

        $ms = [System.IO.MemoryStream]::new($cipherBytes)
        $decryptionStream = [System.Security.Cryptography.CryptoStream]::new($ms, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Read)
        $sr = [System.IO.StreamReader]::new($decryptionStream)
        $plainText = $sr.ReadToEnd()

        $sr.Close()
        $decryptionStream.Close()
        $ms.Close()
        
        return $plainText
    }
    catch [System.Security.Cryptography.CryptographicException]
    {
        Write-Error "Cannot decrypt content. Please check password."
    }
    catch {
        Write-Error "Error" $_.Exception
    }

    return $plainText
}

# function Save-Secrets {
#     param (
#         [string] $alg, 
#         [string] $saltBase64,
#         [int]    $itCount,
#         [string] $ivBase64,
#         [string] $cipherBase64,
#         [string] $savePath
        
#     )

#     $s = [ordered]@{
#         "Alg"   = "AES";
#         "Salt"  = $saltBase64;
#         "It"    = $itCount;
#         "IV"    = $ivBase64;
#         "Cipher"= $cipherBase64;
#     }
    
#     ConvertTo-Json $s | Out-File $savePath
# }

# Main script

# $secretFilePath

# $secrets = ConvertFrom-Json (Get-Content $secretFilePath -Raw)

# $secrets


# Use password derived function PBKDF2

# Make salt bytes the same size as IV size in AES
# IV size for AES = AES.blocksize / 8 
# $saltBytes = Get-RandomBytes ($aes.BlockSize / 8)
# Write-Host "Salt bytes: $saltBytes"

# $saltBase64 = [Convert]::ToBase64String($saltBytes)
# Write-Host "Salt bytes: $saltBase64"



# $itCount = Get-Random -Maximum 99999



function Get-PBKDF2 {
    param (
        [string] $passPhrase,
        [int] $saltBytesLength,
        [int] $itCountMax = 99999,
        [byte[]] $saltBytes = $null,
        [int] $itCount = $null
    )

    Write-Debug "Get-PBKDF2[passPhrase] $passPhrase"
    Write-Debug "Get-PBKDF2[saltBytesLength] $saltBytesLength"
    Write-Debug "Get-PBKDF2[itCountMax] $itCountMax"
    Write-Debug "Get-PBKDF2[saltBytes] $saltBytes"
    Write-Debug "Get-PBKDF2[itCount] $itCount"

    # Write-Host "Get-PBKDF2[passPhrase] $passPhrase"
    # Write-Host "Get-PBKDF2[saltBytesLength] $saltBytesLength"
    # Write-Host "Get-PBKDF2[itCountMax] $itCountMax"
    # Write-Host "Get-PBKDF2[saltBytes] $saltBytes"
    # Write-Host "Get-PBKDF2[itCount] $itCount"

    if ($null -eq $saltBytes)
    {
        $saltBytes = Get-RandomBytes $saltBytesLength
    }
    Write-Debug "Salt bytes: $saltBytes"

    $saltBase64 = [Convert]::ToBase64String($saltBytes)
    Write-Debug "Salt bytes: $saltBase64"

    if ($itCount -eq 0) 
    {
        $itCount = Get-Random -Maximum $itCountMax
    }
    Write-Debug "It count  : $itCount"
    
    
    # List of hashnames (CryptoConfig Class)
    # https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.cryptoconfig?view=netstandard-2.0

    # # Derives a key from a password using an extension of the PBKDF1 algorithm.
    # [System.Security.Cryptography.PasswordDeriveBytes]
    # ZX:   It should also be noted that System.Security.Cryptography.PasswordDeriveBytes 
    #       can only be used with DES-related algorithms
    # $pdb = [System.Security.Cryptography.PasswordDeriveBytes]::new("password", $saltBytes)
    # $tdes = [System.Security.Cryptography.TripleDESCryptoServiceProvider]::Create()
    # $pdb.CryptDeriveKey("TripleDES", "SHA1", 192, $tdes.IV) # Works
    # $pdb.CryptDeriveKey("DES", "SHA1", 64, $tdes.IV)        # Works
    # $pdb.CryptDeriveKey("AES", "SHA1", 256, $aes.IV)        # Throw exception "Object identifier (OID) is unknown" (where OID refers to "AES")


    # Since we want to use AES, we use password-based key derivation functionality, PBKDF2
    # [System.Security.Cryptography.Rfc2898DeriveBytes]
    $pdb = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($passPhrase, $saltBytes, $itCount)

    return @{
        "saltBase64"= $saltBase64;
        "itCount"   = $itCount;
        "pdb"       = $pdb;
    }
}

function Get-Secret {
    param (
        [string] $passPhrase,
        [string] $filePath
    )

    $secretJson =  ConvertFrom-Json (Get-Content $filePath -Raw )
    #$secretJson

    # Restore pbkdf2
    $pbkdf2     = Get-PBKDF2 $passPhrase -itCount $secretJson.It -saltBytes ([Convert]::FromBase64String($secretJson.Salt))
    $saltBase64 = $pbkdf2["saltBase64"]
    $itCount    = $pbkdf2["itCount"]
    $pdb        = $pbkdf2["pdb"]


    # Restore AES 
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.IV = [Convert]::FromBase64String($secretJson.IV)
    $aes.Key = $pdb.GetBytes($aes.KeySize / 8)

    $ans = Get-DecryptedText $aes ([Convert]::FromBase64String($secretJson.Cipher))
    return $ans
}


function Save-Secret {
    param (
        [string] $plainText,
        [string] $passPhrase, 
        [string] $outFilePath
    )

    $aes = [System.Security.Cryptography.Aes]::Create()


    $pbkdf2     = Get-PBKDF2 $passPhrase ($aes.BlockSize / 8)
    $saltBase64 = $pbkdf2["saltBase64"]
    $itCount    = $pbkdf2["itCount"]
    $pdb        = $pbkdf2["pdb"]

    $ivBase64 = [Convert]::ToBase64String($aes.IV)
    Write-Debug "IV   bytes: $ivBase64"

    $aes.Key = $pdb.GetBytes($aes.KeySize / 8)
    $encBytes = Get-EncryptedBytes $aes $plainText
    $cipherBase64 = [Convert]::ToBase64String($encBytes)

    $s = [ordered]@{
        "Alg"   = "AES";
        "Salt"  = $saltBase64;
        "It"    = $itCount;
        "IV"    = $ivBase64;
        "Cipher"= $cipherBase64;
    }
    
    ConvertTo-Json $s | Out-File $outFilePath
}

if ($script:$ZXSHPWD -eq $null)
{
    $script:$ZXSHPWD = Read-Host -Prompt "Enter password for ZXSH"
}
else {
    Write-Host "Using existing zxsh password"    
}

# $plainText = Get-Content "C:\Users\zong\Documents\PowerShell\zxsh-secrets.json" -Raw
# Save-Secret $plainText $script:$ZXSHPWD "C:\Users\zong\Documents\PowerShell\S.txt"

# Now given path "C:\Users\zong\Documents\PowerShell\S.txt"
$a = Get-Secret $script:$ZXSHPWD "C:\Users\zong\Documents\PowerShell\S.txt"
$a                          # $a is a string
$x = ConvertFrom-Json $a    # $x is PSCustomObject, not a HashTable
# $x.Neocities.zhixian

# To save results 
# ConvertTo-Json $x