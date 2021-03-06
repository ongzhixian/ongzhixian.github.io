<#
 .Synopsis
  Start a HTTP server to host a web site.

 .Description
  Start a HTTP web server to host a web site.

 .Parameter Port
  The port that HTTP server will use to host the web site.
  Defaults to 2194

#   .Parameter Host
#   The host that HTTP server will use to host the web site.
#   Defaults to localhost

#  .Parameter Wwwroot
#   The directory to use as root directory to serve files from.
#   Defaults to the folder that command was executed from.

 .Example
   # Start HTTP server to host web site using default settings
   Start-WebHost

#  .Example
#    # Display a date range.
#    Show-Calendar -Start "March, 2010" -End "May, 2010"

#  .Example
#    # Highlight a range of days.
#    Show-Calendar -HighlightDay (1..10 + 22) -HighlightDate "December 25, 2008"
#>

Function Send {
    param (
        [parameter(Mandatory)][System.Net.HttpListenerResponse]$resp,
        [parameter(Mandatory)][byte[]]$data,
        [string]$contentType = [System.Net.Mime.MediaTypeNames+Text]::Html,
        [System.Text.Encoding]$contentEncoding = [System.Text.Encoding]::UTF8,
        [int]$statusCode = 200
    )

    try {
        $resp.StatusCode = $statusCode
        $resp.ContentType = $contentType
        $resp.ContentEncoding = $contentEncoding
        $resp.OutputStream.Write($data, 0, $data.Length)
    }
    catch {
        Write-Error $_
    }
    finally {
        $resp.Close()
    }
}

Function GetMimeType {
    param (
        [parameter(Mandatory)][string]$extension
    )

    $ext = $extension.ToLower()
    switch ($ext) {
        ".css" { "text/css"; Break }
        ".csv" { "text/csv"; Break }
        ".html" { [System.Net.Mime.MediaTypeNames+Text]::Html; Break }
        ".htm" { [System.Net.Mime.MediaTypeNames+Text]::Html; Break }
        ".js" { "text/javascript"; Break }
        ".rtf" { [System.Net.Mime.MediaTypeNames+Text]::RichText; Break }
        ".str" { [System.Net.Mime.MediaTypeNames+Text]::Html; Break }
        ".txt" { [System.Net.Mime.MediaTypeNames+Text]::Plain; Break }
        ".xhtml" { "application/xhtml+xml"; Break }
        ".xml" { [System.Net.Mime.MediaTypeNames+Text]::Xml; Break }

        ".gif" { [System.Net.Mime.MediaTypeNames+Image]::Gif; Break }
        ".ico" { "image/vnd.microsoft.icon"; Break }
        ".jpg" { [System.Net.Mime.MediaTypeNames+Image]::Jpeg; Break }
        ".jpeg" { [System.Net.Mime.MediaTypeNames+Image]::Jpeg; Break }
        ".png" { "image/png"; Break }
        ".svg" { "image/svg+xml"; Break }
        ".tiff" { [System.Net.Mime.MediaTypeNames+Image]::Tiff; Break }
        ".tif" { [System.Net.Mime.MediaTypeNames+Image]::Tiff; Break }

        ".gz" { "application/gzip"; Break }
        ".json" { "application/json"; Break }
        ".pdf" { "application/pdf"; Break }
        ".zip" { [System.Net.Mime.MediaTypeNames+Application]::Zip; Break }

        ".ttf" { "font/ttf"; Break }

        default { [System.Net.Mime.MediaTypeNames+Application]::Octet; Break }
    }

    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
    # System.Net.Mime.MediaTypeNames.Application.Octet
    # System.Net.Mime.MediaTypeNames.Application.Pdf
    # System.Net.Mime.MediaTypeNames.Application.Rtf
    # System.Net.Mime.MediaTypeNames.Application.Soap
    # System.Net.Mime.MediaTypeNames.Application.Zip
}

Function Log {
    param (
        [parameter(Mandatory)][string]$message,
        [string]$filePath = "webhost.log",
        [string]$dateTimeFormat = "u"
    )

    "$((Get-Date).ToString($dateTimeFormat)) $message" | Out-File -FilePath $filePath -Append
}

Function Convert-ToHashTable
{
    param (
        [System.Net.HttpListenerRequest] $req
    )

    try {
        [System.IO.StreamReader] $sr = New-Object -TypeName System.IO.StreamReader -ArgumentList $req.InputStream, $req.ContentEncoding
        $inputString = $sr.ReadToEnd()
        $inputString = $inputString.Replace('&', [System.Environment]::NewLine)
        $data = ConvertFrom-StringData $inputString
        return $data # System.Collections.Hashtable
    }
    catch {              
        Write-Error $_      
    }
    finally {
        if ($null -ne $sr)
        {
            $sr.Close()
        }
    }
}

Function SendFile
{
    param
    (
        [System.Net.HttpListenerResponse]$resp,
        [string]$localPath
    )

    $ext = [System.IO.Path]::GetExtension($localPath)
    $mimeType = GetMimeType($ext)

    $data = Get-Content $localPath -AsByteStream -ReadCount 0
  
    # If file is empty, send a single character 'space' byte array
    if ($null -eq $data) {
        $data = $spaceByteArray
    }

    Send $resp $data -contentType $mimeType
}

Function Start-WebHost {
    param
    (
        [ushort]$port = 2194 # Ports 2194-2196 are unassigned in IANA Service Name and Transport Protocol Port Number Registry
    )

    # Constants
    Set-Variable spaceByteArray -Option Constant -Value ([System.Text.Encoding]::UTF8.GetBytes(" "))
    Set-Variable waitTime -Option Constant -Value (New-Object -TypeName System.TimeSpan -ArgumentList 0, 0, 0, 1, 678)

    # Local variables
    # $waitTime = New-Object -TypeName System.TimeSpan -ArgumentList 0,0,0,1,678
    $rootPath = (Get-Location).Path
    $prefix = "http://127.0.0.1:$port/"         # 127.0.0.1 is fairly universal
    $server = New-Object -TypeName System.Net.HttpListener
    $server.Prefixes.Add($prefix)
    Write-Debug "`$prefix        is $prefix"

    $reqDateTime = "$((Get-Date).ToString("yyyyMMddHHmm"))"
    $reqNum = 0

    if ($Debug) {
        $DebugPreference = 'Continue'           # Start - display debug messages
    }
  
    try {
        $server.Start()
        Write-Host "Server started.`nAccess server at: $prefix"

        while ($true) {
            # The synchronous version of GetContext will block until we get a request connection
            # This unfortuntately also blocks CTRL+C termination of PowerShell 
            # This is a behaviour which we do not want.
            # So we use the asynchronous version.
            Write-Host "Waiting for request"
            $ctxTask = $server.GetContextAsync()
  
            # Instead of directly busy spin, we add a blocking wait call
            while (-not $ctxTask.IsCompleted) {
                [void]$ctxTask.Wait($waitTime)
            }
  
            $ctx = $ctxTask.Result # System.Net.HttpListenerContext

            if ($reqDateTime -eq "$((Get-Date).ToString("yyyyMMddHHmm"))")
            {
                $reqNum = $reqNum + 1
                $reqId = "$($reqDateTime)-$($reqNum)"
            }
            else {
                # Reset
                $reqDateTime = "$((Get-Date).ToString("yyyyMMddHHmm"))"
                $reqNum = 0
            }

            "reqId is [$reqId]"
  
            # Get corresponding requests and response objects
            [System.Net.HttpListenerRequest] $req = $ctx.Request
            [System.Net.HttpListenerResponse] $resp = $ctx.Response;

            # foreach ($cookie in $req.Cookies) {
            #     "Cookie $($cookie.Name)=$($cookie.Value)"
            # }
            # $a = $req.Cookies["aasd"]
            # "aasd is $($null -eq $a)"
            # $a = $req.Cookies["auth"]
            # "auth is $($null -eq $a)"

            # Code for checking for authentication cookie
            # $authCookie = $req.Cookies["auth"]
            # if ($null -eq $authCookie)
            # {
            #     try {
            #         # Redirect to log in page
            #         $localPath = Join-Path (Get-Location).Path "index.html"
            #         SendFile $resp $localPath
            #     }
            #     catch {              
            #         Write-Error $_      
            #     }
            #     finally {
            #         $resp.Close()
            #         $ctxTask.Dispose()                    
            #     }
            #     continue
            # } else {
            #     # Check value of cookie before deciding whether value in authentication cookie is valid
            #     $inRole = $true
            #     if (-note $inRole)
            #     {
            #         try {
            #             # Redirect to log in page
            #             $localPath = Join-Path (Get-Location).Path "index.html"
            #             SendFile $resp $localPath
            #         }
            #         catch {              
            #             Write-Error $_      
            #         }
            #         finally {
            #             $resp.Close()
            #             $ctxTask.Dispose()                    
            #         }
            #         continue
            #     }
            # }
            

            # Resolve request into local path
            $localPath = "$rootPath$($req.Url.AbsolutePath.Replace('/', [System.IO.Path]::DirectorySeparatorChar))"

            if ("POST" -eq $req.HttpMethod) 
            {
                Write-Host "In POST block"
                # Some handling for a HTTP POST
                # How? I don't know. 🤷‍♀️
                #$req

                #   UrlReferrer            : http://localhost:2194/res/testform.html
                #   Url                    : http://localhost:2194/res/test
                #$req.Cookies
                #$req.Headers

                #$req.HasEntityBody  # true
                # System.IO.StreamReader reader = new System.IO.StreamReader(body, encoding);
                # if (request.ContentType != null)
                # {
                #     Console.WriteLine("Client data content type {0}", request.ContentType);
                # }

                try {

                    
                    # TODO: Check if $localPath exists
                    if ([System.IO.File]::Exists($localPath)) {

                        $scriptResult = & $localPath $req $resp

                        # Debug
                        if ($null -eq $scriptResult)
                        {
                            Write-Host "Script result is null."
                        }
                        else {
                            Write-Host "Script result of type is $($scriptResult.GetType().ToString())"
                            $scriptResult
                        }
                    }
                    else {

                        [System.IO.StreamReader] $sr = New-Object -TypeName System.IO.StreamReader -ArgumentList $req.InputStream, $req.ContentEncoding
                        $postDataString = $sr.ReadToEnd()
                        $postDataString
                        $postHereString = $postDataString.Replace('&', [System.Environment]::NewLine)
                        $postData = ConvertFrom-StringData $postHereString
                        $postData
                        # $postData.GetType().ToString() # System.Collections.Hashtable

                        $data = [System.Text.Encoding]::UTF8.GetBytes("404 - Resource not found.")
                        Send $resp $data -statusCode 404
                        Write-Host "Requesting: $($req.Url.AbsolutePath) ==> $localPath (404 $mimeType)"
                    }

                }
                catch {              
                    Write-Error $_      
                }
                finally {
                    $resp.Close()
                    $ctxTask.Dispose()                    
                }

                continue
            }
  
            if ([System.IO.File]::Exists($localPath)) {
                # $ext = [System.IO.Path]::GetExtension($localPath)
                # $mimeType = GetMimeType($ext)
  
                # $data = Get-Content $localPath -AsByteStream -ReadCount 0
              
                # # If file is empty, send a single character 'space' byte array
                # if ($null -eq $data) {
                #     $data = $spaceByteArray
                # }

                # Send $resp $data -contentType $mimeType

                SendFile $resp $localPath

                Write-Host "Requesting: $($req.Url.AbsolutePath) ==> $localPath (200 $mimeType)"
            }
            else {
                $data = [System.Text.Encoding]::UTF8.GetBytes("404 - Resource not found.")
                Send $resp $data -statusCode 404
                Write-Host "Requesting: $($req.Url.AbsolutePath) ==> $localPath (404 $mimeType)"
            }
  
            # Dispose
            $ctxTask.Dispose()
        }

    }
    catch {
        Write-Error $_
    }
    finally {
        $server.Stop()
        Write-Host "Server stopped."
    }

    # End-of-script
    if ($Debug) {
        $DebugPreference = 'SilentlyContinue'   # End   - display debug messages
    }
}

# Module member export definitions
#Export-ModuleMember -Function Start-WebHost
Start-WebHost 3194