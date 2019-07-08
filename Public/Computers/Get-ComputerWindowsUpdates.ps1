function Get-ComputerWindowsUpdates {
    param(
        $ComputerName = $Env:COMPUTERNAME
    )

    $Data = Get-hotfix -ComputerName $vComputerName | Select-Object Description , HotFixId , InstalledBy, InstalledOn, Caption
    return $Data
}