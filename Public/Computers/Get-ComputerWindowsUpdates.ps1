function Get-ComputerWindowsUpdates {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )

    # Get-CimInstance -Class win32_quickfixengineering | Where-Object { $_.InstalledOn -gt (Get-Date).AddMonths(-3) }
    $Data = Get-HotFix -ComputerName $vComputerName | Select-Object Description , HotFixId , InstalledBy, InstalledOn, Caption
    return $Data
}