
[byte[]] $plainTextBytes = [System.Text.Encoding]::UTF8.GetBytes("Data to Encrypt")
[byte[]] $encryptedData = $null
[byte[]] $decryptedData = $null

[System.Security.Cryptography.RSACryptoServiceProvider] $rsa = $null


$rsa = [System.Security.Cryptography.RSACryptoServiceProvider]::new()

# $encryptedData = RSAEncrypt(dataToEncrypt, RSA.ExportParameters(false), false);
#dataToEncrypt, RSA.ExportParameters(false), false
#$rsa.Encrypt($plainTextBytes, $rsa.ExportParameters($false), $false)
[System.Security.Cryptography.RSAParameters] $rsaKeyInfo # Struct
[System.Security.Cryptography.RSAParameters] $fullRsaKeyInfo 
$rsaKeyInfo = $rsa.ExportParameters($false)
$rsaKeyInfo

$fullRsaKeyInfo = $rsa.ExportParameters($true)
$fullRsaKeyInfo

#//Import the RSA Key information. This only needs toinclude the public key information.
$rsa.ImportParameters($rsaKeyInfo)

# Encrypt the passed byte array and specify OAEP padding. 
# OAEP padding is only available on Microsoft Windows XP or later.  
$encryptedData = $rsa.Encrypt($plainTextBytes, $false)
[Convert]::ToBase64String($encryptedData)

Write-Host "Encryption done!"

$rsa = [System.Security.Cryptography.RSACryptoServiceProvider]::new()

$rsa.ImportParameters($fullRsaKeyInfo)

# //Decrypt the passed byte array and specify OAEP padding.  
# //OAEP padding is only available on Microsoft Windows XP or
# //later.  
$decryptedData = $rsa.Decrypt($encryptedData, $false);
$result = [System.Text.Encoding]::UTF8.GetString($decryptedData)
$result

Write-Host "All done"

#How to export key

# Export the key information to an RSAParameters object.
# Pass false to export the public key information or pass true to export public and private key information.
# [System.Security.Cryptography.RSAParameters] $rsaParams = $rsa.ExportParameters($false)

# $e = $rsaParams | ConvertTo-Json -Compress
# [System.Security.Cryptography.RSAParameters] $rsaParams = ConvertFrom-Json $e
