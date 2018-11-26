function Start-MyProgram {
    [CmdletBinding()]
    param (
        [string] $Program,
        [string[]] $CmdArgList
    )
    return & $Program $CmdArgList
}