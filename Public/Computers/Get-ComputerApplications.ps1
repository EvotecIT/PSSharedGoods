function Get-ComputerApplications {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    try {
        $LocalComputerDNSName = [System.Net.Dns]::GetHostByName($Env:COMPUTERNAME).HostName
    } catch {
        $LocalComputerDNSName = $ComputerName
    }

    if ($ComputerName -eq $Env:COMPUTERNAME -or $ComputerName -eq $LocalComputerDNSName) {
        $Parameters = @{ }
    } else {
        $Parameters = @{
            ComputerName = $ComputerName
        }
    }

    $ScriptBlock = {
        $objapp1 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
        $objapp2 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*

        $app1 = $objapp1 | Select-Object Displayname, Displayversion , Publisher, Installdate, @{Expression = { 'x64' }; Label = "WindowsType" }
        $app2 = $objapp2 | Select-Object Displayname, Displayversion , Publisher, Installdate, @{Expression = { 'x86' }; Label = "WindowsType" } | Where-Object { -NOT (([string]$_.displayname).contains("Security Update for Microsoft") -or ([string]$_.displayname).contains("Update for Microsoft")) }
        $app = $app1 + $app2 #| Sort-Object -Unique
        return $app | Where-Object { $null -ne $_.Displayname } | Sort-Object DisplayName
    }
    try {
        $Data = Invoke-Command @Parameters -ScriptBlock $ScriptBlock -ArgumentList $ComputerName
        foreach ($_ in $Data) {
            Add-Member -InputObject $_ -MemberType NoteProperty -Name 'ComputerName' -Value $ComputerName -Force
        }
        return $Data | Select-Object -Property Displayname, DisplayVersion , Publisher, Installdate, WindowsType, 'ComputerName'
    } catch {
        Write-Warning "Get-ComputerApplications - No data for computer $ComputerName"
        return
    }
}