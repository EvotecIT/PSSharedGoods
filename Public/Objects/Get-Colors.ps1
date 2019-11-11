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
Register-ArgumentCompleter -CommandName Get-Colors -ParameterName Color -ScriptBlock { $Script:RGBColors.Keys }