Import-Module .\PSsharedGoods.psd1 -Force



function Get-ComputerAll {
    [cmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME
    )
    Begin {

    }
    Process {
        foreach ($Computer in $ComputerName) {
            $BIOS = Get-ComputerBios -ComputerName $Computer
            $CPU = Get-ComputerCPU -ComputerName $Computer
            $Disk = Get-ComputerDisk -ComputerName $Disk
            $DiskLogical = Get-ComputerDiskLogical -ComputerName $Computer
            $OperatingSystem = Get-ComputerOperatingSystem -ComputerName $Computer
            $System = Get-ComputerSystem -ComputerName $Computer
            $Services = Get-ComputerService -ComputerName $Computer
            $Time = Get-ComputerTime -TimeTarget $Computer

            [ordered] @{
                BIOS            = $BIOS
                CPU             = $CPU
                Disk            = $Disk
                DiskLogical     = $DiskLogical
                OperatingSystem = $OperatingSystem
                Services        = $Services
                System          = $System
                Time            = $Time
            }
        }
    }
}

$Data = Get-ComputerAll
$Data

New-HTML {
    New-HTMLTable -DataTable $Data.BIOS -Filtering
    New-HTMLTable -DataTable $Data.CPU -Filtering
    New-HTMLTable -DataTable $Data.Disk -Filtering
    New-HTMLTable -DataTable $Data.DiskLogical -Filtering
    New-HTMLTable -DataTable $Data.OperatingSystem -Filtering
    New-HTMLTable -DataTable $Data.Services -Filtering
    New-HTMLTable -DataTable $Data.System -Filtering
    New-HTMLTable -DataTable $Data.Time -Filtering
} -Online -FilePath $Env:USERPROFILE\Desktop\ComputerInformation.html -ShowHTML