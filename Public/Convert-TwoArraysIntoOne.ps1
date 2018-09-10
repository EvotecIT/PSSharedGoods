## This methods converts 2 Arrays into 1 Array
## Administrators  + 0 = Administrators (0)
function Convert-TwoArraysIntoOne {
    [CmdletBinding()]
    param (
        $Object,
        $ObjectToAdd
    )

    $Value = @()
    for ($i = 0; $i -lt $Object.Count; $i++) {
        $Value += "$($Object[$i]) ($($ObjectToAdd[$i]))"
    }
    return $Value
}