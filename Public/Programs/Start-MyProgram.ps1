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
        if ($Output) {
            return $Output
        }
    } else {
        $Logger = Get-Logger @LoggerParameters
        if ($null -ne $Output) {
            $Logger.AddInfoRecord("Running program $Program with output: $Output")
        } else {
            $Logger.AddInfoRecord("Running program $Program $CmdArgList")
        }
    }
}