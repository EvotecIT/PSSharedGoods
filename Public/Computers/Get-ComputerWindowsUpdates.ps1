function Get-ComputerWindowsUpdates {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )

    $Data = Get-HotFix -ComputerName $vComputerName | Select-Object Description , HotFixId , InstalledBy, InstalledOn, Caption
    return $Data
}