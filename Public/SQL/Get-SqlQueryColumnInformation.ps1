function Get-SqlQueryColumnInformation {
    [CmdletBinding()]
    param (
        [string] $SqlServer,
        [string] $SqlDatabase,
        [string] $Table
    )
    $Table = $Table.Replace("dbo.", '').Replace('[', '').Replace(']', '') # removes dbo and [] from dbo.[Table] as INFORMATION_SCHEMA expects it without
    $Query = "SELECT * FROM $SqlDatabase.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$Table'"
    #Write-Verbose $Query
    $SQLReturn = Invoke-Sqlcmd2 -ServerInstance $SqlServer -Query $Query #-Verbose
    return $SQLReturn
}