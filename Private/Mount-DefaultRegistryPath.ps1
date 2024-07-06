function Mount-DefaultRegistryPath {
    <#
    .SYNOPSIS
    Mounts the default registry path to a specified mount point.

    .DESCRIPTION
    This function mounts the default registry path to a specified mount point. If an error occurs during the process, it provides appropriate feedback.

    .PARAMETER MountPoint
    Specifies the mount point where the default registry path will be mounted. Default value is "HKEY_USERS\.DEFAULT_USER".

    .EXAMPLE
    Mount-DefaultRegistryPath -MountPoint "HKLM:\Software\CustomMountPoint"
    Mounts the default registry path to the specified custom mount point "HKLM:\Software\CustomMountPoint".

    .EXAMPLE
    Mount-DefaultRegistryPath
    Mounts the default registry path to the default mount point "HKEY_USERS\.DEFAULT_USER".

    #>
    [CmdletBinding()]
    param(
        [string] $MountPoint = "HKEY_USERS\.DEFAULT_USER"
    )
    $DefaultRegistryPath = Get-PSRegistry -RegistryPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' -Key 'Default' -ExpandEnvironmentNames -DoNotUnmount
    if ($PSError -ne $true) {
        $PathToNTUser = [io.path]::Combine($DefaultRegistryPath.PSValue, 'NTUSER.DAT')
        Write-Verbose -Message "Mount-DefaultRegistryPath - Mounting $MountPoint to $PathToNTUser"
        Mount-PSRegistryPath -MountPoint $MountPoint -FilePath $PathToNTUser
    } else {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw $PSErrorMessage
        } else {
            Write-Warning -Message "Mount-DefaultRegistryPath - Couldn't execute. Error: $PSErrorMessage"
        }
    }
}