function Test-ComputerPort {
    [CmdletBinding()]
    param (
        [alias('Server')][string[]] $ComputerName,
        [int[]] $PortTCP,
        [int[]] $PortUDP,
        [int]$Timeout = 5000
    )
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
}


#Test-ComputerPort -ComputerName 'AD1', 'AD2', 'DC123' -PortTCP  25, 88, 389, 464, 636, 5722, 9389 | ft -AutoSize
#Test-ComputerPort -ComputerName 'AD1' -PortTCP 25, 88, 389, 464, 636, 5722, 9389 -PortUDP 88, 123, 389, 464 | ft -AutoSize
#Test-ComputerPort -ComputerName 'AD2' -PortTCP 53 -PortUDP 53 | ft -AutoSize
#Test-ComputerPort -PortUDP 53 -ComputerName AD1,AD2 | ft -AutoSize

#Test-ComputerPort -ComputerName AD1,AD7 -PortTCP 53, 3389 | ft -a