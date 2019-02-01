function Get-SqlQueryColumnInformation {
    [CmdletBinding()]
    param (
        [string] $SqlServer,
        [string] $SqlDatabase,
        [string] $Table
    )
    $Table = $Table.Replace("dbo.", '').Replace('[', '').Replace(']', '') # removes dbo and [] from dbo.[Table] as INFORMATION_SCHEMA expects it without
    $Query = "SELECT * FROM $SqlDatabase.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$Table'"
    try {
        $SQLReturn = Invoke-Sqlcmd2 -ErrorAction Stop -ServerInstance $SqlServer -Query $Query #-Verbose
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        $SQLReturn += "Error occured (Get-SqlQueryColumnInformation): $ErrorMessage"
    }
    return $SQLReturn
}