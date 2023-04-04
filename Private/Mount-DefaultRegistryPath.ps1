function Mount-DefaultRegistryPath {
    [CmdletBinding()]
    param(
        [string] $MountPoint = "HKEY_USERS\.DEFAULT_USER"
    )
    $DefaultRegistryPath = Get-PSRegistry -RegistryPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' -Key 'Default' -ExpandEnvironmentNames
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