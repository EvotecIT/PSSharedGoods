function Convert-TimeToDays {
    [CmdletBinding()]
    param (
        $StartTime,
        $EndTime,
        [string] $Ignore = '*1601*'
    )
    if ($StartTime -and $EndTime) {
        try {
            if ($StartTime -notlike $Ignore -and $EndTime -notlike $Ignore) {
                $Days = (NEW-TIMESPAN -Start (GET-DATE) -End ($EndTime)).Days
            } else {
                $Days = $null
            }
        } catch {
            $Days = $null
        }
    }
    return $Days
}