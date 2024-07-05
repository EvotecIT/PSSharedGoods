function Set-TimeSynchronization {
    <#
    .SYNOPSIS
    Configures time synchronization settings on the local machine.

    .DESCRIPTION
    This function sets up time synchronization on the local machine by configuring the time source, server type, NTP settings, and time correction parameters.

    .PARAMETER TimeSource
    Specifies the time source to synchronize with. Default is 'time.windows.com'.

    .PARAMETER MaxPosPhaseCorrection
    Specifies the maximum positive time correction in seconds. Default is 86400 seconds (24 hours).

    .PARAMETER MaxnegPhaseCorrection
    Specifies the maximum negative time correction in seconds. Default is 86400 seconds (24 hours).

    .PARAMETER PollInterval
    Specifies the poll interval in seconds. Default is 1800 seconds (30 minutes).

    .EXAMPLE
    Set-TimeSynchronization -TimeSource 'time.windows.com' -MaxPosPhaseCorrection 86400 -MaxnegPhaseCorrection 86400 -PollInterval 1800
    Configures time synchronization using default settings.

    .EXAMPLE
    Set-TimeSynchronization -TimeSource 'pool.ntp.org' -MaxPosPhaseCorrection 43200 -MaxnegPhaseCorrection 43200 -PollInterval 3600
    Configures time synchronization with a different time source and shorter time correction limits.

    #>
    param(
        [string[]] $TimeSource = 'time.windows.com',
        [int] $MaxPosPhaseCorrection = 86400,
        [int] $MaxnegPhaseCorrection = 86400,
        [int] $PollInterval = 1800
    )
    ## set external time source
    ## set server type to NTP
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name Type -Value 'NTP'
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Name AnnounceFlags -Value 5
    ## Enable NTP server
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer -Name Enabled -Value 1
    ## Specify Time source
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters -Name NtpServer -Value "$TimeSource,0x1"
    ## Set poll interval in seconds - every 30 minutes
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient -Name SpecialPollInterval -Value $PollInterval
    ## set max +/- time corrections in seconds - 24 hours
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Name MaxPosPhaseCorrection -Value $MaxPosPhaseCorrection
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config -Name MaxnegPhaseCorrection -Value $MaxnegPhaseCorrection

    Stop-Service -Name W32Time
    Start-Service -Name W32Time
}