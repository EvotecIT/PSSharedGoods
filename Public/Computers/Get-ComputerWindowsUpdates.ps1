function Get-ComputerWindowsUpdates {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .EXAMPLE
    $Hotfix = Get-ComputerWindowsUpdates -ComputerName EVOWIN, AD1
    $Hotfix | ft -a *
    $Hotfix[0] | fl *

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME
    )
    foreach ($Computer in $ComputerName) {
        try {
            $Data = Get-HotFix -ComputerName $Computer
            $Output = foreach ($Update in $Data) {
                [PSCustomObject] @{
                    ComputerName = $Computer
                    InstalledOn  = $Update.InstalledOn
                    Description  = $Update.Description
                    KB           = $Update.HotFixId
                    InstalledBy  = $Update.InstalledBy
                    Caption      = $Update.Caption
                }
            }
            $Output | Sort-Object -Descending InstalledOn
        } catch {
            Write-Warning -Message "Get-ComputerWindowsUpdates - No data for computer $($Computer). Failed with errror: $($_.Exception.Message)"
        }
    }
}