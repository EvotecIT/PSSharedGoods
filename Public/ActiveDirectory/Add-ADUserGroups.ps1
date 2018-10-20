function Add-ADUserGroups {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [string[]] $Groups
    )
    $Object = @()
    $ADgroups = Get-ADPrincipalGroupMembership -Identity $User | Where-Object {$_.Name -ne "Domain Users"}
    if ($Groups) {
        foreach ($Group in $Groups) {
            if ($ADgroups -notcontains $Group) {
                try {
                    Add-ADGroupMember -Identity $Group -Members $User -ErrorAction Stop
                    $Object += @{ Status = $true; Output = $Group; Extended = 'Added to group.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $Group; Error = $ErrorMessage }
                }
            } else {
                $Object += @{ Status = $false; Output = $Group; Error = 'Already exists.' }
            }
        }
    }
    return $Object
}