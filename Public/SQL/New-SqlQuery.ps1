function New-SqlQuery {
    [CmdletBinding()]
    param (
        [Object] $SqlSettings,
        [Object] $Object,
        [Object] $TableMapping
    )
    <#
    Example on how output looks like:
    IF NOT EXISTS (
        SELECT 1 FROM dbo.[EventsLogsClearedSecurity] WHERE [RecordID] = '2434391'
        )
    BEGIN
        --INSERT INTO Users (FirstName, LastName) VALUES ('John', 'Smith')
        INSERT INTO  dbo.[EventsLogsClearedSecurity] ( [DomainController],[Action],[BackupPath],[LogType],[Who],[When],[EventID],[RecordID],[AddedWhen],[AddedWho] ) VALUES ( 'AD1.ad.evotec.xyz','Event log automatic backup','C:\Windows\System32\Winevt\Logs\Archive-Security-2018-09-25-14-12-52-658.evtx','Security','Automatic Backup','2018-09-25 16:12:53','1105','2434391','2018-09-25 20:49:02','przemyslaw.klys' )
    END
    #>
    $ArraySQLQueries = New-ArrayList
    if ($null -ne $Object) {
        ## Added fields to know when event was added to SQL and by WHO (in this case TaskS Scheduler User)
        ## Only adding when $Object exists
        foreach ($O in $Object) {
            $ArrayMain = New-ArrayList
            $ArrayKeys = New-ArrayList
            $ArrayValues = New-ArrayList

            if (-not $O.AddedWhen) {
                Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWhen" -Value (Get-Date)
            }
            if (-not $O.AddedWho) {
                Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWho" -Value ($Env:USERNAME)
            }
            $DuplicateString = [System.Text.StringBuilder]::new()
            foreach ($E in $O.PSObject.Properties) {
                $FieldName = $E.Name
                $FieldValue = $E.Value

                foreach ($MapKey in $TableMapping.Keys) {
                    if ($FieldName -eq $MapKey) {
                        $MapValue = $TableMapping.$MapKey
                        $MapValueSplit = $MapValue -Split ','



                        if ($FieldValue -is [DateTime]) { $FieldValue = Get-Date $FieldValue -Format "yyyy-MM-dd HH:mm:ss" }
                        if ($FieldValue -like "*'*") { $FieldValue = $FieldValue -Replace "'", "''" }
                        Add-ToArray -List $ArrayKeys -Element "[$($MapValueSplit[0])]"
                        if ([string]::IsNullOrWhiteSpace($FieldValue)) {

                            Add-ToArray -List $ArrayValues -Element "NULL"
                        } else {
                            foreach ($ColumnName in $SqlSettings.SqlCheckBeforeInsert) {
                                $DuplicateColumn = $ColumnName.Replace("[", '').Replace("]", '') # Remove [ ] for comparision

                                if ($MapValueSplit[0] -eq $DuplicateColumn) {
                                    if ($DuplicateString.Length -ne 0) {
                                        # Means something is already in string so most likely 2nd run
                                        $null = $DuplicateString.Append(" AND ")
                                    }
                                    $null = $DuplicateString.Append("[$DuplicateColumn] = '$FieldValue'")
                                    
                                }
                            }
                            Add-ToArray -List $ArrayValues -Element "'$FieldValue'"
                        }
                    }
                }
            }
            if ($ArrayKeys) {
                if ($null -ne $SqlSettings.SqlCheckBeforeInsert -and $DuplicateString.Length -gt 0) {
                    Add-ToArray -List $ArrayMain -Element "IF NOT EXISTS ("
                    Add-ToArray -List $ArrayMain -Element "SELECT 1 FROM "
                    Add-ToArray -List $ArrayMain -Element "$($SqlSettings.SqlTable) "
                    Add-ToArray -List $ArrayMain -Element "WHERE $($DuplicateString.ToString())"
                    Add-ToArray -List $ArrayMain -Element ")"
                }
                Add-ToArray -List $ArrayMain -Element "BEGIN"
                Add-ToArray -List $ArrayMain -Element "INSERT INTO  $($SqlSettings.SqlTable) ("
                Add-ToArray -List $ArrayMain -Element ($ArrayKeys -join ',')
                Add-ToArray -List $ArrayMain -Element ') VALUES ('
                Add-ToArray -List $ArrayMain -Element ($ArrayValues -join ',')
                Add-ToArray -List $ArrayMain -Element ')'
                Add-ToArray -List $ArrayMain -Element "END"
                Add-ToArray -List $ArraySQLQueries -Element ([string] ($ArrayMain) -replace "`n", "" -replace "`r", "")
            }
        }
    }
    return $ArraySQLQueries
}