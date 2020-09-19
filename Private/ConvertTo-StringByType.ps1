function ConvertTo-StringByType {
    <#
    .SYNOPSIS
    Private function to use within ConvertTo-JsonLiteral

    .DESCRIPTION
    Private function to use within ConvertTo-JsonLiteral

    .PARAMETER Value
    Value to convert to JsonValue

    .PARAMETER DateTimeFormat
    Format to use when converting DateTime to string

    .EXAMPLE
    $Value = ConvertTo-StringByType -Value $($Object[$a][$i]) -DateTimeFormat $DateTimeFormat

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [Object] $Value,
        [int] $Depth,
        [int] $MaxDepth,
        [string] $DateTimeFormat,
        [switch] $NumberAsNumber,
        [switch] $BoolAsBool,
        [System.Text.StringBuilder] $TextBuilder
    )
    if ($null -eq $Value) {
        "`"`""
    } elseif ($Value -is [string]) {
        #"`"$Value`""
        $Value = $Value.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, "\r\n")
        "`"$Value`""
    } elseif ($Value -is [DateTime]) {
        "`"$($($Value).ToString($DateTimeFormat))`""
    } elseif ($Value -is [bool]) {
        if (-not $BoolAsBool) {
            "`"$($Value)`""
        } else {
            $Value.ToString().ToLower()
        }
    } elseif ($Value -is [System.Collections.IDictionary]) {
        if ($Depth -eq 0) {
            "`"$($Value.ToString())`""
        } else {
            $null = $TextBuilder.AppendLine("{")
            for ($i = 0; $i -lt ($Value.Keys).Count; $i++) {
                $Property = ([string[]]$Value.Keys)[$i]
                $null = $TextBuilder.Append("`"$Property`":")
                $OutputValue = ConvertTo-StringByType -Value $($Value[$Property]) -DateTimeFormat $DateTimeFormat -NumberAsNumber:$NumberAsNumber -BoolAsBool:$BoolAsBool -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder
                $null = $TextBuilder.Append("$OutputValue")
                if ($i -ne ($Value.Keys).Count - 1) {
                    $null = $TextBuilder.AppendLine(',')
                }
            }
            $null = $TextBuilder.Append("}")
        }
    } elseif ($Value -is [System.Collections.IList]) {
        if ($Depth -eq 0) {
            "`"$($Value.ToString())`""
        } else {
            $CountInternalObjects = 0
            $null = $TextBuilder.Append("[")
            foreach ($V in $Value) {
                $CountInternalObjects++
                if ($CountInternalObjects -gt 1) {
                    $null = $TextBuilder.Append(',')
                }
                $OutputValue = ConvertTo-StringByType -Value $V -DateTimeFormat $DateTimeFormat -NumberAsNumber:$NumberAsNumber -BoolAsBool:$BoolAsBool -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder
                $null = $TextBuilder.Append($OutputValue)
            }
            $null = $TextBuilder.Append("]")
        }
    } elseif ($Value | IsNumeric) {
        if (-not $NumberAsNumber) {
            "`"$($Value)`""
        } else {
            $($Value)
        }
    } else {
        try {
            $Value = $Value.ToString().Replace('"', '\"')
            "`"$([System.Text.RegularExpressions.Regex]::Unescape($Value))`""
            #"`"$Value`""
        } catch {
            "`"$($Value.Replace('\', "\\"))`""
        }
    }
}