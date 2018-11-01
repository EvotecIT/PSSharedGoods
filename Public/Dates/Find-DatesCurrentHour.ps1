function Find-DatesCurrentHour () {
    $DateTodayStart = (Get-Date -Minute 0 -Second 0 -Millisecond 0)
    $DateTodayEnd = $DateTodayStart.AddHours(1)

    $DateParameters = @{
        DateFrom = $DateTodayStart
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}