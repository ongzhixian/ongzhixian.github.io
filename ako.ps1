# .NET HTTP Server

param (
    [ushort]$port = 2194 # Ports 2194-2196 are unassigned in IANA Service Name and Transport Protocol Port Number Registry
    , [switch]$Debug = $false
)

# Start-of-script
if ($Debug) {
    $DebugPreference = 'Continue'           # Start - display debug messages
}

# Set Window title
# (Get-Host).UI.RawUI.WindowTitle = "PS"

# Local variables declaration
[System.Net.HttpListener] $server = $null
[string] $prefix = [string]::Empty
[bool] $runServer = $false
[string] $rootPath

# Local functions declaration
Function Send
{
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

Function GetMimeType
{
    param (
        [parameter(Mandatory)][string]$extension
    )

    $ext = $extension.ToLower()
    switch ($ext)
    {
        ".css"  { "text/css"; Break}
        ".csv"  { "text/csv"; Break}
        ".html" { [System.Net.Mime.MediaTypeNames+Text]::Html; Break}
        ".htm"  { [System.Net.Mime.MediaTypeNames+Text]::Html; Break}
        ".js"   { "text/javascript"; Break}
        ".rtf"  { [System.Net.Mime.MediaTypeNames+Text]::RichText; Break}
        ".str"  { [System.Net.Mime.MediaTypeNames+Text]::Html; Break}
        ".txt"  { [System.Net.Mime.MediaTypeNames+Text]::Plain; Break}
        ".xhtml" { "application/xhtml+xml"; Break}
        ".xml"  { [System.Net.Mime.MediaTypeNames+Text]::Xml; Break}

        ".gif"  { [System.Net.Mime.MediaTypeNames+Image]::Gif; Break}
        ".ico"  { "image/vnd.microsoft.icon"; Break}
        ".jpg"  { [System.Net.Mime.MediaTypeNames+Image]::Jpeg; Break}
        ".jpeg" { [System.Net.Mime.MediaTypeNames+Image]::Jpeg; Break}
        ".png"  { "image/png"; Break}
        ".svg"  { "image/svg+xml"; Break}
        ".tiff" { [System.Net.Mime.MediaTypeNames+Image]::Tiff; Break}
        ".tif"  { [System.Net.Mime.MediaTypeNames+Image]::Tiff; Break}

        ".gz"   { "application/gzip"; Break}
        ".json" { "application/json"; Break}
        ".pdf"  { "application/pdf"; Break}
        ".zip"  { [System.Net.Mime.MediaTypeNames+Application]::Zip; Break}

        ".ttf"  { "font/ttf"; Break}

        default { [System.Net.Mime.MediaTypeNames+Application]::Octet; Break}
    }

    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
    # System.Net.Mime.MediaTypeNames.Application.Octet
    # System.Net.Mime.MediaTypeNames.Application.Pdf
    # System.Net.Mime.MediaTypeNames.Application.Rtf
    # System.Net.Mime.MediaTypeNames.Application.Soap
    # System.Net.Mime.MediaTypeNames.Application.Zip
}

# Local variables initialization
$rootPath = Get-Location | ForEach-Object { $_.Path }
$prefix = "http://127.0.0.1:$port/"         # 127.0.0.1 is fairly universal
$server = New-Object -TypeName System.Net.HttpListener
$server.Prefixes.Add($prefix)
Write-Debug "`$prefix        is $prefix" 

try {
    
    $server.Start()
    Write-Host "Server started.`nAccess server at: $prefix"

    $runServer = $true
    while ($runServer)
    {
        # Block until we get a request connection
        # ZX: This unfortuntately also blocks CTRL+C termination of PowerShell
        Write-Host "Waiting for request"
        $ctx = $server.GetContext()
        
        # Get corresponding requests and response objects
        [System.Net.HttpListenerRequest] $req = $ctx.Request
        [System.Net.HttpListenerResponse] $resp = $null;

        if (($req.HttpMethod -eq "GET") -and ($req.Url.AbsolutePath -eq "/shutdown"))
        {
            #Console.WriteLine("Shutdown requested");
            $runServer = false;
            continue;
        }
        
        $localPath = "$rootPath$($req.Url.AbsolutePath.Replace('/', [System.IO.Path]::DirectorySeparatorChar))"

        if ([System.IO.File]::Exists($localPath))
        {
            $ext = [System.IO.Path]::GetExtension($localPath)

            $mimeType = GetMimeType($ext)

            if ($ext -eq ".str")
            {
                $tmpl = Get-Content $localPath -Encoding UTF8 -ReadCount 0
                $text = $ExecutionContext.InvokeCommand.ExpandString($tmpl)
                $data = [System.Text.Encoding]::UTF8.GetBytes($text)
            }
            else 
            {
                $data = Get-Content $localPath -AsByteStream -ReadCount 0
            }
            
            #$data = [System.Text.Encoding]::UTF8.GetBytes("File found.")
            Send $ctx.Response $data -contentType $mimeType
            Write-Host "Requesting: $($req.Url.AbsolutePath) ==> $localPath (200 $mimeType)"
        }
        else
        {
            $data = [System.Text.Encoding]::UTF8.GetBytes("404 - Resource not found.")
            Send $ctx.Response $data -statusCode 404
            Write-Host "Requesting: $($req.Url.AbsolutePath) ==> $localPath (404 $mimeType )"
        }
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
