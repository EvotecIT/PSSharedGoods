function Get-PSSubRegistry {
    <#
    .SYNOPSIS
    Retrieves a subkey from the Windows Registry on a local or remote computer.

    .DESCRIPTION
    The Get-PSSubRegistry function retrieves a subkey from the Windows Registry on a local or remote computer. It can be used to access specific registry keys and their values.

    .PARAMETER Registry
    Specifies the registry key to retrieve. This parameter should be an IDictionary object containing information about the registry key.

    .PARAMETER ComputerName
    Specifies the name of the computer from which to retrieve the registry key. This parameter is optional and defaults to the local computer.

    .PARAMETER Remote
    Indicates that the registry key should be retrieved from a remote computer.

    .PARAMETER ExpandEnvironmentNames
    Indicates whether environment variable names in the registry key should be expanded.

    .EXAMPLE
    Get-PSSubRegistry -Registry $Registry -ComputerName "RemoteComputer" -Remote
    Retrieves a subkey from the Windows Registry on a remote computer named "RemoteComputer".

    .EXAMPLE
    Get-PSSubRegistry -Registry $Registry -ExpandEnvironmentNames
    Retrieves a subkey from the Windows Registry on the local computer with expanded environment variable names.

    #>
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Registry,
        [string] $ComputerName,
        [switch] $Remote,
        [switch] $ExpandEnvironmentNames
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
                    PSValue        = if (-not $ExpandEnvironmentNames) {
                        $SubKey.GetValue($Registry.Key, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
                    } else {
                        $SubKey.GetValue($Registry.Key)
                    }
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