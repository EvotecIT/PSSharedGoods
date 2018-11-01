function Find-DatesDayPrevious () {
    $DateToday = (GET-DATE).Date
    $DateYesterday = $DateToday.AddDays(-1)

    $DateParameters = @{
        DateFrom = $DateYesterday
        DateTo   = $dateToday
    }
    return $DateParameters
}