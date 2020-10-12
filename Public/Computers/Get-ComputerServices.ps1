function Get-ComputerService {
    [alias('Get-ComputerServices')]
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME
    )
    Process {
        foreach ($Computer in $ComputerName) {
            $Services = Get-PSService -ComputerName $Computer | Select-Object ComputerName, Name, Displayname, Status, StartType
            $Services
        }
    }
}