function Remove-FilePermission {
    [alias('Remove-Permission')]
    param(
        [string] $StartingDir,
        [string] $UserOrGroup = "",
        [switch] $All
    )
    $acl = get-acl -Path $StartingDir
    if ($UserOrGroup -ne "") {
        foreach ($access in $acl.Access) {
            if ($access.IdentityReference.Value -eq $UserOrGroup) {
                $acl.RemoveAccessRule($access) | Out-Null
            }
        }
    }
    if ($All -eq $true) {
        foreach ($access in $acl.Access) {
            $acl.RemoveAccessRule($access) | Out-Null
        }

    }
    Set-Acl -Path $folder.FullName -AclObject $acl
}