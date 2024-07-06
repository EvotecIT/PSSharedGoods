function Mount-AllRegistryPath {
    <#
    .SYNOPSIS
    Mounts offline registry paths to specified mount points.

    .DESCRIPTION
    This function mounts offline registry paths to specified mount points. It iterates through all offline registry profiles and mounts them to the specified mount point. Optionally, you can specify a specific user profile to mount.

    .PARAMETER MountPoint
    Specifies the mount point where the registry paths will be mounted. Default is "HKEY_USERS\".

    .PARAMETER MountUsers
    Specifies the user profile to mount. If specified, only the specified user profile will be mounted.

    .EXAMPLE
    Mount-AllRegistryPath -MountPoint "HKEY_USERS\" -MountUsers "User1"
    Mounts the offline registry path of user profile "User1" to the default mount point "HKEY_USERS\".

    .EXAMPLE
    Mount-AllRegistryPath -MountPoint "HKEY_LOCAL_MACHINE\SOFTWARE" -MountUsers "User2"
    Mounts the offline registry path of user profile "User2" to the specified mount point "HKEY_LOCAL_MACHINE\SOFTWARE".

    #>
    [CmdletBinding()]
    param(
        [string] $MountPoint = "HKEY_USERS\",
        [string] $MountUsers
    )
    $AllProfiles = Get-OfflineRegistryProfilesPath
    foreach ($Profile in $AllProfiles.Keys) {
        if ($MountUsers) {
            if ($MountUsers -ne $Profile) {
                continue
            }
        }
        $WhereMount = "$MountPoint\$Profile".Replace("\\", "\")
        Write-Verbose -Message "Mount-OfflineRegistryPath - Mounting $WhereMount to $($AllProfiles[$Profile].FilePath)"
        $AllProfiles[$Profile].Status = Mount-PSRegistryPath -MountPoint $WhereMount -FilePath $AllProfiles[$Profile].FilePath
    }
    $AllProfiles
}