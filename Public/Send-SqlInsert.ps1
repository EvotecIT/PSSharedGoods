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
    $SqlTable = Get-SqlQueryColumnInformation -SqlServer $SqlSettings.SqlServer -SqlDatabase $SqlSettings.SqlDatabase -Table $SqlSettings.SqlTable
    if ($SqlTable -eq $null -and $SqlSettings.SqlTableCreate -eq $false) {
        $ReturnData += "Error occured: SQL Table doesn't exists. SqlTableCreate option is disabled"
        return $ReturnData
    }
    if ($SqlTable) {

    }

    $PropertiesFromAllObject = Get-ObjectPropertiesAdvanced -Object $Object -AddProperties 'AddedWhen', 'AddedWho'

    $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject

    if ($SqlSettings.SqlTableCreate) {
        if ($SqlTable -eq $null) {
            # Table doesn't exists
            $CreateTableSQL = New-SqlQueryCreateTable -SqlSettings $SqlSettings -TableMapping $TableMapping
            Add-ToArray -List $Queries -Element $CreateTableSQL
        } else {
            # Table exists... altering Table to add missing columns
            $AlterTableSQL = New-SqlQueryAlterTable -SqlSettings $SqlSettings -TableMapping $TableMapping -ExistingColumns $SqlTable.Column_name
            Add-ToArray -List $Queries -Element $AlterTableSQL
        }

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