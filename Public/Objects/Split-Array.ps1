function Split-Array {
    <#
    .SYNOPSIS
    Split an array into multiple arrays of a specified size or by a specified number of elements

    .DESCRIPTION
    Split an array into multiple arrays of a specified size or by a specified number of elements

    .PARAMETER Objects
    Lists of objects you would like to split into multiple arrays based on their size or number of parts to split into.

    .PARAMETER Parts
    Parameter description

    .PARAMETER Size
    Parameter description

    .EXAMPLE
    This splits array into multiple arrays of 3
    Example below wil return 1,2,3  + 4,5,6 + 7,8,9
    Split-array -Objects @(1,2,3,4,5,6,7,8,9,10) -Parts 3

    .EXAMPLE
    This splits array into 3 parts regardless of amount of elements
    Split-array -Objects @(1,2,3,4,5,6,7,8,9,10) -Size 3

    .NOTES

    #>
    [CmdletBinding()]
    param(
        [alias('InArray', 'List')][Array] $Objects,
        [int]$Parts,
        [int]$Size
    )
    if ($Objects.Count -eq 1) { return $Objects }
    if ($Parts) {
        $PartSize = [Math]::Ceiling($inArray.count / $Parts)
    }
    if ($Size) {
        $PartSize = $Size
        $Parts = [Math]::Ceiling($Objects.count / $Size)
    }
    $outArray = [System.Collections.Generic.List[Object]]::new()
    for ($i = 1; $i -le $Parts; $i++) {
        $start = (($i - 1) * $PartSize)
        $end = (($i) * $PartSize) - 1
        if ($end -ge $Objects.count) { $end = $Objects.count - 1 }
        $outArray.Add(@($Objects[$start..$end]))
    }
    , $outArray
}