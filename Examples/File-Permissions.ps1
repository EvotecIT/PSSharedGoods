$Path = "F:\Shares\PersonalTesting"

function Find-AndFixFolders {
    param(
        $Path
    )
    $folders = Get-ChildItem -Path $path -Directory | Select-Object Name, FullName
    foreach ($folder in $folders) {
        Set-FileInheritance $folder.FullName -DisableInheritance # -KeepInheritedAcl
        #Remove-FilePermission $folder.FullName -UserOrGroup "Domain\srv.pklys"
        #Remove-FilePermission $folder.FullName -All
        Set-FilePermission $folder.FullName -UserOrGroup "Domain\$($folder.Name)" -AclRightsToAssign "ReadAndExecute"
        Set-FilePermission $folder.FullName -UserOrGroup "Domain\Domain Admins" -AclRightsToAssign "FullControl"
        Set-FilePermission $folder.FullName -UserOrGroup "BUILTIN\Administrators" -AclRightsToAssign "FullControl"
        Set-FilePermission $folder.FullName -UserOrGroup "BUILTIN\Administrators" -AclRightsToAssign "FullControl"
        Set-FilePermission $folder.FullName -UserOrGroup "SYSTEM" -AclRightsToAssign "FullControl"
        Set-FilePermission $folder.FullName -UserOrGroup "Domain\domain.pklys" -AclRightsToAssign "FullControl"
        Remove-FilePermission $folder.FullName -UserOrGroup "BUILTIN\Users"
    }
}

Find-AndFixFolders -Path $Path