function Get-ComputerTimeNtp {
    <#
        .Synopsis
        Gets (Simple) Network Time Protocol time (SNTP/NTP, rfc-1305, rfc-2030) from a specified server
        .DESCRIPTION
        This function connects to an NTP server on UDP port 123 and retrieves the current NTP time.
        Selected components of the returned time information are decoded and returned in a PSObject.
        .PARAMETER Server
        The NTP Server to contact.  Uses pool.ntp.org by default.
        .EXAMPLE
        Get-NtpTime uk.pool.ntp.org
        Gets time from the specified server.
        .EXAMPLE
        Get-NtpTime | fl *
        Get time from default server (pool.ntp.org) and displays all output object attributes.
        .FUNCTIONALITY
        Gets NTP time from a specified server.

        .NOTES
        Author https://github.com/ChrisWarwick/PowerShell-NTP-Time
        Slightly simplified for different usage scenarios
    #>

    [CmdletBinding()]
    Param (
        [String]$Server = 'pool.ntp.org',
        [switch]$ToLocal
    )
    # NTP Times are all UTC and are relative to midnight on 1/1/1900
    $StartOfEpoch = New-Object DateTime(1900, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)

    # Construct a 48-byte client NTP time packet to send to the specified server
    # (Request Header: [00=No Leap Warning; 011=Version 3; 011=Client Mode]; 00011011 = 0x1B)

    [Byte[]]$NtpData = , 0 * 48
    $NtpData[0] = 0x1B    # NTP Request header in first byte

    $Socket = [Net.Sockets.Socket]::new([Net.Sockets.AddressFamily]::InterNetwork, [Net.Sockets.SocketType]::Dgram, [Net.Sockets.ProtocolType]::Udp)
    $Socket.SendTimeOut = 2000  # ms
    $Socket.ReceiveTimeOut = 2000   # ms

    Try {
        $Socket.Connect($Server, 123)
    } Catch {
        $_.Error
        Write-Warning "Get-ComputerTimeNtp - Failed to connect to server $Server"
        return
    }


    # NTP Transaction -------------------------------------------------------

    $t1 = Get-Date    # t1, Start time of transaction...

    Try {
        [Void]$Socket.Send($NtpData)
        [Void]$Socket.Receive($NtpData)
    } Catch {
        Write-Warning "Get-ComputerTimeNtp - Failed to communicate with server $Server"
        return
    }

    $t4 = Get-Date    # End of NTP transaction time

    # End of NTP Transaction ------------------------------------------------

    $Socket.Shutdown("Both")
    $Socket.Close()

    $LI = ($NtpData[0] -band 0xC0) -shr 6    # Leap Second indicator
    If ($LI -eq 3) {
        Write-Warning 'Get-ComputerTimeNtp - Alarm condition from server (clock not synchronized)'
        return
    }


    # Convert Integer and Fractional parts of the (64-bit) t3 NTP time from the byte array
    $IntPart = [BitConverter]::ToUInt32($NtpData[43..40], 0)
    $FracPart = [BitConverter]::ToUInt32($NtpData[47..44], 0)

    # Convert to Millseconds (convert fractional part by dividing value by 2^32)
    $t3ms = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)

    # Perform the same calculations for t2 (in bytes [32..39])
    $IntPart = [BitConverter]::ToUInt32($NtpData[35..32], 0)
    $FracPart = [BitConverter]::ToUInt32($NtpData[39..36], 0)
    $t2ms = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)

    # Calculate values for t1 and t4 as milliseconds since 1/1/1900 (NTP format)
    $t1ms = ([TimeZoneInfo]::ConvertTimeToUtc($t1) - $StartOfEpoch).TotalMilliseconds
    $t4ms = ([TimeZoneInfo]::ConvertTimeToUtc($t4) - $StartOfEpoch).TotalMilliseconds

    # Calculate the NTP Offset and Delay values
    $Offset = (($t2ms - $t1ms) + ($t3ms - $t4ms)) / 2
    #$Delay = ($t4ms - $t1ms) - ($t3ms - $t2ms)

    [DateTime] $NTPDateTime = $StartOfEpoch.AddMilliseconds($t4ms + $Offset)

    if ($ToLocal) {
        $NTPDateTime.ToLocalTime()
    } else {
        $NTPDateTime
    }
}