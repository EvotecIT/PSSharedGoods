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