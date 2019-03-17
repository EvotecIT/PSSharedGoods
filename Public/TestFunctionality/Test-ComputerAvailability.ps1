function Test-ComputerAvailability {
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
            $Output = [ordered] @{}
            $Output.ServerName = $Server
            if ($Test -eq 'All' -or $Test -like 'Ping*') {
                $Output.Pingable = Test-Connection -ComputerName $Server -Quiet -Count $PingCount
            }
            if ($Test -eq 'All' -or $Test -like '*WinRM*') {
                $Output.WinRM = Test-WinRM -ComputerName $Server
            }
            if ($Test -eq 'All' -or '*PortOpen*') {
                $Output.PortOpen = Test-ComputerPort -Server $Server -Ports $Ports -Timeout $PortsTimeout
            }
            [PSCustomObject] $Output
        }
    )
    return $OutputList
}