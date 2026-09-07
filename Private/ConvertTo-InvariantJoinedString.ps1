function ConvertTo-InvariantJoinedString {
    [CmdletBinding()]
    param(
        [AllowNull()]
        [System.Collections.IEnumerable] $Value,

        [AllowNull()]
        [string] $Separator
    )

    $ConvertedValues = [System.Collections.Generic.List[string]]::new()
    foreach ($Item in $Value) {
        if ($null -eq $Item) {
            $ConvertedValues.Add([string]::Empty)
        } elseif (
            $Item -is [byte] -or $Item -is [int16] -or $Item -is [int32] -or $Item -is [int64] -or
            $Item -is [sbyte] -or $Item -is [uint16] -or $Item -is [uint32] -or $Item -is [uint64] -or
            $Item -is [float] -or $Item -is [double] -or $Item -is [decimal]
        ) {
            $ConvertedValues.Add([System.Convert]::ToString($Item, [System.Globalization.CultureInfo]::InvariantCulture))
        } else {
            $ConvertedValues.Add([string] $Item)
        }
    }

    $ConvertedValues -join $Separator
}
