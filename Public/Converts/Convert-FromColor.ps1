function ConvertFrom-Color {
    [alias('Convert-FromColor')]
    [CmdletBinding()]
    param (
        [alias('Colors')][RGBColors[]] $Color,
        [switch] $AsDecimal
    )
    $Colors = foreach ($C in $Color) {
        $Value = $Script:RGBColors."$C"
        $HexValue = Convert-Color -RGB $Value
        Write-Verbose "Convert-FromColor - Color Name: $C Value: $Value HexValue: $HexValue"
        <#
    [string] $HexVal = ''
    foreach ($arg in $Value) {
        $hexval = $hexval + [Convert]::ToString($arg, 16).ToUpper()
    }
    #>
        if ($AsDecimal) {
            [Convert]::ToInt64($HexValue, 16)
        } else {
            "#$($HexValue)"
        }
    }
    $Colors
}