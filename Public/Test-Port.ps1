function Test-Port {
    [CmdletBinding()]
    Param(
        [string] $Server,
        [int[]] $Ports = 135,
        [int] $Timeout = 1000
    )
    foreach ($Port in $Ports) {
        #Write-Verbose "Test-Port - $Server`:$Port Start"
        $TcpClient = New-Object system.Net.Sockets.TcpClient
        $iar = $TcpClient.BeginConnect($server, $port, $null, $null)
        # Set the wait time
        $wait = $iar.AsyncWaitHandle.WaitOne($timeout, $false)
        # Check to see if the connection is done
        if (!$wait) {
            # Close the connection and report timeout
            $TcpClient.Close()
            Write-Verbose "Test-Port - $Server`:$Port Connection Timeout"
            return $false
        } else {
            # Close the connection and report the error if there is one
            $error.Clear()
            $TcpClient.EndConnect($iar) | Out-Null
            if (!$?) {
                if ($verbose) {
                    Write-Verbose "Test-Port - $Server`:$Port Error: $($error[0])"
                }
                $failed = $true
            }

            $TcpClient.Close()
        }
        if ($failed) { break }
    }
    #Write-Verbose "Test-Port - $Server`:$Port End"
    # Return $true if connection Establish else $False
    if ($failed) {
        return $false
    } else {
        return $true
    }
}