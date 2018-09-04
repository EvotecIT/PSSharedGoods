function Show-DataInVerbose {
    [CmdletBinding()]
    param(
        [Object] $Object
    )
    foreach ($O in $Object) {
        foreach ($E in $O.PSObject.Properties) {
            $FieldName = $E.Name
            $FieldValue = $E.Value
            Write-Verbose "Display-DataInVerbose - FieldName: $FieldName FieldValue: $FieldValue"
        }
    }
}
function Show-Array {
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