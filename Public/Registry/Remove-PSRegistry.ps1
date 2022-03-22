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

    .PARAMETER Suppress
    Suppresses the output of the command. By default the command outputs PSObject with the results of the operation.

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
        [switch] $Recursive,
        [switch] $Suppress
    )

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

    foreach ($_ in $Script:HiveDictionary.Keys) {
        if ($RegistryPath.StartsWith($_, [System.StringComparison]::CurrentCultureIgnoreCase)) {
            $RegistryValue = [ordered] @{
                HiveKey    = $Script:HiveDictionary[$_]
                SubKeyName = $RegistryPath.substring($_.Length + 1)
                Key        = $Key
            }
            break
        }
    }

    if ($RegistryValue.HiveKey) {
        foreach ($Computer in $ComputersSplit[0]) {
            # Local computer
            Remove-PrivateRegistry -Key $Key -RegistryValue $RegistryValue -Computer $Computer -Suppress:$Suppress.IsPresent -ErrorAction $ErrorActionPreference -WhatIf:$WhatIfPreference
        }
        foreach ($Computer in $ComputersSplit[1]) {
            # Remote computer
            Remove-PrivateRegistry -Key $Key -RegistryValue $RegistryValue -Computer $Computer -Remote -Suppress:$Suppress.IsPresent -ErrorAction $ErrorActionPreference -WhatIf:$WhatIfPreference
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