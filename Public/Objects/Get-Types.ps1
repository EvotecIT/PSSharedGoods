Function Get-Types {
    [CmdletBinding()]
    param (
        [Object] $Types
    )
    $TypesRequired = foreach ($Type in $Types) {
        $Type.GetEnumValues()
    }
    return $TypesRequired
}