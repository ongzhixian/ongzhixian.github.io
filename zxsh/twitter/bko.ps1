
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

# $p = @{
#     oauth_version="1.0";
#     oauth_signature_method="HMAC-SHA1";
#     oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog";
#     oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb";
#     oauth_timestamp="1318622958";
#     oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg";
#     status="Hello Ladies + Gentlemen, a signed OAuth request!";
#     include_entities="true";
# }

# $p = @{
#     include_entities="true";
#     oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog";
#     oauth_nonce="kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg";
#     oauth_signature_method="HMAC-SHA1";
#     status="Hello Ladies + Gentlemen, a signed OAuth request!";
#     oauth_timestamp="1318622958";
#     oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb";
#     oauth_version="1.0";
# }

# [string]$prmString = Get-ParameterString $p

# [string]$method = "Post"

# [string]$url =  "https://api.twitter.com/1.1/statuses/update.json"

# $sign_base = Get-SignatureBase $method $url $prmString

# $comSec = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
# $autSec = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"

# $sign_key = Get-SignatureKey $comSec $autSec

# $b = Get-HMACSHA1 $sign_key $sign_base "BASE64"

# $p.Add("oauth_signature", $b)

# # Building authorization header

# Get-AuthorizationHeader $p


#####
# Script to get request token
# POST https://api.twitter.com/oauth/request_token

# The basic
$p = @{
    oauth_version="1.0";
    oauth_signature_method="HMAC-SHA1";
    oauth_timestamp=Get-EpochTime;
    oauth_nonce=Get-Nonce;
}

# Fields needed for POST statuses/updat
$p["oauth_consumer_key"] = "qqh5fmbjVeAqd0hSbUdrQBqRn"
$p["oauth_token"] = "11217332-1iOkuTXb0oSZeEG0DROPGlaK1XzbvtgZvGNYeqFJQ" # from access token 
$p["status"] = "My first API post"

[string]$prmString = Get-ParameterString $p
[string]$method = "Post"
[string]$url =  "https://api.twitter.com/1.1/statuses/update.json"

$comSec = "fWG6vhX7ksUQBPradcPSR4896wl7SqYvIztlDLUlo92iIwZX41"
$autSec = "1nJYq8kTBeK67jw5kX27YYWDZPdgAXU3GbEDfTUO7Xc2q" # from access token 

$sign_base = Get-SignatureBase $method $url $prmString
$sign_key = Get-SignatureKey $comSec $autSec

Write-Host "Sign-base"
$sign_base

Write-Host "Sign-key"
$sign_key

$b = Get-HMACSHA1 $sign_key $sign_base "BASE64"
$b
$p.Add("oauth_signature", $b)

$p

$oauthHeaders = Get-AuthorizationHeader $p
$oauthHeaders

# oauth_consumer_key="xvz1evFS4wEEPTGEFPHBog";
# oauth_token="370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb";

$headers = @{
    Authorization=$oauthHeaders
}

$body = @{
    status="My first API post"
}

$a = Invoke-RestMethod -Method Post -Headers $headers -Uri $url -Body $body
Write-Host "RESULT"
$a


# created_at                : Tue Jun 02 06:49:08 +0000 2020
# id                        : 1267709819143634945
# id_str                    : 1267709819143634945
# text                      : My first API post
# truncated                 : False
# entities                  : @{hashtags=System.Object[]; symbols=System.Object[]; user_mentions=System.Object[];
#                             urls=System.Object[]}
# source                    : <a href="https://localhost.localhost" rel="nofollow">zxsh-twitter</a>
# in_reply_to_status_id     :
# in_reply_to_status_id_str :
# in_reply_to_user_id       :
# in_reply_to_user_id_str   :
# in_reply_to_screen_name   :
# user                      : @{id=11217332; id_str=11217332; name=zhixian; screen_name=zhixian; location=Singapore;
#                             description=Average Singapore software engineer; url=; entities=; protected=False;
#                             followers_count=11; friends_count=99; listed_count=0; created_at=Sun Dec 16 08:32:02 +0000
#                             2007; favourites_count=28; utc_offset=; time_zone=; geo_enabled=True; verified=False;
#                             statuses_count=90; lang=; contributors_enabled=False; is_translator=False;
#                             is_translation_enabled=False; profile_background_color=C0DEED;
#                             profile_background_image_url=http://abs.twimg.com/images/themes/theme1/bg.png;
#                             profile_background_image_url_https=https://abs.twimg.com/images/themes/theme1/bg.png;
#                             profile_background_tile=False; profile_image_url=http://pbs.twimg.com/profile_images/876597
#                             051215167488/4uxpMJg7_normal.jpg; profile_image_url_https=https://pbs.twimg.com/profile_ima
#                             ges/876597051215167488/4uxpMJg7_normal.jpg; profile_link_color=1DA1F2;
#                             profile_sidebar_border_color=C0DEED; profile_sidebar_fill_color=DDEEF6;
#                             profile_text_color=333333; profile_use_background_image=True; has_extended_profile=True;
#                             default_profile=True; default_profile_image=False; following=False;
#                             follow_request_sent=False; notifications=False; translator_type=none}
# geo                       :
# coordinates               :
# place                     :
# contributors              :
# is_quote_status           : False
# retweet_count             : 0
# favorite_count            : 0
# favorited                 : False
# retweeted                 : False
# lang                      : en