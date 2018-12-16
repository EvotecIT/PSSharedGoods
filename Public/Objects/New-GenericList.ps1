function New-GenericList {
    [CmdletBinding()]
    param(
        [Object] $Type = [System.Object]
    )
    return New-Object "System.Collections.Generic.List[$Type]"
}