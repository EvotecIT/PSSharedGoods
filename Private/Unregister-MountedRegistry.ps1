function Unregister-MountedRegistry {
    <#
    .SYNOPSIS
    Unregisters mounted registry paths.

    .DESCRIPTION
    This function unregisters mounted registry paths that were previously mounted using Mount-PSRegistryPath.

    .EXAMPLE
    Unregister-MountedRegistry

    Description:
    Unregisters all mounted registry paths.

    #>
    [CmdletBinding()]
    param(

    )
    if ($null -ne $Script:DefaultRegistryMounted) {
        Write-Verbose -Message "Unregister-MountedRegistry - Dismounting HKEY_USERS\.DEFAULT_USER"
        $null = Dismount-PSRegistryPath -MountPoint "HKEY_USERS\.DEFAULT_USER"
        $Script:DefaultRegistryMounted = $null
    }
    if ($null -ne $Script:OfflineRegistryMounted) {
        foreach ($Key in $Script:OfflineRegistryMounted.Keys) {
            if ($Script:OfflineRegistryMounted[$Key].Status -eq $true) {
                Write-Verbose -Message "Unregister-MountedRegistry - Dismounting HKEY_USERS\$Key"
                $null = Dismount-PSRegistryPath -MountPoint "HKEY_USERS\$Key"
            }
        }
        $Script:OfflineRegistryMounted = $null
    }
}