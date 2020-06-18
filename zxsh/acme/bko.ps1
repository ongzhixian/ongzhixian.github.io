# # Reference: https://www.reddit.com/r/PowerShell/comments/8bc3rb/generate_jwt_json_web_token_in_powershell/

# $alg = "HS256"
# $exp = [int]([DateTime]::UtcNow - [DateTime]::UnixEpoch).TotalSeconds

# # "HS256" {New-Object System.Security.Cryptography.HMACSHA256}
# # "HS384" {New-Object System.Security.Cryptography.HMACSHA384}
# # "HS512" {New-Object System.Security.Cryptography.HMACSHA512}
# # "ES256"

# Reference https://tools.ietf.org/html/rfc7515#page-7
[hashtable]$header = @{
    "typ" = "JWT";
    "alg" = "HS256";
}
[hashtable]$payload = @{
    "iss" = "joe"; 
    "exp" = 1300819380;
    "http://example.com/is_root" = $true
}


$headerJson = $header | ConvertTo-Json -Compress
$payloadJson = $payload | ConvertTo-Json -Compress

[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($headerjson))
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
eyJ0eXAiOiJKV1QiLA0KICJhbGciOiJIUzI1NiJ9

# $headerjsonbase64 = [Convert]::ToBase64String(
#     [System.Text.Encoding]::UTF8.GetBytes($headerjson)
#     ).Split('=')[0].Replace('+', '-').Replace('/', '_')


# $payloadjsonbase64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($payloadjson)).Split('=')[0].Replace('+', '-').Replace('/', '_')

# $ToBeSigned = $headerjsonbase64 + "." + $payloadjsonbase64


eyJ0eXAiOiJKV1QiLA0KICJhbGciOiJIUzI1NiJ9