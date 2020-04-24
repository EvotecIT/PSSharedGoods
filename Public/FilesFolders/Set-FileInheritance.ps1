function Set-FileInheritance {
    [cmdletBinding()]
    param(
        [string] $StartingDir,
        [switch] $DisableInheritance,
        [switch] $KeepInheritedAcl
    )
    $acl = get-acl -Path $StartingDir
    $acl.SetAccessRuleProtection($DisableInheritance, $KeepInheritedAcl)
    $acl | Set-Acl -Path $StartingDir
}