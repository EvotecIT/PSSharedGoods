function Compare-MultipleObjects {
    [CmdLetBinding()]
    param(
        [System.Collections.IList] $Objects,
        [Array] $ObjectsName = @(),
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
    if (-not $ObjectsName) {
        $ObjectsName = @()
    }
    if ($ObjectsName.Count -gt 0 -and $Objects.Count -gt $ObjectsName.Count) {
        #$ObjectsName = @()
        Write-Warning -Message "Compare-MultipleObjects - Unable to rename objects. ObjectsName small then amount of Objects ($($Objects.Count))."
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

    if ($ObjectsName[0]) {
        $ValueSourceName = $ObjectsName[0]
    } else {
        $ValueSourceName = "Source"
    }

    [Array] $Objects = foreach ($Object in $Objects) {
        if ($null -eq $Object) {
            [PSCustomObject] @{}
        } else {
            $Object
        }
    }

    if ($FlattenObject) {
        try {
            [Array] $Objects = ConvertTo-FlatObject -Objects $Objects -ExcludeProperty $ExcludeProperty
        } catch {
            Write-Warning "Compare-MultipleObjects - Unable to flatten objects. ($($_.Exception.Message))"
        }
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
                $FirstElement[$ValueSourceName] = $FirstObjectProperties -join $Splitter
            } else {
                $FirstElement[$ValueSourceName] = $FirstObjectProperties
            }
            [Array] $IsSame = for ($i = 1; $i -lt $Objects.Count; $i++) {
                if ($ObjectsName[$i]) {
                    $ValueToUse = $ObjectsName[$i]
                } else {
                    $ValueToUse = $i
                }
                if ($Objects[0] -is [System.Collections.IDictionary]) {
                    [string[]] $CompareObjectProperties = $Objects[$i].Keys
                } else {
                    [string[]] $CompareObjectProperties = $Objects[$i].PSObject.Properties.Name
                    [string[]] $CompareObjectProperties = Select-Properties -Objects $Objects[$i] -Property $Property -ExcludeProperty $ExcludeProperty -AllProperties:$AllProperties
                }

                if ($FormatOutput) {
                    $FirstElement["$ValueToUse"] = $CompareObjectProperties -join $Splitter
                } else {
                    $FirstElement["$ValueToUse"] = $CompareObjectProperties
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
                    $FirstElement["$ValueToUse-Add"] = $Status['Add'] -join $Splitter
                    $FirstElement["$ValueToUse-Remove"] = $Status['Remove'] -join $Splitter
                    $FirstElement["$ValueToUse-Same"] = $Status['Same'] -join $Splitter
                } else {
                    $FirstElement["$ValueToUse-Add"] = $Status['Add']
                    $FirstElement["$ValueToUse-Remove"] = $Status['Remove']
                    $FirstElement["$ValueToUse-Same"] = $Status['Same']
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
                    $FirstElement['Same'] = ($Collection[0] | ForEach-Object {
                            $Count = $_ + 1
                            if ($ObjectsName[$Count]) {
                                $ObjectsName[$Count]
                            } else {
                                $Count
                            }
                        }
                    ) -join $Splitter
                    $FirstElement['Different'] = ($Collection[1] | ForEach-Object {
                            $Count = $_ + 1
                            if ($ObjectsName[$Count]) {
                                $ObjectsName[$Count]
                            } else {
                                $Count
                            }
                        }
                    ) -join $Splitter
                } else {
                    $FirstElement['Same'] = $Collection[0] | ForEach-Object {
                        $Count = $_ + 1
                        if ($ObjectsName[$Count]) {
                            $ObjectsName[$Count]
                        } else {
                            $Count
                        }
                    }
                    $FirstElement['Different'] = $Collection[1] | ForEach-Object {
                        $Count = $_ + 1
                        if ($ObjectsName[$Count]) {
                            $ObjectsName[$Count]
                        } else {
                            $Count
                        }
                    }
                }
            }
            [PSCustomObject] $FirstElement
        }

        # Compare Objects
        foreach ($NameProperty in $FirstObjectProperties) {
            $EveryOtherElement = [ordered] @{ }
            $EveryOtherElement['Name'] = $NameProperty
            if ($Summary) {
                $EveryOtherElement['Same'] = $null
                $EveryOtherElement['Different'] = $null
            }
            $EveryOtherElement.Status = $false

            if ($FormatOutput) {
                $EveryOtherElement[$ValueSourceName] = $Objects[0].$NameProperty -join $Splitter
            } else {
                $EveryOtherElement[$ValueSourceName] = $Objects[0].$NameProperty
            }

            [Array] $IsSame = for ($i = 1; $i -lt $Objects.Count; $i++) {
                $Skip = $false

                if ($ObjectsName[$i]) {
                    $ValueToUse = $ObjectsName[$i]
                } else {
                    $ValueToUse = $i
                }

                if ($Objects[$i] -is [System.Collections.IDictionary] -and $Objects[$i].Keys -notcontains $NameProperty) {
                    $Status = [ordered] @{ Status = $false; Same = @(); Add = @(); Remove = @() }
                    $Skip = $true
                } elseif ($Objects[$i].PSObject.Properties.Name -notcontains $NameProperty) {
                    $Status = [ordered] @{
                        Status = $false;
                        Same   = @();
                        Add    = @()
                        Remove = @()
                    }
                    $Skip = $true
                }

                if ($FormatOutput) {
                    $EveryOtherElement["$ValueToUse"] = $Objects[$i].$NameProperty -join $Splitter
                } else {
                    $EveryOtherElement["$ValueToUse"] = $Objects[$i].$NameProperty
                }

                if ($CompareSorted) {
                    $Value1 = $Objects[0].$NameProperty | Sort-Object
                    $Value2 = $Objects[$i].$NameProperty | Sort-Object
                } else {
                    $Value1 = $Objects[0].$NameProperty
                    $Value2 = $Objects[$i].$NameProperty
                }
                # This will be used only if we don't use flattening of objects.
                if ($Value1 -is [PSCustomObject]) {
                    [ordered] @{ Status = $null; Same = @(); Add = @(); Remove = @() }
                    continue
                } elseif ($Value1 -is [System.Collections.IDictionary]) {
                    [ordered] @{ Status = $null; Same = @(); Add = @(); Remove = @() }
                    continue
                } elseif ($Value1 -is [Array] -and $Value1.Count -ne 0 -and $Value1[0] -isnot [string]) {
                    [ordered] @{ Status = $null; Same = @(); Add = @(); Remove = @() }
                    continue
                }
                if (-not $Skip) {
                    $Status = Compare-TwoArrays -FieldName $NameProperty -Object1 $Value1 -Object2 $Value2 -Replace $Replace
                } else {
                    $Status['Add'] = $Value1
                }
                if ($FormatDifferences) {
                    $EveryOtherElement["$ValueToUse-Add"] = $Status['Add'] -join $Splitter
                    $EveryOtherElement["$ValueToUse-Remove"] = $Status['Remove'] -join $Splitter
                    $EveryOtherElement["$ValueToUse-Same"] = $Status['Same'] -join $Splitter
                } else {
                    $EveryOtherElement["$ValueToUse-Add"] = $Status['Add']
                    $EveryOtherElement["$ValueToUse-Remove"] = $Status['Remove']
                    $EveryOtherElement["$ValueToUse-Same"] = $Status['Same']
                }
                $Status
            }
            if ($null -eq $IsSame.Status) {
                $EveryOtherElement['Status'] = $null
            } elseif ($IsSame.Status -notcontains $false) {
                $EveryOtherElement['Status'] = $true
            } else {
                $EveryOtherElement['Status'] = $false
            }

            if ($Summary) {
                [Array] $Collection = (0..($IsSame.Count - 1)).Where( { $IsSame[$_].Status -eq $true }, 'Split')
                if ($FormatDifferences) {
                    $EveryOtherElement['Same'] = ($Collection[0] | ForEach-Object {
                            $Count = $_ + 1
                            if ($ObjectsName[$Count]) {
                                $ObjectsName[$Count]
                            } else {
                                $Count
                            }
                        }
                    ) -join $Splitter
                    $EveryOtherElement['Different'] = ($Collection[1] | ForEach-Object {
                            $Count = $_ + 1
                            if ($ObjectsName[$Count]) {
                                $ObjectsName[$Count]
                            } else {
                                $Count
                            }
                        }
                    ) -join $Splitter
                } else {
                    $EveryOtherElement['Same'] = $Collection[0] | ForEach-Object {
                        $Count = $_ + 1
                        if ($ObjectsName[$Count]) {
                            $ObjectsName[$Count]
                        } else {
                            $Count
                        }
                    }
                    $EveryOtherElement['Different'] = $Collection[1] | ForEach-Object {
                        $Count = $_ + 1
                        if ($ObjectsName[$Count]) {
                            $ObjectsName[$Count]
                        } else {
                            $Count
                        }
                    }
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