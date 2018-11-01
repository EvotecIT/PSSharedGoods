function Find-DatesPastHour () {
    $DateTodayEnd = Get-Date -Minute 0 -Second 0 -Millisecond 0
    $DateTodayStart = $DateTodayEnd.AddHours(-1)

    $DateParameters = @{
        DateFrom = $DateTodayStart
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}