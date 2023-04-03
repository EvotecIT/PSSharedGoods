function Unregister-MountedRegistry {
    [CmdletBinding()]
    param(

    )
    if ($null -ne $Script:DefaultRegistryMounted) {
        $null = Dismount-PSRegistryPath -MountPoint "HKEY_USERS\.DEFAULT_USER"
        Write-Verbose -Message "Unregister-MountedRegistry - Dismounting HKEY_USERS\.DEFAULT_USER"
        $Script:DefaultRegistryMounted = $null
    }
    if ($null -ne $Script:OfflineRegistryMounted) {
        foreach ($Key in $Script:OfflineRegistryMounted.Keys) {
            Write-Verbose -Message "Unregister-MountedRegistry - Dismounting HKEY_USERS\$Key"
            $null = Dismount-PSRegistryPath -MountPoint "HKEY_USERS\$Key"
        }
        $Script:OfflineRegistryMounted = $null
    }
}