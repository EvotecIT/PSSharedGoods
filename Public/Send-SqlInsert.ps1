function Send-SqlInsert {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [Object] $SqlSettings
    )
    $Queries = New-ArrayList
    $ReturnData = @()
    if ($SqlSettings.SqlTableTranspose) {
        $Object = Format-TransposeTable -Object $Object
    }
    $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object

    if ($SqlSettings.SqlTableCreate) {
        $CreateTableSQL = New-SqlQueryCreateTable -SqlSettings $SqlSettings -TableMapping $TableMapping
        Add-ToArray -List $Queries -Element $CreateTableSQL
    }
    $Queries += New-SqlQuery -Object $Object -SqlSettings $SqlSettings -TableMapping $TableMapping
    foreach ($Query in $Queries) {
        $ReturnData += $Query
        try {
            if ($Query) {
                $ReturnData += Invoke-Sqlcmd2 -SqlInstance $SqlSettings.SqlServer -Database $SqlSettings.SqlDatabase -Query $Query -ErrorAction Stop
            }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $ReturnData += "Error occured: $ErrorMessage"
        }
    }
    return $ReturnData
}