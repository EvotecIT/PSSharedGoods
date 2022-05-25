function Dismount-DefaultRegistryPath {
    [CmdletBinding()]
    param(
        [string] $MountPoint = "HKEY_USERS\.DEFAULT_USER"
    )
    Dismount-RegistryPath -MountPoint $MountPoint
}