Function Get-ObjectEnumValues {
    param(
        [string]$enum
    )
    $enumValues = @{}
    [enum]::getvalues([type]$enum) |
        ForEach-Object {
        $enumValues.add($_, $_.value__)
    }
    $enumValues
}