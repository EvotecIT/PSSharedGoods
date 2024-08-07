function Get-ComputerCPU {
    <#
    .SYNOPSIS
    Retrieves CPU information from specified computers.

    .DESCRIPTION
    This function retrieves CPU information from the specified computers. It provides details such as Name, DeviceID, Caption, SystemName, CurrentClockSpeed, MaxClockSpeed, ProcessorID, ThreadCount, Architecture, Status, LoadPercentage, L3CacheSize, Manufacturer, NumberOfCores, NumberOfEnabledCore, and NumberOfLogicalProcessors.

    .PARAMETER ComputerName
    Specifies the names of the computers for which to retrieve CPU information.

    .PARAMETER Protocol
    Specifies the protocol to use for retrieving CPU information. Valid values are 'Default', 'Dcom', and 'Wsman'.

    .PARAMETER All
    Indicates whether to retrieve all available CPU information.

    .EXAMPLE
    Get-ComputerCPU -ComputerName Server01, Server02 -Protocol Wsman -All
    Retrieves all available CPU information from remote computers Server01 and Server02 using Wsman protocol.

    .EXAMPLE
    Get-ComputerCPU -ComputerName "Workstation01" -Protocol Default
    Retrieves CPU information from a single remote computer named Workstation01 using the default protocol.

    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All
    )
    [string] $Class = 'win32_processor'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = 'PSComputerName', 'Name', 'DeviceID', 'Caption', 'SystemName', 'CurrentClockSpeed', 'MaxClockSpeed', 'ProcessorID', 'ThreadCount', 'Architecture', 'Status', 'LoadPercentage', 'L3CacheSize', 'Manufacturer', 'VirtualizationFirmwareEnabled', 'NumberOfCores', 'NumberOfEnabledCore', 'NumberOfLogicalProcessors'

    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                [PSCustomObject] @{
                    ComputerName                  = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Name                          = $Data.Name
                    DeviceID                      = $Data.DeviceID
                    Caption                       = $Data.Caption
                    CurrentClockSpeed             = $Data.CurrentClockSpeed
                    MaxClockSpeed                 = $Data.MaxClockSpeed
                    ProcessorID                   = $Data.ProcessorID
                    ThreadCount                   = $Data.ThreadCount
                    Architecture                  = $Data.Architecture
                    Status                        = $Data.Status
                    LoadPercentage                = $Data.LoadPercentage
                    Manufacturer                  = $Data.Manufacturer
                    #VirtualizationFirmwareEnabled = $Data.VirtualizationFirmwareEnabled
                    NumberOfCores                 = $Data.NumberOfCores
                    NumberOfEnabledCore           = $Data.NumberOfEnabledCore
                    NumberOfLogicalProcessors     = $Data.NumberOfLogicalProcessors    
                }
            }
        }
    }
}


#get-counter -Counter '\Processor(*)\% Processor Time' -SampleInterval 1 -MaxSamples 3 | select -ExpandProperty countersamples | select -ExpandProperty cookedvalue | Measure-Object -Average | select -ExpandProperty Average