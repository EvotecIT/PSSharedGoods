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

    .NOTES
    General notes
    #>
    [cmdletbinding()]
    param(
        [alias('Path')][string[]] $RegistryPath,
        [string[]] $ComputerName = $Env:COMPUTERNAME
    )

    $RootKeyDictionary = @{
        HKEY_CLASSES_ROOT   = 2147483648 #(0x80000000)
        HKCR                = 2147483648 #(0x80000000)
        HKEY_CURRENT_USER   = 2147483649 #(0x80000001)
        HKCU                = 2147483649 #(0x80000001)
        HKEY_LOCAL_MACHINE  = 2147483650 #(0x80000002)
        HKLM                = 2147483650 #(0x80000002)
        HKEY_USERS          = 2147483651 #(0x80000003)
        HKU                 = 2147483651 #(0x80000003)
        HKEY_CURRENT_CONFIG = 2147483653 #(0x80000005)
        HKCC                = 2147483653 #(0x80000005)
        HKEY_DYN_DATA       = 2147483654 #(0x80000006)
        HKDD                = 2147483654 #(0x80000006)
    }
    $TypesDictionary = @{
        '1'  = 'GetStringValue' #'REG_SZ'
        '2'  = 'GetExpandedStringValue' #'REG_EXPAND_SZ'
        '3'  = 'GetBinaryValue' # REG_BINARY
        '4'  = 'GetDWORDValue' #'REG_DWORD'
        '7'  = 'GetMultiStringValue'  # REG_MULTI_SZ
        '11' = 'GetQWORDValue' # 'REG_QWORD'
        # https://docs.microsoft.com/en-us/previous-versions/windows/desktop/regprov/stdregprov
    }
    $Dictionary = @{
        'HKCR:' = 'HKEY_CLASSES_ROOT'
        'HKCU:' = 'HKEY_CURRENT_USER'
        'HKLM:' = 'HKEY_LOCAL_MACHINE'
        'HKU:'  = 'HKEY_USERS'
        'HKCC:' = 'HKEY_CURRENT_CONFIG'
        'HKDD:' = 'HKEY_DYN_DATA'
    }

    [uint32] $RootKey = $null

    [Array] $Computers = Get-ComputerSplit -ComputerName $ComputerName
    #[Array] $Computers = $ComputerName.Where( { $_ -ne $Env:COMPUTERNAME }, 'Split' )
    foreach ($Registry in $RegistryPath) {
        # Fix regkey if used with :
        If ($Registry -like '*:*') {
            foreach ($Key in $Dictionary.Keys) {
                if ($Registry.StartsWith($Key, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                    $Registry = $Registry -replace $Key, $Dictionary[$Key]
                    break
                }
            }
        }
        # Remove additional slashes
        $Registry = $Registry.Replace("\\", "\")

        for ($ComputerSplit = 0; $ComputerSplit -lt $Computers.Count; $ComputerSplit++) {
            if ($Computers[$ComputerSplit].Count -gt 0) {
                $Arguments = foreach ($_ in $RootKeyDictionary.Keys) {
                    if ($Registry.StartsWith($_, [System.StringComparison]::CurrentCultureIgnoreCase)) {
                        $RootKey = [uint32] $RootKeyDictionary[$_]
                        @{
                            hDefKey     = [uint32] $RootKeyDictionary[$_]
                            sSubKeyName = $Registry.substring($_.Length + 1)
                        }
                        break
                    }
                }
                try {
                    if ($ComputerSplit -eq 0) {
                        $Output2 = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumValues -Arguments $Arguments -Verbose:$false -ErrorAction Stop
                        $OutputKeys = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumKey -Arguments $Arguments -Verbose:$false -ErrorAction Stop
                        #$OutputPermissions = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName GetSecurityDescriptor -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                        #$OutputCheckAccess = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName CheckAccess -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                    } else {
                        $Output2 = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumValues -Arguments $Arguments -ComputerName $Computers[$ComputerSplit] -Verbose:$false -ErrorAction Stop
                        $OutputKeys = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumKey -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false -ErrorAction Stop
                        #$OutputPermissions = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName GetSecurityDescriptor -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                        #$OutputCheckAccess =  Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName CheckAccess -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                    }
                } catch {
                    $RegistryOutput = [ordered] @{
                        PSConnection = $false
                        PSError      = $true
                    }
                    if (-not $RegistryOutput['PSComputerName']) {
                        # We check if COmputerName exists. Just in case someone actually set it up in registry with that name
                        # We then use PSComputerName
                        if ($ComputerSplit -eq 0) {
                            $RegistryOutput['PSComputerName'] = $ENV:COMPUTERNAME
                        } else {
                            $RegistryOutput['PSComputerName'] = $Entry.PSComputerName
                        }
                    } else {
                        if ($ComputerSplit -eq 0) {
                            $RegistryOutput['ComputerName'] = $ENV:COMPUTERNAME
                        } else {
                            $RegistryOutput['ComputerName'] = $Entry.PSComputerName
                        }
                    }
                    if (-not $RegistryOutput['PSSubKeys']) {
                        # Same as above. If for some reason RegistryKeys exists we need to save it to different value
                        $RegistryOutput['PSSubKeys'] = $OutputKeys.sNames
                    } else {
                        $RegistryOutput['SubKeys'] = $OutputKeys.sNames
                    }
                    $RegistryOutput['PSPath'] = $Registry

                    [PSCustomObject] $RegistryOutput
                    continue
                }
                foreach ($Entry in $Output2) {
                    $RegistryOutput = [ordered] @{
                        PSConnection = $true
                    }
                    if ($Entry.ReturnValue -ne 0) {
                        $RegistryOutput['PSError'] = $true
                    } else {
                        $RegistryOutput['PSError'] = $false
                        $Types = $Entry.Types
                        $Names = $Entry.sNames
                        for ($i = 0; $i -lt $Names.Count; $i++) {
                            $Arguments['sValueName'] = $Names[$i]
                            $MethodName = $TypesDictionary["$($Types[$i])"]

                            try {
                                if ($ComputerSplit -eq 0) {
                                    $Values = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -Verbose:$false -ErrorAction Stop
                                } else {
                                    $Values = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -ComputerName $Entry.PSComputerName -Verbose:$false -ErrorAction Stop #-ComputerName $Entry.PSComputerName
                                }
                            } catch {
                                $Values = $null
                            }
                            #$Output2 = Get-RegistryData -ComputerName $Entry.PSComputerName -MethodName $MethodName -Arguments $Arguments
                            if ($null -ne $Values.sValue) {

                                if ($Names[$i]) {
                                    $RegistryOutput[$Names[$i]] = $Values.sValue
                                } else {
                                    # Default value ''
                                    $RegistryOutput['DefaultKey'] = $Values.sValue
                                }
                            } elseif ($null -ne $Values.uValue) {
                                if ($Names[$i]) {
                                    $RegistryOutput[$Names[$i]] = $Values.uValue
                                } else {
                                    # Default value ''
                                    $RegistryOutput['DefaultKey'] = $Values.sValue
                                }
                            }

                        }
                    }
                    if (-not $RegistryOutput['PSComputerName']) {
                        # We check if COmputerName exists. Just in case someone actually set it up in registry with that name
                        # We then use PSComputerName
                        if ($ComputerSplit -eq 0) {
                            $RegistryOutput['PSComputerName'] = $ENV:COMPUTERNAME
                        } else {
                            $RegistryOutput['PSComputerName'] = $Entry.PSComputerName
                        }
                    } else {
                        if ($ComputerSplit -eq 0) {
                            $RegistryOutput['ComputerName'] = $ENV:COMPUTERNAME
                        } else {
                            $RegistryOutput['ComputerName'] = $Entry.PSComputerName
                        }
                    }
                    if (-not $RegistryOutput['PSSubKeys']) {
                        # Same as above. If for some reason RegistryKeys exists we need to save it to different value
                        $RegistryOutput['PSSubKeys'] = $OutputKeys.sNames
                    } else {
                        $RegistryOutput['SubKeys'] = $OutputKeys.sNames
                    }
                    $RegistryOutput['PSPath'] = $Registry

                    [PSCustomObject] $RegistryOutput

                    <#
                    PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Internet Explorer
                    PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog
                    PSChildName  : Internet Explorer
                    PSDrive      : HKLM
                    PSProvider   : Microsoft.PowerShell.Core\Registry
                    #>
                }

            }
        }
    }
}