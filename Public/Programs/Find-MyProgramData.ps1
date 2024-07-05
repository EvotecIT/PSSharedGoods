function Find-MyProgramData {
    <#
    .SYNOPSIS
    Finds specific data within a given array of strings.

    .DESCRIPTION
    This function searches for a specific text within an array of strings and returns the second element of the string that matches the search criteria.

    .PARAMETER Data
    The array of strings to search through.

    .PARAMETER FindText
    The text to search for within the array of strings.

    .EXAMPLE
    Find-MyProgramData -Data @("Program A 123", "Program B 456", "Program C 789") -FindText "B"
    This example will return "456" as it finds the string containing "B" and returns the second element of that string.

    #>
    [CmdletBinding()]
    param (
        $Data,
        $FindText
    )
    foreach ($Sub in $Data) {
        if ($Sub -like $FindText) {
            $Split = $Sub.Split(' ')
            return $Split[1]
        }
    }
    return ''
}