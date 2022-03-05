function Set-PSRegistry {
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
    # Remove additional
    $RegistryPath = $RegistryPath.Replace("\\", "\")

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
            }
            if ($Type -in ('REG_SZ', 'REG_EXPAND_SZ', 'REG_MULTI_SZ')) {
                $RegistryValue['Value'] = [string] $Value
            } elseif ($Type -in ('REG_DWORD', 'REG_QWORD')) {
                $RegistryValue['Value'] = [uint32] $Value
            } elseif ($Type -in ('REG_BINARY')) {
                $RegistryValue['Value'] = [uint8] $Value
            }
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
                        foreach ($S in $SubKeysSplit | Select-Object -Skip 1) {
                            $SubKey = $SubKey.CreateSubKey($S)
                        }
                    }
                    #$SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                    $SubKey.SetValue($RegistryValue.Key, $RegistryValue.Value, $RegistryValue.ValueKind)
                }

                # $ReturnValues = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -ErrorAction Stop -Verbose:$false
                # if ($ReturnValues.ReturnValue -ne 0) {
                #Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer may have failed. Please verify."
                # }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message)"
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
                    #$SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                    $SubKey.SetValue($RegistryValue.Key, $RegistryValue.Value, $RegistryValue.ValueKind)
                }
                #$ReturnValues = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -ComputerName $Computer -ErrorAction Stop -Verbose:$false
                #if ($ReturnValues.ReturnValue -ne 0) {
                #    Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer may have failed. Please verify."
                #}
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message)"
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