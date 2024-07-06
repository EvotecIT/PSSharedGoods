function Get-IPRange {
    <#
    .SYNOPSIS
    Generates a list of IP addresses within a specified binary range.

    .DESCRIPTION
    This function takes two binary strings representing the start and end IP addresses and generates a list of IP addresses within that range.

    .PARAMETER StartBinary
    Specifies the starting IP address in binary format.

    .PARAMETER EndBinary
    Specifies the ending IP address in binary format.

    .EXAMPLE
    Get-IPRange -StartBinary '11000000' -EndBinary '11000010'
    Description:
    Generates a list of IP addresses between '192.0.0.0' and '192.0.2.0'.

    .EXAMPLE
    Get-IPRange -StartBinary '10101010' -EndBinary '10101100'
    Description:
    Generates a list of IP addresses between '170.0.0.0' and '172.0.0.0'.
    #>
    [cmdletBinding()]
    param(
        [string] $StartBinary,
        [string] $EndBinary
    )
    [int64] $StartInt = [System.Convert]::ToInt64($StartBinary, 2)
    [int64] $EndInt = [System.Convert]::ToInt64($EndBinary, 2)
    for ($BinaryIP = $StartInt; $BinaryIP -le $EndInt; $BinaryIP++) {
        Convert-BinaryToIP ([System.Convert]::ToString($BinaryIP, 2).PadLeft(32, '0'))
    }
}