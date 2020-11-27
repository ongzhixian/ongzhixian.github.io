param (
    # [string]$message,
    [System.Net.HttpListenerRequest] $req,
    [System.Net.HttpListenerResponse] $resp
)

try {
    Write-Host "In Test handler"

    # Convert form data to hashtable

    $inputData = Convert-ToHashTable $req

    # Debug: Display input data
    $inputData

    $wwwroot

    # Do some processing here
    # ...
    if (($inputData["login_company"] -eq "zx") -and ($inputData["login_username"] -eq "zx") -and ($inputData["login_password"] -eq "zx"))
    {
        # Send positive reply
        $reply = "200 - Valid user."
        
        # Redirect to index.html
        $localPath = Join-Path (Get-Location).Path "index.html"

        # Add cookies https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
        $resp.AddHeader("Set-Cookie", "auth=value1hashcode; HttpOnly");
        $resp.AppendHeader("Set-Cookie", "roles=value2, value3, value4");

        # Send file
        SendFile $resp $localPath



        # Redirect $localPath

        # $ext = [System.IO.Path]::GetExtension($localPath)
        # $mimeType = GetMimeType($ext)

        # $data = Get-Content $localPath -AsByteStream -ReadCount 0
        # if ($null -eq $data) { # If file is empty, send a single character 'space' byte array
        #     $data = $spaceByteArray
        # }

        # Send $resp $data -contentType $mimeType
        Write-Host "Requesting: $($req.Url.AbsolutePath) ==> $localPath (200 $mimeType)"
    }
    else {
        
        # Send negative reply
        # Get-Content C:\src\github.com\ongzhixian\ongzhixian.github.io\LeaveSys\login.html -AsByteStream -ReadCount 0
        # C:\src\github.com\ongzhixian\ongzhixian.github.io\LeaveSys\login.html
        $reply = "200 - Invalid user."
    }

    # Send some reply here

    $data = [System.Text.Encoding]::UTF8.GetBytes($reply)
    Send $resp $data
    Write-Host "Test handler reply: [$reply]"
    #Write-Host "Requesting: $($req.Url.AbsolutePath) ==> $localPath (200 POST)"

    # 
    Get-Location
    $wwwroot
    $reply
}
catch {
    
}
finally {
    
}
