function Set-FileInheritance {
    <#
    .SYNOPSIS
    Sets or removes inheritance for a specified directory.

    .DESCRIPTION
    This function allows you to set or remove inheritance for a specified directory. You can choose to disable inheritance and optionally keep the inherited ACL.

    .PARAMETER StartingDir
    Specifies the directory for which to set or remove inheritance.

    .PARAMETER DisableInheritance
    Switch parameter to disable inheritance for the specified directory.

    .PARAMETER KeepInheritedAcl
    Switch parameter to keep the inherited ACL when disabling inheritance.

    .EXAMPLE
    Set-FileInheritance -StartingDir "C:\Example" -DisableInheritance
    Disables inheritance for the directory "C:\Example".

    .EXAMPLE
    Set-FileInheritance -StartingDir "D:\Data" -DisableInheritance -KeepInheritedAcl
    Disables inheritance for the directory "D:\Data" and keeps the inherited ACL.

    #>
    [cmdletBinding()]
    param(
        [string] $StartingDir,
        [switch] $DisableInheritance,
        [switch] $KeepInheritedAcl
    )
    $acl = Get-Acl -Path $StartingDir
    $acl.SetAccessRuleProtection($DisableInheritance, $KeepInheritedAcl)
    $acl | Set-Acl -Path $StartingDir
}