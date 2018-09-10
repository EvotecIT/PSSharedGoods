function New-SqlTableMapping {
    [CmdletBinding()]
    param(
        [Object] $SqlTableMapping,
        [Object] $Object
    )
    if ($SqlTableMapping) {
        $TableMapping = $SqlTableMapping
    } else {
        $TableMapping = @{}
        foreach ($O in $Object) {
            if (-not $O.AddedWhen) {
                Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWhen" -Value (Get-Date)
            }
            if (-not $O.AddedWho) {
                Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWho" -Value ($Env:USERNAME)
            }
            foreach ($E in $O.PSObject.Properties) {
                $FieldName = $E.Name
                $FieldValue = $E.Value
                $FieldNameSQL = $($E.Name).Replace(' ', '') #.Replace('-', '')
                if ($FieldValue -is [DateTime]) {
                    $TableMapping.$FieldName = "$FieldNameSQL,[datetime],null"
                    #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [DateTime] NULL"
                } elseif ($FieldValue -is [int] -or $FieldValue -is [Int64]) {
                    $TableMapping.$FieldName = "$FieldNameSQL,[bigint]"
                    #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [bigint] NULL"
                } elseif ($FieldValue -is [bool]) {
                    $TableMapping.$FieldName = "$FieldNameSQL,[bit]"
                    #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [bit] NULL"
                } else {
                    $TableMapping.$FieldName = "$FieldNameSQL"
                    #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [nvarchar](max) NULL"
                }
            }
            break
        }
    }
    return $TableMapping
}