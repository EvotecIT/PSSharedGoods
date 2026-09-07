function Resolve-PortableModuleGraph {
    <#
    .SYNOPSIS
    Resolves a compatible portable-module dependency graph with backtracking.
    #>
    param(
        [object[]] $Requirements,
        [System.Collections.IDictionary] $SelectedModules,
        [string] $RootModuleName,
        [string] $RootPath
    )

    if ($Requirements.Count -eq 0) {
        $OrderedManifests = [System.Collections.Generic.List[string]]::new()
        $Ordered = Add-PortableModuleInDependencyOrder -ModuleName $RootModuleName -SelectedModules $SelectedModules -VisitingModules @{} -VisitedModules @{} -OrderedManifests $OrderedManifests
        if (-not $Ordered) {
            return $null
        }
        return [PSCustomObject] @{
            Modules          = $SelectedModules
            OrderedManifests = $OrderedManifests.ToArray()
        }
    }

    $Requirement = $Requirements[0]
    $RemainingRequirements = if ($Requirements.Count -gt 1) { @($Requirements[1..($Requirements.Count - 1)]) } else { @() }
    if ($SelectedModules.Contains($Requirement.Name)) {
        if (-not (Test-PortableModuleRequirement -Module $SelectedModules[$Requirement.Name] -Requirement $Requirement)) {
            return $null
        }
        return Resolve-PortableModuleGraph -Requirements $RemainingRequirements -SelectedModules $SelectedModules -RootModuleName $RootModuleName -RootPath $RootPath
    }

    $Candidates = @(Get-PortableModuleCandidates -RootPath $RootPath -Requirement $Requirement)
    foreach ($Candidate in $Candidates) {
        $BranchModules = $SelectedModules.Clone()
        $BranchModules[$Requirement.Name] = $Candidate
        $DependencyRequirements = foreach ($RequiredModule in $Candidate.RequiredModules) {
            $DependencyRequirement = Get-PortableModuleRequirement -RequiredModule $RequiredModule
            if (-not $DependencyRequirement.Name) {
                continue
            }
            $DependencyRequirement
        }
        if (@($DependencyRequirements).Count -ne $Candidate.RequiredModules.Count) {
            continue
        }

        $BranchResult = Resolve-PortableModuleGraph -Requirements (@($DependencyRequirements) + $RemainingRequirements) -SelectedModules $BranchModules -RootModuleName $RootModuleName -RootPath $RootPath
        if ($BranchResult) {
            return $BranchResult
        }
    }

    $null
}
