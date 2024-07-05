function Test-ComputerPort {
    <#
    .SYNOPSIS
    Tests the connectivity of a computer on specified TCP and UDP ports.

    .DESCRIPTION
    The Test-ComputerPort function tests the connectivity of a computer on specified TCP and UDP ports. It checks if the specified ports are open and reachable on the target computer.

    .PARAMETER ComputerName
    Specifies the name of the computer to test the port connectivity.

    .PARAMETER PortTCP
    Specifies an array of TCP ports to test connectivity.

    .PARAMETER PortUDP
    Specifies an array of UDP ports to test connectivity.

    .PARAMETER Timeout
    Specifies the timeout value in milliseconds for the connection test. Default is 5000 milliseconds.

    .EXAMPLE
    Test-ComputerPort -ComputerName "Server01" -PortTCP 80,443 -PortUDP 53 -Timeout 3000
    Tests the connectivity of Server01 on TCP ports 80 and 443, UDP port 53 with a timeout of 3000 milliseconds.

    .EXAMPLE
    Test-ComputerPort -ComputerName "Server02" -PortTCP 3389 -PortUDP 123
    Tests the connectivity of Server02 on TCP port 3389, UDP port 123 with the default timeout of 5000 milliseconds.
    #>
    [CmdletBinding()]
    param (
        [alias('Server')][string[]] $ComputerName,
        [int[]] $PortTCP,
        [int[]] $PortUDP,
        [int]$Timeout = 5000
    )
    begin {
        if ($Global:ProgressPreference -ne 'SilentlyContinue') {
            $TemporaryProgress = $Global:ProgressPreference
            $Global:ProgressPreference = 'SilentlyContinue'
        }
    }
    process {
        foreach ($Computer in $ComputerName) {
            foreach ($P in $PortTCP) {
                $Output = [ordered] @{
                    'ComputerName' = $Computer
                    'Port'         = $P
                    'Protocol'     = 'TCP'
                    'Status'       = $null
                    'Summary'      = $null
                    'Response'     = $null
                }
                <#
                $TcpClient = [System.Net.Sockets.TcpClient]::new()
                $Connect = $TcpClient.BeginConnect($Computer, $P, $null, $null)
                $Wait = $Connect.AsyncWaitHandle.WaitOne($Timeout, $false)
                if (!$Wait) {
                    $TcpClient.Close()
                    $Output['Status'] = $false
                    $Output['Summary'] = "TCP $P Failed"
                } else {
                    $TcpClient.EndConnect($Connect)
                    $TcpClient.Close()
                    $Output['Status'] = $true
                    $Output['Summary'] = "TCP $P Successful"
                }
                $TcpClient.Close()
                $TcpClient.Dispose()


                #>

                $TcpClient = Test-NetConnection -ComputerName $Computer -Port $P -InformationLevel Detailed -WarningAction SilentlyContinue
                if ($TcpClient.TcpTestSucceeded) {
                    $Output['Status'] = $TcpClient.TcpTestSucceeded
                    $Output['Summary'] = "TCP $P Successful"
                } else {
                    $Output['Status'] = $false
                    $Output['Summary'] = "TCP $P Failed"
                    $Output['Response'] = $Warnings
                }
                [PSCustomObject]$Output
            }
            foreach ($P in $PortUDP) {
                $Output = [ordered] @{
                    'ComputerName' = $Computer
                    'Port'         = $P
                    'Protocol'     = 'UDP'
                    'Status'       = $null
                    'Summary'      = $null
                }
                $UdpClient = [System.Net.Sockets.UdpClient]::new($Computer, $P)
                $UdpClient.Client.ReceiveTimeout = $Timeout
                # $UdpClient.Connect($Computer, $P)
                $Encoding = [System.Text.ASCIIEncoding]::new()
                $byte = $Encoding.GetBytes("Evotec")
                [void]$UdpClient.Send($byte, $byte.length)
                $RemoteEndpoint = [System.Net.IPEndPoint]::new([System.Net.IPAddress]::Any, 0)
                try {
                    $Bytes = $UdpClient.Receive([ref]$RemoteEndpoint)
                    [string]$Data = $Encoding.GetString($Bytes)
                    If ($Data) {
                        $Output['Status'] = $true
                        $Output['Summary'] = "UDP $P Successful"
                        $Output['Response'] = $Data
                    }
                } catch {
                    $Output['Status'] = $false
                    $Output['Summary'] = "UDP $P Failed"
                    $Output['Response'] = $_.Exception.Message
                }
                $UdpClient.Close()
                $UdpClient.Dispose()
                [PSCustomObject]$Output
            }

        }
    }
    end {
        # Bring back setting as per default
        if ($TemporaryProgress) {
            $Global:ProgressPreference = $TemporaryProgress
        }
    }
}


#Test-ComputerPort -ComputerName 'AD1', 'AD2' -PortTCP  25, 88, 389, 464, 636, 5722, 9389 | Format-Table -AutoSize
#Test-ComputerPort -ComputerName 'AD1' -PortTCP 25, 88, 389, 464, 636, 5722, 9389 -PortUDP 88, 123, 389, 464 | ft -AutoSize
#Test-ComputerPort -ComputerName 'AD2' -PortTCP 53 -PortUDP 53 | ft -AutoSize
#Test-ComputerPort -PortUDP 53 -ComputerName AD1,AD2 | ft -AutoSize

#Test-ComputerPort -ComputerName AD1,AD7 -PortTCP 53, 3389 | ft -a