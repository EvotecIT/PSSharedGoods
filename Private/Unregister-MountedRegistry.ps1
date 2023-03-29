function Unregister-MountedRegistry {
    [CmdletBinding()]
    param(

    )
    if ($Script:DefaultRegistryMounted) {
        $null = Dismount-PSRegistryPath -MountPoint "HKEY_USERS\.DEFAULT_USER"
        $Script:DefaultRegistryMounted = $null
    }
    if ($Script:OfflineRegistryMounted) {
        foreach ($Key in $Script:OfflineRegistryMounted.Keys) {
            $null = Dismount-PSRegistryPath -MountPoint "HKEY_USERS\$Key"
        }
        $Script:OfflineRegistryMounted = $null
    }
}