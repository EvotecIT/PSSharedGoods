function Mount-DefaultRegistryPath {
    [CmdletBinding()]
    param(
        [string] $MountPoint = "HKEY_USERS\.DEFAULT_USER"
    )
    $DefaultRegistryPath = Get-PSRegistry -RegistryPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' -Key 'Default'
    if ($PSError -ne $true) {
        $PathToNTUser = [io.path]::Combine($DefaultRegistryPath.PSValue, 'NTUSER.DAT')
        Mount-RegistryPath -MountPoint $MountPoint -FilePath $PathToNTUser
    } else {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw $PSErrorMessage
        } else {
            Write-Warning -Message "Import-DefaultRegistryPath - Couldn't execute. Error: $PSErrorMessage"
        }
    }
}