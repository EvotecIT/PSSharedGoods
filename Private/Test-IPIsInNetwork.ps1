function Test-IPIsInNetwork {
    <#
    .SYNOPSIS
    Checks if an IP address falls within a specified range defined by binary start and end values.

    .DESCRIPTION
    This function compares the binary representation of an IP address with the binary start and end values to determine if the IP address falls within the specified range.

    .EXAMPLE
    Test-IPIsInNetwork -IP "192.168.1.10" -StartBinary "11000000101010000000000100000000" -EndBinary "11000000101010000000000111111111"

    Description:
    Checks if the IP address 192.168.1.10 falls within the range defined by the binary start and end values.

    #>
    [cmdletBinding()]
    param(
        [string] $IP,
        [string] $StartBinary,
        [string] $EndBinary
    )
    $TestIPBinary = Convert-IPToBinary $IP
    [int64] $TestIPInt64 = [System.Convert]::ToInt64($TestIPBinary, 2)
    [int64] $StartInt64 = [System.Convert]::ToInt64($StartBinary, 2)
    [int64] $EndInt64 = [System.Convert]::ToInt64($EndBinary, 2)
    if ($TestIPInt64 -ge $StartInt64 -and $TestIPInt64 -le $EndInt64) {
        return $True
    } else {
        return $False
    }
}