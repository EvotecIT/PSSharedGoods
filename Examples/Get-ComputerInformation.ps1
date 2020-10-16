#Win32_PhysicalMemory
#Win32_ComputerSystemProcessor

#Get-CimData -Class 'Win32_SystemUsers'
#Get-CimData -Class 'Win32_ComputerSystemProcessor'
#Get-CimData -Class 'Win32_PhysicalMemory'
#Get-ComputerOperatingSystem

#Get-WmiObject win32_processor | select LoadPercentage  |fl
#Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average

<#

Get-Counter '\Process(*)\% Processor Time' `
    | Select-Object -ExpandProperty countersamples `
    | Select-Object -Property instancename, cookedvalue `
    | Sort-Object -Property cookedvalue -Descending | Select-Object -First 20 `
    | ft InstanceName, @{L = 'CPU'; E = {($_.Cookedvalue / 100).toString('P')}} -AutoSize

#>
#Get-Counter '\Memory\Available MBytes'

#Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average | ft


#$Processor = Get-CimData -Class 'win32_processor' -ComputerName AD1,AD3,AD2,EVO1 | Select-Object PSComputerName, Name, DeviceID, Caption, SystemName, CurrentClockSpeed, MaxClockSpeed, ProcessorID, ThreadCount, Architecture, Status, LoadPercentage, L3CacheSize, Manufacturer, VirtualizationFirmwareEnabled, NumberOfCores, NumberOfEnabledCore, NumberOfLogicalProcessors
#$Processor | ft *


$Classes = Get-CimClass
$Classes[0] #| Select-Object -First 15 | Format-Table -AutoSize NameSpace, CimClassName, CimClassProperties
#Get-ComputerCPU -ComputerName AD1,AD2, AD2019, EVO1 | ft *



<#1
Get-Counter -ListSet *memory* | Select-Object -ExpandProperty  Counter
#>

Function Test-MemoryUsage {
    [cmdletbinding()]
    Param()

    $os = Get-CimInstance Win32_OperatingSystem
    $pctFree = [math]::Round(($os.FreePhysicalMemory / $os.TotalVisibleMemorySize) * 100, 2)

    if ($pctFree -ge 45) {
        $Status = "OK"
    } elseif ($pctFree -ge 15 ) {
        $Status = "Warning"
    } else {
        $Status = "Critical"
    }

    $os | Select-Object @{Name = "Status"; Expression = { $Status } },
    @{Name = "PctFree"; Expression = { $pctFree } },
    @{Name = "FreeGB"; Expression = { [math]::Round($_.FreePhysicalMemory / 1mb, 2) } },
    @{Name = "TotalGB"; Expression = { [int]($_.TotalVisibleMemorySize / 1mb) } }

}

Function Show-MemoryUsage {

    [cmdletbinding()]
    Param()

    #get memory usage data
    $data = Test-MemoryUsage

    Switch ($data.Status) {
        "OK" { $color = "Green" }
        "Warning" { $color = "Yellow" }
        "Critical" { $color = "Red" }
    }

    $title = @"

    Memory Check
    ------------
"@

    Write-Host $title -ForegroundColor Cyan

    $data | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor $color

}


Test-MemoryUsage
Show-MemoryUsage