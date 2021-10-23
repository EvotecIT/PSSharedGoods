function ConvertTo-OperatingSystem {
    <#
    .SYNOPSIS
    Allows easy conversion of OperatingSystem, Operating System Version to proper Windows 10 naming based on WMI or AD

    .DESCRIPTION
    Allows easy conversion of OperatingSystem, Operating System Version to proper Windows 10 naming based on WMI or AD

    .PARAMETER OperatingSystem
    Operating System as returned by Active Directory

    .PARAMETER OperatingSystemVersion
    Operating System Version as returned by Active Directory

    .EXAMPLE
    $Computers = Get-ADComputer -Filter * -Properties OperatingSystem, OperatingSystemVersion | ForEach-Object {
        $OPS = ConvertTo-OperatingSystem -OperatingSystem $_.OperatingSystem -OperatingSystemVersion $_.OperatingSystemVersion
        Add-Member -MemberType NoteProperty -Name 'OperatingSystemTranslated' -Value $OPS -InputObject $_ -Force
        $_
    }
    $Computers | Select-Object DNS*, Name, SamAccountName, Enabled, OperatingSystem*, DistinguishedName | Format-Table

    .EXAMPLE
    $Registry = Get-PSRegistry -ComputerName 'AD1' -RegistryPath 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    ConvertTo-OperatingSystem -OperatingSystem $Registry.ProductName -OperatingSystemVersion $Registry.CurrentBuildNumber

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $OperatingSystem,
        [string] $OperatingSystemVersion
    )

    if ($OperatingSystem -like 'Windows 10*' -or $OperatingSystem -like 'Windows 11*') {
        $Systems = @{
            # This is how it's written in AD
            '10.0 (22000)' = 'Windows 11 21H2'
            '10.0 (19043)' = 'Windows 10 21H1'
            '10.0 (19042)' = 'Windows 10 20H2'
            '10.0 (19041)' = 'Windows 10 2004'
            '10.0 (18898)' = 'Windows 10 Insider Preview'
            '10.0 (18363)' = "Windows 10 1909"
            '10.0 (18362)' = "Windows 10 1903"
            '10.0 (17763)' = "Windows 10 1809"
            '10.0 (17134)' = "Windows 10 1803"
            '10.0 (16299)' = "Windows 10 1709"
            '10.0 (15063)' = "Windows 10 1703"
            '10.0 (14393)' = "Windows 10 1607"
            '10.0 (10586)' = "Windows 10 1511"
            '10.0 (10240)' = "Windows 10 1507"

            # This is how WMI/CIM stores it
            '10.0.22000'   = 'Windows 11 21H2'
            '10.0.19043'   = 'Windows 10 21H1'
            '10.0.19042'   = 'Windows 10 20H2'
            '10.0.19041'   = 'Windows 10 2004'
            '10.0.18898'   = 'Windows 10 Insider Preview'
            '10.0.18363'   = "Windows 10 1909"
            '10.0.18362'   = "Windows 10 1903"
            '10.0.17763'   = "Windows 10 1809"
            '10.0.17134'   = "Windows 10 1803"
            '10.0.16299'   = "Windows 10 1709"
            '10.0.15063'   = "Windows 10 1703"
            '10.0.14393'   = "Windows 10 1607"
            '10.0.10586'   = "Windows 10 1511"
            '10.0.10240'   = "Windows 10 1507"

            # This is how it's written in registry
            '22000'        = 'Windows 11 21H2'
            '19043'        = 'Windows 10 21H1'
            '19042'        = 'Windows 10 20H2'
            '19041'        = 'Windows 10 2004'
            '18898'        = 'Windows 10 Insider Preview'
            '18363'        = "Windows 10 1909"
            '18362'        = "Windows 10 1903"
            '17763'        = "Windows 10 1809"
            '17134'        = "Windows 10 1803"
            '16299'        = "Windows 10 1709"
            '15063'        = "Windows 10 1703"
            '14393'        = "Windows 10 1607"
            '10586'        = "Windows 10 1511"
            '10240'        = "Windows 10 1507"
        }
        $System = $Systems[$OperatingSystemVersion]
        if (-not $System) {
            $System = $OperatingSystem
        }
    } elseif ($OperatingSystem -like 'Windows Server*') {
        # May need updates https://docs.microsoft.com/en-us/windows-server/get-started/windows-server-release-info
        # to detect Core

        $Systems = @{
            # This is how it's written in AD
            '10.0 (20348)' = 'Windows Server 2022'
            '10.0 (19042)' = 'Windows Server 2019 20H2'
            '10.0 (19041)' = 'Windows Server 2019 2004'
            '10.0 (18363)' = 'Windows Server 2019 1909'
            '10.0 (18362)' = "Windows Server 2019 1903" # (Datacenter Core, Standard Core)
            '10.0 (17763)' = "Windows Server 2019 1809" # (Datacenter, Essentials, Standard)
            '10.0 (17134)' = "Windows Server 2016 1803" # (Datacenter, Standard)
            '10.0 (14393)' = "Windows Server 2016 1607"
            '6.3 (9600)'   = 'Windows Server 2012 R2'
            '6.1 (7601)'   = 'Windows Server 2008 R2'
            '5.2 (3790)'   = 'Windows Server 2003'

            # This is how WMI/CIM stores it
            '10.0.20348'   = 'Windows Server 2022'
            '10.0.19042'   = 'Windows Server 2019 20H2'
            '10.0.19041'   = 'Windows Server 2019 2004'
            '10.0.18363'   = 'Windows Server 2019 1909'
            '10.0.18362'   = "Windows Server 2019 1903" #  (Datacenter Core, Standard Core)
            '10.0.17763'   = "Windows Server 2019 1809"  # (Datacenter, Essentials, Standard)
            '10.0.17134'   = "Windows Server 2016 1803" ## (Datacenter, Standard)
            '10.0.14393'   = "Windows Server 2016 1607"
            '6.3.9600'     = 'Windows Server 2012 R2'
            '6.1.7601'     = 'Windows Server 2008 R2' # i think
            '5.2.3790'     = 'Windows Server 2003' # i think

            # This is how it's written in registry
            '20348'        = 'Windows Server 2022'
            '19042'        = 'Windows Server 2019 20H2'
            '19041'        = 'Windows Server 2019 2004'
            '18363'        = 'Windows Server 2019 1909'
            '18362'        = "Windows Server 2019 1903" # (Datacenter Core, Standard Core)
            '17763'        = "Windows Server 2019 1809" # (Datacenter, Essentials, Standard)
            '17134'        = "Windows Server 2016 1803" # (Datacenter, Standard)
            '14393'        = "Windows Server 2016 1607"
            '9600'         = 'Windows Server 2012 R2'
            '7601'         = 'Windows Server 2008 R2'
            '3790'         = 'Windows Server 2003'
        }
        $System = $Systems[$OperatingSystemVersion]
        if (-not $System) {
            $System = $OperatingSystem
        }
    } else {
        $System = $OperatingSystem
    }
    if ($System) {
        $System
    } else {
        'Unknown'
    }
}

<#
$Computers = Get-ADComputer -Filter * -Properties OperatingSystem, OperatingSystemVersion | ForEach-Object {
    $OPS = ConvertTo-OperatingSystem -OperatingSystem $_.OperatingSystem -OperatingSystemVersion $_.OperatingSystemVersion
    Add-Member -MemberType NoteProperty -Name 'OperatingSystemTranslated' -Value $OPS -InputObject $_ -Force
    $_
}
$Computers | Select-Object DNS*, Name, SamAccountName, Enabled, OperatingSystem*, DistinguishedName | Format-Table
#>