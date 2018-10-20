function Convert-ToTimeSpan {
    [CmdletBinding()]
    param (
        $StartTime,
        $EndTime
    )
    if ($StartTime -and $EndTime) {
        try {
            $TimeSpan = (NEW-TIMESPAN -Start (GET-DATE) -End ($EndTime))
        } catch {
            $TimeSpan = $null
        }
    }
    if ($TimeSpan -ne $null) {
        return $TimeSpan
    } else {
        return $null
    }
}