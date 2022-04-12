function Get-PSRegistry {
    <#
    .SYNOPSIS
    Get registry key values.

    .DESCRIPTION
    Get registry key values.

    .PARAMETER RegistryPath
    The registry path to get the values from.

    .PARAMETER ComputerName
    The computer to get the values from. If not specified, the local computer is used.

    .EXAMPLE
    Get-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters' -ComputerName AD1

    .EXAMPLE
    Get-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters'

    .EXAMPLE
    Get-PSRegistry -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\DFSR\Parameters" -ComputerName AD1,AD2,AD3 | ft -AutoSize

    .EXAMPLE
    Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Directory Service'

    .EXAMPLE
    Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Windows PowerShell' | Format-Table -AutoSize

    .EXAMPLE
    Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Directory Service' -ComputerName AD1 -Advanced

    .EXAMPLE
    Get-PSRegistry -RegistryPath "HKLM:\Software\Microsoft\Powershell\1\Shellids\Microsoft.Powershell\"

    .EXAMPLE
    # Get default key and it's value
    Get-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests" -Key ""

    .EXAMPLE
    # Get default key and it's value (alternative)
o   Get-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests" -DefaultKey

    .NOTES
    General notes
    #>
    [cmdletbinding()]
    param(
        [alias('Path')][string[]] $RegistryPath,
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [string] $Key,
        [switch] $Advanced,
        [switch] $DefaultKey
    )
    Get-PSRegistryDictionaries

    $RegistryPath = foreach ($R in $RegistryPath) {
        If ($R -like '*:*') {
            foreach ($DictionaryKey in $Script:Dictionary.Keys) {
                if ($R.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                    $R -replace $DictionaryKey, $Script:Dictionary[$DictionaryKey]
                    break
                }
            }
        } else {
            $R
        }
    }

    [Array] $Computers = Get-ComputerSplit -ComputerName $ComputerName

    [Array] $RegistryTranslated = Get-PSConvertSpecialRegistry -RegistryPath $RegistryPath -Computers $ComputerName -HiveDictionary $Script:HiveDictionary

    if ($PSBoundParameters.ContainsKey("Key") -or $DefaultKey) {
        [Array] $RegistryValues = Get-PSSubRegistryTranslated -RegistryPath $RegistryTranslated -HiveDictionary $Script:HiveDictionary -Key $Key
        foreach ($Computer in $Computers[0]) {
            foreach ($R in $RegistryValues) {
                Get-PSSubRegistry -Registry $R -ComputerName $Computer
            }
        }
        foreach ($Computer in $Computers[1]) {
            foreach ($R in $RegistryValues) {
                Get-PSSubRegistry -Registry $R -ComputerName $Computer -Remote
            }
        }
    } else {
        [Array] $RegistryValues = Get-PSSubRegistryTranslated -RegistryPath $RegistryTranslated -HiveDictionary $Script:HiveDictionary
        foreach ($Computer in $Computers[0]) {
            foreach ($R in $RegistryValues) {
                Get-PSSubRegistryComplete -Registry $R -ComputerName $Computer -Advanced:$Advanced
            }
        }
        foreach ($Computer in $Computers[1]) {
            foreach ($R in $RegistryValues) {
                Get-PSSubRegistryComplete -Registry $R -ComputerName $Computer -Remote -Advanced:$Advanced
            }
        }
    }
}