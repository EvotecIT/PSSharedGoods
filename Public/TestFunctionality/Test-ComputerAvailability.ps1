function Test-ComputerAvailability {
    <#
    .SYNOPSIS
    Tests the availability of specified servers using various methods.

    .DESCRIPTION
    This function tests the availability of specified servers by performing ping, WinRM, and port open tests. It provides detailed information about the availability status of each server.

    .PARAMETER Servers
    Specifies an array of server names to test.

    .PARAMETER Test
    Specifies the type of tests to perform. Valid values are 'All', 'Ping', 'WinRM', 'PortOpen', 'Ping+WinRM', 'Ping+PortOpen', 'WinRM+PortOpen'. Default is 'All'.

    .PARAMETER Ports
    Specifies an array of TCP ports to test for port open. Default is 135.

    .PARAMETER PortsTimeout
    Specifies the timeout value (in milliseconds) for testing port open. Default is 100.

    .PARAMETER PingCount
    Specifies the number of ping attempts to make. Default is 1.

    .EXAMPLE
    Test-ComputerAvailability -Servers "Server1", "Server2" -Test Ping+WinRM
    Tests the availability of Server1 and Server2 using both ping and WinRM methods.

    .EXAMPLE
    Test-ComputerAvailability -Servers "Server3" -Test PortOpen -Ports 80,443 -PortsTimeout 200
    Tests the availability of Server3 by checking if ports 80 and 443 are open within a timeout of 200 milliseconds.

    #>
    [CmdletBinding()]
    param(
        [string[]] $Servers,
        [ValidateSet('All', 'Ping', 'WinRM', 'PortOpen', 'Ping+WinRM', 'Ping+PortOpen', 'WinRM+PortOpen')] $Test = 'All',
        [int[]] $Ports = 135,
        [int] $PortsTimeout = 100,
        [int] $PingCount = 1
    )
    $OutputList = @(
        foreach ($Server in $Servers) {
            $Output = [ordered] @{ }
            $Output.ServerName = $Server
            if ($Test -eq 'All' -or $Test -like 'Ping*') {
                $Output.Pingable = Test-Connection -ComputerName $Server -Quiet -Count $PingCount
            }
            if ($Test -eq 'All' -or $Test -like '*WinRM*') {
                $Output.WinRM = (Test-WinRM -ComputerName $Server).Status
            }
            if ($Test -eq 'All' -or '*PortOpen*') {
                $Output.PortOpen = (Test-ComputerPort -Server $Server -PortTCP $Ports -Timeout $PortsTimeout).Status
            }
            [PSCustomObject] $Output
        }
    )
    return $OutputList
}

#Test-ComputerAvailability -Servers AD1,AD2