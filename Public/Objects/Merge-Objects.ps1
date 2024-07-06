<#
$FoundUser1 = [pscustomobject] @{
    'Duplicate Group1' = 'test1'
    'User2'            = 'test2'
}

$FoundUser2 = [pscustomobject] @{
    'Duplicate Group2' = 'test3'
    'User1'            = 'test4'
}

Merge-Objects -Object1 $FoundUser1 -Object2 $FoundUser2
#>
function Merge-Objects {
    <#
    .SYNOPSIS
    Merges two objects into a single object.

    .DESCRIPTION
    This function merges two objects into a single object by combining their properties. If there are duplicate properties, the values from Object2 will overwrite the values from Object1.

    .PARAMETER Object1
    The first object to be merged.

    .PARAMETER Object2
    The second object to be merged.

    .EXAMPLE
    $Object1 = [pscustomobject] @{
        'Name' = 'John Doe'
        'Age'  = 30
    }

    $Object2 = [pscustomobject] @{
        'Age'  = 31
        'City' = 'New York'
    }

    Merge-Objects -Object1 $Object1 -Object2 $Object2

    Description
    -----------
    Merges $Object1 and $Object2 into a single object. The resulting object will have properties 'Name', 'Age', and 'City' with values 'John Doe', 31, and 'New York' respectively.

    #>
    [CmdletBinding()]
    param (
        [Object] $Object1,
        [Object] $Object2
    )
    $Object = [ordered] @{}
    foreach ($Property in $Object1.PSObject.Properties) {
        $Object.($Property.Name) = $Property.Value

    }
    foreach ($Property in $Object2.PSObject.Properties) {
        $Object.($Property.Name) = $Property.Value
    }
    return [pscustomobject] $Object
}