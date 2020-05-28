# Google Tasks API client
$bearerToken = $null

if ($null -eq $bearerToken) {

}

# Invoke-RestMethod -Uri "https://accounts.google.com/o/oauth2/v2/auth?
# scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ftasks+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ftasks.readonly

# &state=123
# &client_id=980914380422-67950b9niqj855smjd5jgk61e5770e82.apps.googleusercontent.com


# &access_type=offline
# &include_granted_scopes=true
# &response_type=code
# &redirect_uri=oob"


# Invoke-RestMethod -Uri "https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ftasks+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ftasks.readonly&access_type=offline&include_granted_scopes=true&response_type=code&state=123&client_id=980914380422-67950b9niqj855smjd5jgk61e5770e82.apps.googleusercontent.com&redirect_uri=oob"

$c = @{
    access_type="offline";
    response_type="code";
    include_granted_scopes="true";
    redirect_uri="oob";
    client_id="980914380422-67950b9niqj855smjd5jgk61e5770e82.apps.googleusercontent.com";
    scope="https://www.googleapis.com/auth/tasks https://www.googleapis.com/auth/tasks.readonly";
    state="123"
}

#$c

# Main script

# Convert dictionary to querystring

$qs = "?"
foreach ($key in $c.Keys) {
    $qs = $qs + "$($key)=$([Uri]::EscapeDataString($c[$key]))&" 
}

$final = "https://accounts.google.com/o/oauth2/v2/auth$qs"
$final

start $final