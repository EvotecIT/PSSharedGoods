function Get-TimeZoneLegacy () {
    return ([System.TimeZone]::CurrentTimeZone).StandardName
}
