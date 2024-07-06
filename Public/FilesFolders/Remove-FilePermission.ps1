function Remove-FilePermission {
    <#
    .SYNOPSIS
    Removes specific or all access rules for a user or group from a file or folder.

    .DESCRIPTION
    This function removes specific or all access rules for a specified user or group from a file or folder. It can be used to manage file permissions effectively.

    .PARAMETER Path
    Specifies the path of the file or folder from which to remove access rules.

    .PARAMETER UserOrGroup
    Specifies the user or group for which access rules should be removed. If not specified, all access rules will be removed.

    .PARAMETER All
    Indicates whether all access rules for the specified file or folder should be removed.

    .EXAMPLE
    Remove-FilePermission -Path "C:\Example\File.txt" -UserOrGroup "User1"
    Removes access rules for "User1" from the file "File.txt".

    .EXAMPLE
    Remove-FilePermission -Path "C:\Example\Folder" -All
    Removes all access rules from the folder "Folder".

    #>
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