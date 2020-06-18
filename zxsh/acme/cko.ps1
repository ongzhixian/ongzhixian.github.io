# Reference: https://www.reddit.com/r/PowerShell/comments/8bc3rb/generate_jwt_json_web_token_in_powershell/

$alg = "HS256"
$exp = [int]([DateTime]::UtcNow - [DateTime]::UnixEpoch).TotalSeconds

# "HS256" {New-Object System.Security.Cryptography.HMACSHA256}
# "HS384" {New-Object System.Security.Cryptography.HMACSHA384}
# "HS512" {New-Object System.Security.Cryptography.HMACSHA512}
# "ES256"

[hashtable]$header = @{
    alg = $alg; 
    typ = "JWT"
}
[hashtable]$payload = @{
    iss = $Issuer; 
    exp = $exp
}


$headerJson = $header | ConvertTo-Json -Compress
$payloadJson = $payload | ConvertTo-Json -Compress

$headerjsonbase64 = [Convert]::ToBase64String(
    [System.Text.Encoding]::UTF8.GetBytes($headerjson)
    ).Split('=')[0].Replace('+', '-').Replace('/', '_')


# $payloadjsonbase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($payloadjson)).Split('=')[0].Replace('+', '-').Replace('/', '_')

# $ToBeSigned = $headerjsonbase64 + "." + $payloadjsonbase64