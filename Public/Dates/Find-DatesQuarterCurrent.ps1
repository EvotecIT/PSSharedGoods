function Find-DatesQuarterCurrent ([bool] $Force) {
    $Today = (Get-Date)
    $Quarter = [Math]::Ceiling($Today.Month / 3)
    $LastDay = [DateTime]::DaysInMonth([Int]$Today.Year.ToString(), [Int]($Quarter * 3))
    $StartDate = (get-date -Year $Today.Year -Month ($Quarter * 3 - 2) -Day 1).Date
    $EndDate = (get-date -Year $Today.Year -Month ($Quarter * 3) -Day $LastDay).Date.AddDays(1).AddTicks(-1)
    $DateParameters = @{
        DateFrom = $StartDate
        DateTo   = $EndDate
    }
    return $DateParameters
}