Function Split-ArrayEvery {
    [CmdletBinding()]
    param(
        $list,
        [int] $count = 4
    )
    $aggregateList = @()

    $blocks = [Math]::Floor($list.Count / $count)
    $leftOver = $list.Count % $count
    $start = $end = 0
    for ($i = 0; $i -lt $blocks; $i++) {
        $end = $count * ($i + 1) - 1

        $aggregateList += @(, $list[$start..$end])
        $start = $end + 1
    }
    if ($leftOver -gt 0) {
        $aggregateList += @(, $list[$start..($end + $leftOver)])
    }

    $aggregateList
}