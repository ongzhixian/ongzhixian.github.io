
function Get-EpochTime
{
    return [int]([DateTime]::UtcNow - [DateTime]::UnixEpoch).TotalSeconds
}

function Get-Nonce
{
    [string]$nonce = $null
    [byte[]] $buffer = [byte[]]::new(32)
    [System.Security.Cryptography.RandomNumberGenerator] $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    
    $rng.GetBytes($buffer)
    $nonce = [Convert]::ToBase64String($buffer)

    # https://en.wikipedia.org/wiki/Base64
    
    # if we only want alphanumeric characters, we need to remove '+', '/' and '=' characters
    # Why we may want this?
    # Twitter use this as a definition for nonce
    # Needless to say, a string like this can not be convert back to its byte form.
    $nonce = $nonce.Replace('+', '')
    $nonce = $nonce.Replace('/', '')
    $nonce = $nonce.Replace('=', '')

    return $nonce
}

function Get-ParameterString
{
    param(
        [Parameter(Mandatory)]
        [System.Collections.Hashtable] $ht
    )

    [string] $qs = ""
    $encoded_prm = @{}
    
    # %-encoding key and value
    foreach ($key in $ht.Keys) {
        $encoded_prm.Add(
            [Uri]::EscapeDataString($key), 
            [Uri]::EscapeDataString($ht[$key]))
    }

    # Sort by name, then concat into querystring format
    foreach ($dictEntry in ($encoded_prm.GetEnumerator() | Sort-Object -Property Name)) 
    {
        $qs = $qs + "$($dictEntry.Key)=$($dictEntry.Value)&"
    }
    # Remove trailing ampersand
    $qs = $qs.Remove($qs.Length-1, 1)

    return $qs
}

function Get-SignatureBase
{
    param (
        [string] $httpMethod,
        [string] $url,
        [string]$parameterString
    )

    # Write-host "$parameterString"
    # $parameterString

    return "$($httpMethod.ToUpperInvariant())&$([Uri]::EscapeDataString($url))&$([Uri]::EscapeDataString($parameterString))"
}

function Get-SignatureKey
{
    param(
        [Parameter(Mandatory)]
        [string] $consumerSecret,
        [string] $tokenSecret = $null
    )

    if ($tokenSecret -eq $null)
    {
        return "$([Uri]::EscapeDataString($consumerSecret))&"
    }

    return "$([Uri]::EscapeDataString($consumerSecret))&$([Uri]::EscapeDataString($tokenSecret))"
}

function Get-HMACSHA1
{
    param(
        [string] $sign_key,
        [string] $sign_base,
        [string] $outputFormat = $null
    )

    [System.Security.Cryptography.HMACSHA1] $hmac = [System.Security.Cryptography.HMACSHA1]::new(
        [System.Text.Encoding]::UTF8.GetBytes($sign_key)
    )

    [byte[]] $hashBytes = $hmac.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($sign_base))

    # Print as hex "HEX"
    Write-Debug $([String]::Join(' ', $($hashBytes | ForEach-Object { $_.ToString("X2") })))

    # Print as base64 string "BASE64"
    Write-Debug $([Convert]::ToBase64String($hashBytes))

    # return $hashBytes

    switch ($outputFormat)
    {
        "HEX" {
            return [String]::Join(' ', $($hashBytes | ForEach-Object { $_.ToString("X2") }))
            break
        }
        "BASE64" {
            return [Convert]::ToBase64String($hashBytes)
            break
        }
        default {
            return $hashBytes
        }
    } 
}

function Get-AuthorizationHeader
{
    param(
        [System.Collections.Hashtable] $ht
    )

    [string] $qs = "OAuth "

    # Filter for entries with name starting with "oauth_*", sorted by Name
    
    foreach ($kvp in ($ht.GetEnumerator() | ? {$_.Name -like "oauth_*" } | Sort-Object -Property Name) ) {
        # %-encoding key and value
        $qs = $qs + "$([Uri]::EscapeDataString($kvp.Key))=`"$([Uri]::EscapeDataString($kvp.Value))`", "
    }

    
    # Remove trailing ampersand
    $qs = $qs.Remove($qs.Length-2, 2)

    return $qs
}


########################################
# Main script

$p = @{
    include_entities="true";
    oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog";
    oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg";
    oauth_signature_method="HMAC-SHA1";
    status="Hello Ladies + Gentlemen, a signed OAuth request!";
    oauth_timestamp="1318622958";
    oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb";
    oauth_version="1.0";
}



[string]$prmString = Get-ParameterString $p

[string]$method = "Post"

[string]$url =  "https://api.twitter.com/1.1/statuses/update.json"

$sign_base = Get-SignatureBase $method $url $prmString

$comSec = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
$autSec = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"

$sign_key = Get-SignatureKey $comSec $autSec


# [System.Security.Cryptography.HMACSHA1] $hm = [System.Security.Cryptography.HMACSHA1]::new([System.Text.Encoding]::UTF8.GetBytes($sign_key))

# $hb = $hm.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($sign_base))
# [String]::Join(' ', $($hb | ForEach-Object { $_.ToString("X2") }));
# [Convert]::ToBase64String($hb)

# Get-HMACSHA1 $sign_key $sign_base "HEX"
# Get-HMACSHA1 $sign_key $sign_base "BASE64"

$b = Get-HMACSHA1 $sign_key $sign_base "BASE64"

$p.Add("oauth_signature", $b)



# Building authorization header

Get-AuthorizationHeader $p

# # Filter to get only entries with name starting with "oauth_*", sorted by Name
# $p.GetEnumerator() | ? {$_.Name -like "oauth_*" } | Sort-Object -Property Name

# [string] $qs = "OAuth "
# $encoded_prm = @{}

# # %-encoding key and value
# foreach ($kvp in ($p.GetEnumerator() | ? {$_.Name -like "oauth_*" } | Sort-Object -Property Name) ) {
#     $qs = $qs + "$([Uri]::EscapeDataString($kvp.Key))=`"$([Uri]::EscapeDataString($kvp.Value))`", "
# }
# $qs

# Sort by name, then concat into querystring format
# foreach ($dictEntry in ($encoded_prm.GetEnumerator() | Sort-Object -Property Name)) 
# {
#     $qs = $qs + "$($dictEntry.Key)=$($dictEntry.Value)&"
# }


# Remove trailing ampersand



# $hm.Hash

# Write-Host "Signbase"
# $sign_base

# Write-Host "Signkey"
# $sign_key



# [String]::Join(' ', $hb);

# $p

# $encoded_prm = @{}

# Write-Host

# foreach ($key in $p.Keys) {
#     $encoded_prm.Add(
#         [Uri]::EscapeDataString($key), 
#         [Uri]::EscapeDataString($p[$key]))
# }

# $sorted = @()
# $qs = ""
# foreach ($dictEntry in ($encoded_prm.GetEnumerator() | Sort-Object -Property Name)) 
# {
#     $qs = $qs + "$($dictEntry.Key)=$($dictEntry.Value)&"
# }

# $qs = $qs.Remove($qs.Length-1, 1)
# $qs

# $sorted

# $encoded_prm = $encoded_prm.GetEnumerator() | Sort-Object -Property name
# $encoded_prm.GetType().ToString()
# $encoded_prm

# $qs = ""
# foreach ($key in $encoded_prm.Keys) {
#     Write-Host $key
#     $qs = $qs + "$key=$encoded_prm.Keys[$key]&" 
# }

# $qs

# # $qs = $qs.Remove($qs.Length - 1, 1)

# # $qs