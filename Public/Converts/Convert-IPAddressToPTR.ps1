function Convert-IpAddressToPtr {
    <#
    .SYNOPSIS
    Converts an IP address to a PTR record

    .DESCRIPTION
    This function takes an IP address as input and converts it to a PTR record.

    .PARAMETER IPAddress
    The IP address to convert

    .PARAMETER AsObject
    Should the function return an object instead of a string?

    .EXAMPLE
    Convert-IpAddressToPtr -IPAddress "10.1.2.3"

    .EXAMPLE
    Convert-IpAddressToPtr -IPAddress "10.1.2.3", "8.8.8.8" -AsObject

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$IPAddress,
        [switch] $AsObject
    )
    foreach ($IP in $IPAddress) {

        # Split the IP address into its octets
        $octets = $IP -split "\."

        # Reverse the octets
        [array]::Reverse($octets)

        # Join the reversed octets with dots and append the standard PTR suffix
        $ptrString = ($octets -join ".") + ".in-addr.arpa"

        if ($AsObject) {
            [pscustomobject] @{
                IPAddress = $IP
                PTR       = $ptrString
            }
        } else {
            $ptrString
        }
    }
}