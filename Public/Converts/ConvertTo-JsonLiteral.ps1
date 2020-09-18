﻿function ConvertTo-JsonLiteral {
    [cmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)][Array] $Object,
        #[int] $Depth,
        [switch] $HashTableAsIs,
        [switch] $AsArray,
        [string] $DateTimeFormat = "yyyy-MM-dd HH:mm:ss",
        [switch] $NumberAsNumber,
        [switch] $BoolAsBool
    )
    Begin {
        $TextBuilder = [System.Text.StringBuilder]::new()
        $CountObjects = 0

        filter IsNumeric() {
            return $_ -is [byte] -or $_ -is [int16] -or $_ -is [int32] -or $_ -is [int64]  `
                -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
                -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
        }
    }
    Process {
        for ($a = 0; $a -lt $Object.Count; $a++) {
            $CountObjects++
            if ($CountObjects -gt 1) {
                $null = $TextBuilder.Append(',')
            }
            if ($Object[$a] -is [System.Collections.IDictionary]) {
                if (-not $HashTableAsIs) {
                    # Push to TEXT the same as [PSCustomObject]
                    $null = $TextBuilder.AppendLine("{")
                    for ($i = 0; $i -lt ($Object[$a].Keys).Count; $i++) {
                        $Property = ([string[]]$Object[$a].Keys)[$i]

                        $Value = ConvertTo-StringByType -Value $($Object[$a][$Property]) -DateTimeFormat $DateTimeFormat -NumberAsNumber:$NumberAsNumber -BoolAsBool:$BoolAsBool
                        $null = $TextBuilder.Append("`"$Property`":$Value")
                        if ($i -ne ($Object[$a].Keys).Count - 1) {
                            $null = $TextBuilder.AppendLine(',')
                        }
                    }
                    $null = $TextBuilder.Append("}")
                } else {
                    # Push to TEXT as real [ordered]
                    $null = $TextBuilder.AppendLine('[')
                    for ($i = 0; $i -lt ($Object[$a].Keys).Count; $i++) {
                        $null = $TextBuilder.AppendLine("{")
                        $Property = ([string[]]$Object[$a].Keys)[$i]

                        $Value = ConvertTo-StringByType -Value $($Object[$a][$i]) -DateTimeFormat $DateTimeFormat -NumberAsNumber:$NumberAsNumber -BoolAsBool:$BoolAsBool
                        $null = $TextBuilder.Append("`"$Property`":$Value")
                        $null = $TextBuilder.Append("}")
                        if ($i -ne ($Object[$a].Keys).Count - 1) {
                            $null = $TextBuilder.AppendLine(',')
                        }
                    }
                    $null = $TextBuilder.AppendLine(']')
                }

            } elseif ($Object[$a].GetType().Name -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {
                $Value = ConvertTo-StringByType -Value $($Object[$a]) -DateTimeFormat $DateTimeFormat -NumberAsNumber:$NumberAsNumber -BoolAsBool:$BoolAsBool
                #$null = $TextBuilder.Append("`"$($Object[$a].ToString())`"")
                $null = $TextBuilder.Append($Value)
            } else {
                $null = $TextBuilder.AppendLine("{")
                for ($i = 0; $i -lt ($Object[$a].PSObject.Properties.Name).Count; $i++) {
                    $Property = $($Object[$a].PSObject.Properties.Name)[$i]

                    $Value = ConvertTo-StringByType -Value $($Object[$a].$Property) -DateTimeFormat $DateTimeFormat -NumberAsNumber:$NumberAsNumber -BoolAsBool:$BoolAsBool
                    # Push to Text
                    $null = $TextBuilder.Append("`"$Property`":$Value")
                    if ($i -ne ($Object[$a].PSObject.Properties.Name).Count - 1) {
                        $null = $TextBuilder.AppendLine(',')
                    }
                }
                $null = $TextBuilder.Append("}")
            }
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