function Set-PSRegistry {
    [cmdletbinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [Parameter(Mandatory)][string] $RegistryPath,
        [Parameter(Mandatory)][ValidateSet('REG_SZ', 'REG_EXPAND_SZ', 'REG_BINARY', 'REG_DWORD', 'REG_MULTI_SZ', 'REG_QWORD')][string] $Type,
        [Parameter(Mandatory)][string] $Key,
        [Parameter(Mandatory)][object] $Value
        # [switch] $Force
    )
    #if ($null -eq $Value -and $Force -eq $false) {
    #    Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $($ComputerName -join ', ') was terminated. Value is null."
    #    return
    #}
    [Array] $ComputersSplit = Get-ComputerSplit -ComputerName $ComputerName
    # https://docs.microsoft.com/en-us/previous-versions/windows/desktop/regprov/setstringvalue-method-in-class-stdregprov
    [uint32] $RootKey = $null

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
        'REG_SZ'        = 'SetStringValue' #'REG_SZ'
        'REG_EXPAND_SZ' = 'SetExpandedStringValue' #'REG_EXPAND_SZ'
        'REG_BINARY'    = 'SetBinaryValue' # REG_BINARY
        'REG_DWORD'     = 'SetDWORDValue' #'REG_DWORD'
        'REG_MULTI_SZ'  = 'SetMultiStringValue' # REG_MULTI_SZ
        'REG_QWORD'     = 'SetQWORDValue' # 'REG_QWORD'
        # https://docs.microsoft.com/en-us/previous-versions/windows/desktop/regprov/stdregprov
    }
    $MethodName = $TypesDictionary["$($Type)"]
    $Arguments = foreach ($_ in $RootKeyDictionary.Keys) {
        if ($RegistryPath.StartsWith($_, [System.StringComparison]::CurrentCultureIgnoreCase)) {
            $RootKey = [uint32] $RootKeyDictionary[$_]
            $RegistryValue = @{
                hDefKey     = [uint32] $RootKeyDictionary[$_]
                sSubKeyName = $RegistryPath.substring($_.Length + 1)
                sValueName  = $Key
            }
            if ($Type -in ('REG_SZ', 'REG_EXPAND_SZ', 'REG_MULTI_SZ')) {
                $RegistryValue['sValue'] = [string] $Value
            } elseif ($Type -in ('REG_DWORD', 'REG_QWORD')) {
                $RegistryValue['uValue'] = [uint32] $Value
            } elseif ($Type -in ('REG_BINARY')) {
                $RegistryValue['uValue'] = [uint8] $Value
            }
            $RegistryValue
            break
        }
    }
    foreach ($Computer in $ComputersSplit[0]) {
        # Local computer
        try {
            $ReturnValues = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -ErrorAction Stop -Verbose:$false
            if ($ReturnValues.ReturnValue -ne 0) {
                Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer may have failed. Please verify."
            }
        } catch {
            Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message)"
        }
    }
    foreach ($Computer in $ComputersSplit[1]) {
        # Remote computer
        try {
            $ReturnValues = Invoke-CimMethod -Namespace root\cimv2 -ClassName StdRegProv -MethodName $MethodName -Arguments $Arguments -ComputerName $Computer -ErrorAction Stop -Verbose:$false
            if ($ReturnValues.ReturnValue -ne 0) {
                Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer may have failed. Please verify."
            }
        } catch {
            Write-Warning "Set-PSRegistry - Setting registry to $RegistryPath on $Computer have failed. Error: $($_.Exception.Message)"
        }
    }
}