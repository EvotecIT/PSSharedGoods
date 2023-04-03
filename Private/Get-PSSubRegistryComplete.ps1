function Get-PSSubRegistryComplete {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Registry,
        [string] $ComputerName,
        [switch] $Remote,
        [switch] $Advanced
    )
    if ($Registry.ComputerName) {
        if ($Registry.ComputerName -ne $ComputerName) {
            return
        }
    }
    if (-not $Registry.Error) {
        try {
            if ($Remote) {
                $BaseHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Registry.HiveKey, $ComputerName, 0 )
            } else {
                $BaseHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey($Registry.HiveKey, 0 )
            }
            $PSConnection = $true
            $PSError = $null
        } catch {
            $PSConnection = $false
            $PSError = $($_.Exception.Message)
        }
    } else {
        # this should happen if we weren't able to get registry keys in Get-PSConvertSpecialRegistry for HKEY_USERS
        $PSConnection = $false
        $PSError = $($Registry.ErrorMessage)
    }
    if ($PSError) {
        [PSCustomObject] @{
            PSComputerName = $ComputerName
            PSConnection   = $PSConnection
            PSError        = $true
            PSErrorMessage = $PSError
            PSSubKeys      = $null
            PSPath         = $Registry.Registry
            PSKey          = $Registry.Key
        }
    } else {
        try {
            $SubKey = $BaseHive.OpenSubKey($Registry.SubKeyName, $false)
            if ($null -ne $SubKey) {
                $Object = [ordered] @{
                    PSComputerName = $ComputerName
                    PSConnection   = $PSConnection
                    PSError        = $false
                    PSErrorMessage = $null
                    PSSubKeys      = $SubKey.GetSubKeyNames()
                    PSPath         = $Registry.Registry
                }
                $Keys = $SubKey.GetValueNames()
                foreach ($K in $Keys) {
                    if ($K -eq "") {
                        if ($Advanced) {
                            $Object['DefaultKey'] = [ordered] @{
                                Value = $SubKey.GetValue($K, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
                                Type  = $SubKey.GetValueKind($K)
                            }
                        } else {
                            $Object['DefaultKey'] = $SubKey.GetValue($K)
                        }
                    } else {
                        if ($Advanced) {
                            $Object[$K] = [ordered] @{
                                Value = $SubKey.GetValue($K, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
                                Type  = $SubKey.GetValueKind($K)
                            }
                        } else {
                            $Object[$K] = $SubKey.GetValue($K, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
                        }
                    }
                }
                [PSCustomObject] $Object
            } else {
                [PSCustomObject] @{
                    PSComputerName = $ComputerName
                    PSConnection   = $PSConnection
                    PSError        = $true
                    PSErrorMessage = "Registry path $($Registry.Registry) doesn't exists."
                    PSSubKeys      = $null
                    PSPath         = $Registry.Registry
                }
            }
        } catch {
            [PSCustomObject] @{
                PSComputerName = $ComputerName
                PSConnection   = $PSConnection
                PSError        = $true
                PSErrorMessage = $_.Exception.Message
                PSSubKeys      = $null
                PSPath         = $Registry.Registry
            }
        }
    }
    if ($null -ne $SubKey) {
        $SubKey.Close()
        $SubKey.Dispose()
    }
    if ($null -ne $BaseHive) {
        $BaseHive.Close()
        $BaseHive.Dispose()
    }
}