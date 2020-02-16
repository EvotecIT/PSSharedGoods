function Get-ComputerSplit {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName
    )
    if ($null -eq $ComputerName) {
        $ComputerName = $Env:COMPUTERNAME
    }
    try {
        $LocalComputerDNSName = [System.Net.Dns]::GetHostByName($Env:COMPUTERNAME).HostName
    } catch {
        $LocalComputerDNSName = $Env:COMPUTERNAME
    }
    $ComputersLocal = $null
    [Array] $Computers = foreach ($_ in $ComputerName) {
        if ($_ -eq '' -or $null -eq $_) {
            $_ = $Env:COMPUTERNAME
        }
        if ($_ -ne $Env:COMPUTERNAME -and $_ -ne $LocalComputerDNSName) {
            $_
        } else {
            $ComputersLocal = $_
        }
    }
    #[Array] $ComputersLocal = foreach ($_ in $ComputerName) {
    #    if ($_ -eq $Env:COMPUTERNAME -or $_ -eq $LocalComputerDNSName) {
    #        $_
    #    }
    #}
    , @($ComputersLocal, $Computers)
}

#$T = Get-ComputerSplit -ComputerName $Env:COMPUTERNAME, 'EVOWin','AD1'
#$T
#$T[0]
#$T[1]