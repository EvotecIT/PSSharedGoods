function Test-PortableModuleRequirement {
    <#
    .SYNOPSIS
    Tests a portable-module candidate against version and GUID constraints.
    #>
    param(
        [object] $Module,
        [object] $Requirement
    )

    if ($Requirement.Guid -and $Module.Guid -ne $Requirement.Guid) { return $false }
    if ($Requirement.RequiredVersion -and $Module.Version -ne $Requirement.RequiredVersion) { return $false }
    if ($Requirement.MinimumVersion -and $Module.Version -lt $Requirement.MinimumVersion) { return $false }
    if ($Requirement.MaximumVersion -and $Module.Version -gt $Requirement.MaximumVersion) { return $false }
    $true
}
