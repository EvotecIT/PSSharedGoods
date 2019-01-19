function Set-FilePermission {
    [alias('Set-Permission')]
    param (
        [string] $StartingDir,
        [string] $UserOrGroup = "",
        $InheritedFolderPermissions = "ContainerInherit, ObjectInherit",
        [string] $AccessControlType = "Allow",
        [string] $PropagationFlags = "None",
        $AclRightsToAssign
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

    #define a new access rule.
    $acl = Get-Acl -Path $StartingDir
    $perm = $UserOrGroup, $AclRightsToAssign, $InheritedFolderPermissions, $PropagationFlags, $AccessControlType
    $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
    $acl.SetAccessRule($rule)
    set-acl -Path $StartingDir $acl
}
