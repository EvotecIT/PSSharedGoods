function Get-PSSubRegistry {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Registry,
        [string] $ComputerName,
        [switch] $Remote
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
            PSPath         = $Registry.Registry
            PSKey          = $Registry.Key
            PSValue        = $null
            PSType         = $null
        }
    } else {
        try {
            $SubKey = $BaseHive.OpenSubKey($Registry.SubKeyName, $false)
            if ($null -ne $SubKey) {
                [PSCustomObject] @{
                    PSComputerName = $ComputerName
                    PSConnection   = $PSConnection
                    PSError        = $false
                    PSErrorMessage = $null
                    PSPath         = $Registry.Registry
                    PSKey          = $Registry.Key
                    PSValue        = $SubKey.GetValue($Registry.Key, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
                    PSType         = $SubKey.GetValueKind($Registry.Key)
                }
            } else {
                [PSCustomObject] @{
                    PSComputerName = $ComputerName
                    PSConnection   = $PSConnection
                    PSError        = $true
                    PSErrorMessage = "Registry path $($Registry.Registry) doesn't exists."
                    PSPath         = $Registry.Registry
                    PSKey          = $Registry.Key
                    PSValue        = $null
                    PSType         = $null
                }
            }
        } catch {
            [PSCustomObject] @{
                PSComputerName = $ComputerName
                PSConnection   = $PSConnection
                PSError        = $true
                PSErrorMessage = $_.Exception.Message
                PSPath         = $Registry.Registry
                PSKey          = $Registry.Key
                PSValue        = $null
                PSType         = $null
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