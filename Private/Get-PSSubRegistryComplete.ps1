function Get-PSSubRegistryComplete {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Registry,
        [string] $ComputerName,
        [switch] $Remote,
        [switch] $Advanced
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
            PSErrorMessage = $PSError
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
                                Value = $SubKey.GetValue($K)
                                Type  = $SubKey.GetValueKind($K)
                            }
                        } else {
                            $Object['DefaultKey'] = $SubKey.GetValue($K)
                        }
                    } else {
                        if ($Advanced) {
                            $Object[$K] = [ordered] @{
                                Value = $SubKey.GetValue($K)
                                Type  = $SubKey.GetValueKind($K)
                            }
                        } else {
                            $Object[$K] = $SubKey.GetValue($K)
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
}