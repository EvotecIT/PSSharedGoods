function Set-FilePermission {
    [cmdletBinding()]
    param (
        [string] $Path,
        [alias('UserOrGroup')][string] $Principal,
        [System.Security.AccessControl.InheritanceFlags] $InheritedFolderPermissions = @(
            [System.Security.AccessControl.InheritanceFlags]::ContainerInherit,
            [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
        ),
        [System.Security.AccessControl.AccessControlType] $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow,
        [System.Security.AccessControl.PropagationFlags] $PropagationFlags = [System.Security.AccessControl.PropagationFlags]::None,
        [System.Security.AccessControl.FileSystemRights] $AclRightsToAssign
    )
    ### The possible values for Rights are:
    # ListDirectory, ReadData, WriteData, CreateFiles, CreateDirectories, AppendData, Synchronize, FullControl
    # ReadExtendedAttributes, WriteExtendedAttributes, Traverse, ExecuteFile, DeleteSubdirectoriesAndFiles, ReadAttributes
    # WriteAttributes, Write, Delete, ReadPermissions, Read, ReadAndExecute, Modify, ChangePermissions, TakeOwnership

    ### Principal expected
    # domain\username

    ### Inherited folder permissions:
    # Object inherit    - This folder and files. (no inheritance to subfolders)
    # Container inherit - This folder and subfolders.
    # Inherit only      - The ACE does not apply to the current file/directory

    if ($Principal) {
        $User = [System.Security.Principal.NTAccount]::new($Principal)

        #define a new access rule.
        $ACL = Get-Acl -Path $Path
        <#
        System.Security.AccessControl.FileSystemAccessRule new(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AccessControlType type)
        System.Security.AccessControl.FileSystemAccessRule new(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AccessControlType type)
        System.Security.AccessControl.FileSystemAccessRule new(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type)
        System.Security.AccessControl.FileSystemAccessRule new(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type)
        #>

        $Rule = [System.Security.AccessControl.FileSystemAccessRule]::new($User, $AclRightsToAssign, $InheritedFolderPermissions, $PropagationFlags, $AccessControlType)
        $ACL.SetAccessRule($Rule)
        Try {
            Set-Acl -Path $Path -AclObject $ACL
        } catch {
            Write-Warning "Set-FilePermission - Setting permission $AclRightsToAssign failed with error: $($_.Exception.Message)"
        }
    }
}
