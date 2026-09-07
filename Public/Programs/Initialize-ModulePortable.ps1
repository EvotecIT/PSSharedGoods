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
        $ResolvedGraph = Resolve-PortableModuleGraph -Requirements @($RootRequirement) -SelectedModules @{} -RootModuleName $Name -RootPath $Path
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
