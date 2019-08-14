function Get-WMILocalDateTime {
    [CmdletBinding()]
    param(
        [Object] $WMILocalTime
    )
    if ($WMILocalTime -and $WMILocalTime.Year -and $WMILocalTime.Month) {
        Get-Date -Year $WMILocalTime.Year -Month $WMILocalTime.Month -Day $WMILocalTime.Day -Hour $WMILocalTime.Hour -Minute $WMILocalTime.Minute -Second $WMILocalTime.Second
    }
}