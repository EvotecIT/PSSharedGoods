function ConvertTo-OperatingSystem {
    [CmdletBinding()]
    param(
        [string] $OperatingSystem,
        [string] $OperatingSystemVersion
    )

    if ($OperatingSystem -like '*Windows 10*') {
        $Systems = @{
            # This is how it's written in AD
            '10.0 (18363)' = "Windows 10 1909"
            '10.0 (18362)' = "Windows 10 1903"
            '10.0 (17763)' = "Windows 10 1809"
            '10.0 (17134)' = "Windows 10 1803"
            '10.0 (16299)' = "Windows 10 1709"
            '10.0 (15063)' = "Windows 10 1703"
            '10.0 (14393)' = "Windows 10 1607"
            '10.0 (10586)' = "Windows 10 1511"
            '10.0 (10240)' = "Windows 10 1507"
            '10.0 (18898)' = 'Windows 10 Insider Preview'

            # This is how WMI/CIM stores it
            '10.0.18363'   = "Windows 10 1909"
            '10.0.18362'   = "Windows 10 1903"
            '10.0.17763'   = "Windows 10 1809"
            '10.0.17134'   = "Windows 10 1803"
            '10.0.16299'   = "Windows 10 1709"
            '10.0.15063'   = "Windows 10 1703"
            '10.0.14393'   = "Windows 10 1607"
            '10.0.10586'   = "Windows 10 1511"
            '10.0.10240'   = "Windows 10 1507"
            '10.0.18898'   = 'Windows 10 Insider Preview'
        }
        $System = $Systems[$OperatingSystemVersion]

    } elseif ($OperatingSystem -like '*Windows Server*') {
        # May need updates https://docs.microsoft.com/en-us/windows-server/get-started/windows-server-release-info
        # to detect Core

        $Systems = @{
            '5.2 (3790)'   = 'Windows Server 2003'
            '6.1 (7601)'   = 'Windows Server 2008 R2'
            # This is how it's written in AD
            '10.0 (18362)' = "Windows Server, version 1903 (Semi-Annual Channel) 1903" # (Datacenter Core, Standard Core)
            '10.0 (17763)' = "Windows Server 2019 (Long-Term Servicing Channel) 1809" # (Datacenter, Essentials, Standard)
            '10.0 (17134)' = "Windows Server, version 1803 (Semi-Annual Channel) 1803" # (Datacenter, Standard)
            '10.0 (14393)' = "Windows Server 2016 (Long-Term Servicing Channel) 1607"

            # This is how WMI/CIM stores it
            '10.0.18362'   = "Windows Server, version 1903 (Semi-Annual Channel) 1903" #  (Datacenter Core, Standard Core)
            '10.0.17763'   = "Windows Server 2019 (Long-Term Servicing Channel) 1809"  # (Datacenter, Essentials, Standard)
            '10.0.17134'   = "Windows Server, version 1803 (Semi-Annual Channel) 1803" ## (Datacenter, Standard)
            '10.0.14393'   = "Windows Server 2016 (Long-Term Servicing Channel) 1607"
        }
        $System = $Systems[$OperatingSystemVersion]
    } else {
        $System = $OperatingSystem
    }
    if ($System) {
        $System
    } else {
        'Unknown'
    }
}