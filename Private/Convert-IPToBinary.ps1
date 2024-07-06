function Convert-IPToBinary {
    <#
    .SYNOPSIS
    Converts an IPv4 address to binary format.

    .DESCRIPTION
    This function takes an IPv4 address as input and converts it to binary format.

    .PARAMETER IP
    Specifies the IPv4 address to convert to binary format.

    .EXAMPLE
    Convert-IPToBinary -IP "192.168.1.1"
    Converts the IPv4 address "192.168.1.1" to binary format.

    .EXAMPLE
    Convert-IPToBinary -IP "10.0.0.1"
    Converts the IPv4 address "10.0.0.1" to binary format.

    #>
    [cmdletBinding()]
    param(
        [string] $IP
    )
    $IPv4Regex = '(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)'
    $IP = $IP.Trim()
    if ($IP -match "\A${IPv4Regex}\z") {
        try {
            return ($IP.Split('.') | ForEach-Object { [System.Convert]::ToString([byte] $_, 2).PadLeft(8, '0') }) -join ''
        } catch {
            Write-Warning -Message "Convert-IPToBinary - Error converting '$IP' to a binary string: $_"
            return $Null
        }
    } else {
        Write-Warning -Message "Convert-IPToBinary - Invalid IP detected: '$IP'. Conversion failed."
        return $Null
    }
}