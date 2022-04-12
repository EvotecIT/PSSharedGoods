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

    .PARAMETER Suppress
    Suppresses the output of the command. By default the command outputs PSObject with the results of the operation.

    .EXAMPLE
    Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_DWORD -Key "16 LDAP Interface Events" -Value 2 -ComputerName AD1

    .EXAMPLE
    Set-PSRegistry -RegistryPath 'HKLM\SYSTEM\CurrentControlSet\Services\NTDS\Diagnostics' -Type REG_SZ -Key "LDAP Interface Events" -Value 'test' -ComputerName AD1

    .EXAMPLE
    Set-PSRegistry -RegistryPath "HKCU:\\Tests" -Key "LimitBlankPass1wordUse" -Value "0" -Type REG_DWORD

    .EXAMPLE
    Set-PSRegistry -RegistryPath "HKCU:\\Tests\MoreTests\Tests1" -Key "LimitBlankPass1wordUse" -Value "0" -Type REG_DWORD

    .EXAMPLE
    # Setting default value

    $ValueData = [byte[]] @(
        0, 1, 0, 0, 9, 0, 0, 0, 128, 0, 0, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3,
        0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3,
        0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3,
        0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3, 0, 3,
        0, 3, 0, 0, 0, 5, 0, 10, 0, 14, 0, 3, 0, 5, 0, 6, 0, 6, 0, 4, 0, 4, 0
    )
    Set-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests" -Key '' -Value $ValueData -Type 'NONE'

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [Parameter(Mandatory)][string] $RegistryPath,
        [Parameter(Mandatory)][ValidateSet('REG_SZ', 'REG_NONE', 'None', 'REG_EXPAND_SZ', 'REG_BINARY', 'REG_DWORD', 'REG_MULTI_SZ', 'REG_QWORD', 'string', 'binary', 'dword', 'qword', 'multistring', 'expandstring')][string] $Type,
        [Parameter()][string] $Key,
        [Parameter(Mandatory)][object] $Value,
        [switch] $Suppress
    )
    Get-PSRegistryDictionaries

    [Array] $ComputersSplit = Get-ComputerSplit -ComputerName $ComputerName

    # We need to supporrt a lot of options and clean the registry path a bit
    If ($RegistryPath -like '*:*') {
        foreach ($DictionaryKey in $Script:Dictionary.Keys) {
            if ($RegistryPath.StartsWith($DictionaryKey, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                $RegistryPath = $RegistryPath -replace $DictionaryKey, $Script:Dictionary[$DictionaryKey]
                break
            }
        }
    }
    # Remove additional slashes
    $RegistryPath = $RegistryPath.Replace("\\", "\").Replace("\\", "\")

    [Array] $RegistryTranslated = Get-PSConvertSpecialRegistry -RegistryPath $RegistryPath -Computers $ComputerName -HiveDictionary $Script:HiveDictionary

    foreach ($Registry in $RegistryTranslated) {
        $RegistryValue = Get-PrivateRegistryTranslated -RegistryPath $Registry -HiveDictionary $Script:HiveDictionary -Key $Key -Value $Value -Type $Type -ReverseTypesDictionary $Script:ReverseTypesDictionary

        if ($RegistryValue.HiveKey) {
            foreach ($Computer in $ComputersSplit[0]) {
                # Local computer
                Set-PrivateRegistry -RegistryValue $RegistryValue -Computer $Computer -Suppress:$Suppress.IsPresent -ErrorAction $ErrorActionPreference -WhatIf:$WhatIfPreference
            }
            foreach ($Computer in $ComputersSplit[1]) {
                # Remote computer
                Set-PrivateRegistry -RegistryValue $RegistryValue -Computer $Computer -Remote -Suppress:$Suppress.IsPresent -ErrorAction $ErrorActionPreference -WhatIf:$WhatIfPreference
            }
        } else {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                throw
            } else {
                # This shouldn't really happen
                Write-Warning "Set-PSRegistry - Setting registry to $Registry have failed. Couldn't translate HIVE."
            }
        }
    }
}