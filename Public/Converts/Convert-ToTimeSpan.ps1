function Convert-ToTimeSpan {
    [CmdletBinding()]
    param (
        [DateTime] $StartTime = (Get-Date),
        [DateTime] $EndTime
    )
    if ($StartTime -and $EndTime) {
        try {
            $TimeSpan = (NEW-TIMESPAN -Start $StartTime -End $EndTime)
        } catch {
            $TimeSpan = $null
        }
    }
    if ($null -ne $TimeSpan) {
        return $TimeSpan
    } else {
        return $null
    }
}