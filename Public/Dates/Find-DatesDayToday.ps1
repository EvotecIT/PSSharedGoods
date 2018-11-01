function Find-DatesDayToday () {
    $DateToday = (GET-DATE).Date
    $DateTodayEnd = $DateToday.AddDays(1).AddSeconds(-1)

    $DateParameters = @{
        DateFrom = $DateToday
        DateTo   = $DateTodayEnd
    }
    return $DateParameters
}