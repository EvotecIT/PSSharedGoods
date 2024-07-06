function Get-ComputerOemInformation {
    <#
    .SYNOPSIS
    Retrieves OEM information from a specified computer.

    .DESCRIPTION
    This function retrieves OEM information such as Model, Manufacturer, Logo, Support Phone, Support URL, and Support Hours from the specified computer.

    .PARAMETER ComputerName
    Specifies the name of the computer from which to retrieve the OEM information. If not specified, the local computer name is used.

    .EXAMPLE
    Get-ComputerOemInformation
    Retrieves OEM information from the local computer.

    .EXAMPLE
    Get-ComputerOemInformation -ComputerName "Computer01"
    Retrieves OEM information from a remote computer named "Computer01".

    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $ScriptBlock = { Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation | Select-Object Model, Manufacturer, Logo, SupportPhone, SupportURL, SupportHours }
    if ($ComputerName -eq $Env:COMPUTERNAME) {
        $Data = Invoke-Command -ScriptBlock $ScriptBlock
    } else {
        $Data = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
    }
    return $Data
}