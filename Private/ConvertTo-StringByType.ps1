﻿function ConvertTo-StringByType {
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
        [switch] $NumberAsString,
        [switch] $BoolAsString,
        [System.Collections.IDictionary] $NewLineFormat = @{
            NewLineCarriage = '\r\n'
            NewLine         = "\n"
            Carriage        = "\r"
        },
        [System.Collections.IDictionary] $NewLineFormatProperty = @{
            NewLineCarriage = '\r\n'
            NewLine         = "\n"
            Carriage        = "\r"
        },
        [System.Text.StringBuilder] $TextBuilder
    )
    if ($null -eq $Value) {
        "`"`""
    } elseif ($Value -is [string]) {
        #"`"$Value`""
        $Value = $Value.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage) #.Replace("`r`n", '\r\n')
        #$Value = $Value.Replace('\', "\\").Replace('"', '\"') -replace '\r?\n', '\n'
        "`"$Value`""
    } elseif ($Value -is [DateTime]) {
        "`"$($($Value).ToString($DateTimeFormat))`""
    } elseif ($Value -is [bool]) {
        if ($BoolAsString) {
            "`"$($Value)`""
        } else {
            $Value.ToString().ToLower()
        }
    } elseif ($Value -is [System.Collections.IDictionary]) {
        if ($MaxDepth -eq 0 -or $Depth -eq $MaxDepth) {
            "`"$($Value)`""
        } else {
            $Depth++
            $null = $TextBuilder.AppendLine("{")
            for ($i = 0; $i -lt ($Value.Keys).Count; $i++) {
                $Property = ([string[]]$Value.Keys)[$i]
                $DisplayProperty = $Property.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                $null = $TextBuilder.Append("`"$DisplayProperty`":")
                $OutputValue = ConvertTo-StringByType -Value $Value[$Property] -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder
                $null = $TextBuilder.Append("$OutputValue")
                if ($i -ne ($Value.Keys).Count - 1) {
                    $null = $TextBuilder.AppendLine(',')
                }
            }
            $null = $TextBuilder.Append("}")
        }
    } elseif ($Value -is [System.Collections.IList] -or $Value -is [System.Collections.ReadOnlyCollectionBase]) {
        if ($MaxDepth -eq 0 -or $Depth -eq $MaxDepth) {
            $Value = "$Value".Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, "\r\n").Replace("`n", "\n").Replace("`r", '\r') #.Replace("`r`n", '\r\n')
            #$Value = $Value.Replace('\', "\\").Replace('"', '\"') -replace '\r?\n', '\n'
            "`"$Value`""
            #"`"$($Value)`""
        } else {
            $CountInternalObjects = 0
            $null = $TextBuilder.Append("[")
            foreach ($V in $Value) {
                $CountInternalObjects++
                if ($CountInternalObjects -gt 1) {
                    $null = $TextBuilder.Append(',')
                }
                $OutputValue = ConvertTo-StringByType -Value $V -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder
                $null = $TextBuilder.Append($OutputValue)
            }
            $null = $TextBuilder.Append("]")
        }
    } elseif ($Value -is [PSObject]) {
        if ($MaxDepth -eq 0 -or $Depth -eq $MaxDepth) {
            "`"$($Value)`""
        } else {
            $Depth++
            $CountInternalObjects = 0
            $null = $TextBuilder.AppendLine("{")
            foreach ($Property in $Value.PSObject.Properties.Name) {
                $CountInternalObjects++
                if ($CountInternalObjects -gt 1) {
                    $null = $TextBuilder.AppendLine(',')
                }
                $DisplayProperty = $Property.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                $null = $TextBuilder.Append("`"$DisplayProperty`":")
                $OutputValue = ConvertTo-StringByType -Value $Value.$Property -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder
                $null = $TextBuilder.Append("$OutputValue")
            }
            $null = $TextBuilder.Append("}")
        }
    } elseif ($Value -is [System.Enum]) {
        "`"$($($Value).ToString())`""
    } elseif (($Value | IsNumeric) -eq $true) {
        if ($NumberAsString) {
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