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

    .NOTES
    General notes
    #>
    [cmdletbinding()]
    param(
        [alias('Path')][string[]] $RegistryPath,
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [string] $Key,
        [switch] $Advanced
    )

    # We need to support the PSDrive syntax for backwards compatibility
    $Dictionary = @{
        'HKCR:' = 'HKEY_CLASSES_ROOT'
        'HKCU:' = 'HKEY_CURRENT_USER'
        'HKLM:' = 'HKEY_LOCAL_MACHINE'
        'HKU:'  = 'HKEY_USERS'
        'HKCC:' = 'HKEY_CURRENT_CONFIG'
        'HKDD:' = 'HKEY_DYN_DATA'
        'HKPD:' = 'HKEY_PERFORMANCE_DATA'
    }

    $RegistryPath = foreach ($R in $RegistryPath) {
        If ($R -like '*:*') {
            foreach ($DictionaryKey in $Dictionary.Keys) {
                if ($R.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                    $R -replace $DictionaryKey, $Dictionary[$DictionaryKey]
                    break
                }
            }
        } else {
            $R
        }
    }

    $HiveDictionary = @{
        'HKEY_CLASSES_ROOT'      = 'ClassesRoot'
        'HKCR'                   = 'ClassesRoot'
        'HKCU'                   = 'CurrentUser'
        'HKEY_CURRENT_USER'      = 'CurrentUser'
        'HKLM'                   = 'LocalMachine'
        'HKEY_LOCAL_MACHINE'     = 'LocalMachine'
        'HKU'                    = 'Users'
        'HKEY_USERS'             = 'Users'
        'HKCC'                   = 'CurrentConfig'
        'HKEY_CURRENT_CONFIG'    = 'CurrentConfig'
        'HKDD'                   = 'DynData'
        'HKEY_DYN_DATA'          = 'DynData'
        'HKPD'                   = 'PerformanceData'
        'HKEY_PERFORMANCE_DATA ' = 'PerformanceData '
    }
    [Array] $Computers = Get-ComputerSplit -ComputerName $ComputerName

    if ($Key) {
        [Array] $RegistryValues = Get-PSRegistryTranslated -RegistryPath $RegistryPath -HiveDictionary $HiveDictionary -Key $Key
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
        [Array] $RegistryValues = Get-PSRegistryTranslated -RegistryPath $RegistryPath -HiveDictionary $HiveDictionary
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