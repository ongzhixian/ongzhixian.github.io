# Generate a random bytes.
$AESKey = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey)


$pwdTxt = Get-Content $SecurePwdFilePath
$securePwd = $pwdTxt | ConvertTo-SecureString -Key $AESKey

$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd


[System.Management.Automation.PSCredential]::new
