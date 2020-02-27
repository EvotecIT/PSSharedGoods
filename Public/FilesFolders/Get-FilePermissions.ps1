function Get-FilePermissions {
    [alias('Get-PSPermissions')]
    [cmdletBinding()]
    param(
        [string[]] $ComputerName,
        [Array] $Path,
        [switch] $Inherited,
        [switch] $NotInherited
    )
    [Array] $LiteralPath = foreach ($_ in $Path) {
        if ($Path[0] -is [System.IO.FileSystemInfo]) {
            $Path.FullName
        } elseif ($Path[0] -is [string]) {
            $Path
        }
    }
    foreach ($FullPath in $LiteralPath) {
        $TestPath = Test-Path -Path $FullPath
        if ($TestPath) {
            $ACLS = (Get-Acl -Path $FullPath).Access

            $Output = foreach ($ACL in $ACLS) {
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
                if ($ACL.IdentityReference -like '*\*') {
                    if ($ResolveTypes -and $Script:ForestCache ) {
                        $TemporaryIdentity = $Script:ForestCache["$($ACL.IdentityReference)"]
                        $IdentityReferenceType = $TemporaryIdentity.ObjectClass
                        $IdentityReference = $ACL.IdentityReference.Value
                    } else {
                        $IdentityReferenceType = ''
                        $IdentityReference = $ACL.IdentityReference.Value
                    }
                } elseif ($ACL.IdentityReference -like '*-*-*-*') {
                    $ConvertedSID = ConvertFrom-SID -sid $ACL.IdentityReference
                    if ($ResolveTypes -and $Script:ForestCache) {
                        $TemporaryIdentity = $Script:ForestCache["$($ConvertedSID.Name)"]
                        $IdentityReferenceType = $TemporaryIdentity.ObjectClass
                    } else {
                        $IdentityReferenceType = ''
                    }
                    $IdentityReference = $ConvertedSID.Name
                } else {
                    $IdentityReference = $ACL.IdentityReference
                    $IdentityReferenceType = 'Unknown'
                }
                $ReturnObject = [ordered] @{ }
                $ReturnObject['Path' ] = $FullPath
                $ReturnObject['AccessControlType'] = $ACL.AccessControlType
                $ReturnObject['Principal'] = $IdentityReference
                if ($ResolveTypes) {
                    $ReturnObject['PrincipalType'] = $IdentityReferenceType
                }
                #$ReturnObject['ObjectTypeName'] = $Script:ForestGUIDs["$($ACL.objectType)"]
                #$ReturnObject['InheritedObjectTypeName'] = $Script:ForestGUIDs["$($ACL.inheritedObjectType)"]
                $ReturnObject['FileSystemRights'] = $TranslateRights
                #$ReturnObject['FileSystemRights'] = $ACL.FileSystemRights
                # $ReturnObject['InheritanceType'] = $ACL.InheritanceType
                $ReturnObject['IsInherited'] = $ACL.IsInherited

                if ($Extended) {
                    $ReturnObject['ObjectType'] = $ACL.ObjectType
                    $ReturnObject['InheritedObjectType'] = $ACL.InheritedObjectType
                    $ReturnObject['ObjectFlags'] = $ACL.ObjectFlags
                    $ReturnObject['InheritanceFlags'] = $ACL.InheritanceFlags
                    $ReturnObject['PropagationFlags'] = $ACL.PropagationFlags
                }
                [PSCustomObject] $ReturnObject
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