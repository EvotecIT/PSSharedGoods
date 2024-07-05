## This methods converts 2 Arrays into 1 Array
## Administrators  + 0 = Administrators (0)
function Convert-TwoArraysIntoOne {
    <#
    .SYNOPSIS
    Combines two arrays into a single array by pairing elements from each array.

    .DESCRIPTION
    This function takes two arrays as input and combines them into a single array by pairing elements from each array. It creates a new array where each element is a combination of an element from the first array and the corresponding element from the second array.

    .PARAMETER Object
    Specifies the first array containing elements to be combined.

    .PARAMETER ObjectToAdd
    Specifies the second array containing elements to be paired with elements from the first array.

    .EXAMPLE
    Convert-TwoArraysIntoOne -Object @("A", "B", "C") -ObjectToAdd @(1, 2, 3)
    # Combines the arrays ["A", "B", "C"] and [1, 2, 3] into a single array: ["A (1)", "B (2)", "C (3)"].

    .EXAMPLE
    $Array1 = @("Apple", "Banana", "Cherry")
    $Array2 = @(5, 10, 15)
    Convert-TwoArraysIntoOne -Object $Array1 -ObjectToAdd $Array2
    # Combines the arrays $Array1 and $Array2 into a single array where each element pairs an item from $Array1 with the corresponding item from $Array2.

    #>
    [CmdletBinding()]
    param (
        $Object,
        $ObjectToAdd
    )

    $Value = for ($i = 0; $i -lt $Object.Count; $i++) {
        "$($Object[$i]) ($($ObjectToAdd[$i]))"
    }
    return $Value
}