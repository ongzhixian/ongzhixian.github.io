param (
    [Parameter(Mandatory)]
    [string] $ipString = $null,
    [Parameter(Mandatory)] 
    [ushort] $ipPort = $null
)

Write-Host "ipString:   $ipString"
Write-Host "ipPort:     $ipPort"

# Local variables
[System.Net.IPAddress]              $ipAddr     = $null
[System.Net.Sockets.TcpListener]    $tcpServer  = $null
[System.Net.Sockets.TcpClient]      $tcpClient  = $null
[byte[]]                            $buffer     = New-Object byte[] 256
[System.Net.Sockets.NetworkStream]  $stream     = $null
[int]                               $bytesRead  = 0
[string]                            $dataString = $null

# Parameters checking
if (-not [System.Net.IPAddress]::TryParse($ipString, [ref] $ipAddr))
{
    Write-Host "Invalid IP Address"
    return
}

# Functions

# N/A

# Main script

Write-Host "Do work"

try {
    $tcpServer = [System.Net.Sockets.TcpListener]::new($ipAddr, $ipPort)
    $tcpServer.Start()
}
catch {
    Write-Error "Cannot start server on $($ipAddr):$ipPort"
    #Write-Error $_.Exception
    return
}

# Wait for clients to connect and handle client
try {

    while ($true)
    {
        
        $tcpClient = $tcpServer.AcceptTcpClient()
        Write-Host "Connected"
    
        try {
            $stream = $tcpClient.GetStream()
    
            # Loop to receive all the data sent by the client.
            while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -ne 0)
            {
                $dataString = [System.Text.Encoding]::UTF8.GetString($buffer, 0, $bytesRead)
        
                [byte[]] $responseMessage = [System.Text.Encoding]::UTF8.GetBytes($dataString.ToUpper())
                $stream.Write($responseMessage, 0, $responseMessage.Length)
                Write-Host "Sent[$($responseMessage.Length)]: $responseMessage"
            }
        }
        # catch [System.Net.WebException],[System.IO.IOException] {}
        catch [System.Net.Sockets.SocketException], [System.IO.IOException], [System.Management.Automation.MethodInvocationException] {
            if (($_.Exception -ne $null) -and ($_.Exception.InnerException -ne $null))
            {
                #Write-Error "Client socket ka-booom"
                #Write-Error $_.Exception.InnerException 
                if ($_.Exception.InnerException -is [System.Net.Sockets.SocketException])
                {
                    [System.Net.Sockets.SocketException]$e = $_.Exception.InnerException
                    if ($e.SocketErrorCode -eq [System.Net.Sockets.SocketError]::ConnectionAborted) {
                        # Probably means client dropped
                        Write-Host "Connection dropped."
                    }
                    else 
                    {
                        Write-Host $e
                        Write-Host $e.SocketErrorCode   # ConnectionAborted
                        Write-Host $e.ErrorCode         # 10053
                        Write-Host $e.NativeErrorCode   # 10053
                        Write-Host $e.Message           # An established connection was aborted by the software in your host machine
                    }
                }
            }
            else {
                throw
            }
            
        }
        catch {
            Write-Error "Client ka-booom"
            Write-Error $_.Exception
        }
        finally {
            $tcpClient.Close()
        }

    }
}
catch {
    Write-Error "Server ka-booom"
    Write-Error $_.Exception
    return
}
finally {
    $tcpServer.Stop()

}

Write-Host "End-of-script"