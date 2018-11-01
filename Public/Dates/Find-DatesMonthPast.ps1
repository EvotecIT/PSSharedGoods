function Find-DatesMonthPast ([bool] $Force) {
    $DateToday = (Get-Date).Date
    $DateMonthFirstDay = (GET-DATE -Day 1).Date
    $DateMonthPreviousFirstDay = $DateMonthFirstDay.AddMonths(-1)

    if ($Force -eq $true -or $DateToday -eq $DateMonthFirstDay) {
        $DateParameters = @{
            DateFrom = $DateMonthPreviousFirstDay
            DateTo   = $DateMonthFirstDay
        }
        return $DateParameters
    } else {
        return $null
    }
}