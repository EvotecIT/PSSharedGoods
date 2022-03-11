function Remove-PSRegistry {
    <#
    .SYNOPSIS
    Remove registry keys and folders

    .DESCRIPTION
    Remove registry keys and folders using .NET methods

    .PARAMETER ComputerName
    The computer to run the command on. Defaults to local computer.

    .PARAMETER RegistryPath
    The registry path to remove.

    .PARAMETER Key
    The registry key to remove.

    .PARAMETER Recursive
    Forces deletion of registry folder and all keys, including nested folders

    .EXAMPLE
    Remove-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\Ok\MaybeNot" -Recursive

    .EXAMPLE
    Remove-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\Ok\MaybeNot" -Key "LimitBlankPass1wordUse"

    .EXAMPLE
    Remove-PSRegistry -RegistryPath "HKCU:\Tests\Ok"

    .NOTES
    General notes
    #>
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [Parameter(Mandatory)][string] $RegistryPath,
        [Parameter()][string] $Key,
        [switch] $Recursive
    )

    [Array] $ComputersSplit = Get-ComputerSplit -ComputerName $ComputerName

    $Dictionary = @{
        'HKCR:' = 'HKEY_CLASSES_ROOT'
        'HKCU:' = 'HKEY_CURRENT_USER'
        'HKLM:' = 'HKEY_LOCAL_MACHINE'
        'HKU:'  = 'HKEY_USERS'
        'HKCC:' = 'HKEY_CURRENT_CONFIG'
        'HKDD:' = 'HKEY_DYN_DATA'
        'HKPD:' = 'HKEY_PERFORMANCE_DATA'
    }

    # We need to supporrt a lot of options and clean the registry path a bit
    If ($RegistryPath -like '*:*') {
        foreach ($DictionaryKey in $Dictionary.Keys) {
            if ($RegistryPath.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                $RegistryPath = $RegistryPath -replace $DictionaryKey, $Dictionary[$DictionaryKey]
                break
            }
        }
    }
    # Remove additional slashes
    $RegistryPath = $RegistryPath.Replace("\\", "\").Replace("\\","\")

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

    foreach ($_ in $HiveDictionary.Keys) {
        if ($RegistryPath.StartsWith($_, [System.StringComparison]::CurrentCultureIgnoreCase)) {
            $RegistryValue = [ordered] @{
                HiveKey    = $HiveDictionary[$_]
                SubKeyName = $RegistryPath.substring($_.Length + 1)
                Key        = $Key
            }
            break
        }
    }

    if ($RegistryValue.HiveKey) {
        foreach ($Computer in $ComputersSplit[0]) {
            # Local computer
            try {
                if ($Key) {
                    if ($PSCmdlet.ShouldProcess($Computer, "Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) key $($RegistryValue.Key)")) {
                        $BaseHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey($RegistryValue.HiveKey, 0 )
                        $SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                        if ($SubKey) {
                            # DeleteValue(string name, bool throwOnMissingValue)
                            $SubKey.DeleteValue($RegistryValue.Key, $true)
                        }
                    }
                } else {
                    if ($PSCmdlet.ShouldProcess($Computer, "Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) folder)")) {
                        $BaseHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey($RegistryValue.HiveKey, 0 )
                        if ($BaseHive) {
                            # void DeleteSubKey(string subkey, bool throwOnMissingSubKey)
                            # void DeleteSubKeyTree(string subkey, bool throwOnMissingSubKey)
                            if ($Recursive) {
                                $BaseHive.DeleteSubKeyTree($RegistryValue.SubKeyName, $true)
                            } else {
                                $BaseHive.DeleteSubKey($RegistryValue.SubKeyName, $true)
                            }
                        }
                    }
                }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "Remove-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
                }
            }
        }
        foreach ($Computer in $ComputersSplit[1]) {
            # Remote computer
            try {
                if ($Key) {
                    if ($PSCmdlet.ShouldProcess($Computer, "Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) key $($RegistryValue.Key)")) {
                        $BaseHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryValue.HiveKey, $Computer, 0 )
                        $SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                        if ($SubKey) {
                            # DeleteValue(string name, bool throwOnMissingValue)
                            $SubKey.DeleteValue($RegistryValue.Key, $true)
                        }
                    }
                } else {
                    if ($PSCmdlet.ShouldProcess($Computer, "Removing registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) folder)")) {
                        $BaseHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryValue.HiveKey, $Computer, 0 )
                        if ($BaseHive) {
                            # void DeleteSubKey(string subkey, bool throwOnMissingSubKey)
                            # void DeleteSubKeyTree(string subkey, bool throwOnMissingSubKey)
                            if ($Recursive) {
                                $BaseHive.DeleteSubKeyTree($RegistryValue.SubKeyName, $true)
                            } else {
                                $BaseHive.DeleteSubKey($RegistryValue.SubKeyName, $true)
                            }
                        }
                    }
                }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "Remove-PSRegistry - Removing registry $RegistryPath on $Computer have failed (recursive: $($Recursive.IsPresent)). Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
                }
            }
        }
    } else {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw
        } else {
            # This shouldn't really happen
            Write-Warning "Remove-PSRegistry - Removingf registry $RegistryPath have failed (recursive: $($Recursive.IsPresent)). Couldn't translate HIVE."
        }
    }
}