function Show-Array {
    <#
    .SYNOPSIS
    Displays the elements of an ArrayList with optional type information.

    .DESCRIPTION
    The Show-Array function displays each element of the provided ArrayList. Optionally, it can also show the type of each element.

    .PARAMETER List
    Specifies the ArrayList containing the elements to display.

    .PARAMETER WithType
    Switch parameter to include type information along with each element.

    .EXAMPLE
    $myList = New-Object System.Collections.ArrayList
    $myList.Add("Apple")
    $myList.Add(42)
    Show-Array -List $myList
    # Output:
    # Apple
    # 42

    .EXAMPLE
    $myList = New-Object System.Collections.ArrayList
    $myList.Add("Banana")
    $myList.Add(3.14)
    Show-Array -List $myList -WithType
    # Output:
    # Banana (Type: String)
    # 3.14 (Type: Double)
    #>
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [switch] $WithType
    )
    foreach ($Element in $List) {
        $Type = Get-ObjectType -Object $Element
        if ($WithType) {
            Write-Output "$Element (Type: $($Type.ObjectTypeName))"
        } else {
            Write-Output $Element
        }
    }
}