function Remove-FilePermission {
    [cmdletBinding()]
    param(
        [string] $Path,
        [string] $UserOrGroup = "",
        [switch] $All
    )
    $ACL = Get-Acl -Path $Path
    if ($UserOrGroup -ne "") {
        foreach ($access in $ACL.Access) {
            if ($access.IdentityReference.Value -eq $UserOrGroup) {
                $ACL.RemoveAccessRule($access) | Out-Null
            }
        }
    }
    if ($All -eq $true) {
        foreach ($access in $ACL.Access) {
            $ACL.RemoveAccessRule($access) | Out-Null
        }

    }
    Set-Acl -Path $Path -AclObject $ACL
}