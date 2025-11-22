function Get-ComputerOemInformation {
    <#
    .SYNOPSIS
    Retrieves OEM information from a specified computer.

    .DESCRIPTION
    This function retrieves OEM information such as Model, Manufacturer, Logo, Support Phone, Support URL, and Support Hours from the specified computer.

    .PARAMETER ComputerName
    Specifies the name of the computer from which to retrieve the OEM information. If not specified, the local computer name is used.

    .PARAMETER Credential
    Alternate credentials for remote Invoke-Command.

    .EXAMPLE
    Get-ComputerOemInformation
    Retrieves OEM information from the local computer.

    .EXAMPLE
    Get-ComputerOemInformation -ComputerName "Computer01"
    Retrieves OEM information from a remote computer named "Computer01".

    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME,
        [pscredential] $Credential
    )
    $ScriptBlock = { Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation | Select-Object Model, Manufacturer, Logo, SupportPhone, SupportURL, SupportHours }
    if ($ComputerName -eq $Env:COMPUTERNAME) {
        $Data = Invoke-Command -ScriptBlock $ScriptBlock
    } else {
        $invokeSplat = @{ ComputerName = $ComputerName; ScriptBlock = $ScriptBlock }
        if ($Credential) { $invokeSplat.Credential = $Credential }
        $Data = Invoke-Command @invokeSplat
    }
    return $Data
}
