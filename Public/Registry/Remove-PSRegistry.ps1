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
    Get-PSRegistryDictionaries

    [Array] $ComputersSplit = Get-ComputerSplit -ComputerName $ComputerName

    # Cleans up registry path and makes sure it's as required to be processed further
    $RegistryPath = Resolve-PrivateRegistry -RegistryPath $RegistryPath

    [Array] $RegistryTranslated = Get-PSConvertSpecialRegistry -RegistryPath $RegistryPath -Computers $ComputerName -HiveDictionary $Script:HiveDictionary

    foreach ($Registry in $RegistryTranslated) {
        $RegistryValue = Get-PrivateRegistryTranslated -RegistryPath $Registry -HiveDictionary $Script:HiveDictionary -Key $Key -ReverseTypesDictionary $Script:ReverseTypesDictionary

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
                Unregister-MountedRegistry
                throw
            } else {
                # This shouldn't really happen
                Write-Warning "Remove-PSRegistry - Removing registry $RegistryPath have failed (recursive: $($Recursive.IsPresent)). Couldn't translate HIVE."
            }
        }
    }
    Unregister-MountedRegistry
}