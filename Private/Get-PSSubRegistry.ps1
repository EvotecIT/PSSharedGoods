function Get-PSSubRegistry {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Registry,
        [string] $ComputerName,
        [switch] $Remote
    )
    try {
        if ($Remote) {
            $BaseHive = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($R.HiveKey, $ComputerName, 0 )
        } else {
            $BaseHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey($R.HiveKey, 0 )
        }
        $PSConnection = $true
        $PSError = $null
    } catch {
        $PSConnection = $false
        $PSError = $($_.Exception.Message)
    }
    if ($PSError) {
        [PSCustomObject] @{
            PSComputerName = $ComputerName
            PSConnection   = $PSConnection
            PSError        = $true
            PSErrorMessage = $_.Exception.Message
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
                    PSKey          = $Registry.Key
                    PSValue        = $SubKey.GetValue($Registry.Key)
                    PSType         = $SubKey.GetValueKind($Registry.Key)
                }
            } else {
                [PSCustomObject] @{
                    PSComputerName = $ComputerName
                    PSConnection   = $PSConnection
                    PSError        = $true
                    PSErrorMessage = "Registry path $($Registry.Registry) doesn't exists."
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
                PSKey          = $Registry.Key
                PSValue        = $null
                PSType         = $null
            }
        }
    }
}