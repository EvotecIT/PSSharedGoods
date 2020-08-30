function Get-Colors {
    [CmdletBinding()]
    param(
        [string[]] $Color
    )
    if ($Color) {
        foreach ($_ in $Color) {
            $Script:RGBColors.$_
        }
    } else {
        return $Script:RGBColors
    }
}
$ScriptBlockColors = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $Script:RGBColors.Keys | Where-Object { $_ -like "*$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName Get-Colors -ParameterName Color -ScriptBlock $ScriptBlockColors