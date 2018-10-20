function Start-MyProgram {
    [CmdletBinding()]
    param (
        [string] $Program,
        [string[]]$cmdArgList
    )
    return & $Program $cmdArgList
}