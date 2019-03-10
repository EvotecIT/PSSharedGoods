function Send-SqlInsert {
    [CmdletBinding()]
    param(
        [Array] $Object,
        [System.Collections.IDictionary] $SqlSettings
    )
    $Queries = New-ArrayList
    $ReturnData = @()
    if ($SqlSettings.SqlTableTranspose) {
        $Object = Format-TransposeTable -Object $Object
    }
    $SqlTable = Get-SqlQueryColumnInformation -SqlServer $SqlSettings.SqlServer -SqlDatabase $SqlSettings.SqlDatabase -Table $SqlSettings.SqlTable
    $PropertiesFromAllObject = Get-ObjectPropertiesAdvanced -Object $Object -AddProperties 'AddedWhen', 'AddedWho'
    $PropertiesFromTable = $SqlTable.Column_name

    if ($SqlTable -eq $null) {
        if ($SqlSettings.SqlTableCreate) {
            Write-Verbose "Send-SqlInsert - SqlTable doesn't exists, table creation is allowed, mapping will be done either on properties from object or from TableMapping defined in config"
            $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
            $CreateTableSQL = New-SqlQueryCreateTable -SqlSettings $SqlSettings -TableMapping $TableMapping
        } else {
            Write-Verbose "Send-SqlInsert - SqlTable doesn't exists, no table creation is allowed. Terminating"
            $ReturnData += "Error occured: SQL Table doesn't exists. SqlTableCreate option is disabled"
            return $ReturnData
        }
    } else {
        if ($SqlSettings.SqlTableAlterIfNeeded) {
            if ( $SqlSettings.SqlTableMapping) {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is allowed, but SqlTableMapping is already defined"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
            } else {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is allowed, and SqlTableMapping is not defined"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
                $AlterTableSQL = New-SqlQueryAlterTable -SqlSettings $SqlSettings -TableMapping $TableMapping -ExistingColumns $SqlTable.Column_name
            }
        } else {
            if ( $SqlSettings.SqlTableMapping) {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is not allowed, SqlTableMaping is already defined"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromAllObject
            } else {
                Write-Verbose "Send-SqlInsert - Sql Table exists, Alter is not allowed, SqlTableMaping is not defined, using SqlTable Columns"
                $TableMapping = New-SqlTableMapping -SqlTableMapping $SqlSettings.SqlTableMapping -Object $Object -Properties $PropertiesFromTable -BasedOnSqlTable
            }
        }
    }
    ### Rest of code is based on TableMapping
    <#
    if ($SqlSettings.SqlTableCreate) {
        if ($SqlTable -eq $null) {
            # Table doesn't exists
            $CreateTableSQL = New-SqlQueryCreateTable -SqlSettings $SqlSettings -TableMapping $TableMapping

        } else {
            # Table exists... altering Table to add missing columns
            $AlterTableSQL = New-SqlQueryAlterTable -SqlSettings $SqlSettings -TableMapping $TableMapping -ExistingColumns $SqlTable.Column_name

        }

    }
  #>
    Add-ToArrayAdvanced -List $Queries -Element $CreateTableSQL -SkipNull
    Add-ToArrayAdvanced -List $Queries -Element $AlterTableSQL -SkipNull

    $Queries += New-SqlQuery -Object $Object -SqlSettings $SqlSettings -TableMapping $TableMapping
    foreach ($Query in $Queries) {
        #Write-Verbose "Send-SqlInsert - query: $Query"
        $ReturnData += $Query
        try {
            if ($Query) {
                $ReturnData += Invoke-DbaQuery -SqlInstance $SqlSettings.SqlServer -Database $SqlSettings.SqlDatabase -Query $Query -ErrorAction Stop
            }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $ReturnData += "Error occured (Send-SqlInsert): $ErrorMessage"
        }
    }
    return $ReturnData
}