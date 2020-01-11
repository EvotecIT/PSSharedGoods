function Get-SqlQueryColumnInformation {
    [CmdletBinding()]
    param (
        [string] $SqlServer,
        [string] $SqlDatabase,
        [string] $Table
    )
    $Table = $Table.Replace("dbo.", '').Replace('[', '').Replace(']', '') # removes dbo and [] from dbo.[Table] as INFORMATION_SCHEMA expects it without
    $SqlDatabase = $SqlDatabase.Replace('[', '').Replace(']', '') # makes sure we know what we have
    $SqlDatabase = "[$SqlDatabase]"
    $Query = "SELECT * FROM $SqlDatabase.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$Table'"
    $SqlReturn = @(
        try {
            Invoke-DbaQuery -ErrorAction Stop -SqlInstance $SqlServer -Query $Query #-Verbose
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            "Error occured (Get-SqlQueryColumnInformation): $ErrorMessage" # return of error
        }
    )
    return $SQLReturn
}