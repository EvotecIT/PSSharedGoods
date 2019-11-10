function Get-ObjectData {
    [CmdletBinding()]
    param(
        $Object,
        $Title,
        [switch] $DoNotAddTitles
    )
    [Array] $Values = $Object.$Title
    [Array] $ArrayList = @(
        if ($Values.Count -eq 1 -and $DoNotAddTitles -eq $false) {
            "$Title - $($Values[0])"
        } else {
            if ($DoNotAddTitles -eq $false) {
                $Title
            }
            foreach ($Value in $Values) {
                "$Value"
            }
        }
    )
    return $ArrayList
}