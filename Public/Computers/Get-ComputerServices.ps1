function Get-ComputerService {
    <#
    .SYNOPSIS
    Retrieves information about services running on specified computers.

    .DESCRIPTION
    This function retrieves information about services running on one or more specified computers. It returns details such as ComputerName, Name, Displayname, Status, and StartType of the services.

    .EXAMPLE
    Get-ComputerServices -ComputerName "Computer01"
    Retrieves information about services running on a single computer named "Computer01".

    .EXAMPLE
    Get-ComputerServices -ComputerName "Computer01", "Computer02"
    Retrieves information about services running on multiple computers named "Computer01" and "Computer02".

    #>
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