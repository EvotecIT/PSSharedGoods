function Get-TimeZoneLegacy () {
    <#
    .SYNOPSIS
    Retrieves the standard name of the current time zone.

    .DESCRIPTION
    The Get-TimeZoneLegacy function retrieves the standard name of the current time zone using the legacy method.

    .EXAMPLE
    Get-TimeZoneLegacy
    # Output: "Pacific Standard Time"

    #>
    return ([System.TimeZone]::CurrentTimeZone).StandardName
}
