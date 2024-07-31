function Get-ComputerNetFramework {
    <#
    .SYNOPSIS
    Get the installed .NET Framework version on a computer

    .DESCRIPTION
    Get the installed .NET Framework version on a computer

    .PARAMETER ComputerName
    The name of the computer to check the .NET Framework version on

    .EXAMPLE
    $DCs = Get-ADDomainController -Filter * -Server 'ad.evotec.xyz'
    Get-ComputerNetFramework -ComputerName $Dcs.HostName | Format-Table *

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $env:COMPUTERNAME
    )
    foreach ($Computer in $ComputerName) {
        $Output1 = Get-PSRegistry -ComputerName $Computer -RegistryPath 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client'
        #$Output2 = Get-PSRegistry -ComputerName $Computer -RegistryPath 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
        if ($Output1.PSError -eq $false) {
            [PSCustomObject] @{
                ComputerName        = $Computer
                NetFrameworkVersion = $Output1.Version
                NetFrameworkRelease = $Output1.Release
                Message             = ""
            }
        } else {
            [PSCustomObject] @{
                ComputerName        = $Computer
                NetFrameworkVersion = 'Not Installed'
                NetFrameworkRelease = 'Not Installed'
                Message             = $Output1.PSErrorMessage
            }
        }
    }
}