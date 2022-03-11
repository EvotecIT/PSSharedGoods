function Set-PSRegistry {
    <#
    .SYNOPSIS
    Sets/Udpates registry entries locally and remotely using .NET methods.

    .DESCRIPTION
    Sets/Udpates registry entries locally and remotely using .NET methods.

    .PARAMETER ComputerName
    The computer to run the command on. Defaults to local computer.

    .PARAMETER RegistryPath
    Registry Path to Update

    .PARAMETER Type
    Registry type

    .PARAMETER Key
    Registry key to set. If the path to registry key doesn't exists it will be created.

    .PARAMETER Value
    Registry value to set.

    .EXAMPLE
    Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_DWORD -Key "16 LDAP Interface Events" -Value 2 -ComputerName AD1

    .EXAMPLE
    Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_SZ -Key "LDAP Interface Events" -Value 'test' -ComputerName AD1

    .EXAMPLE
    Set-PSRegistry -RegistryPath "HKCU:\\Tests" -Key "LimitBlankPass1wordUse" -Value "0" -Type REG_DWORD

    .EXAMPLE
    Set-PSRegistry -RegistryPath "HKCU:\\Tests\MoreTests\Tests1" -Key "LimitBlankPass1wordUse" -Value "0" -Type REG_DWORD

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [Parameter(Mandatory)][string] $RegistryPath,
        [Parameter(Mandatory)][ValidateSet('REG_SZ', 'REG_EXPAND_SZ', 'REG_BINARY', 'REG_DWORD', 'REG_MULTI_SZ', 'REG_QWORD', 'string', 'binary', 'dword', 'qword', 'multistring', 'expandstring')][string] $Type,
        [Parameter(Mandatory)][string] $Key,
        [Parameter(Mandatory)][object] $Value
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

    $ReverseTypesDictionary = @{
        'REG_SZ'        = 'string'
        'REG_EXPAND_SZ' = 'expandstring'
        'REG_BINARY'    = 'binary'
        'REG_DWORD'     = 'dword'
        'REG_MULTI_SZ'  = 'multistring'
        'REG_QWORD'     = 'qword'
        'string'        = 'string'
        'expandstring'  = 'expandstring'
        'binary'        = 'binary'
        'dword'         = 'dword'
        'multistring'   = 'multistring'
        'qword'         = 'qword'
    }

    foreach ($_ in $HiveDictionary.Keys) {
        if ($RegistryPath.StartsWith($_, [System.StringComparison]::CurrentCultureIgnoreCase)) {
            $RegistryValue = [ordered] @{
                HiveKey    = $HiveDictionary[$_]
                SubKeyName = $RegistryPath.substring($_.Length + 1)
                ValueKind  = [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type])
                Key        = $Key
                Value      = $Value
            }
            # if ($Type -in ('REG_SZ', 'REG_EXPAND_SZ', 'REG_MULTI_SZ')) {
            #     $RegistryValue['Value'] = [string] $Value
            # } elseif ($Type -in ('REG_DWORD', 'REG_QWORD')) {
            #     $RegistryValue['Value'] = [uint32] $Value
            # } elseif ($Type -in ('REG_BINARY')) {
            #     $RegistryValue['Value'] = [uint8] $Value
            # }
            break
        }
    }

    if ($RegistryValue.HiveKey) {
        foreach ($Computer in $ComputersSplit[0]) {
            # Local computer
            try {
                if ($PSCmdlet.ShouldProcess($Computer, "Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) on $($RegistryValue.Key) to $($RegistryValue.Value) of $($RegistryValue.ValueKind)")) {
                    $BaseHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey($RegistryValue.HiveKey, 0 )
                    $SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                    if (-not $SubKey) {
                        $SubKeysSplit = $RegistryValue.SubKeyName.Split('\')
                        $SubKey = $BaseHive.OpenSubKey($SubKeysSplit[0], $true)
                        if (-not $SubKey) {
                            $SubKey = $BaseHive.CreateSubKey($SubKeysSplit[0])
                        }
                        $SubKey = $BaseHive.OpenSubKey($SubKeysSplit[0], $true)
                        foreach ($S in $SubKeysSplit | Select-Object -Skip 1) {
                            $SubKey = $SubKey.CreateSubKey($S)
                        }
                    }
                    if ($RegistryValue.ValueKind -eq [Microsoft.Win32.RegistryValueKind]::MultiString) {
                        $SubKey.SetValue($RegistryValue.Key, [string[]] $RegistryValue.Value, $RegistryValue.ValueKind)
                    } else {
                        $SubKey.SetValue($RegistryValue.Key, $RegistryValue.Value, $RegistryValue.ValueKind)
                    }
                }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
                }
            }
        }
        foreach ($Computer in $ComputersSplit[1]) {
            # Remote computer
            try {
                if ($PSCmdlet.ShouldProcess($Computer, "Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName) on $($RegistryValue.Key) to $($RegistryValue.Value) of $($RegistryValue.ValueKind)")) {
                    $BaseHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryValue.HiveKey, $Computer, 0 )
                    $SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                    if (-not $SubKey) {
                        $SubKeysSplit = $RegistryValue.SubKeyName.Split('\')
                        $SubKey = $BaseHive.OpenSubKey($SubKeysSplit[0], $true)
                        foreach ($S in $SubKeysSplit | Select-Object -Skip 1) {
                            $SubKey = $SubKey.CreateSubKey($S)
                        }
                    }
                    if ($RegistryValue.ValueKind -eq [Microsoft.Win32.RegistryValueKind]::MultiString) {
                        $SubKey.SetValue($RegistryValue.Key, [string[]] $RegistryValue.Value, $RegistryValue.ValueKind)
                    } else {
                        $SubKey.SetValue($RegistryValue.Key, $RegistryValue.Value, $RegistryValue.ValueKind)
                    }
                }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
                }
            }
        }
    } else {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw
        } else {
            # This shouldn't really happen
            Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath have failed. Couldn't translate HIVE."
        }
    }
}