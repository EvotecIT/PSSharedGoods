function Get-Computer {
    <#
    .SYNOPSIS
    Retrieves various information about a computer or server based on specified types.

    .DESCRIPTION
    This function retrieves information about a computer or server based on the specified types. It can gather details about applications, BIOS, CPU, RAM, Disk, Logical Disk, Network, Network Firewall, Operating System, Services, System, Startup, Time, and Windows Updates.

    .PARAMETER ComputerName
    Specifies the name of the computer or server to retrieve information from. Defaults to the local computer.

    .PARAMETER Type
    Specifies the types of information to retrieve. Valid values include 'Application', 'BIOS', 'CPU', 'RAM', 'Disk', 'DiskLogical', 'Network', 'NetworkFirewall', 'OperatingSystem', 'Services', 'System', 'Startup', 'Time', and 'WindowsUpdates'. If not specified, retrieves all available types.

    .PARAMETER Credential
    Alternate credentials passed to all underlying queries.

    .PARAMETER AsHashtable
    Indicates whether to return the output as a hashtable.

    .EXAMPLE
    Get-Computer -ComputerName "Server01" -Type "CPU", "RAM"
    Retrieves CPU and RAM information from a remote server named Server01.

    .EXAMPLE
    Get-Computer -ComputerName "Workstation01" -Type "Application" -AsHashtable
    Retrieves application information from a workstation named Workstation01 and returns the output as a hashtable.

    #>
    [cmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Application',
            'BIOS', 'CPU', 'RAM', 'Disk', 'DiskLogical',
            'Network', 'NetworkFirewall',
            'OperatingSystem', 'Services', 'System', 'Startup', 'Time', 'WindowsUpdates'
        )][string[]] $Type,
        [pscredential] $Credential,
        [switch] $AsHashtable
    )
    Begin {

    }
    Process {
        foreach ($Computer in $ComputerName) {
            $OutputObject = [ordered] @{}
            if ($Type -contains 'Application' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Application for $Computer"
                $Application = Get-ComputerApplication -ComputerName $Computer -Credential $Credential
                $OutputObject['Application'] = $Application
            }
            if ($Type -contains 'BIOS' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing BIOS for $Computer"
                $BIOS = Get-ComputerBios -ComputerName $Computer -Credential $Credential
                $OutputObject['BIOS'] = $BIOS
            }
            if ($Type -contains 'CPU' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing CPU for $Computer"
                $CPU = Get-ComputerCPU -ComputerName $Computer -Credential $Credential
                $OutputObject['CPU'] = $CPU
            }
            if ($Type -contains 'RAM' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing RAM for $Computer"
                $RAM = Get-ComputerRAM -ComputerName $Computer -Credential $Credential
                $OutputObject['RAM'] = $RAM
            }
            if ($Type -contains 'Disk' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Disk for $Computer"
                $Disk = Get-ComputerDisk -ComputerName $Computer -Credential $Credential
                $OutputObject['Disk'] = $Disk
            }
            if ($Type -contains 'DiskLogical' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing DiskLogical for $Computer"
                $DiskLogical = Get-ComputerDiskLogical -ComputerName $Computer -Credential $Credential
                $OutputObject['DiskLogical'] = $DiskLogical
            }
            if ($Type -contains 'OperatingSystem' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing OperatingSystem for $Computer"
                $OperatingSystem = Get-ComputerOperatingSystem -ComputerName $Computer -Credential $Credential
                $OutputObject['OperatingSystem'] = $OperatingSystem
            }
            if ($Type -contains 'Network' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Network for $Computer"
                $Network = Get-ComputerNetwork -ComputerName $Computer -Credential $Credential
                $OutputObject['Network'] = $Network
            }
            if ($Type -contains 'NetworkFirewall' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing NetworkFirewall for $Computer"
                $NetworkFirewall = Get-ComputerNetwork -ComputerName $Computer -Credential $Credential -NetworkFirewallOnly
                $OutputObject['NetworkFirewall'] = $NetworkFirewall
            }
            if ($Type -contains 'RDP' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing RDP for $Computer"
                $RDP = Get-ComputerRDP -ComputerName $Computer -Credential $Credential
                $OutputObject['RDP'] = $RDP
            }
            if ($Type -contains 'Services' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Services for $Computer"
                $Services = Get-ComputerService -ComputerName $Computer -Credential $Credential
                $OutputObject['Services'] = $Services
            }
            if ($Type -contains 'System' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing System for $Computer"
                $System = Get-ComputerSystem -ComputerName $Computer -Credential $Credential
                $OutputObject['System'] = $System
            }
            if ($Type -contains 'Startup' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Startup for $Computer"
                $Startup = Get-ComputerStartup -ComputerName $Computer -Credential $Credential
                $OutputObject['Startup'] = $Startup
            }
            if ($Type -contains 'Time' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Time for $Computer"
                $Time = Get-ComputerTime -TimeTarget $Computer -Credential $Credential
                $OutputObject['Time'] = $Time
            }
            if ($Type -contains 'Tasks' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Tasks for $Computer"
                $Tasks = Get-ComputerTask -ComputerName $Computer -Credential $Credential
                $OutputObject['Tasks'] = $Tasks
            }
            if ($Type -contains 'WindowsUpdates' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing WindowsUpdates for $Computer"
                $WindowsUpdates = Get-ComputerWindowsUpdates -ComputerName $Computer -Credential $Credential
                $OutputObject['WindowsUpdates'] = $WindowsUpdates
            }
            if ($AsHashtable) {
                $OutputObject
            } else {
                [PSCustomObject] $OutputObject
            }
        }
    }
}
