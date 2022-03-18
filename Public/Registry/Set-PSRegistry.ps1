function Set-PSRegistry {
    <#
    .SYNOPSIS
    Sets/Updates registry entries locally and remotely using .NET methods.

    .DESCRIPTION
    Sets/Updates registry entries locally and remotely using .NET methods. If the registry path to key doesn't exists it will be created.

    .PARAMETER ComputerName
    The computer to run the command on. Defaults to local computer.

    .PARAMETER RegistryPath
    Registry Path to Update

    .PARAMETER Type
    Registry type to use. Options are:  REG_SZ, REG_EXPAND_SZ, REG_BINARY, REG_DWORD, REG_MULTI_SZ, REG_QWORD, string, expandstring, binary, dword, multistring, qword

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
        [Parameter(Mandatory)][object] $Value,
        [switch] $Suppress
    )
    [Array] $ComputersSplit = Get-ComputerSplit -ComputerName $ComputerName

    $Dictionary = @{
        'HKCR:'  = 'HKEY_CLASSES_ROOT'
        'HKCU:'  = 'HKEY_CURRENT_USER'
        'HKLM:'  = 'HKEY_LOCAL_MACHINE'
        'HKU:'   = 'HKEY_USERS'
        'HKCC:'  = 'HKEY_CURRENT_CONFIG'
        'HKDD:'  = 'HKEY_DYN_DATA'
        'HKPD:'  = 'HKEY_PERFORMANCE_DATA'
        # Those don't really exists, but we want to allow targetting all users or default users
        'HKUAD:' = 'HKEY_ALL_USERS_DEFAULT' # All users in HKEY_USERS including .DEFAULT
        'HKUA:'  = 'HKEY_ALL_USERS' # All users in HKEY_USERS excluding .DEFAULT
        'HKUD:'  = 'HKEY_DEFAULT_USER' # DEFAULT user in HKEY_USERS
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

    $ReverseTypesDictionary = [ordered] @{
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

    foreach ($Hive in $HiveDictionary.Keys) {
        if ($RegistryPath.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
            $RegistryValue = [ordered] @{
                HiveKey    = $HiveDictionary[$Hive]
                SubKeyName = $RegistryPath.substring($Hive.Length + 1)
                ValueKind  = [Microsoft.Win32.RegistryValueKind]::($ReverseTypesDictionary[$Type])
                Key        = $Key
                Value      = $Value
            }
            break
        }
    }

    if ($RegistryValue.HiveKey) {
        foreach ($Computer in $ComputersSplit[0]) {
            # Local computer
            Set-PSSubRegistry -RegistryValue $RegistryValue -Computer $Computer -Suppress:$Suppress.IsPresent
        }
        foreach ($Computer in $ComputersSplit[1]) {
            # Remote computer
            Set-PSSubRegistry -RegistryValue $RegistryValue -Computer $Computer -Remote -Suppress:$Suppress.IsPresent
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