function ConvertTo-JsonLiteral {
    <#
    .SYNOPSIS
    Converts an object to a JSON-formatted string.

    .DESCRIPTION
    The ConvertTo-Json cmdlet converts any object to a string in JavaScript Object Notation (JSON) format. The properties are converted to field names, the field values are converted to property values, and the methods are removed.

    .PARAMETER Object
    Specifies the objects to convert to JSON format. Enter a variable that contains the objects, or type a command or expression that gets the objects. You can also pipe an object to ConvertTo-JsonLiteral

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

    .PARAMETER NewLineFormat
    Provides a way to configure how new lines are converted for property names

    .PARAMETER NewLineFormatProperty
    Provides a way to configure how new lines are converted for values

    .PARAMETER PropertyName
    Allows passing property names to be used for custom objects (hashtables and alike are unaffected)

    .PARAMETER ArrayJoin
    Forces any array to be a string regardless of depth level

    .PARAMETER ArrayJoinString
    Uses defined string or char for array join. By default it uses comma with a space when used.

    .PARAMETER Force
    Forces using property names from first object or given thru PropertyName parameter

    .EXAMPLE
    Get-Process | Select-Object -First 2 | ConvertTo-JsonLiteral

    .EXAMPLE
    Get-Process | Select-Object -First 2 | ConvertTo-JsonLiteral -Depth 3

    .EXAMPLE
    Get-Process | Select-Object -First 2 | ConvertTo-JsonLiteral -NewLineFormat $NewLineFormat = @{
        NewLineCarriage = '\r\n'
        NewLine         = "\n"
        Carriage        = "\r"
    } -NumberAsString -BoolAsString

    .EXAMPLE
    Get-Process | Select-Object -First 2 | ConvertTo-JsonLiteral -NumberAsString -BoolAsString -DateTimeFormat "yyyy-MM-dd HH:mm:ss"

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [alias('InputObject')][Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, Mandatory)][Array] $Object,
        [int] $Depth,
        [switch] $AsArray,
        [string] $DateTimeFormat = "yyyy-MM-dd HH:mm:ss",
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
        [string] $ArrayJoinString,
        [switch] $ArrayJoin,
        [string[]]$PropertyName,
        [switch] $Force
    )
    Begin {
        $TextBuilder = [System.Text.StringBuilder]::new()
        $CountObjects = 0
        filter IsNumeric() {
            return $_ -is [byte] -or $_ -is [int16] -or $_ -is [int32] -or $_ -is [int64]  `
                -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
                -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
        }
        filter IsOfType() {
            return $_ -is [bool] -or $_ -is [char] -or $_ -is [datetime] -or $_ -is [string] `
                -or $_ -is [timespan] -or $_ -is [URI] `
                -or $_ -is [byte] -or $_ -is [int16] -or $_ -is [int32] -or $_ -is [int64] `
                -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
                -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
        }
        [int] $MaxDepth = $Depth
        [int] $InitialDepth = 0
    }
    Process {
        for ($a = 0; $a -lt $Object.Count; $a++) {
            $CountObjects++
            if ($CountObjects -gt 1) {
                $null = $TextBuilder.Append(',')
            }
            if ($Object[$a] -is [System.Collections.IDictionary]) {
                # Push to TEXT the same as [PSCustomObject]
                $null = $TextBuilder.AppendLine("{")
                for ($i = 0; $i -lt ($Object[$a].Keys).Count; $i++) {
                    $Property = ([string[]]$Object[$a].Keys)[$i] #.Replace('\', "\\").Replace('"', '\"')
                    $DisplayProperty = $Property.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                    $null = $TextBuilder.Append("`"$DisplayProperty`":")
                    $Value = ConvertTo-StringByType -Value $Object[$a][$Property] -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $InitialDepth -MaxDepth $MaxDepth -TextBuilder $TextBuilder -NewLineFormat $NewLineFormat -NewLineFormatProperty $NewLineFormatProperty -Force:$Force -ArrayJoin:$ArrayJoin -ArrayJoinString $ArrayJoinString
                    $null = $TextBuilder.Append("$Value")
                    if ($i -ne ($Object[$a].Keys).Count - 1) {
                        $null = $TextBuilder.AppendLine(',')
                    }
                }
                $null = $TextBuilder.Append("}")
            } elseif ($Object[$a] | IsOfType) {
                $Value = ConvertTo-StringByType -Value $Object[$a] -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $InitialDepth -MaxDepth $MaxDepth -TextBuilder $TextBuilder -NewLineFormat $NewLineFormat -NewLineFormatProperty $NewLineFormatProperty -Force:$Force -ArrayJoin:$ArrayJoin -ArrayJoinString $ArrayJoinString
                $null = $TextBuilder.Append($Value)
            } else {
                $null = $TextBuilder.AppendLine("{")
                if ($Force -and -not $PropertyName) {
                    $PropertyName = $Object[0].PSObject.Properties.Name
                } elseif ($Force -and $PropertyName) {

                } else {
                    $PropertyName = $Object[$a].PSObject.Properties.Name
                }
                $PropertyCount = 0
                foreach ($Property in $PropertyName) {
                    $PropertyCount++
                    $DisplayProperty = $Property.Replace('\', "\\").Replace('"', '\"').Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                    $null = $TextBuilder.Append("`"$DisplayProperty`":")
                    $Value = ConvertTo-StringByType -Value $Object[$a].$Property -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $InitialDepth -MaxDepth $MaxDepth -TextBuilder $TextBuilder -NewLineFormat $NewLineFormat -NewLineFormatProperty $NewLineFormatProperty -Force:$Force -ArrayJoin:$ArrayJoin -ArrayJoinString $ArrayJoinString
                    # Push to Text
                    $null = $TextBuilder.Append("$Value")
                    if ($PropertyCount -ne $PropertyName.Count) {
                        $null = $TextBuilder.AppendLine(',')
                    }
                }
                $null = $TextBuilder.Append("}")
            }
            $InitialDepth = 0
        }
    }
    End {
        if ($CountObjects -gt 1 -or $AsArray) {
            "[$($TextBuilder.ToString())]"
        } else {
            $TextBuilder.ToString()
        }
    }
}