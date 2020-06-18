$baseUrl = "https://acme-staging-v02.api.letsencrypt.org/directory"

$headers = @{ 
    Authorization="Bearer ya29.a0AfH6SMCUtakvMCKwuLXt2WurR-vPGXWXJ-WvXYHKSD_5ERBdq-jXNsZ5rlRe7Yu7-I0qwHshkpFlMdC9q5M82eb6BBlduQgKCNjguTgPyOKzx_sN55mwiYHxVS9_9cqUywDRmfyAqTyakUMAaiHgNCvmGapt4zlvt-M" 
}


# Get directory
$a = Invoke-RestMethod -Headers $headers -Uri $baseUrl

# ZX: Will receive a response like the below:

# bE0KQlktC38 : https://community.letsencrypt.org/t/adding-random-entries-to-the-directory/33417
# keyChange   : https://acme-staging-v02.api.letsencrypt.org/acme/key-change
# meta        : @{caaIdentities=System.Object[];
#               termsOfService=https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf;
#               website=https://letsencrypt.org/docs/staging-environment/}
# newAccount  : https://acme-staging-v02.api.letsencrypt.org/acme/new-acct
# newNonce    : https://acme-staging-v02.api.letsencrypt.org/acme/new-nonce
# newOrder    : https://acme-staging-v02.api.letsencrypt.org/acme/new-order
# revokeCert  : https://acme-staging-v02.api.letsencrypt.org/acme/revoke-cert

# Setup variables mapped to urls from response

$keyChangeUrl   = $a.keyChange
$newAccountUrl  = $a.newAccount
$newNonceUrl    = $a.newNonce
$newOrderUrl    = $a.newOrder
$revokeCertUrl  = $a.revokeCert

# No newAuthzUrl 
# According to docs
# If the ACME server does not implement pre-authorization (Section 7.4.1), it MUST omit the "newAuthz" field of the directory.
#$newAuthzUrl    = $a.

$b = Invoke-RestMethod -Headers $headers -Uri $a.newNonce -Method Head

$r = Invoke-WebRequest -Headers $headers -Uri $a.newNonce -Method Head
$r.Headers["Replay-Nonce"]




# The following table illustrates a typical sequence of requests required to 
# 1.  establish a new account with the server, 
# 2.  prove control of an identifier, 
# 3.  issue a certificate, and 
# 4.  fetch an updated certificate some time after issuance.  
# The "->" is a mnemonic for a Location header field pointing to a created resource.


# The object MAY additionally contain a "meta" field.  
# If present, it MUST be a JSON object; 
# each field in the object is an item of metadata relating to the service provided by the ACME server.


