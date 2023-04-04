function Mount-AllRegistryPath {
    [CmdletBinding()]
    param(
        [string] $MountPoint = "HKEY_USERS\"
    )
    $AllProfiles = Get-OfflineRegistryProfilesPath
    foreach ($Profile in $AllProfiles.Keys) {
        $WhereMount = "$MountPoint\$Profile".Replace("\\", "\")
        Write-Verbose -Message "Mount-OfflineRegistryPath - Mounting $WhereMount to $($AllProfiles[$Profile].FilePath)"
        $AllProfiles[$Profile].Status = Mount-PSRegistryPath -MountPoint $WhereMount -FilePath $AllProfiles[$Profile].FilePath
    }
    $AllProfiles
}