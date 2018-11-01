function Find-DatesMonthCurrent () {
    $DateMonthFirstDay = (GET-DATE -Day 1).Date
    $DateMonthLastDay = GET-DATE $DateMonthFirstDay.AddMonths(1).AddSeconds(-1)

    $DateParameters = @{
        DateFrom = $DateMonthFirstDay
        DateTo   = $DateMonthLastDay
    }
    return $DateParameters
}