
[string]$client_id = "d877ef27-a110-4e0f-82dd-e6c8e5385c62" # Application (client) ID
[string]$tenant_id = "17370574-7110-40c3-a317-12ac3ebf9e96" # Directory (tenant) ID
$base_url = "https://login.microsoftonline.com"


$code = "OAQABAAIAAAAm-06blBE1TpVMil8KPQ41N3oVDVuKNDq-Plmag6I-mhxcO82PTrboIzq9qvrIfYEQU5xNOV-1n7HQVPAiNC4vfuIcoh_z_9cQLkXxV5P-RHnvSXCL7YdIxr3bu9SWhiIGXFwlA0Yk54U7RM-CGVn0gt5PqgXVmkCdaCcKDTjrwOO62Z8bmTiQYDeP308evQYnOuqfox0lk3utxOpqDN7wus1taLIhsIp6m6Su2pi4APr1fEC60HjyGGQWs8BgXyxVF099WR2pNAhRLf9ZmMkRrVfDcUd00c6DcbKkWf3bJ2QsFSAn3nDkjoxPszMph8P_-gqaG43ov19OHIc9umczwJcP-91Ym_s3dgHf98uHRATAZ9U4LrWjxffs2ktqu_AbeE9FKIam2I6dD_5e74yBGEk7Q47KTjk0cRGwp2-yW5YcCucWNPbVe9iBgr6_L2_JTZR2ObcmtNUL0vw3kDSf_a4rrrZMZCVJRiHRBvosdwkDDMQ9BfSyK3OYENvffH1Guvmnr7RhkgwKHkUYKjx_MCpsgU4BmlzHGmrE2W3gG7jZbnvlm_CJUHjumDvCaxI8rm6iOz3PG4vdqzSnVcyjYWMeBGK_YspvfDYimVBxMfWpsdnah3r9K0j6DkLDq2CIs1sNC_m4UH8KzEq6hjxJOnXwnKcrJjC2SOptq6RJ-TcHa3S0tOVu6WqLjjXAbdP3rbAolsz45S-K4ZZ6r3Ot2-gsxvyUgVfYTrsSSarE6-1ASwBw0Rqtzmjk8EqL2htljIVk53lIeer8EOnZ7za1QNyDL8ZmPIUzWWQM39zlrq6pZLcr8N7Sk8uli74PMQm8rqhIi8SLgJljIB17553jBopQPOe5yQbtUecQ9Zh7RzBxe3e7niAqDwvs805Tb8wtH01yKjecsIVHRZXrhH-ZnLNmfjc1L5ZR_ktXhI4DTF_F5HL"


# Got auth code. Exchange for access code


# Get auth code



$c = @{
    client_id=$client_id;
    redirect_uri="https://login.microsoftonline.com/common/oauth2/nativeclient"
    grant_type="authorization_code";
    code=$code;
    scope="openid offline_access https://graph.microsoft.com/mail.read";
}

# Convert dictionary to querystring

$qs = "?"
foreach ($key in $c.Keys) {
    $qs = $qs + "$($key)=$([Uri]::EscapeDataString($c[$key]))&" 
}


$auth_sub = "/$tenant_id/oauth2/v2.0/token"
$final = "$base_url$auth_sub"
$final



$body = @{grant_type='authorization_code'
      client_id='s6BhdRkqt'
      redirect_uri='MyAppServer.com/receiveAuthCode'
      code='i1WsRn1uB'}
$contentType = 'application/x-www-form-urlencoded' 
Invoke-WebRequest -Method POST -Uri <yourUrl> -body $body -ContentType $contentType



## Refreshing token

// Line breaks for legibility only

POST /{tenant}/oauth2/v2.0/token HTTP/1.1
Host: https://login.microsoftonline.com
Content-Type: application/x-www-form-urlencoded

client_id=6731de76-14a6-49ae-97bc-6eba6914391e
&scope=https%3A%2F%2Fgraph.microsoft.com%2Fmail.read
&refresh_token=OAAABAAAAiL9Kn2Z27UubvWFPbm0gLWQJVzCTE9UkP3pSx1aXxUjq...
&grant_type=refresh_token
&client_secret=JqQX2PNo9bpM0uEihUPzyrh      // NOTE: Only required for web apps. This secret needs to be URL-Encoded
