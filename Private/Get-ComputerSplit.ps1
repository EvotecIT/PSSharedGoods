function Get-ComputerSplit {
    <#
    .SYNOPSIS
    This function splits the list of computer names provided into two arrays: one containing remote computers and another containing the local computer.

    .DESCRIPTION
    The Get-ComputerSplit function takes an array of computer names as input and splits them into two arrays based on whether they are remote computers or the local computer. It determines the local computer by comparing the provided computer names with the local computer name and DNS name.

    .PARAMETER ComputerName
    Specifies an array of computer names to split into remote and local computers.

    .EXAMPLE
    Get-ComputerSplit -ComputerName "Computer1", "Computer2", $Env:COMPUTERNAME
    This example splits the computer names "Computer1" and "Computer2" into the remote computers array and the local computer array based on the local computer's name.

    #>
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
    [Array] $Computers = foreach ($Computer in $ComputerName) {
        if ($Computer -eq '' -or $null -eq $Computer) {
            $Computer = $Env:COMPUTERNAME
        }
        if ($Computer -ne $Env:COMPUTERNAME -and $Computer -ne $LocalComputerDNSName) {
            $Computer
        } else {
            $ComputersLocal = $Computer
        }
    }
    , @($ComputersLocal, $Computers)
}