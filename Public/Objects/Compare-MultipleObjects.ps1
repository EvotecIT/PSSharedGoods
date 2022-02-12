function Compare-MultipleObjects {
    [CmdLetBinding()]
    param(
        [System.Collections.IList] $Objects,
        [switch] $CompareSorted,
        [switch] $FormatOutput,
        [switch] $FormatDifferences,
        [switch] $Summary,
        [string] $Splitter = ', ',
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $AllProperties,
        [switch] $SkipProperties,
        [int] $First,
        [int] $Last,
        [Array] $Replace,
        [switch] $FlattenObject
    )
    if ($null -eq $Objects -or $Objects.Count -eq 1) {
        Write-Warning "Compare-MultipleObjects - Unable to compare objects. Not enough objects to compare ($($Objects.Count))."
        return
    }
    # Default Select-Object -Unique is case sensitive, Sort-Object -Unique isn't but it sorts object.
    # Below is function that solves this, ugly but it works
    function Compare-TwoArrays {
        [CmdLetBinding()]
        param(
            [string] $FieldName,
            [Array] $Object1,
            [Array] $Object2,
            [Array] $Replace
        )
        $Result = [ordered] @{
            Status = $false
            Same   = [System.Collections.Generic.List[string]]::new()
            Add    = [System.Collections.Generic.List[string]]::new()
            Remove = [System.Collections.Generic.List[string]]::new()
        }

        if ($Replace) {
            foreach ($R in $Replace) {
                # if no keys are given replace is for all objects ''
                # if keys are given replace is only done for a given FieldName
                if (($($R.Keys[0]) -eq '') -or ($($R.Keys[0]) -eq $FieldName)) {
                    if ($null -ne $Object1) {
                        $Object1 = $Object1 -replace $($R.Values)[0], $($R.Values)[1]
                        #$Object1 = $Object1 -replace $R[0], $R[1]
                    }
                    if ($null -ne $Object2) {
                        $Object2 = $Object2 -replace $($R.Values)[0], $($R.Values)[1]
                        #$Object2 = $Object2 -replace $R[0], $R[1]
                    }
                }
            }
        }

        if ($null -eq $Object1 -and $null -eq $Object2) {
            $Result['Status'] = $true
        } elseif (($null -eq $Object1) -or ($null -eq $Object2)) {
            $Result['Status'] = $false
            foreach ($O in $Object1) {
                $Result['Add'].Add($O)
            }
            foreach ($O in $Object2) {
                $Result['Remove'].Add($O)
            }
        } else {
            $ComparedObject = Compare-Object -ReferenceObject $Object1 -DifferenceObject $Object2 -IncludeEqual
            foreach ($_ in $ComparedObject) {
                if ($_.SideIndicator -eq '==') {
                    $Result['Same'].Add($_.InputObject)
                } elseif (($_.SideIndicator -eq '<=')) {
                    $Result['Add'].Add($_.InputObject)
                } elseif (($_.SideIndicator -eq '=>')) {
                    $Result['Remove'].Add($_.InputObject)
                }
            }
            IF ($Result['Add'].Count -eq 0 -and $Result['Remove'].Count -eq 0) {
                $Result['Status'] = $true
            } else {
                $Result['Status'] = $false
            }
        }
        $Result
    }

    if ($FlattenObject) {
        $Objects = ConvertTo-FlatObject -Objects $Objects
    }

    if ($First -or $Last) {
        [int] $TotalCount = $First + $Last
        if ($TotalCount -gt 1) {
            $Objects = $Objects | Select-Object -First $First -Last $Last
        } else {
            Write-Warning "Compare-MultipleObjects - Unable to compare objects. Not enough objects to compare ($TotalCount)."
            return
        }
    }
    $ReturnValues = @(
        $FirstElement = [ordered] @{ }
        $FirstElement['Name'] = 'Properties'
        if ($Summary) {
            $FirstElement['Same'] = $null
            $FirstElement['Different'] = $null
        }
        $FirstElement['Status'] = $false

        # Compare properties
        $FirstObjectProperties = Select-Properties -Objects $Objects -Property $Property -ExcludeProperty $ExcludeProperty -AllProperties:$AllProperties
        if (-not $SkipProperties) {
            if ($FormatOutput) {
                $FirstElement["Source"] = $FirstObjectProperties -join $Splitter
            } else {
                $FirstElement["Source"] = $FirstObjectProperties
            }
            [Array] $IsSame = for ($i = 1; $i -lt $Objects.Count; $i++) {
                if ($Objects[0] -is [System.Collections.IDictionary]) {
                    [string[]] $CompareObjectProperties = $Objects[$i].Keys
                } else {
                    [string[]] $CompareObjectProperties = $Objects[$i].PSObject.Properties.Name
                    [string[]] $CompareObjectProperties = Select-Properties -Objects $Objects[$i] -Property $Property -ExcludeProperty $ExcludeProperty -AllProperties:$AllProperties
                }

                if ($FormatOutput) {
                    $FirstElement["$i"] = $CompareObjectProperties -join $Splitter
                } else {
                    $FirstElement["$i"] = $CompareObjectProperties
                }
                if ($CompareSorted) {
                    $Value1 = $FirstObjectProperties | Sort-Object
                    $Value2 = $CompareObjectProperties | Sort-Object
                } else {
                    $Value1 = $FirstObjectProperties
                    $Value2 = $CompareObjectProperties
                }

                $Status = Compare-TwoArrays -FieldName 'Properties' -Object1 $Value1 -Object2 $Value2 -Replace $Replace
                if ($FormatDifferences) {
                    $FirstElement["$i-Add"] = $Status['Add'] -join $Splitter
                    $FirstElement["$i-Remove"] = $Status['Remove'] -join $Splitter
                    $FirstElement["$i-Same"] = $Status['Same'] -join $Splitter
                } else {
                    $FirstElement["$i-Add"] = $Status['Add']
                    $FirstElement["$i-Remove"] = $Status['Remove']
                    $FirstElement["$i-Same"] = $Status['Same']
                }
                $Status
            }
            if ($IsSame.Status -notcontains $false) {
                $FirstElement['Status'] = $true
            } else {
                $FirstElement['Status'] = $false
            }
            if ($Summary) {
                [Array] $Collection = (0..($IsSame.Count - 1)).Where( { $IsSame[$_].Status -eq $true }, 'Split')
                if ($FormatDifferences) {
                    $FirstElement['Same'] = ($Collection[0] | ForEach-Object { $_ + 1 }) -join $Splitter
                    $FirstElement['Different'] = ($Collection[1] | ForEach-Object { $_ + 1 }) -join $Splitter
                } else {
                    $FirstElement['Same'] = $Collection[0] | ForEach-Object { $_ + 1 }
                    $FirstElement['Different'] = $Collection[1] | ForEach-Object { $_ + 1 }
                }
            }
            [PSCustomObject] $FirstElement
        }

        # Compare Objects
        foreach ($ObjectProperty in $FirstObjectProperties) {
            $EveryOtherElement = [ordered] @{ }
            $EveryOtherElement['Name'] = $ObjectProperty
            if ($Summary) {
                $EveryOtherElement['Same'] = $null
                $EveryOtherElement['Different'] = $null
            }
            $EveryOtherElement.Status = $false

            if ($FormatOutput) {
                $EveryOtherElement['Source'] = $Objects[0].$ObjectProperty -join $Splitter
            } else {
                $EveryOtherElement['Source'] = $Objects[0].$ObjectProperty
            }

            [Array] $IsSame = for ($i = 1; $i -lt $Objects.Count; $i++) {
                if ($FormatOutput) {
                    $EveryOtherElement["$i"] = $Objects[$i].$ObjectProperty -join $Splitter
                } else {
                    $EveryOtherElement["$i"] = $Objects[$i].$ObjectProperty
                }

                if ($CompareSorted) {
                    $Value1 = $Objects[0].$ObjectProperty | Sort-Object
                    $Value2 = $Objects[$i].$ObjectProperty | Sort-Object
                } else {
                    $Value1 = $Objects[0].$ObjectProperty
                    $Value2 = $Objects[$i].$ObjectProperty
                }

                # This will be used only if we don't use flattening of objects.
                # 
                if ($Value1 -is [PSCustomObject]) {
                    continue
                } elseif ($Value1 -is [System.Collections.IDictionary]) {
                    continue
                } elseif ($Value1 -is [Array] -and $Value1[0] -isnot [string]) {
                    continue
                }

                $Status = Compare-TwoArrays -FieldName $ObjectProperty -Object1 $Value1 -Object2 $Value2 -Replace $Replace
                if ($FormatDifferences) {
                    $EveryOtherElement["$i-Add"] = $Status['Add'] -join $Splitter
                    $EveryOtherElement["$i-Remove"] = $Status['Remove'] -join $Splitter
                    $EveryOtherElement["$i-Same"] = $Status['Same'] -join $Splitter
                } else {
                    $EveryOtherElement["$i-Add"] = $Status['Add']
                    $EveryOtherElement["$i-Remove"] = $Status['Remove']
                    $EveryOtherElement["$i-Same"] = $Status['Same']
                }
                $Status
            }
            if (-not $IsSame) {
                $EveryOtherElement['Status'] = $null
            } elseif ($IsSame.Status -notcontains $false) {
                $EveryOtherElement['Status'] = $true
            } else {
                $EveryOtherElement['Status'] = $false
            }

            if ($Summary) {
                [Array] $Collection = (0..($IsSame.Count - 1)).Where( { $IsSame[$ObjectProperty].Status -eq $true }, 'Split')
                if ($FormatDifferences) {
                    $EveryOtherElement['Same'] = ($Collection[0] | ForEach-Object { $ObjectProperty + 1 }) -join $Splitter
                    $EveryOtherElement['Different'] = ($Collection[1] | ForEach-Object { $ObjectProperty + 1 }) -join $Splitter
                } else {
                    $EveryOtherElement['Same'] = $Collection[0] | ForEach-Object { $ObjectProperty + 1 }
                    $EveryOtherElement['Different'] = $Collection[1] | ForEach-Object { $ObjectProperty + 1 }
                }
            }
            [PSCuStomObject] $EveryOtherElement
        }
    )
    if ($ReturnValues.Count -eq 1) {
        return , $ReturnValues
    } else {
        return $ReturnValues
    }
}