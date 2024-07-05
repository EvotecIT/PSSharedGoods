function Set-FilePermission {
    <#
    .SYNOPSIS
    Sets file permissions for a specified user or group on a given path.

    .DESCRIPTION
    This function sets file permissions for a specified user or group on a given path. It allows you to define the type of access control, inheritance flags, and propagation flags.

    .PARAMETER Path
    The path to the file or directory for which permissions need to be set.

    .PARAMETER Principal
    Specifies the user or group for which permissions are being set. Use the format 'domain\username'.

    .PARAMETER InheritedFolderPermissions
    Specifies the inheritance flags for folder permissions. Default values are ContainerInherit and ObjectInherit.

    .PARAMETER AccessControlType
    Specifies the type of access control to be allowed or denied. Default is Allow.

    .PARAMETER PropagationFlags
    Specifies how the access control entries are propagated to child objects. Default is None.

    .PARAMETER AclRightsToAssign
    Specifies the file system rights to assign to the user or group.

    .EXAMPLE
    Set-FilePermission -Path "C:\Example\File.txt" -Principal "domain\username" -AclRightsToAssign "Modify"
    Sets Modify permissions for the user 'domain\username' on the file "File.txt" located at "C:\Example".

    .EXAMPLE
    Set-FilePermission -Path "D:\Data" -Principal "domain\group" -AclRightsToAssign "FullControl" -InheritedFolderPermissions @("ContainerInherit")
    Sets FullControl permissions for the group 'domain\group' on the directory "Data" located at "D:\" with inheritance only for subfolders.

    .NOTES
    File permissions are set using the Set-Acl cmdlet from the System.Security.AccessControl module.
    #>
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
