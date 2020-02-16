function Get-PSRegistry {
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
                if ($Registry.StartsWith($Key)) {
                    $Registry = $Registry -replace $Key, $Dictionary[$Key]
                    break
                }
            }
        }

        for ($ComputerSplit = 0; $ComputerSplit -lt $Computers.Count; $ComputerSplit++) {
            if ($Computers[$ComputerSplit].Count -gt 0) {
                $Arguments = foreach ($_ in $RootKeyDictionary.Keys) {
                    if ($Registry.StartsWith($_)) {
                        $RootKey = [uint32] $RootKeyDictionary[$_]
                        @{
                            hDefKey     = [uint32] $RootKeyDictionary[$_]
                            sSubKeyName = $Registry.substring($_.Length + 1)
                        }
                        break
                    }
                }
                if ($ComputerSplit -eq 0) {
                    $Output2 = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumValues -Arguments $Arguments -Verbose:$false
                    $OutputKeys = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumKey -Arguments $Arguments -Verbose:$false
                    #$OutputPermissions = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName GetSecurityDescriptor -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                    #$OutputCheckAccess = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName CheckAccess -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                } else {
                    $Output2 = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumValues -Arguments $Arguments -ComputerName $Computers[$ComputerSplit] -Verbose:$false
                    $OutputKeys = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumKey -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                    #$OutputPermissions = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName GetSecurityDescriptor -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                    #$OutputCheckAccess =  Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName CheckAccess -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments -Verbose:$false
                }
                foreach ($Entry in $Output2) {
                    $RegistryOutput = [ordered] @{ }
                    if ($Entry.ReturnValue -ne 0) {
                        $RegistryOutput['PSError'] = $true
                    } else {
                        $RegistryOutput['PSError'] = $false
                        $Types = $Entry.Types
                        $Names = $Entry.sNames
                        for ($i = 0; $i -lt $Names.Count; $i++) {
                            $Arguments['sValueName'] = $Names[$i]
                            $MethodName = $TypesDictionary["$($Types[$i])"]

                            if ($ComputerSplit -eq 0) {
                                $Values = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -Verbose:$false
                            } else {
                                $Values = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -ComputerName $Entry.PSComputerName -Verbose:$false #-ComputerName $Entry.PSComputerName
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



#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters' -ComputerName AD2

#Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName GetSTRINGvalue -Arguments @{hDefKey = $hklm; sSubKeyName = $newkey; sValueName = $newname } -ComputerName 'AD1','AD2','AD3'
#$T = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumValues -Arguments @{hDefKey = $hklm; sSubKeyName = $newkey; } -ComputerName 'AD1' #,'AD2','AD3'
#$T.sNames
#foreach ($_ in $T.sNames) {
#    Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName GetSTRINGvalue -Arguments @{hDefKey = $hklm; sSubKeyName = $newkey; sValueName = $_ } -ComputerName 'AD1'
#}

<#
$class = Get-CimClass -Namespace root\cimv2 -ClassName StdRegProv
$class.CimClassMethods | select Name

CreateKey
DeleteKey
EnumKey
EnumValues
DeleteValue
SetDWORDValue
SetQWORDValue
GetDWORDValue
GetQWORDValue
SetStringValue
GetStringValue
SetMultiStringValue
GetMultiStringValue
SetExpandedStringValue
GetExpandedStringValue
SetBinaryValue
GetBinaryValue
CheckAccess
SetSecurityDescriptor
GetSecurityDescriptor
#>

#Get-PSRegistry -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\DFSR\Parameters" -ComputerName AD1,AD2,AD3 | ft -AutoSize

#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Directory Service'
#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Windows PowerShell' | Format-Table -AutoSize


#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels' | Format-Table -AutoSize
#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\'

#Get-PSRegistry -registrypath 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet'

#Get-PSRegistry -RegistryPath 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Search' -ComputerName AD1