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