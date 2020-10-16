function Get-Computer {
    [cmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('BIOS', 'CPU', 'RAM', 'Disk', 'DiskLogical', 'OperatingSystem', 'Services', 'System', 'Time')][string[]] $Type,
        [switch] $AsHashtable
    )
    Begin {

    }
    Process {
        foreach ($Computer in $ComputerName) {
            $OutputObject = [ordered] @{}
            if ($Type -contains 'BIOS' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing BIOS for $Computer"
                $BIOS = Get-ComputerBios -ComputerName $Computer
                $OutputObject['BIOS'] = $BIOS
            }
            if ($Type -contains 'CPU' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing CPU for $Computer"
                $CPU = Get-ComputerCPU -ComputerName $Computer
                $OutputObject['CPU'] = $CPU
            }
            if ($Type -contains 'RAM' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing RAM for $Computer"
                $RAM = Get-ComputerRAM -ComputerName $Computer
                $OutputObject['RAM'] = $RAM
            }
            if ($Type -contains 'Disk' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Disk for $Computer"
                $Disk = Get-ComputerDisk -ComputerName $Computer
                $OutputObject['Disk'] = $Disk
            }
            if ($Type -contains 'DiskLogical' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing DiskLogical for $Computer"
                $DiskLogical = Get-ComputerDiskLogical -ComputerName $Computer
                $OutputObject['DiskLogical'] = $DiskLogical
            }
            if ($Type -contains 'OperatingSystem' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing OperatingSystem for $Computer"
                $OperatingSystem = Get-ComputerOperatingSystem -ComputerName $Computer
                $OutputObject['OperatingSystem'] = $OperatingSystem
            }
            if ($Type -contains 'Services' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Services for $Computer"
                $Services = Get-ComputerService -ComputerName $Computer
                $OutputObject['Services'] = $Services
            }
            if ($Type -contains 'System' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing System for $Computer"
                $System = Get-ComputerSystem -ComputerName $Computer
                $OutputObject['System'] = $System
            }
            if ($Type -contains 'Time' -or $null -eq $Type) {
                Write-Verbose "Get-Computer - Processing Time for $Computer"
                $Time = Get-ComputerTime -TimeTarget $Computer
                $OutputObject['Time'] = $Time
            }
            if ($AsHashtable) {
                $OutputObject
            } else {
                [PSCustomObject] $OutputObject
            }
        }
    }
}