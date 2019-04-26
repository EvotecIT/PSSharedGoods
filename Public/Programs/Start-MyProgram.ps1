function Start-MyProgram {
    [CmdletBinding()]
    param (
        [string] $Program,
        [string[]] $CmdArgList,
        [System.Collections.IDictionary] $LoggerParameters
    )

   # $Output = & $Program $CmdArgList 2>&1
    $Output = (cmd /c $Program $CmdArgList '2>&1')
    if (-not $LoggerParameters) {
        return $Output
    } else {
        $Logger = Get-Logger @LoggerParameters
        $Logger.AddInfoRecord("Running program $Program - $Output")
    }
}