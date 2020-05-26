# Script to send messages to a server
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
[System.Net.IPEndPoint]             $ipEndpoint = $null
[System.Net.Sockets.TcpClient]      $tcpClient  = $null
[byte[]]                            $buffer     = $null
[System.Net.Sockets.NetworkStream]  $stream     = $null

# Parameters checking
if (-not [System.Net.IPAddress]::TryParse($ipString, [ref] $ipAddr))
{
    Write-Host "Invalid IP Address"
    return
}

Write-Host "Do work"

try {
    $ipEndpoint = [System.Net.IPEndPoint]::new($ipAddr, $ipPort)
    
    $tcpClient  = [System.Net.Sockets.TcpClient]::new()
    $messageId = 0
    $tcpClient.Connect($ipEndpoint)
    $stream = $tcpClient.GetStream()

    while ($true) 
    {
        $messageId = $messageId + 1
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("Sending message $messageId");

        try {
            Write-Host "Sending message $messageId"
            $stream.Write($buffer, 0, $buffer.Length)
        }
        catch [System.Management.Automation.MethodInvocationException] {
            
            $ex = $_.Exception
            if (($null -ne $ex) -and ($null -ne $ex.InnerException) -and ($ex.InnerException -is [System.IO.IOException])) 
            {
                [System.IO.IOException]$ioEx = $ex.InnerException
                if (($null -ne $ioEx.InnerException) -and ($ioEx.InnerException -is [System.Net.Sockets.SocketException]))
                {

                    [System.Net.Sockets.SocketException]$skEx = $ioEx.InnerException
                    Write-Host "Connection dropped -- $($skEx.SocketErrorCode) ($($skEx.ErrorCode))`n$($skEx.Message)"
                    break

                    # Sample messages:
                    
                    # 1) We would get this message if the port connection was closed at server while attempting to write
                    # [System.Net.Sockets.SocketException] -- ConnectionAborted (10053)
                    # An established connection was aborted by the software in your host machine.
                }
            }
            else {
                throw
            }
        }
        catch {
            throw
        }
        finally {
            
        }
        
        Start-Sleep -Seconds 1
    }
}
catch {
    Write-Error "Cannot connect to $($ipAddr):$ipPort"
    Write-Error $_.Exception
    return
}
finally {
    # close everything.
    $stream.Close()
    $tcpClient.Close()
}