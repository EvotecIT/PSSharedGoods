function Get-PortableModuleRequirement {
    <#
    .SYNOPSIS
    Normalizes a PowerShell module dependency declaration for portable resolution.
    #>
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
