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

    .PARAMETER Suppress
    Suppresses the output of the command. By default the command outputs PSObject with the results of the operation.

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
        [Parameter(Mandatory)][string] $RegistryPath,
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

    # foreach ($Hive in $Script:HiveDictionary.Keys) {
    #     if ($RegistryPath.StartsWith($Hive, [System.StringComparison]::CurrentCultureIgnoreCase)) {
    #         $RegistryValue = [ordered] @{
    #             HiveKey    = $Script:HiveDictionary[$Hive]
    #             SubKeyName = $RegistryPath.substring($Hive.Length + 1)
    #         }
    #         break
    #     }
    # }

    [Array] $RegistryTranslated = Get-PSConvertSpecialRegistry -RegistryPath $RegistryPath -Computers $ComputerName -HiveDictionary $Script:HiveDictionary

    foreach ($Registry in $RegistryTranslated) {
        $RegistryValue = Get-PrivateRegistryTranslated -RegistryPath $Registry -HiveDictionary $Script:HiveDictionary -Key $Key -ReverseTypesDictionary $Script:ReverseTypesDictionary

        if ($RegistryValue.HiveKey) {
            foreach ($Computer in $ComputersSplit[0]) {
                # Local computer
                New-PrivateRegistry -RegistryValue $RegistryValue -Computer $Computer -ErrorAction $ErrorActionPreference -WhatIf:$WhatIfPreference
            }
            foreach ($Computer in $ComputersSplit[1]) {
                # Remote computer
                New-PrivateRegistry -RegistryValue $RegistryValue -Computer $Computer -Remote -ErrorAction $ErrorActionPreference -WhatIf:$WhatIfPreference
            }
        } else {
            if ($PSBoundParameters.ErrorAction -eq 'Stop') {
                if ($Script:DefaultRegistryMounted) {
                    $null = Dismount-DefaultRegistryPath
                    $Script:DefaultRegistryMounted = $null
                }
                throw
            } else {
                # This shouldn't really happen
                Write-Warning "New-PSRegistry - Setting registry to $RegistryPath have failed. Couldn't translate HIVE."
            }
        }
    }

    if ($Script:DefaultRegistryMounted) {
        $null = Dismount-DefaultRegistryPath
        $Script:DefaultRegistryMounted = $null
    }
}