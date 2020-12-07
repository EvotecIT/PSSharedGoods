function Get-ComputerApplication {
    <#
    .SYNOPSIS
    Get software installed on computer or server

    .DESCRIPTION
    Get software installed on computer or server

    .PARAMETER ComputerName
    Specifies computer on which you want to run the operation.

    .EXAMPLE
    Get-ComputerApplications -Verbose | Format-Table

    .EXAMPLE
    Get-ComputerApplications -Verbose -ComputerName AD1, AD2 | Format-Table

    .NOTES
    General notes
    #>
    [alias('Get-ComputerApplications')]
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME
    )
    $ScriptBlock = {
        $objapp1 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
        $objapp2 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*

        $app1 = $objapp1 | Select-Object Displayname, Displayversion , Publisher, Installdate, @{Expression = { 'x64' }; Label = 'WindowsType' }
        $app2 = $objapp2 | Select-Object Displayname, Displayversion , Publisher, Installdate, @{Expression = { 'x86' }; Label = 'WindowsType' } | Where-Object { -NOT (([string]$_.displayname).contains('Security Update for Microsoft') -or ([string]$_.displayname).contains('Update for Microsoft')) }
        $app = $app1 + $app2 #| Sort-Object -Unique
        $app | Where-Object { $null -ne $_.Displayname } #| Sort-Object DisplayName
    }
    foreach ($Computer in $ComputerName) {
        try {
            $LocalComputerDNSName = [System.Net.Dns]::GetHostByName($Env:COMPUTERNAME).HostName
        } catch {
            $LocalComputerDNSName = $Computer
        }

        if ($Computer -eq $Env:COMPUTERNAME -or $Computer -eq $LocalComputerDNSName) {
            $Parameters = @{
                ScriptBlock = $ScriptBlock
            }
        } else {
            $Parameters = @{
                ComputerName = $Computer
                ScriptBlock  = $ScriptBlock
            }
        }
        try {
            $Data = Invoke-Command @Parameters
        } catch {
            Write-Warning "Get-ComputerApplications - No data for computer $Computer"
            continue
        }
        foreach ($Information in $Data) {
            if ($Information.Installdate) {
                try {
                    $InstallDate = [datetime]::ParseExact($Information.Installdate, 'yyyyMMdd', $null)
                } catch {
                    Write-Verbose "Get-ComputerApplications - InstallDate $($Information.Installdate) couldn't be converted."
                    $InstallDate = $null
                }
            } else {
                $InstallDate = $null
            }
            [PSCustomObject] @{
                DisplayName  = $Information.DisplayName
                Version      = $Information.DisplayVersion
                Publisher    = $Information.Publisher
                Installdate  = $InstallDate
                Type         = $Information.WindowsType
                ComputerName = $Computer
            }
        }
    }
}