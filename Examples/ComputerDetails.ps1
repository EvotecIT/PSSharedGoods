Import-Module .\PSSharedGoods.psd1 -Force

$Data = Get-Computer -ComputerName EVOWIN, AD1,AD2 -Verbose
$Data
$Data.RAM

return

New-HTML {
    New-HTMLTableOption -DataStore JavaScript
    New-HTMLTable -DataTable $Data.BIOS -Filtering
    New-HTMLTable -DataTable $Data.CPU -Filtering
    New-HTMLTable -DataTable $Data.RAM -Filtering
    New-HTMLTable -DataTable $Data.Disk -Filtering {
        New-HTMLTableCondition -Name 'FreePercent' -Value 32 -Color Red -ComparisonType number -Operator lt
    }
    New-HTMLTable -DataTable $Data.DiskLogical -Filtering {
        New-HTMLTableCondition -Name 'FreePercent' -Value 32 -Color Red -ComparisonType number -Operator lt
    }
    New-HTMLTable -DataTable $Data.OperatingSystem -Filtering
    New-HTMLTable -DataTable $Data.Services -Filtering
    New-HTMLTable -DataTable $Data.System -Filtering
    New-HTMLTable -DataTable $Data.Time -Filtering
} -Online -FilePath $PSScriptRoot\Reports\ComputerInformation.html -ShowHTML