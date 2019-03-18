function New-SqlQueryAlterTable {
    [CmdletBinding()]
    param (
        [Object]$SqlSettings,
        [Object]$TableMapping,
        [string[]] $ExistingColumns
    )
    $ArraySQLQueries = New-ArrayList
    $ArrayMain = New-ArrayList
    $ArrayKeys = New-ArrayList

    foreach ($MapKey in $TableMapping.Keys) {
        $MapValue = $TableMapping.$MapKey
        $Field = $MapValue -Split ','


        if ($ExistingColumns -notcontains $MapKey -and $ExistingColumns -notcontains $Field[0]) {
            if ($Field.Count -eq 1) {
                Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] [nvarchar](max) NULL"
            } elseif ($Field.Count -eq 2) {
                Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] $($Field[1]) NULL"
            } elseif ($Field.Count -eq 3) {
                Add-ToArray -List $ArrayKeys -Element "[$($Field[0])] $($Field[1]) $($Field[2])"
            }
        }
    }

    if ($ArrayKeys) {
        Add-ToArray -List $ArrayMain -Element "ALTER TABLE $($SqlSettings.SqlTable) ADD"
        Add-ToArray -List $ArrayMain -Element ($ArrayKeys -join ',')
        Add-ToArray -List $ArrayMain -Element ';'
        Add-ToArray -List $ArraySQLQueries -Element ([string] ($ArrayMain) -replace "`n", "" -replace "`r", "")
    }
    return $ArraySQLQueries
}