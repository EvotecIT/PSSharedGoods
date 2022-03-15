function New-PSRegistry {
    <#
    .SYNOPSIS
    Provides a way to create new registry paths

    .DESCRIPTION
    Provides a way to create new registry paths

    .PARAMETER ComputerName
    The computer to run the command on. Defaults to local computer.

    .PARAMETER RegistryPath
    Registry Path to Create

    .EXAMPLE
    New-PSRegistry -RegistryPath "HKCU:\\Tests1\CurrentControlSet\Control\Lsa" -Verbose -WhatIf

    .EXAMPLE
    New-PSRegistry -RegistryPath "HKCU:\\Tests1\CurrentControlSet\Control\Lsa"

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [Parameter(Mandatory)][string] $RegistryPath
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
    $RegistryPath = $RegistryPath.Replace("\\", "\").Replace("\\", "\")

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


    foreach ($Hive in $HiveDictionary.Keys) {
        if ($RegistryPath.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
            $RegistryValue = [ordered] @{
                HiveKey    = $HiveDictionary[$Hive]
                SubKeyName = $RegistryPath.substring($Hive.Length + 1)
            }
            break
        }
    }

    if ($RegistryValue.HiveKey) {
        foreach ($Computer in $ComputersSplit[0]) {
            # Local computer
            try {
                if ($PSCmdlet.ShouldProcess($Computer, "Creating registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)")) {
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
                }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "New-PSRegistry - Creating registry $RegistryPath on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
                }
            }
        }
        foreach ($Computer in $ComputersSplit[1]) {
            # Remote computer
            try {
                if ($PSCmdlet.ShouldProcess($Computer, "Setting registry $($RegistryValue.HiveKey)\$($RegistryValue.SubKeyName)")) {
                    $BaseHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryValue.HiveKey, $Computer, 0 )
                    $SubKey = $BaseHive.OpenSubKey($RegistryValue.SubKeyName, $true)
                    if (-not $SubKey) {
                        $SubKeysSplit = $RegistryValue.SubKeyName.Split('\')
                        $SubKey = $BaseHive.OpenSubKey($SubKeysSplit[0], $true)
                        foreach ($S in $SubKeysSplit | Select-Object -Skip 1) {
                            $SubKey = $SubKey.CreateSubKey($S)
                        }
                    }
                }
            } catch {
                if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                    throw
                } else {
                    Write-Warning "New-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message.Replace([System.Environment]::NewLine, " "))"
                }
            }
        }
    } else {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw
        } else {
            # This shouldn't really happen
            Write-Warning "New-PSRegistry - Setting registry to $RegistryPath have failed. Couldn't translate HIVE."
        }
    }
}