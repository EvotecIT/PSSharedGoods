function Get-PortableModuleCandidates {
    <#
    .SYNOPSIS
    Returns installed portable-module versions that satisfy a module requirement.
    #>
    param(
        [string] $RootPath,
        [object] $Requirement
    )

    $ModuleName = $Requirement.Name
    $ModulePath = Join-Path -Path $RootPath -ChildPath $ModuleName
    $ManifestFiles = Get-ChildItem -LiteralPath $ModulePath -Filter "$ModuleName.psd1" -File -Recurse -ErrorAction SilentlyContinue
    $Candidates = foreach ($ManifestFile in $ManifestFiles) {
        try {
            $Manifest = Import-PowerShellDataFile -LiteralPath $ManifestFile.FullName -ErrorAction Stop
            $Version = [version] $Manifest.ModuleVersion
            $Guid = [guid] $Manifest.GUID
        } catch {
            Write-Warning "Initialize-ModulePortable - Ignoring invalid module manifest $($ManifestFile.FullName): $($_.Exception.Message)"
            continue
        }

        $Candidate = [PSCustomObject] @{
            Name            = $ModuleName
            Version         = $Version
            Guid            = $Guid
            Path            = $ManifestFile.FullName
            RequiredModules = @($Manifest.RequiredModules | Where-Object { $null -ne $_ })
        }
        if (-not (Test-PortableModuleRequirement -Module $Candidate -Requirement $Requirement)) {
            continue
        }

        $Candidate
    }

    $Candidates | Sort-Object -Property Version -Descending
}
