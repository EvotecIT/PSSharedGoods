function Get-PSRegistry {
    param(
        [string[]] $ComputerName,
        [string[]] $RegistryPath,
        [string] $Value #,
        #[switch] $CustomObject
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
        # GetMultiStringValue
        '4'  = 'GetDWORDValue' #'REG_DWORD'
        '7'  = 'GetExpandedStringValue' # REG_MULTI_SZ
        '11' = 'GetQWORDValue' # 'REG_QWORD'
        # https://docs.microsoft.com/en-us/previous-versions/windows/desktop/regprov/stdregprov
    }

    [uint32] $RootKey = $null

    [Array] $Computers = $ComputerName.Where( { $_ -ne $Env:COMPUTERNAME }, 'Split' )
    foreach ($Registry in $RegistryPath) {


        #if ($Value) {
        #$Output1 = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumKey -ComputerName $ComputerName -Arguments $Arguments
        #$Output1.sNames


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
                    $Output2 = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumValues -ComputerName $Computers[$ComputerSplit] -Arguments $Arguments
                } else {
                    $Output2 = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName EnumValues -Arguments $Arguments
                }
                #$Output2 = Get-RegistryData -ComputerName $Computers[0] -MethodName EnumValues -Arguments $Arguments
                foreach ($Entry in $Output2) {
                    $RegistryOutput = [ordered] @{ }
                    $Types = $Entry.Types
                    $Names = $Entry.sNames
                    for ($i = 0; $i -lt $Names.Count; $i++) {
                        $Arguments['sValueName'] = $Names[$i]
                        $MethodName = $TypesDictionary["$($Types[$i])"]

                        if ($ComputerSplit -eq 0) {
                            $Values = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -ComputerName $Entry.PSComputerName
                        } else {
                            $Values = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments #-ComputerName $Entry.PSComputerName
                        }
                        #$Output2 = Get-RegistryData -ComputerName $Entry.PSComputerName -MethodName $MethodName -Arguments $Arguments
                        if ($null -ne $Values.sValue) {
                            $RegistryOutput[$Names[$i]] = $Values.sValue
                        } elseif ($null -ne $Values.uValue) {
                            $RegistryOutput[$Names[$i]] = $Values.uValue
                        }

                    }
                    if ($ComputerSplit -eq 0) {
                        $RegistryOutput['ComputerName'] = $Entry.PSComputerName
                    } else {
                        $RegistryOutput['ComputerName'] = $ENV:COMPUTERNAME
                    }
                    #if ($CustomObject) {
                    [PSCustomObject] $RegistryOutput
                    # } else {
                    #     $RegistryOutput
                    # }
                }
            }
        }
    }
}

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