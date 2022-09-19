function Split-Array {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        Split an array
        .NOTES
        Version : July 2, 2017 - implemented suggestions from ShadowSHarmon for performance
        .PARAMETER inArray
        A one dimensional array you want to split
        .EXAMPLE
        This splits array into multiple arrays of 3
        Example below wil return 1,2,3  + 4,5,6 + 7,8,9

        Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -parts 3
        .EXAMPLE
        This splits array into 3 parts regardless of amount of elements

        Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -size 3

        # Link: https://gallery.technet.microsoft.com/scriptcenter/Split-an-array-into-parts-4357dcc1
    #>
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
    return , $outArray
}