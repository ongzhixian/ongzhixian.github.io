# Overview of ACME
                                  directory
                                      |
                                      +--> newNonce
                                      |
          +----------+----------+-----+-----+------------+
          |          |          |           |            |
          |          |          |           |            |
          V          V          V           V            V
     newAccount   newAuthz   newOrder   revokeCert   keyChange
          |          |          |
          |          |          |
          V          |          V
       account       |        order --+--> finalize
                     |          |     |
                     |          |     +--> cert
                     |          V
                     +---> authorization
                               | ^
                               | | "up"
                               V |
                             challenge

                     ACME Resources and Relationships


bE0KQlktC38 : https://community.letsencrypt.org/t/adding-random-entries-to-the-directory/33417
keyChange   : https://acme-staging-v02.api.letsencrypt.org/acme/key-change
meta        : @{caaIdentities=System.Object[];
              termsOfService=https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf;
              website=https://letsencrypt.org/docs/staging-environment/}
newAccount  : https://acme-staging-v02.api.letsencrypt.org/acme/new-acct
newNonce    : https://acme-staging-v02.api.letsencrypt.org/acme/new-nonce
newOrder    : https://acme-staging-v02.api.letsencrypt.org/acme/new-order
revokeCert  : https://acme-staging-v02.api.letsencrypt.org/acme/revoke-cert

The following table illustrates a typical sequence of requests required to 
1.  establish a new account with the server, 
2.  prove control of an identifier, 
3.  issue a certificate, and 
4.  fetch an updated certificate some time after issuance.  
The "->" is a mnemonic for a Location header field pointing to a created resource.

# Actions

Action                  Request                                     Response
Get directory           GET  directory                              200
Get nonce               HEAD newNonce                               200
Create account          POST newAccount                             201 -> account
Submit order            POST newOrder                               201 -> order
Fetch challenges        POST-as-GET order's authorization urls      200 
Respond to challenges   POST authorization challenge urls           200
Poll for status         POST-as-GET order                           200
Finalize order          POST order's finalize url                   200
Poll for status         POST-as-GET order                           200
Download certificate    POST-as-GET order's certificate url         200

| Action            | Request                        | Response     |
+-------------------+--------------------------------+--------------+
| Get directory     | GET  directory                 | 200          |
|                   |                                |              |
| Get nonce         | HEAD newNonce                  | 200          |
|                   |                                |              |
| Create account    | POST newAccount                | 201 ->       |
|                   |                                | account      |
|                   |                                |              |
| Submit order      | POST newOrder                  | 201 -> order |
|                   |                                |              |
| Fetch challenges  | POST-as-GET order's            | 200          |
|                   | authorization urls             |              |
|                   |                                |              |
| Respond to        | POST authorization challenge   | 200          |
| challenges        | urls                           |              |
|                   |                                |              |
| Poll for status   | POST-as-GET order              | 200          |
|                   |                                |              |
| Finalize order    | POST order's finalize url      | 200          |
|                   |                                |              |
| Poll for status   | POST-as-GET order              | 200          |
|                   |                                |              |
| Download          | POST-as-GET order's            | 200          |
| certificate       | certificate url                |              |
+-------------------+--------------------------------+--------------+


install-module acme-ps




# Get Atom Feed
$r = Invoke-WebRequest -Uri "https://status.digitalocean.com/history.atom" -UseBasicParsing -ContentType "application/xml"

If ($Response.StatusCode -ne "200") {
    # Feed failed to respond.
    Write-Host "Message: $($Response.StatusCode) $($Response.StatusDescription)"
}


   {
     "protected": base64url({
       "alg": "ES256",
       "jwk": {...},
       "nonce": "6S8IqOGY7eL2lsGoTZYifg",
       "url": "https://example.com/acme/new-account"
     }),
     "payload": base64url({
       "termsOfServiceAgreed": true,
       "contact": [
         "mailto:cert-admin@example.org",
         "mailto:admin@example.org"
       ]
     }),
     "signature": "RZPOnYoPs1PhjszF...-nh6X1qtOFPB519I"
   }
   
$q = "eyJpc3MiOiJqb2UiLA0KICJleHAiOjEzMDA4MTkzODAsDQogImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlfQ"
$q = "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ"
$q = "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ=="
      12345678901234567890123456789012345678901234567890123456789012345678901234567890
4*(n/3)
123456789012345678901234567890123456789012345678901234567890
{"sub":"1234567890","name":"John Doe","iat":1516239022}

         1         2         3         4         5         6         7
123456789|123456789|123456789|123456789|123456789|123456789|123456789|123456789|
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ==

123456789|123456789|123456789|123456789|123456789|12345
{"sub":"1234567890","name":"John Doe","iat":1516239022}
4 * CEIL(n / 3)

76 = 4 * CEIL(n / 3)

($q.Length / 4) == [Math]::Ceiling(($q.Length / 4)) * 4
$paddedLength = [Math]::Ceiling(($q.Length / 4)) * 4



< < ? ? ? > >
PDw/Pz8+Pg==
PDw_Pz8-Pg

$t = "<<???>>"
[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($t))
PDw/Pz8+Pg==

Replaces “+” by “-” (minus)
Replaces “/” by “_” (underline)
Does not require a padding character
Forbids line separators
