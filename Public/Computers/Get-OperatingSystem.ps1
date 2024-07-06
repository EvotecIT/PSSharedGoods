function Get-OperatingSystem {
    <#
    .SYNOPSIS
    Retrieves information about Windows operating systems.

    .DESCRIPTION
    This function returns details about various versions of Windows operating systems, including their names, version numbers, code names, marketing names, build numbers, release dates, and support end dates.

    .PARAMETER Version
    Specifies the version number of the Windows operating system to retrieve information for.

    .EXAMPLE
    Get-OperatingSystem -Version '10.0 (19042)'
    Retrieves information about Windows 10 20H2.

    .EXAMPLE
    Get-OperatingSystem
    Retrieves information about all available Windows operating systems.

    #>
    [cmdletbinding()]
    param(
        [string] $Version
    )

    $ListOperatingSystems = [ordered] @{
        '10.0 (19043)' = [PSCustomObject] @{ Name = 'Windows 10 21H1'; Version = '10.0 (19043)'; CodeName = '21H1'; MarketingName = 'May 2021 Update'; BuildNumber = '19043';
            ReleaseDate = (Get-Date -Year 2021 -Month 5 -Day 18 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2022 -Month 12 -Day 13 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2022 -Month 12 -Day 13 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = $null
        }
        '10.0 (19042)' = [PSCustomObject] @{ Name = 'Windows 10 20H2'; Version = '10.0 (19042)'; CodeName = '20H2'; MarketingName = 'October 2020 Update'; BuildNumber = '19042';
            ReleaseDate = (Get-Date -Year 2020 -Month 9 -Day 20 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2022 -Month 5 -Day 10 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2023 -Month 5 -Day 9 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = $null
        }
        '10.0 (19041)' = [PSCustomObject] @{ Name = 'Windows 10 2004'; Version = '10.0 (19041)'; CodeName = '20H1'; MarketingName = 'May 2020 Update'; BuildNumber = '19041';
            ReleaseDate = (Get-Date -Year 2020 -Month 5 -Day 27 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2021 -Month 12 -Day 14 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2021 -Month 12 -Day 14 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = $null
        }
        '10.0 (18363)' = [PSCustomObject] @{ Name = "Windows 10 1909"; Version = '10.0 (18363)'; CodeName = '19H2'; MarketingName = 'November 2019 Update'; BuildNumber = '18363';
            ReleaseDate = (Get-Date -Year 2019 -Month 11 -Day 12 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2021 -Month 5 -Day 11 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2022 -Month 5 -Day 10 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = $null
        }
        '10.0 (18362)' = [PSCustomObject] @{ Name = "Windows 10 1903"; Version = '10.0 (18362)'; CodeName = '19H1'; MarketingName = 'May 2019 Update'; BuildNumber = '18362';
            ReleaseDate = (Get-Date -Year 2019 -Month 5 -Day 21 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2020 -Month 12 -Day 8 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2020 -Month 12 -Day 8 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = $null
        }
        '10.0 (17763)' = [PSCustomObject] @{ Name = "Windows 10 1809"; Version = '10.0 (17763)'; CodeName = 'Redstone 5'; MarketingName = 'October 2018 Update'; BuildNumber = '17763';
            ReleaseDate = (Get-Date -Year 2018 -Month 11 -Day 13 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2020 -Month 11 -Day 10 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2021 -Month 5 -Day 11 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = (Get-Date -Year 2029 -Month 1 -Day 9 -Second 1 -Minute 1 -Hour 1 -Millisecond 1)
        }
        '10.0 (17134)' = [PSCustomObject] @{ Name = "Windows 10 1803"; Version = '10.0 (17134)'; CodeName = 'Redstone 4'; MarketingName = 'April 2018 Update'; BuildNumber = '17134';
            ReleaseDate = (Get-Date -Year 2018 -Month 4 -Day 30 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2020 -Month 11 -Day 12 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2021 -Month 5 -Day 11 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = $null
        }
        '10.0 (16299)' = [PSCustomObject] @{ Name = "Windows 10 1709"; Version = '10.0 (16299)'; CodeName = 'Redstone 3'; MarketingName = 'Fall Creators Update'; BuildNumber = '16299';
            ReleaseDate = (Get-Date -Year 2017 -Month 9 -Day 17 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2019 -Month 4 -Day 9 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2020 -Month 10 -Day 13 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); ; LTSC = $null
        }
        '10.0 (15063)' = [PSCustomObject] @{ Name = "Windows 10 1703"; Version = '10.0 (15063)'; CodeName = 'Redstone 2'; MarketingName = 'Creators Update'; BuildNumber = '15063';
            ReleaseDate = (Get-Date -Year 2017 -Month 4 -Day 5 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2018 -Month 10 -Day 9 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2019 -Month 10 -Day 8 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); ; LTSC = $null
        }
        '10.0 (14393)' = [PSCustomObject] @{ Name = "Windows 10 1607"; Version = '10.0 (14393)'; CodeName = 'Redstone 1'; MarketingName = 'Anniversary Update'; BuildNumber = '14393';
            ReleaseDate = (Get-Date -Year 2016 -Month 8 -Day 2 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2018 -Month 4 -Day 10 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2019 -Month 4 -Day 9 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = (Get-Date -Year 2026 -Month 10 -Day 13 -Second 1 -Minute 1 -Hour 1 -Millisecond 1)
        }
        '10.0 (10586)' = [PSCustomObject] @{ Name = "Windows 10 1511"; Version = '10.0 (10586)'; CodeName = 'Threshold 2'; MarketingName = 'November Update'; BuildNumber = '10586';
            ReleaseDate = (Get-Date -Year 2015 -Month 11 -Day 10 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2017 -Month 10 -Day 10 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2018 -Month 4 -Day 10 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = $null
        }
        '10.0 (10240)' = [PSCustomObject] @{ Name = "Windows 10 1507"; Version = '10.0 (10240)' ; CodeName = 'Threshold 1'; MarketingName = 'N/A'; BuildNumber = '10240';
            ReleaseDate = (Get-Date -Year 2015 -Month 7 -Day 29 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndPro = (Get-Date -Year 2017 -Month 5 -Day 9 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); SupportEndEnterprise = (Get-Date -Year 2017 -Month 5 -Day 9 -Second 1 -Minute 1 -Hour 1 -Millisecond 1); LTSC = (Get-Date -Year 2025 -Month 10 -Day 14 -Second 1 -Minute 1 -Hour 1 -Millisecond 1)
        }
    }
    if ($Version) {
        $ListOperatingSystems[$Version]
    } else {
        $ListOperatingSystems.Values
    }
}