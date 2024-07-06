function Test-PSRegistry {
    <#
    .SYNOPSIS
    Tests the existence of a specified registry key on a remote or local computer.

    .DESCRIPTION
    This function checks if a specified registry key exists on a remote or local computer.

    .PARAMETER RegistryPath
    Specifies the path to the registry key(s) to be checked.

    .PARAMETER ComputerName
    Specifies the name of the remote computer to check. Defaults to the local computer.

    .PARAMETER Key
    Specifies the specific registry key to check for existence.

    .EXAMPLE
    Test-PSRegistry -RegistryPath 'HKLM:\Software\Microsoft' -Key 'Windows'

    Description
    -----------
    Checks if the 'Windows' key exists under 'HKLM:\Software\Microsoft' on the local computer.

    .EXAMPLE
    Test-PSRegistry -RegistryPath 'HKLM:\Software\Microsoft' -ComputerName 'RemoteComputer' -Key 'Windows'

    Description
    -----------
    Checks if the 'Windows' key exists under 'HKLM:\Software\Microsoft' on the 'RemoteComputer'.

    #>
    [cmdletbinding()]
    param(
        [alias('Path')][string[]] $RegistryPath,
        [string] $ComputerName = $Env:COMPUTERNAME,
        [string] $Key
    )
    $Output = Get-PSRegistry -RegistryPath $RegistryPath -ComputerName $ComputerName
    if ($Output.PSConnection -eq $true -and $Output.PSError -eq $false) {
        if ($Key) {
            if ($null -ne $Output.$Key) {
                return $true
            } else {
                return $false
            }
        } else {
            return $true
        }
    } else {
        return $false
    }
}