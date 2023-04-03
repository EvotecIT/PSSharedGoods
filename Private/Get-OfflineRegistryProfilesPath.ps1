function Get-OfflineRegistryProfilesPath {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .EXAMPLE
    Get-OfflineRegistryProfilesPath

    .NOTES

    Name                           Value
    ----                           -----
    Przemek                        {[FilePath, C:\Users\Przemek\NTUSER.DAT], [Status, ]}
    test.1                         {[FilePath, C:\Users\test.1\NTUSER.DAT], [Status, ]}

    #>
    [CmdletBinding()]
    param(

    )
    $Profiles = [ordered] @{}
    $CurrentMapping = (Get-PSRegistry -RegistryPath 'HKEY_USERS').PSSubKeys

    $UsersInSystem = (Get-PSRegistry -RegistryPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList').PSSubKeys
    $MissingProfiles = foreach ($Profile in $UsersInSystem) {
        if ($Profile.StartsWith("S-1-5-21") -and $CurrentMapping -notcontains $Profile) {
            Get-PSRegistry -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Profile"
        }
    }
    foreach ($Profile in $MissingProfiles) {
        $PathToNTUser = [io.path]::Combine($Profile.ProfileImagePath, 'NTUSER.DAT')
        $ProfileName = [io.path]::GetFileName($Profile.ProfileImagePath)
        $StartPath = "Offline_$ProfileName"
        try {
            $PathExists = Test-Path -LiteralPath $PathToNTUser -ErrorAction Stop
            if ($PathExists) {
                $Profiles[$StartPath] = [ordered] @{
                    FilePath = $PathToNTUser
                    Status   = $null
                }
            }
        } catch {
            Write-Warning -Message "Mount-OfflineRegistryPath - Couldn't execute. Error: $($_.Exception.Message)"
            continue
        }

    }
    $Profiles
}