function Initialize-ModulePortable {
    <#
    .SYNOPSIS
    Initializes a portable module by downloading or importing it along with its required modules.

    .DESCRIPTION
    This function initializes a portable module by either downloading it from the PowerShell Gallery or importing it from a specified path. It also recursively loads any required modules for the primary module.

    .PARAMETER Name
    Specifies the name of the module to initialize.

    .PARAMETER Path
    Specifies the path where the module will be downloaded or imported. Defaults to the current script root.

    .PARAMETER Download
    Switch to indicate whether to download the module from the PowerShell Gallery.

    .PARAMETER Import
    Switch to indicate whether to import the module from the specified path.

    .EXAMPLE
    Initialize-ModulePortable -Name "MyModule" -Download
    Downloads the module named "MyModule" from the PowerShell Gallery.

    .EXAMPLE
    Initialize-ModulePortable -Name "MyModule" -Path "C:\Modules" -Import
    Imports the module named "MyModule" from the specified path "C:\Modules".

    #>
    [CmdletBinding()]
    param(
        [alias('ModuleName')][string] $Name,
        [string] $Path = $PSScriptRoot,
        [switch] $Download,
        [switch] $Import
    )
    function Get-PortableModuleCandidates {
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

    function Get-PortableModuleRequirement {
        param(
            [object] $RequiredModule
        )

        if ($RequiredModule -is [string]) {
            return [PSCustomObject] @{
                Name            = $RequiredModule
                MinimumVersion  = $null
                RequiredVersion = $null
                MaximumVersion  = $null
                Guid            = $null
            }
        }

        $MinimumVersion = if ($RequiredModule.ModuleVersion) { [version] $RequiredModule.ModuleVersion } else { $null }
        $RequiredVersion = if ($RequiredModule.RequiredVersion) { [version] $RequiredModule.RequiredVersion } else { $null }
        $MaximumVersion = if ($RequiredModule.MaximumVersion) { [version] $RequiredModule.MaximumVersion } else { $null }
        $Guid = if ($RequiredModule.GUID) { [guid] $RequiredModule.GUID } else { $null }
        [PSCustomObject] @{
            Name            = $RequiredModule.ModuleName
            MinimumVersion  = $MinimumVersion
            RequiredVersion = $RequiredVersion
            MaximumVersion  = $MaximumVersion
            Guid            = $Guid
        }
    }

    function Test-PortableModuleRequirement {
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

    function Resolve-PortableModuleGraph {
        param(
            [object[]] $Requirements,
            [System.Collections.IDictionary] $SelectedModules
        )

        if ($Requirements.Count -eq 0) {
            $OrderedManifests = [System.Collections.Generic.List[string]]::new()
            $Ordered = Add-PortableModuleInDependencyOrder -ModuleName $Name -SelectedModules $SelectedModules -VisitingModules @{} -VisitedModules @{} -OrderedManifests $OrderedManifests
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
            return Resolve-PortableModuleGraph -Requirements $RemainingRequirements -SelectedModules $SelectedModules
        }

        $Candidates = @(Get-PortableModuleCandidates -RootPath $Path -Requirement $Requirement)
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

            $BranchResult = Resolve-PortableModuleGraph -Requirements (@($DependencyRequirements) + $RemainingRequirements) -SelectedModules $BranchModules
            if ($BranchResult) {
                return $BranchResult
            }
        }

        $null
    }

    function Add-PortableModuleInDependencyOrder {
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

    if (-not $Name) {
        Write-Warning "Initialize-ModulePortable - Module name not given. Terminating."
        return
    }
    if (-not $Download -and -not $Import) {
        Write-Warning "Initialize-ModulePortable - Please choose Download/Import switch. Terminating."
        return
    }

    if ([string]::IsNullOrWhiteSpace($Path)) {
        $Path = $PSScriptRoot
    }
    try {
        $Provider = $null
        $Drive = $null
        $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path, [ref] $Provider, [ref] $Drive)
        if ($Provider.Name -ne 'FileSystem') {
            Write-Warning "Initialize-ModulePortable - Path must use the FileSystem provider."
            return
        }
        $Path = [System.IO.Path]::GetFullPath($Path)
    } catch {
        Write-Warning "Initialize-ModulePortable - Invalid path $Path. $($_.Exception.Message)"
        return
    }

    if ($Download) {
        try {
            if (-not (Test-Path -LiteralPath $Path)) {
                $null = New-Item -ItemType Directory -Path $Path -Force
            }
            $WarningData = $null
            Save-Module -Name $Name -LiteralPath $Path -Force -WarningVariable WarningData -WarningAction SilentlyContinue -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message

            if ($WarningData) {
                Write-Warning "Initialize-ModulePortable - $WarningData"
            }
            Write-Warning "Initialize-ModulePortable - Error $ErrorMessage"
            return
        }
    }

    if ($Download -or $Import) {
        $RootRequirement = [PSCustomObject] @{
            Name            = $Name
            MinimumVersion  = $null
            RequiredVersion = $null
            MaximumVersion  = $null
            Guid            = $null
        }
        $ResolvedGraph = Resolve-PortableModuleGraph -Requirements @($RootRequirement) -SelectedModules @{}
        if (-not $ResolvedGraph) {
            Write-Warning "Initialize-ModulePortable - Unable to resolve a compatible dependency graph for module $Name in $Path."
            return
        }

        [Array] $PSD1Files = $ResolvedGraph.OrderedManifests
    }
    if ($Download) {
        $DirectorySeparators = [char[]] @([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
        $PortableRoot = $Path.TrimEnd($DirectorySeparators) + [System.IO.Path]::DirectorySeparatorChar
        $ListFiles = foreach ($PSD1 in $PSD1Files) {
            $ManifestPath = [System.IO.Path]::GetFullPath($PSD1)
            if (-not $ManifestPath.StartsWith($PortableRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
                Write-Warning "Initialize-ModulePortable - Module manifest $ManifestPath is outside portable path $Path."
                return
            }
            $ManifestPath.Substring($PortableRoot.Length).Replace('\', '/')
        }
        # Build File
        $Content = @(
            '$Modules = @('
            foreach ($_ in $ListFiles) {
                $RelativePath = $_.Replace("'", "''")
                "    Join-Path -Path `$PSScriptRoot -ChildPath '$RelativePath'"
            }
            ')'
            "foreach (`$_ in `$Modules) {"
            "    Import-Module `$_ -Verbose:`$false -Force"
            "}"
        )
        $Content | Set-Content -LiteralPath (Join-Path -Path $Path -ChildPath "$Name.ps1") -Force
    }
    if ($Import) {
        $ListFiles = foreach ($PSD1 in $PSD1Files) {
            $PSD1
        }
        foreach ($_ in $ListFiles) {
            Import-Module $_ -Verbose:$false -Force
        }
    }
}

#Initialize-ModulePortable -Name 'Testimo' -Path $Env:USERPROFILE\Desktop\TestimoPortable -Verbose -Download -Import

#Initialize-ModulePortable -Name 'SqlServer' -Path $Env:USERPROFILE\Desktop\SqlServer -Verbose -Download #-Import
