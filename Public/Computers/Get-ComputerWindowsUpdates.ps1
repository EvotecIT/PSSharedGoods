function Get-ComputerWindowsUpdates {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME
    )

    # Get-CimInstance -Class win32_quickfixengineering | Where-Object { $_.InstalledOn -gt (Get-Date).AddMonths(-3) }
    $Data = Get-HotFix -ComputerName $ComputerName | Select-Object Description , HotFixId , InstallDate, InstalledBy, InstalledOn, Caption, PSComputerName, Status, FixComments, ServicePackInEffect, Name, Site, Containerr
    return $Data
}

#$Hotfix = Get-ComputerWindowsUpdates -ComputerName EVOWIN, AD1 #| ft -a *
#$Hotfix | ft -a *
#$Hotfix[0] | fl *

#Get-CimData -Class 'Win32_QuickFixEngineering' -ComputerName EVOWIN,AD1 | ft -AutoSize *