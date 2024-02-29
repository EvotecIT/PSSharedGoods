function Get-ComputerMemory {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_operatingsystem'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string] $Properties = "*"
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Data in $Information) {
            $FreeMB = [math]::Round($Data.FreePhysicalMemory / 1024, 2)
            $TotalMB = [math]::Round($Data.TotalVisibleMemorySize / 1024, 2)
            $UsedMB = $TotalMB - $FreeMB
            $UsedPercent = [math]::Round(($UsedMB / $TotalMB) * 100, 2)
            $FreeVirtualMB = [math]::Round($Data.FreeVirtualMemory / 1024, 2)
            $TotalVirtualMB = [math]::Round($Data.TotalVirtualMemorySize / 1024, 2)
            $UsedVirtualMB = $TotalVirtualMB - $FreeVirtualMB
            $UsedVirtualPercent = [math]::Round(($UsedVirtualMB / $TotalVirtualMB) * 100, 2)

            [PSCustomObject] @{
                ComputerName                = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                MemoryUsed                  = $UsedMB
                MemoryFree                  = $FreeMB
                MemoryTotal                 = $TotalMB
                MemoryUsedPercentage        = $UsedPercent
                VirtualMemoryUsed           = $UsedVirtualMB
                VirtualMemoryUsedPercentage = $UsedVirtualPercent
                VirtualMemoryFree           = $FreeVirtualMB
                VirtualMemoryTotal          = $TotalVirtualMB
            }
        }
    }
}

#Get-ComputerMemory -ComputerName AD0, AD1 | Format-Table *