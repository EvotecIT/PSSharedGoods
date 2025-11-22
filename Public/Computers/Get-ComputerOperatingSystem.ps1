function Get-ComputerOperatingSystem {
    <#
    .SYNOPSIS
    Retrieves operating system information from remote computers.

    .DESCRIPTION
    This function retrieves operating system information from remote computers using CIM/WMI queries. It provides details such as the operating system name, version, manufacturer, architecture, language, product suite, installation date, last boot-up time, and more.

    .PARAMETER ComputerName
    Specifies the name of the remote computer(s) to retrieve the operating system information from. Defaults to the local computer.

    .PARAMETER Protocol
    Specifies the protocol to use for the connection (Default, Dcom, or Wsman). Default is 'Default'.

    .PARAMETER Credential
    Alternate credentials for CIM queries. Default is current user.

    .PARAMETER All
    Switch parameter to retrieve all available properties of the operating system.

    .EXAMPLE
    Get-ComputerOperatingSystem -ComputerName "Server01" -Protocol Wsman
    Retrieves operating system information from a single remote computer named "Server01" using the Wsman protocol.

    .EXAMPLE
    Get-ComputerOperatingSystem -ComputerName "Server01", "Server02" -All
    Retrieves all available operating system properties from multiple remote computers named "Server01" and "Server02".

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
        [string[]] $Properties = 'Caption', 'Manufacturer', 'InstallDate', 'OSArchitecture', 'Version', 'SerialNumber', 'BootDevice', 'WindowsDirectory', 'CountryCode', 'OSLanguage', 'OSProductSuite', 'PSComputerName', 'LastBootUpTime', 'LocalDateTime'
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Credential $Credential -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Data in $Information) {
            # # Remember to expand if changing properties above
            [PSCustomObject] @{
                ComputerName           = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                OperatingSystem        = $Data.Caption
                OperatingSystemVersion = ConvertTo-OperatingSystem -OperatingSystem $Data.Caption -OperatingSystemVersion $Data.Version
                OperatingSystemBuild   = $Data.Version
                Manufacturer           = $Data.Manufacturer
                OSArchitecture         = $Data.OSArchitecture
                OSLanguage             = ConvertFrom-LanguageCode -LanguageCode $Data.OSLanguage
                OSProductSuite         = [Microsoft.PowerShell.Commands.OSProductSuite] $($Data.OSProductSuite)
                InstallDate            = $Data.InstallDate
                LastBootUpTime         = $Data.LastBootUpTime
                LocalDateTime          = $Data.LocalDateTime
                SerialNumber           = $Data.SerialNumber
                BootDevice             = $Data.BootDevice
                WindowsDirectory       = $Data.WindowsDirectory
                CountryCode            = $Data.CountryCode
            }
        }
    }
}

#Get-ComputerOperatingSystem -ComputerName AD1, AD2, AD3, DC1 -All #| ft -a *

#Get-CimInstance SoftwareLicensingProduct -ComputerName AD1 -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" | where licensestatus -eq 1 | `
#    select name, description, @{Label = 'computer'; Expression = { $_.PscomputerName } } | Format-List  name, description, computer

#Get-CimInstance -class SoftwareLicensingProduct | where { $_.name -match 'office' -AND $_.licensefamily } | ft -a *

#$L = Get-CimData -Class 'SoftwareLicensingProduct' -ComputerName AD1,AD2,EVOWIN
#$L | Where-Object { $_.Name -match 'windows' } | ft -a Name, ApplicationID,Description,ExtendedGrace,graceperiodremaining, GenuineStatus,LicenseFamily,LicenseStatus,LicenseStatusReason,PSComputerName

<#
$T = foreach ($_ in $L) {

    $LicensStatus = switch ($_.LicenseStatus) {
        0 { "Unlicensed" }
        1 { "Licensed" }
        2 { "Out-Of-Box Grace Period" }
        3 { "Out-Of-Tolerance Grace Period" }
        4 { "Non-Genuine Grace Period" }
        5 { 'Evaluation' }
    }


    [PSCustomObject] @{
        Name                     = $_.Name
        Description              = $_.Description
        LicenseFamily            = $_.LicenseFamily
        LicenseStatus            = $LicensStatus
        LicenseStatusReason      = $_.LicenseStatusReason
        GracePeriodRemainingDays = $_.graceperiodremaining / 1440
        ComputerName             = $_.PSComputerName
    }
}

$T | ft -a

#>
