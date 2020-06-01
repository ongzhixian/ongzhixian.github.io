# MS Graph
# Demo "auth-code grant" https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow

[string]$client_id = "d877ef27-a110-4e0f-82dd-e6c8e5385c62" # Application (client) ID
[string]$tenant_id = "17370574-7110-40c3-a317-12ac3ebf9e96" # Directory (tenant) ID
$base_url = "https://login.microsoftonline.com"


# Get auth code

$c = @{
    response_type="code";
    redirect_uri="https://login.microsoftonline.com/common/oauth2/nativeclient";
    client_id=$client_id;
    scope="openid offline_access User.Read User.ReadWrite tasks.read https://graph.microsoft.com/mail.read";
    response_mode="query";
    state="12345";
}

# Convert dictionary to querystring

$qs = "?"
foreach ($key in $c.Keys) {
    $qs = $qs + "$($key)=$([Uri]::EscapeDataString($c[$key]))&" 
}


$auth_sub = "/$tenant_id/oauth2/v2.0/authorize"
$final = "$base_url$auth_sub$qs"

Write-Host "Opening site: $final"
#$final

# Comment out until ready
start $final

# Manual process here: 
# User interactively use browser authorize access
# User TODO: paste response uri to the following read prompt. 

# ZX: Microsoft's full url is TOO long to be paste into PowerShell's Read-Host.
# Read-Host apparently can only read up to a default limit fo 1024 characters?

# One way is to use clipboard :-D
# $user_response_uri = Read-Host -Prompt "Press <ENTER> to continue after you copied uri"
# $user_response_uri = Get-Clipboard

Write-Host -NoNewLine "Paste response: "
$user_response_uri = [Console]::ReadLine()


$code = ""
[Uri] $parsed_response_uri = [Uri]::new("", [UriKind]::RelativeOrAbsolute)
if ([Uri]::TryCreate($user_response_uri, [UriKind]::RelativeOrAbsolute, [ref] $parsed_response_uri))
{
    $qs = [System.Web.HttpUtility]::ParseQueryString($parsed_response_uri.Query)
    #$qs
    $code = $qs["code"]
    #Write-Host "Code FOUND! Code is: [$code]"
    
}
else
{
    Write-Host "No code found."
}


# OK, exchange auth-code for access-code
$body = @{
    client_id=$client_id;
    redirect_uri="https://login.microsoftonline.com/common/oauth2/nativeclient"
    grant_type="authorization_code";
    code=$code;
    scope="openid offline_access https://graph.microsoft.com/mail.read";
}

# $body




$access_code_path = "/$tenant_id/oauth2/v2.0/token"
$access_code_uri = "$base_url$access_code_path"
$contentType = 'application/x-www-form-urlencoded'


#$t = Invoke-WebRequest -Method POST -Uri $access_code_uri -body $body -ContentType $contentType
# Write-Host $t

# Write-Host "DEBUG"
# Write-Host $access_code_uri
# Write-Host $body["code"]
# Write-Host $contentType

$t = Invoke-RestMethod -Method POST -Uri $access_code_uri -body $body -ContentType $contentType
$t.GetType().ToString() # System.Management.Automation.PSCustomObject
$t


Write-Host "Access token:"
Write-Host $t.access_token

# Write-Host "Access token: [$($t["access_token"])]"
# Write-Host "Refresh token: [$($t["refresh_token"])]"
# Write-Host "Id token: [$($t["id_token"])]"

# Write-Host $t

# Write-Host 'the end'
