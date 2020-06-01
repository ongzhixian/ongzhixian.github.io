# Overview

Flow:

1.  Get authorization code
2.  Exchange code for access token



## Getting authorization code

// Line breaks for legibility only

POST /common/oauth2/v2.0/token HTTP/1.1
Host: https://login.microsoftonline.com
Content-Type: application/x-www-form-urlencoded

client_id=6731de76-14a6-49ae-97bc-6eba6914391e
&scope=user.read%20mail.read
&code=OAAABAAAAiL9Kn2Z27UubvWFPbm0gLWQJVzCTE9UkP3pSx1aXxUjq3n8b2JRLk4OxVXr...
&redirect_uri=http%3A%2F%2Flocalhost%2Fmyapp%2F
&grant_type=authorization_code
&client_secret=JqQX2PNo9bpM0uEihUPzyrh    // NOTE: Only required for web apps

## Exchange auth code for access code

access_token    -- The requested access token. The app can use this token to authenticate to the secured resource, such as a web API.
refresh_token   -- An OAuth 2.0 refresh token. The app can use this token acquire additional access tokens after the current access token expires.
id_token        -- A JSON Web Token (JWT). The app can decode the segments of this token to request information about the user who signed in. 
                   The app can cache the values and display them, but it should not rely on them for any authorization or security boundaries.
expires_in      -- How long the access token is valid (in seconds).


ZX: Use access tokens

## Sample access token:

EwAoA8l6BAAU7p9QDpi/D7xJLwsTgCg3TskyTaQAAXu71AU9f4aS4rOK5xoO/SU5HZKSXtCsDe0Pj7uSc5Ug008qTI+a9M1tBeKoTs7tHzhJNSKgk7pm5e8d3oGWXX5shyOG3cKSqgfwuNDnmmPDNDivwmi9kmKqWIC9OQRf8InpYXH7NdUYNwN+jljffvNTewdZz42VPrvqoMH7hSxiG7A1h8leOv4F3Ek/oeJX6U8nnL9nJ5pHLVuPWD0aNnTPTJD8Y4oQTp5zLhDIIfaJCaGcQperULVF7K6yX8MhHxIBwek418rKIp11om0SWBXOYSGOM0rNNN59qNiKwLNK+MPUf7ObcRBN5I5vg8jB7IMoz66jrNmT2uiWCyI8MmYDZgAACPoaZ9REyqke+AE1/x1ZX0w7OamUexKF8YGZiw+cDpT/BP1GsONnwI4a8M7HsBtDgZPRd6/Hfqlq3HE2xLuhYX8bAc1MUr0gP9KuH6HDQNlIV4KaRZWxyRo1wmKHOF5G5wTHrtxg8tnXylMc1PKOtaXIU4JJZ1l4x/7FwhPmg9M86PBPWr5zwUj2CVXC7wWlL/6M89Mlh8yXESMO3AIuAmEMKjqauPrgi9hAdI2oqnLZWCRL9gcHBida1y0DTXQhcwMv1ORrk65VFHtVgYAegrxu3NDoJiDyVaPZxDwTYRGjPII3va8GALAMVy5xou2ikzRvJjW7Gm3XoaqJCTCExN4m5i/Dqc81Gr4uT7OaeypYTUjnwCh7aMhsOTDJehefzjXhlkn//2eik+NivKx/BTJBEdT6MR97Wh/ns/VcK7QTmbjwbU2cwLngT7Ylq+uzhx54R9JMaSLhnw+/nIrcVkG77Hi3neShKeZmnl5DC9PuwIbtNvVge3Q+V0ws2zsL3z7ndz4tTMYFdvR/XbrnbEErTDLWrV6Lc3JHQMs0bYUyTBg5dThwCiuZ1evaT6BlMMLuSCVxdBGzXTBcvGwihFzZbyNoX+52DS5x+RbIEvd6KWOpQ6Ni+1GAawHDdNUiQTQFXRxLSHfc9fh7hE4qcD7PqHGsykYj7A0XqHCjbKKgWSkcAg==


## Sample call using token:

GET https://graph.microsoft.com/v1.0/me/ HTTP/1.1
Host: graph.microsoft.com
Authorization: Bearer EwAoA8l6BAAU ... 7PqHGsykYj7A0XqHCjbKKgWSkcAg==







# Side notes

## Applicaiton registration

Before your app can get a token from the Microsoft identity platform, it must be registered in the Azure portal. 
Registration integrates your app with the Microsoft identity platform and establishes the information that it uses to get tokens, including:

1.  Application ID: 
    A unique identifier assigned by the Microsoft identity platform.

2.  Redirect URI/URL: 
    One or more endpoints at which your app will receive responses from the Microsoft identity platform. 
    (For native and mobile apps, this is a URI assigned by the Microsoft identity platform.)

3.  Application Secret: 
    A password or a public/private key pair that your app uses to authenticate with the Microsoft identity platform. 
    (Not needed for native or mobile apps.)

Microsoft Graph has two types of permissions:

Delegated permissions are 
    used by apps that have a signed-in user present. 
    For these apps, either the user or an administrator consents to the permissions 
    that the app requests and the app can act as the signed-in user when making calls to Microsoft Graph. 
    Some delegated permissions can be consented by non-administrative users, but some higher-privileged permissions require administrator consent.

Application permissions are 
    used by apps that run without a signed-in user present; 
    for example, apps that run as background services or daemons. Application permissions can only be consented by an administrator.

Note By default, apps that have been granted application permissions to the following data sets can access all the mailboxes in the organization:

Calendars
Contacts
Mail
Mailbox settings


# Links
https://developer.microsoft.com/en-us/graph/graph-explorer
https://apps.dev.microsoft.com/



Built-in
https://login.microsoftonline.com/common/oauth2/nativeclient
urn:ietf:wg:oauth:2.0:oob


2 authentication endpoints (Office API)
https://login.microsoftonline.com/common/oauth2/v2.0/authorize
https://login.microsoftonline.com/common/oauth2/v2.0/token


Graph (corresponding for MS Graph)
https://login.microsoftonline.com /$tenant_id/oauth2/v2.0/authorize
https://login.microsoftonline.com /$tenant_id/oauth2/v2.0/token"


https://www.c-sharpcorner.com/blogs/manage-outlook-tasks-using-microsoft-graph


Careful
https://oauthplay.azurewebsites.net/?code=M657b8bab-e543-f849-134c-0a2f85179a67&state=17661047-2a14-4c90-9edd-0119f841b559


https://docs.microsoft.com/en-us/graph/permissions-reference#microsoft-accounts-and-work-or-school-accounts

https://docs.microsoft.com/en-us/graph/api/outlooktaskfolder-list-tasks?view=graph-rest-beta&tabs=http


OData (https://docs.microsoft.com/en-us/graph/query-parameters)
On the beta endpoint, the $ prefix is optional. 
For example, instead of $filter, you can use filter. 
On the v1 endpoint, the $ prefix is optional for only a subset of APIs.
For simplicity, always include $ if using the v1 endpoint.

Examples:
GET https://graph.microsoft.com/v1.0/users?$filter=startswith(givenName, 'J')   # Bad - not properly encoded
GET https://graph.microsoft.com/v1.0/users?$filter=startswith(givenName%2C+'J') # Correct

https://graph.microsoft.com/v1.0/me/contacts?$count=true

https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ee692794(v=technet.10)?redirectedfrom=MSDN


$a =    @{Expression={$_.Name}              ; Label="Process Name"  ; width=25}, 
        @{Expression={$_.ID}                ; Label="Process ID"    ; width=15}, 
        @{Expression={$_.MainWindowTitle}   ; Label="Window Title"  ; width=40}

$fmt = @{Expression={"{0:o}" -f $_.CreatedDateTime} ; Label="Created DateTime"  ; width=28}, @{Expression={$_.Subject} ; Label="Subject"  ; width=25}

1234567890123456789012345678 -- 28 characters
2019-11-28T15:46:55.5626237Z

$a.value | Format-Table $fmt

Subject                   Created DateTime
-------                   ----------------
Tensorflow                11/28/2019 3:46:55 PM
Pandas                    11/28/2019 3:46:55 PM
Flask                     11/28/2019 3:46:55 PM
Ice                       11/28/2019 3:46:55 PM
Django                    11/28/2019 3:46:55 PM
Numpy                     11/28/2019 3:46:55 PM
ASX                       11/28/2019 3:46:25 PM
Sgx                       11/28/2019 3:46:25 PM
Google keep               11/28/2019 3:46:22 PM
Microsoft todos           11/28/2019 3:46:22 PM