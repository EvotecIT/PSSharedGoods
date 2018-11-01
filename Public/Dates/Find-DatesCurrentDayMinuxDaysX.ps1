function Find-DatesCurrentDayMinuxDaysX ($days) {
    $DateTodayStart = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays( - $Days)
    $DateTodayEnd = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays(1).AddMilliseconds(-1)

    $DateParameters = @{
        DateFrom = $DateTodayStart
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}