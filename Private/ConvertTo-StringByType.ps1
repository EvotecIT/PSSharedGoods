function ConvertTo-StringByType {
    <#
    .SYNOPSIS
    Private function to use within ConvertTo-JsonLiteral

    .DESCRIPTION
    Private function to use within ConvertTo-JsonLiteral

    .PARAMETER Value
    Value to convert to JsonValue

     .PARAMETER Depth
    Specifies how many levels of contained objects are included in the JSON representation. The default value is 0.

    .PARAMETER AsArray
    Outputs the object in array brackets, even if the input is a single object.

    .PARAMETER DateTimeFormat
    Changes DateTime string format. Default "yyyy-MM-dd HH:mm:ss"

    .PARAMETER NumberAsString
    Provides an alternative serialization option that converts all numbers to their string representation.

    .PARAMETER BoolAsString
    Provides an alternative serialization option that converts all bool to their string representation.

    .PARAMETER PropertyName
    Uses PropertyNames provided by user (only works with Force)

    .PARAMETER ArrayJoin
    Forces any array to be a string regardless of depth level

    .PARAMETER ArrayJoinString
    Uses defined string or char for array join. By default it uses comma with a space when used.

    .PARAMETER Force
    Forces using property names from first object or given thru PropertyName parameter

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
        [System.Collections.IDictionary] $AdvancedReplace,
        [System.Text.StringBuilder] $TextBuilder,
        [string[]] $PropertyName,
        [switch] $ArrayJoin,
        [string] $ArrayJoinString,
        [switch] $Force
    )
    Process {
        if ($null -eq $Value) {
            "`"`""
        } elseif ($Value -is [string]) {
            $Value = $Value.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
            #$Value = $Value.Replace('.', '\.').Replace('$', '\$')
            foreach ($Key in $AdvancedReplace.Keys) {
                $Value = $Value.Replace($Key, $AdvancedReplace[$Key])
            }
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
                    $OutputValue = ConvertTo-StringByType -Value $Value[$Property] -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder -Force:$Force -ArrayJoinString $ArrayJoinString
                    $null = $TextBuilder.Append("$OutputValue")
                    if ($i -ne ($Value.Keys).Count - 1) {
                        $null = $TextBuilder.AppendLine(',')
                    }
                }
                $null = $TextBuilder.Append("}")
            }
        } elseif ($Value -is [System.Collections.IList] -or $Value -is [System.Collections.ReadOnlyCollectionBase]) {
            if ($ArrayJoin) {
                $Value = $Value -join $ArrayJoinString
                $Value = "$Value".Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                "`"$Value`""
            } else {
                if ($MaxDepth -eq 0 -or $Depth -eq $MaxDepth) {
                    $Value = "$Value".Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                    "`"$Value`""
                } else {
                    $CountInternalObjects = 0
                    $null = $TextBuilder.Append("[")
                    foreach ($V in $Value) {
                        $CountInternalObjects++
                        if ($CountInternalObjects -gt 1) {
                            $null = $TextBuilder.Append(',')
                        }
                        if ($Force -and -not $PropertyName) {
                            $PropertyName = $V.PSObject.Properties.Name
                        } elseif ($Force -and $PropertyName) {

                        } else {
                            $PropertyName = $V.PSObject.Properties.Name
                        }
                        $OutputValue = ConvertTo-StringByType -Value $V -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder -Force:$Force -PropertyName $PropertyName -ArrayJoinString $ArrayJoinString
                        $null = $TextBuilder.Append($OutputValue)
                    }
                    $null = $TextBuilder.Append("]")
                }
            }
        } elseif ($Value -is [System.Enum]) {
            "`"$($($Value).ToString())`""
        } elseif (($Value | IsNumeric) -eq $true) {
            if ($NumberAsString) {
                "`"$($Value)`""
            } else {
                $($Value)
            }
        } elseif ($Value -is [PSObject]) {
            if ($MaxDepth -eq 0 -or $Depth -eq $MaxDepth) {
                "`"$($Value)`""
            } else {
                $Depth++
                $CountInternalObjects = 0
                $null = $TextBuilder.AppendLine("{")
                if ($Force -and -not $PropertyName) {
                    $PropertyName = $Value.PSObject.Properties.Name
                } elseif ($Force -and $PropertyName) {

                } else {
                    $PropertyName = $Value.PSObject.Properties.Name
                }
                foreach ($Property in $PropertyName) {
                    $CountInternalObjects++
                    if ($CountInternalObjects -gt 1) {
                        $null = $TextBuilder.AppendLine(',')
                    }
                    $DisplayProperty = $Property.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                    $null = $TextBuilder.Append("`"$DisplayProperty`":")
                    $OutputValue = ConvertTo-StringByType -Value $Value.$Property -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $Depth -MaxDepth $MaxDepth -TextBuilder $TextBuilder -Force:$Force -ArrayJoinString $ArrayJoinString
                    $null = $TextBuilder.Append("$OutputValue")
                }
                $null = $TextBuilder.Append("}")
            }
        } else {
            $Value = $Value.ToString().Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
            "`"$Value`""
        }
    }
}