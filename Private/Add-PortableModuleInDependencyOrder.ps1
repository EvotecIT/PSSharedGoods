function Add-PortableModuleInDependencyOrder {
    <#
    .SYNOPSIS
    Adds selected portable modules to a dependency-first manifest list.
    #>
    param(
        [string] $ModuleName,
        [System.Collections.IDictionary] $SelectedModules,
        [System.Collections.IDictionary] $VisitingModules,
        [System.Collections.IDictionary] $VisitedModules,
        [System.Collections.Generic.List[string]] $OrderedManifests
    )

    if ($VisitedModules.Contains($ModuleName)) {
        return $true
    }
    if ($VisitingModules.Contains($ModuleName)) {
        return $false
    }

    $VisitingModules[$ModuleName] = $true
    $Module = $SelectedModules[$ModuleName]
    foreach ($RequiredModule in $Module.RequiredModules) {
        $Requirement = Get-PortableModuleRequirement -RequiredModule $RequiredModule
        if (-not $Requirement.Name -or -not $SelectedModules.Contains($Requirement.Name)) {
            return $false
        }
        if (-not (Add-PortableModuleInDependencyOrder -ModuleName $Requirement.Name -SelectedModules $SelectedModules -VisitingModules $VisitingModules -VisitedModules $VisitedModules -OrderedManifests $OrderedManifests)) {
            return $false
        }
    }

    $VisitingModules.Remove($ModuleName)
    $VisitedModules[$ModuleName] = $true
    $null = $OrderedManifests.Add($Module.Path)
    $true
}
