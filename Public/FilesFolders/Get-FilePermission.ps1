function Get-FilePermission {
    <#
    .SYNOPSIS
    Retrieves and displays file permissions for the specified file or folder.

    .DESCRIPTION
    This function retrieves and displays the file permissions for the specified file or folder. It provides options to filter permissions based on inheritance, resolve access control types, and include extended information.

    .EXAMPLE
    Get-FilePermission -Path "C:\Example\File.txt"
    Description:
    Retrieves and displays the permissions for the "File.txt" file.

    .EXAMPLE
    Get-FilePermission -Path "D:\Folder" -Inherited
    Description:
    Retrieves and displays only the inherited permissions for the "Folder" directory.

    .EXAMPLE
    Get-FilePermission -Path "E:\Document.docx" -ResolveTypes -Extended
    Description:
    Retrieves and displays the resolved access control types and extended information for the "Document.docx" file.

    .NOTES
    This function supports various options to customize the output and handle different permission scenarios.
    #>
    [alias('Get-PSPermissions', 'Get-FilePermissions')]
    [cmdletBinding()]
    param(
        [Array] $Path,
        [switch] $Inherited,
        [switch] $NotInherited,
        [switch] $ResolveTypes,
        [switch] $Extended,
        [switch] $IncludeACLObject,
        [switch] $AsHashTable,
        [System.Security.AccessControl.FileSystemSecurity] $ACLS
    )
    foreach ($P in $Path) {
        if ($P -is [System.IO.FileSystemInfo]) {
            $FullPath = $P.FullName
        } elseif ($P -is [string]) {
            $FullPath = $P
        }
        $TestPath = Test-Path -Path $FullPath
        if ($TestPath) {
            if (-not $ACLS) {
                try {
                    $ACLS = (Get-Acl -Path $FullPath -ErrorAction Stop)
                } catch {
                    Write-Warning -Message "Get-FilePermission - Can't access $FullPath. Error $($_.Exception.Message)"
                    continue
                }
            }
            $Output = foreach ($ACL in $ACLS.Access) {
                if ($Inherited) {
                    if ($ACL.IsInherited -eq $false) {
                        # if it's not inherited and we require inherited lets continue
                        continue
                    }
                }
                if ($NotInherited) {
                    if ($ACL.IsInherited -eq $true) {
                        continue
                    }
                }
                $TranslateRights = Convert-GenericRightsToFileSystemRights -OriginalRights $ACL.FileSystemRights
                $ReturnObject = [ordered] @{ }
                $ReturnObject['Path' ] = $FullPath
                $ReturnObject['AccessControlType'] = $ACL.AccessControlType
                if ($ResolveTypes) {
                    $Identity = Convert-Identity -Identity $ACL.IdentityReference
                    if ($Identity) {
                        $ReturnObject['Principal'] = $ACL.IdentityReference
                        $ReturnObject['PrincipalName'] = $Identity.Name
                        $ReturnObject['PrincipalSid'] = $Identity.Sid
                        $ReturnObject['PrincipalType'] = $Identity.Type
                    } else {
                        # this shouldn't happen because Identity should always return value
                        $ReturnObject['Principal'] = $Identity
                        $ReturnObject['PrincipalName'] = ''
                        $ReturnObject['PrincipalSid'] = ''
                        $ReturnObject['PrincipalType'] = ''
                    }
                } else {
                    $ReturnObject['Principal'] = $ACL.IdentityReference.Value
                }
                $ReturnObject['FileSystemRights'] = $TranslateRights
                $ReturnObject['IsInherited'] = $ACL.IsInherited
                if ($Extended) {
                    $ReturnObject['InheritanceFlags'] = $ACL.InheritanceFlags
                    $ReturnObject['PropagationFlags'] = $ACL.PropagationFlags
                }
                if ($IncludeACLObject) {
                    $ReturnObject['ACL'] = $ACL
                    $ReturnObject['AllACL'] = $ACLS
                }
                if ($AsHashTable) {
                    $ReturnObject
                } else {
                    [PSCustomObject] $ReturnObject
                }
            }
            $Output
        } else {
            Write-Warning "Get-PSPermissions - Path $Path doesn't exists. Skipping."
        }
    }
}
<#
$Directories = @(
    '\\ad1.ad.evotec.xyz\SYSVOL'
    Get-ChildItem -Path '\\ad1.ad.evotec.xyz\SYSVOL' -Recurse -Directory
)
$Output = foreach ($Directory in $Directories) {
    Get-PSPermissions -Path $Directory -NotInherited
}
$Output | Format-Table -a

#>