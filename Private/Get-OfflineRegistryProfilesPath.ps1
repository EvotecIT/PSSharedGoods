function Get-OfflineRegistryProfilesPath {
    <#
    .SYNOPSIS
    Retrieves the paths of offline user profiles in the Windows registry.

    .DESCRIPTION
    This function retrieves the paths of offline user profiles in the Windows registry by comparing the profiles listed in 'HKEY_USERS' with those in 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'. It then checks for the existence of the 'NTUSER.DAT' file for each profile and returns the paths of offline profiles found.

    .EXAMPLE
    Get-OfflineRegistryProfilesPath
    Retrieves the paths of offline user profiles in the Windows registry and returns a hashtable containing the profile paths.

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
    $CurrentMapping = (Get-PSRegistry -RegistryPath 'HKEY_USERS' -ExpandEnvironmentNames -DoNotUnmount).PSSubKeys
    $UsersInSystem = (Get-PSRegistry -RegistryPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' -ExpandEnvironmentNames -DoNotUnmount).PSSubKeys
    $MissingProfiles = foreach ($Profile in $UsersInSystem) {
        if ($Profile.StartsWith("S-1-5-21") -and $CurrentMapping -notcontains $Profile) {
            Get-PSRegistry -RegistryPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Profile" -ExpandEnvironmentNames -DoNotUnmount
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