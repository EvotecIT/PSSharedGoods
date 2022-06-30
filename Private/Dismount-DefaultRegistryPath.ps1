function Dismount-DefaultRegistryPath {
    [CmdletBinding()]
    param(
        [string] $MountPoint = "HKEY_USERS\.DEFAULT_USER"
    )
    Dismount-PSRegistryPath -MountPoint $MountPoint
}