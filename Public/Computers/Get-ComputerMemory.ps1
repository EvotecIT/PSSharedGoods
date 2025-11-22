function Get-ComputerMemory {
    <#
    .SYNOPSIS
    Retrieves memory information from specified computers.

    .DESCRIPTION
    This function retrieves memory information from specified computers, including details about physical memory usage, virtual memory usage, and memory percentages.

    .PARAMETER ComputerName
    Specifies the name of the computer(s) to retrieve memory information from. Defaults to the local computer.

    .PARAMETER Protocol
    Specifies the protocol to use for retrieving memory information. Valid values are 'Default', 'Dcom', and 'Wsman'. Defaults to 'Default'.

    .PARAMETER Credential
    Alternate credentials for CIM queries. Default is current user.

    .PARAMETER All
    Switch parameter to retrieve all available memory properties.

    .EXAMPLE
    Get-ComputerMemory -ComputerName "Server01"
    Retrieves memory information from a remote computer named Server01.

    .EXAMPLE
    Get-ComputerMemory -ComputerName "WorkstationA", "WorkstationB" -Protocol Wsman -All
    Retrieves all available memory properties from multiple remote computers using the Wsman protocol.

    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [pscredential] $Credential,
        [switch] $All
    )
    [string] $Class = 'win32_operatingsystem'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string] $Properties = "*"
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Credential $Credential -Class $Class -Properties $Properties
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
