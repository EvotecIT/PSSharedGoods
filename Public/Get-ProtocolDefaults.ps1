function Get-ProtocolDefaults {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER WindowsVersion
    Parameter description

    .PARAMETER AsList

    .EXAMPLE
    Get-ProtocolDefaults -AsList | Format-Table

    .EXAMPLE
    Get-ProtocolDefaults -WindowsVersion 'Windows 10 1809' | Format-Table

    .NOTES
    Based on: https://docs.microsoft.com/en-us/windows/win32/secauthn/protocols-in-tls-ssl--schannel-ssp-
    #>
    [cmdletbinding()]
    param(
        [string] $WindowsVersion,
        [switch] $AsList
    )

    $Defaults = [ordered] @{
        'Windows Server 2022'        = [ordered] @{
            'Version'     = 'Windows Server 2022'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Enabled'
            'TLS13Server' = 'Enabled'
        }
        'Windows Server 2019 20H2'   = [ordered] @{
            'Version'     = 'Windows Server 2019 20H2'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows Server 2019 2004'   = [ordered] @{
            'Version'     = 'Windows Server 2019 2004'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows Server 2019 1909'   = [ordered] @{
            'Version'     = 'Windows Server 2019 1909'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows Server 2019 1903"   = [ordered] @{
            'Version'     = 'Windows Server 2019 1903'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows Server 2019 1809"   = [ordered] @{
            'Version'     = 'Windows Server 2019 1809'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows Server 2016 1803"   = [ordered] @{
            'Version'     = 'Windows Server 2016 1803'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows Server 2016 1607"   = [ordered] @{
            'Version'     = 'Windows Server 2019 1607'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows Server 2012 R2'     = [ordered] @{
            'Version'     = 'Windows Server 2012 R2'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Disabled'
            'SSL2Server'  = 'Disabled'
            'SSL3Client'  = 'Enabled'
            'SSL3Server'  = 'Enabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows Server 2012'        = [ordered] @{
            'Version'     = 'Windows Server 2012'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Disabled'
            'SSL2Server'  = 'Disabled'
            'SSL3Client'  = 'Enabled'
            'SSL3Server'  = 'Enabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows Server 2008 R2'     = [ordered] @{
            'Version'     = 'Windows Server 2008 R2'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Disabled'
            'SSL2Server'  = 'Enabled'
            'SSL3Client'  = 'Enabled'
            'SSL3Server'  = 'Enabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Disabled'
            'TLS11Server' = 'Disabled'
            'TLS12Client' = 'Disabled'
            'TLS12Server' = 'Disabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows Server 2008'        = [ordered] @{
            'Version'     = 'Windows Server 2008'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Disabled'
            'SSL2Server'  = 'Enabled'
            'SSL3Client'  = 'Enabled'
            'SSL3Server'  = 'Enabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Disabled'
            'TLS11Server' = 'Disabled'
            'TLS12Client' = 'Disabled'
            'TLS12Server' = 'Disabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }

        'Windows 11 21H2'            = [ordered] @{
            'Version'     = 'Windows 11 21H2'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Enabled'
            'TLS13Server' = 'Enabled'
        }
        'Windows 10 21H1'            = [ordered] @{
            'Version'     = 'Windows 10 21H1'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows 10 20H2'            = [ordered] @{
            'Version'     = 'Windows 10 20H2'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows 10 2004'            = [ordered] @{
            'Version'     = 'Windows 10 2004'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        'Windows 10 Insider Preview' = [ordered] @{
            'Version'     = 'Windows 10 Insider Preview'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1909"            = [ordered] @{
            'Version'     = 'Windows 10 1909'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1903"            = [ordered] @{
            'Version'     = 'Windows 10 1903'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1809"            = [ordered] @{
            'Version'     = 'Windows 10 1809'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1803"            = [ordered] @{
            'Version'     = 'Windows 10 1803'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1709"            = [ordered] @{
            'Version'     = 'Windows 10 1709'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1703"            = [ordered] @{
            'Version'     = 'Windows 10 1703'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1607"            = [ordered] @{
            'Version'     = 'Windows 10 1607'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Not supported'
            'SSL2Server'  = 'Not supported'
            'SSL3Client'  = 'Disabled'
            'SSL3Server'  = 'Disabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1511"            = [ordered] @{
            'Version'     = 'Windows 10 1511'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Disabled'
            'SSL2Server'  = 'Disabled'
            'SSL3Client'  = 'Enabled'
            'SSL3Server'  = 'Enabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
        "Windows 10 1507"            = [ordered] @{
            'Version'     = 'Windows 10 1507'
            'PCT10'       = 'Not supported'
            'SSL2Client'  = 'Disabled'
            'SSL2Server'  = 'Disabled'
            'SSL3Client'  = 'Enabled'
            'SSL3Server'  = 'Enabled'
            'TLS10Client' = 'Enabled'
            'TLS10Server' = 'Enabled'
            'TLS11Client' = 'Enabled'
            'TLS11Server' = 'Enabled'
            'TLS12Client' = 'Enabled'
            'TLS12Server' = 'Enabled'
            'TLS13Client' = 'Not supported'
            'TLS13Server' = 'Not supported'
        }
    }
    if ($AsList) {
        foreach ($Key in $Defaults.Keys) {
            [PSCustomObject] $Defaults[$Key]
        }
    } else {
        if ($Defaults[$WindowsVersion]) {
            $Defaults[$WindowsVersion]
        } else {
            [ordered] @{
                'Version'     = 'Unknown'
                'PCT10'       = 'Unknown'
                'SSL2Client'  = 'Unknown'
                'SSL2Server'  = 'Unknown'
                'SSL3Client'  = 'Unknown'
                'SSL3Server'  = 'Unknown'
                'TLS10Client' = 'Unknown'
                'TLS10Server' = 'Unknown'
                'TLS11Client' = 'Unknown'
                'TLS11Server' = 'Unknown'
                'TLS12Client' = 'Unknown'
                'TLS12Server' = 'Unknown'
                'TLS13Client' = 'Unknown'
                'TLS13Server' = 'Unknown'
            }
        }
    }
}