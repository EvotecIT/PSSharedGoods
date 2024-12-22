<#

$Group1 = 'GDS-TestGroup1'
$Group2 = 'GDS-TestGroup2'

Set-WinADGroupSynchronization -GroupFrom $Group1 -GroupTo $Group2 -Type 'All' -Recursive None
#>

function Set-WinADGroupSynchronization {
    <#
    .SYNOPSIS
    Sets up synchronization between two Active Directory groups.

    .DESCRIPTION
    This function sets up synchronization between two Active Directory groups by copying members from one group to another based on specified criteria.

    .PARAMETER GroupFrom
    The name of the source Active Directory group from which members will be synchronized.

    .PARAMETER GroupTo
    The name of the target Active Directory group to which members will be synchronized.

    .PARAMETER Type
    Specifies the type of members to synchronize. Valid values are 'User', 'Group', or 'All'. Default is 'User'.

    .PARAMETER Recursive
    Specifies the type of synchronization to perform. Valid values are 'None', 'RecursiveFrom', 'RecursiveBoth', or 'RecursiveTo'. Default is 'None'.

    .PARAMETER WhatIf
    Shows what would happen if the synchronization is performed without actually performing it.

    .EXAMPLE
    Set-WinADGroupSynchronization -GroupFrom 'GDS-TestGroup1' -GroupTo 'GDS-TestGroup2' -Type 'All' -Recursive None
    Synchronizes all members from 'GDS-TestGroup1' to 'GDS-TestGroup2' without recursion.

    .EXAMPLE
    Set-WinADGroupSynchronization -GroupFrom 'GDS-TestGroup1' -GroupTo 'GDS-TestGroup2' -Type 'User' -Recursive RecursiveBoth
    Synchronizes only user members from 'GDS-TestGroup1' to 'GDS-TestGroup2' with recursion in both groups.

    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)][string] $GroupFrom,
        [parameter(Mandatory = $true)][string] $GroupTo,
        [parameter(Mandatory = $false)][ValidateSet("User", "Group", "All")][string] $Type = 'User',
        [parameter(Mandatory = $false)][ValidateSet("None", "RecursiveFrom", "RecursiveBoth", "RecursiveTo")] $Recursive = 'None',
        [switch] $WhatIf
    )
    Begin {
        $Object = @()
        if ($Recursive -eq 'None') {
            $GroupFromRecursive = $false
            $GroupToRecursive = $false
        } elseif ($Recursive -eq 'RecursiveFrom') {
            $GroupFromRecursive = $true
            $GroupToRecursive = $false
        } elseif ($Recursive -eq 'RecursiveBoth') {
            $GroupFromRecursive = $true
            $GroupToRecursive = $true
        } else {
            $GroupFromRecursive = $false
            $GroupToRecursive = $true
        }
    }
    Process {
        try {

            $GroupMembersFrom = Get-ADGroupMember -Identity $GroupFrom -Recursive:$GroupFromRecursive | Select-Object Name, ObjectClass, SamAccountName, UserPrincipalName
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
        }
        try {
            $GroupMembersTo = Get-ADGroupMember -Identity $GroupTo -Recursive:$GroupToRecursive | Select-Object Name, ObjectClass, SamAccountName, UserPrincipalName
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
        }
        if ($Object.Count -gt 0) {
            # Something went seriously wrong. Terminate ASAP
            return $Object
        }

        foreach ($User in $GroupMembersFrom) {
            if ($User.ObjectClass -eq "user") {
                if ($Type -eq 'User' -or $Type -eq 'All') {
                    if ($GroupMembersTo.SamAccountName -notcontains $User.SamAccountName) {
                        #Write-Color "Not a member ", $User.SamAccountName, " of $GroupTo", ". Adding!" -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Add-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Added to group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            } else {
                if ($Type -eq 'Group' -or $Type -eq 'All') {
                    if ($GroupMembersTo.SamAccountName -notcontains $User.SamAccountName) {
                        #Write-Color "Not a member ", $User.SamAccountName, " of $GroupTo", ". Adding!" -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Add-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Added to group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            }
        }
        foreach ($User in $GroupMembersTo) {
            if ($User.ObjectClass -eq "user") {
                if ($Type -eq 'User' -or $Type -eq 'All') {
                    if ($GroupMembersFrom.SamAccountName -notcontains $User.SamAccountName) {
                        Write-Color "Not a member of $GroupFrom - requires removal from $GroupTo ", $User.SamAccountName -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Remove-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName -Confirm:$false
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Removed from group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            } else {
                if ($Type -eq 'Group' -or $Type -eq 'All') {
                    if ($GroupMembersFrom.SamAccountName -notcontains $User.SamAccountName) {
                        Write-Color "Not a member of $GroupFrom - requires removal from $GroupTo ", $User.SamAccountName -Color Red -LogFile $LogFile
                        try {
                            if (-not $WhatIf) {
                            Remove-ADGroupMember -Identity $GroupTo -Members $User.SamAccountName -Confirm:$false
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Removed from group $GroupTo" }
                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $Group.Name; Extended = $ErrorMessage }
                        }
                    }
                }
            }
        }
    }
    End {
        return $object
    }
}