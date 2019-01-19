function Set-FileInheritance {
    [alias('Set-Inheritance')]
    param(
        [string] $StartingDir,
        [switch] $DisableInheritance,
        [switch] $KeepInheritedAcl
    )
    $acl = get-acl -Path $StartingDir
    $acl.SetAccessRuleProtection($DisableInheritance, $KeepInheritedAcl)
    $acl | Set-Acl -Path $StartingDir
}