function Get-CimData {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .PARAMETER Protocol
    Parameter description

    .PARAMETER Class
    Parameter description

    .PARAMETER Properties
    Parameter description

    .EXAMPLE
    Get-CimData -Class 'win32_bios' -ComputerName AD1,EVOWIN

    Get-CimData -Class 'win32_bios'

    # Get-CimClass to get all classes

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [parameter(Mandatory)][string] $Class,
        [string] $NameSpace = 'root\cimv2',
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [string[]] $Properties = '*'
    )
    $ExcludeProperties = 'CimClass', 'CimInstanceProperties', 'CimSystemProperties', 'SystemCreationClassName', 'CreationClassName'

    # Querying CIM locally usually doesn't work. This means if you're querying same computer you neeed to skip CimSession/ComputerName if it's local query
    [Array] $ComputersSplit = Get-ComputerSplit -ComputerName $ComputerName

    $CimObject = @(
        # requires removal of this property for query
        [string[]] $PropertiesOnly = $Properties | Where-Object { $_ -ne 'PSComputerName' }
        # Process all remote computers
        $Computers = $ComputersSplit[1]
        if ($Computers.Count -gt 0) {
            if ($Protocol = 'Default') {
                Get-CimInstance -ClassName $Class -ComputerName $Computers -ErrorAction SilentlyContinue -Property $PropertiesOnly -Namespace $NameSpace -Verbose:$false | Select-Object -Property $Properties -ExcludeProperty $ExcludeProperties
            } else {
                $Option = New-CimSessionOption -Protocol
                $Session = New-CimSession -ComputerName $Computers -SessionOption $Option -ErrorAction SilentlyContinue
                $Info = Get-CimInstance -ClassName $Class -CimSession $Session -ErrorAction SilentlyContinue -Property $PropertiesOnly -Namespace $NameSpace -Verbose:$false | Select-Object -Property $Properties -ExcludeProperty $ExcludeProperties
                $null = Remove-CimSession -CimSession $Session -ErrorAction SilentlyContinue
                $Info
            }
        }
        # Process local computer
        $Computers = $ComputersSplit[0]
        if ($Computers.Count -gt 0) {
            $Info = Get-CimInstance -ClassName $Class -ErrorAction SilentlyContinue -Property $PropertiesOnly -Namespace $NameSpace -Verbose:$false | Select-Object -Property $Properties -ExcludeProperty $ExcludeProperties
            $Info | Add-Member -Name 'PSComputerName' -Value $Computers -MemberType NoteProperty -Force
            $Info
        }
    )
    # Find computers that are not part of data return and warn user
    $CimComputers = $CimObject.PSComputerName | Sort-Object -Unique
    foreach ($Computer in $ComputerName) {
        if ($CimComputers -notcontains $Computer) {
            Write-Warning "Get-CimData - No data for computer $Computer. Most likely an error on receiving side."
        }
    }
    # removes unneeded properties
    return $CimObject
}