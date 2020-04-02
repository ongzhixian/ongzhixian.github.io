# .NET HTTP Server

param (
    [ushort]$port = 2194 # Ports 2194-2196 are unassigned in IANA Service Name and Transport Protocol Port Number Registry
    , [switch]$Debug = $false
)

# Start-of-script
if ($Debug) {
    $DebugPreference = 'Continue'           # Start - display debug messages
}

# Local variables declaration
[System.Net.HttpListener] $server = $null
[string] $prefix = [string]::Empty
[bool] $runServer = $false

# Local variables initialization
$prefix = "http://127.0.0.1:$port/"         # 127.0.0.1 is fairly universal
$server = New-Object -TypeName System.Net.HttpListener
$server.Prefixes.Add($prefix)
Write-Debug "`$prefix        is $prefix" 

try {
    
    $server.Start()
    Write-Host "Server started."

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

        if (($req.HttpMethod -eq "GET") && ($req.Url.AbsolutePath -eq "/shutdown"))
        {
            #Console.WriteLine("Shutdown requested");
            $runServer = false;
            continue;
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
