function Get-IPAddressRangeInformation {
    <#
    .SYNOPSIS
    Provides information about IP Address range

    .DESCRIPTION
    Provides information about IP Address range

    .PARAMETER Network
    Network in form of IP/NetworkLength (e.g. 10.2.10.0/24')

    .PARAMETER IPAddress
    IP Address to use

    .PARAMETER NetworkLength
    Network length to use

    .PARAMETER CIDRObject
    CIDRObject to use

    .EXAMPLE
    $CidrObject = @{
        Ip            = '10.2.10.0'
        NetworkLength = 24
    }
    Get-IPAddressRangeInformation -CIDRObject $CidrObject | Format-Table

    .EXAMPLE
    Get-IPAddressRangeInformation -Network '10.2.10.0/24' | Format-Table

    .EXAMPLE
    Get-IPAddressRangeInformation -IPAddress '10.2.10.0' -NetworkLength 24 | Format-Table

    .NOTES
    General notes
    #>
    [cmdletBinding(DefaultParameterSetName = 'Network')]
    param(
        [Parameter(ParameterSetName = 'Network', Mandatory)][string] $Network,
        [Parameter(ParameterSetName = 'IPAddress', Mandatory)][string] $IPAddress,
        [Parameter(ParameterSetName = 'IPAddress', Mandatory)][int] $NetworkLength,
        [Parameter(ParameterSetName = 'CIDR', Mandatory)][psobject] $CIDRObject
    )
    $IPv4Regex = '(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)'

    if ($Network) {
        $CIDRObject = @{
            Ip            = $Network.Split('/')[0]
            NetworkLength = $Network.Split('/')[1]
        }
    } elseif ($IPAddress -and $NetworkLength) {
        $CIDRObject = @{
            Ip            = $IPAddress
            NetworkLength = $NetworkLength
        }
    } elseif ($CIDRObject) {

    } else {
        Write-Error "Get-IPAddressRangeInformation - Invalid parameters specified"
        return
    }

    $o = [ordered] @{}
    $o.IP = [string] $CIDRObject.IP
    $o.BinaryIP = Convert-IPToBinary $o.IP
    if (-not $o.BinaryIP) {
        return
    }
    $o.NetworkLength = [int32] $CIDRObject.NetworkLength
    $o.SubnetMask = Convert-BinaryToIP ('1' * $o.NetworkLength).PadRight(32, '0')
    $o.BinarySubnetMask = ('1' * $o.NetworkLength).PadRight(32, '0')
    $o.BinaryNetworkAddress = $o.BinaryIP.SubString(0, $o.NetworkLength).PadRight(32, '0')
    if ($Contains) {
        if ($Contains -match "\A${IPv4Regex}\z") {
            # Passing in IP to test, start binary and end binary.
            return Test-IPIsInNetwork $Contains $o.BinaryNetworkAddress $o.BinaryNetworkAddress.SubString(0, $o.NetworkLength).PadRight(32, '1')
        } else {
            Write-Error "Get-IPAddressRangeInformation - Invalid IPv4 address specified with -Contains"
            return
        }
    }
    $o.NetworkAddress = Convert-BinaryToIP $o.BinaryNetworkAddress
    if ($o.NetworkLength -eq 32 -or $o.NetworkLength -eq 31) {
        $o.HostMin = $o.IP
    } else {
        $o.HostMin = Convert-BinaryToIP ([System.Convert]::ToString(([System.Convert]::ToInt64($o.BinaryNetworkAddress, 2) + 1), 2)).PadLeft(32, '0')
    }
    [string] $BinaryBroadcastIP = $o.BinaryNetworkAddress.SubString(0, $o.NetworkLength).PadRight(32, '1') # this gives broadcast... need minus one.
    $o.BinaryBroadcast = $BinaryBroadcastIP
    [int64] $DecimalHostMax = [System.Convert]::ToInt64($BinaryBroadcastIP, 2) - 1
    [string] $BinaryHostMax = [System.Convert]::ToString($DecimalHostMax, 2).PadLeft(32, '0')
    $o.HostMax = Convert-BinaryToIP $BinaryHostMax
    $o.TotalHosts = [int64][System.Convert]::ToString(([System.Convert]::ToInt64($BinaryBroadcastIP, 2) - [System.Convert]::ToInt64($o.BinaryNetworkAddress, 2) + 1))
    $o.UsableHosts = $o.TotalHosts - 2
    # ugh, exceptions for network lengths from 30..32
    if ($o.NetworkLength -eq 32) {
        $o.Broadcast = $Null
        $o.UsableHosts = [int64] 1
        $o.TotalHosts = [int64] 1
        $o.HostMax = $o.IP
    } elseif ($o.NetworkLength -eq 31) {
        $o.Broadcast = $Null
        $o.UsableHosts = [int64] 2
        $o.TotalHosts = [int64] 2
        # Override the earlier set value for this (bloody exceptions).
        [int64] $DecimalHostMax2 = [System.Convert]::ToInt64($BinaryBroadcastIP, 2) # not minus one here like for the others
        [string] $BinaryHostMax2 = [System.Convert]::ToString($DecimalHostMax2, 2).PadLeft(32, '0')
        $o.HostMax = Convert-BinaryToIP $BinaryHostMax2
    } elseif ($o.NetworkLength -eq 30) {
        $o.UsableHosts = [int64] 2
        $o.TotalHosts = [int64] 4
        $o.Broadcast = Convert-BinaryToIP $BinaryBroadcastIP
    } else {
        $o.Broadcast = Convert-BinaryToIP $BinaryBroadcastIP
    }
    if ($Enumerate) {
        $IPRange = @(Get-IPRange $o.BinaryNetworkAddress $o.BinaryNetworkAddress.SubString(0, $o.NetworkLength).PadRight(32, '1'))
        if ((31, 32) -notcontains $o.NetworkLength ) {
            $IPRange = $IPRange[1..($IPRange.Count - 1)] # remove first element
            $IPRange = $IPRange[0..($IPRange.Count - 2)] # remove last element
        }
        $o.IPEnumerated = $IPRange
    } else {
        $o.IPEnumerated = @()
    }
    [PSCustomObject]$o
}