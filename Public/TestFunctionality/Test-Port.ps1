function Test-Port {
    [CmdletBinding()]
    Param(
        [string] $Server,
        [int[]] $Ports = 135,
        [int] $TimeOut = 1000
    )
    foreach ($Port in $Ports) {
        #Write-Verbose "Test-Port - $Server`:$Port Start"
        $TcpClient = New-Object system.Net.Sockets.TcpClient
        $iar = $TcpClient.BeginConnect($server, $port, $null, $null)
        # Set the Wait time
        $Wait = $iar.AsyncWaitHandle.WaitOne($TimeOut, $false)
        # Check to see if the connection is done
        if (!$Wait) {
            # Close the connection and report TimeOut
            $TcpClient.Close()
            Write-Verbose "Test-Port - $Server`:$Port Connection TimeOut"
            return $false
        } else {
            # Close the connection and report the error if there is one
            $error.Clear()
            $TcpClient.EndConnect($iar) | Out-Null
            if (!$?) {
                Write-Verbose "Test-Port - $Server`:$Port Error: $($error[0])"
                $Failed = $true
            }
            $TcpClient.Close()
        }
        if ($Failed) { break }
    }
    if ($Failed) {
        return $false # Failed on all or just one of tested ports
    } else {
        return $true # Established
    }
}