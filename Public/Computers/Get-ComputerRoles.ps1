function Get-ComputerRoles {
    <#
    .SYNOPSIS
    Get Computer/Server Roles

    .DESCRIPTION
    Get Computer/Server Roles

    .PARAMETER ComputerName
    Parameter description

    .PARAMETER FeatureType
    Display all or limited types. Choices are Role, Role Service and Feature.

    .PARAMETER EnabledOnly
    Display only enabled/installed features or roles

    .EXAMPLE
    Get-ComputerRoles -ComputerName AD1 -EnabledOnly -FeatureType Role | Format-Table

    .NOTES
    General notes
    #>
    [alias('Get-ServerRoles')]
    [CmdletBinding()]
    param (
        [string[]] $ComputerName = $env:COMPUTERNAME,
        [ValidateSet('Role', 'Role Service', 'Feature')] $FeatureType,
        [switch] $EnabledOnly
    )
    if ($Global:ProgressPreference -ne 'SilentlyContinue') {
        $TemporaryProgress = $Global:ProgressPreference
        $Global:ProgressPreference = 'SilentlyContinue'
    }
    foreach ($Computer in $ComputerName) {
        $Output = Get-WindowsFeature -ComputerName $Computer
        #$ | Where-Object { $_.installed -eq $true -and $_.featuretype -eq 'Role' } | Select-Object name, installed -ExcludeProperty subfeatures
        #$Output | Select-Object Name, Installed , @{name = 'Server Name'; expression = { $Computer } }
        foreach ($Data in $Output) {
            if ($EnabledOnly -and $Data.Installed -eq $false) {
                continue
            }
            if ($FeatureType) {
                if ($Data.FeatureType -notin $FeatureType) {
                    continue
                }
            }
            [PSCustomObject] @{
                ComputerName = $Computer
                Name         = $Data.Name
                DisplayName  = $Data.DisplayName
                FeatureType  = $Data.FeatureType
                Installed    = $Data.Installed
                #MajorVersion = $Data.AdditionalInfo.MajorVersion
                #MinorVersion = $Data.AdditionalInfo.MinorVersion
                #InstallName  = $Data.AdditionalInfo.InstallName
                #SubFeatures  = $Data.SubFeatures
                Description  = $Data.Description
            }
        }
    }
    # Bring back setting as per default
    if ($TemporaryProgress) {
        $Global:ProgressPreference = $TemporaryProgress
    }
}