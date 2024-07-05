function Remove-WinADUserGroups {
    <#
    .SYNOPSIS
    Removes specified Active Directory groups from a user.

    .DESCRIPTION
    This function removes specified Active Directory groups from a user account. It provides options to remove groups based on category, scope, or all groups.

    .PARAMETER User
    The user object from which groups will be removed.

    .PARAMETER GroupCategory
    Specifies the category of groups to remove. Valid values are "Distribution" and "Security".

    .PARAMETER GroupScope
    Specifies the scope of groups to remove. Valid values are "DomainLocal", "Global", and "Universal".

    .PARAMETER Groups
    An array of specific group names to remove.

    .PARAMETER All
    If specified, removes all groups from the user.

    .PARAMETER WhatIf
    Shows what would happen if the command runs without actually running it.

    .EXAMPLE
    Remove-WinADUserGroups -User $User -All
    Removes all groups from the specified user account.

    .EXAMPLE
    Remove-WinADUserGroups -User $User -GroupCategory "Security" -GroupScope "Global"
    Removes all security groups with a global scope from the specified user account.
    #>
    [CmdletBinding()]
    [alias("Remove-ADUserGroups")]
    param(
        [parameter(Mandatory = $true)][Object] $User,
        [ValidateSet("Distribution", "Security")][String] $GroupCategory ,
        [ValidateSet("DomainLocal", "Global", "Universal")][String] $GroupScope,
        [string[]] $Groups,
        [switch] $All,
        [switch] $WhatIf
    )
    $Object = @()
    try {
        $ADgroups = Get-ADPrincipalGroupMembership -Identity $User.DistinguishedName -ErrorAction Stop | Where-Object { $_.Name -ne "Domain Users" }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
    }
    if ($ADgroups) {
        if ($All) {
            #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups ', ($ADgroups.Name -join ', '), ' from user ', $User.DisplayName -Color White, Yellow, Green, White, Yellow
            foreach ($Group in $ADgroups) {
                try {
                    if (-not $WhatIf) {
                        Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $Group -Confirm:$false -ErrorAction Stop
                    }
                    $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                }
            }
        }
        if ($GroupCategory) {
            $ADGroupsByCategory = $ADgroups | Where-Object { $_.GroupCategory -eq $GroupCategory }
            if ($ADGroupsByCategory) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups (by category - ', $GroupCategory, ") ", ($ADGroupsByCategory.Name -join ', '), ' from user ', $User.DisplayName -Colo White, Yellow, Green, White, Yellow, White, Blue
                foreach ($Group in $ADGroupsByCategory) {
                    try {
                        if (-not $WhatIf) {
                            Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $Group -Confirm:$false -ErrorAction Stop
                        }
                        $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                    }
                }
            }
        }
        if ($GroupScope) {
            $ADGroupsByScope = $ADgroups | Where-Object { $_.GroupScope -eq $GroupScope }
            if ($ADGroupsByScope) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups (by scope ', " - $GroupScope) ", ($ADGroupsByScope.Name -join ', '), ' from user ', $User.DisplayName -Color White, Yellow, Green, White, Yellow, White, Blue
                foreach ($Group in $ADGroupsByScope) {
                    try {
                        if (-not $WhatIf) {
                            Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $Group -Confirm:$false -ErrorAction Stop
                        }
                        $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                    }
                }
            }
        }
        if ($Groups) {
            foreach ($Group in $Groups) {
                $ADGroupsByName = $ADgroups | Where-Object { $_.Name -like $Group }
                if ($ADGroupsByName) {
                    #Write-Color @Script:WriteParameters -Text '[i]', ' Removing groups (by name) ', ($ADGroupsByName.Name -join ', '), ' from user ', $User.DisplayName -Color White, Yellow, Green, White, Yellow, White, Yellow
                    try {
                        if (-not $WhatIf) {
                            Remove-ADPrincipalGroupMembership -Identity $User.DistinguishedName -MemberOf $ADGroupsByName -Confirm:$false -ErrorAction Stop
                        }
                        $Object += @{ Status = $true; Output = $Group.Name; Extended = 'Removed from group.' }
                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                    }
                } else {
                    $Object += @{ Status = $false; Output = $Group.Name; Extended = 'Not available on user.' }
                }
            }
        }
    }
    return $Object
}
