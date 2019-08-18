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
        [switch] $SkipProperties
    )
    if ($null -eq $Objects) {
        return
    }
    # Default Select-Object -Unique is case sensitive, Sort-Object -Unique isn't but it sorts object.
    # Below is function that solves this, ugly but it works
    function Select-ObjectSort {
        [CmdLetBinding()]
        param(
            [System.Collections.IList] $Object
        )
        #$Test = 'one', 'Two', 'One', 'Three'
        $New = $Object.ToLower() | Select-Object -Unique
        $Selected = foreach ($_ in $New) {
            $Index = $Object.ToLower().IndexOf($_)
            if ($Index -ne -1) {
                $Object[$Index]
            }
        }
        $Selected
    }
    function Compare-TwoArrays {
        [CmdLetBinding()]
        param(
            [Array] $Object1,
            [Array] $Object2
        )
        $Result = @{ }
        if ($null -eq $Object1 -and $null -eq $Object2) {
            $Result['Status'] = $true
        } elseif (($null -eq $Object1) -or ($null -eq $Object2)) {
            $Result['Status'] = $false
        } else {
            $ComparedObject = Compare-Object -ReferenceObject $Object1 -DifferenceObject $Object2 -SyncWindow 0
            $Result['Status'] = @($ComparedObject).Length -eq 0
            if ($Result['Status'] -eq $false) {
                $Collection = @($ComparedObject).Where( { $_.SideIndicator -eq '<=' }, 'Split')
                $Result['MissingLeft'] = $Collection[0].InputObject
                $Result['MissingRight'] = $Collection[1].InputObject
            }
        }
        $Result
    }
    $FirstElement = [ordered] @{ }
    $FirstElement['Name'] = 'Properties'
    if ($Summary) {
        $FirstElement['Same'] = $null
        $FirstElement['Different'] = $null
    }
    $FirstElement['Status'] = $false

    # Compare properties
    if ($Objects[0] -is [System.Collections.IDictionary]) {
        if ($AllProperties) {
            [Array] $All = foreach ($_ in $Objects) {
                $_.Keys
            }
            #  $FirstObjectProperties = $All | Select-Object -Unique
            $FirstObjectProperties = Select-ObjectSort -Object $All
        } else {
            $FirstObjectProperties = $Objects[0].Keys
        }
        if ($Property.Count -gt 0 -and $ExcludeProperty.Count -gt 0) {
            $FirstObjectProperties = $FirstObjectProperties | Where-Object { $Property -contains $_ -and $ExcludeProperty -notcontains $_ }
        } elseif ($Property.Count -gt 0) {
            $FirstObjectProperties = $FirstObjectProperties | Where-Object { $Property -contains $_ }
        } elseif ($ExcludeProperty.Count -gt 0) {
            $FirstObjectProperties = $FirstObjectProperties | Where-Object { $ExcludeProperty -notcontains $_ }
        }

    } else {
        if ($Property.Count -gt 0 -and $ExcludeProperty.Count -gt 0) {
            $Objects = $Objects | Select-Object -Property $Property -ExcludeProperty $ExcludeProperty
        } elseif ($Property.Count -gt 0) {
            $Objects = $Objects | Select-Object -Property $Property #-ExcludeProperty $ExcludeProperty
        } elseif ($ExcludeProperty.Count -gt 0) {
            $Objects = $Objects | Select-Object -Property '*' -ExcludeProperty $ExcludeProperty
        }
        if ($AllProperties) {
            [Array] $All = foreach ($_ in $Objects) {
                $_.PSObject.Properties.Name
            }
            #$FirstObjectProperties = $All | Select-Object -Unique
            $FirstObjectProperties = Select-ObjectSort -Object $All
        } else {
            $FirstObjectProperties = $Objects[0].PSObject.Properties.Name
        }

    }

    #for ($i = 0; $i -lt 1; $i++) {
    if ($FormatOutput) {
        $FirstElement["Source"] = $FirstObjectProperties -join $Splitter
    } else {
        $FirstElement["Source"] = $FirstObjectProperties
    }
    #}


    [Array] $IsSame = for ($i = 1; $i -lt $Objects.Count; $i++) {
        if ($Objects[0] -is [System.Collections.IDictionary]) {
            [string[]] $CompareObjectProperties = $Objects[$i].Keys
        } else {
            [string[]] $CompareObjectProperties = $Objects[$i].PSObject.Properties.Name
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

        $Status = Compare-TwoArrays -Object1 $Value1 -Object2 $Value2
        if ($FormatDifferences) {
            $FirstElement["$i-Add"] = $Status['MissingLeft'] -join $Splitter
            $FirstElement["$i-Remove"] = $Status['MissingRight'] -join $Splitter
        } else {
            $FirstElement["$i-Add"] = $Status['MissingLeft']
            $FirstElement["$i-Remove"] = $Status['MissingRight']
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

    if (-not $SkipProperties) {
        [PSCustomObject] $FirstElement
    }

    # Compare Objects
    foreach ($_ in $FirstObjectProperties) {
        $EveryOtherElement = [ordered] @{ }
        $EveryOtherElement['Name'] = $_
        if ($Summary) {
            $EveryOtherElement['Same'] = $null
            $EveryOtherElement['Different'] = $null
        }
        $EveryOtherElement.Status = $false

        #for ($i = 0; $i -lt 1; $i++) {
        if ($FormatOutput) {
            $EveryOtherElement['Source'] = $Objects[0].$_ -join $Splitter
        } else {
            $EveryOtherElement['Source'] = $Objects[0].$_
        }
        # }

        [Array] $IsSame = for ($i = 1; $i -lt $Objects.Count; $i++) {

            if ($FormatOutput) {
                $EveryOtherElement["$i"] = $Objects[$i].$_ -join $Splitter
            } else {
                $EveryOtherElement["$i"] = $Objects[$i].$_
            }

            if ($CompareSorted) {
                $Value1 = $Objects[0].$_ | Sort-Object
                $Value2 = $Objects[$i].$_ | Sort-Object
            } else {
                $Value1 = $Objects[0].$_
                $Value2 = $Objects[$i].$_
            }

            $Status = Compare-TwoArrays -Object1 $Value1 -Object2 $Value2
            if ($FormatDifferences) {
                $EveryOtherElement["$i-Add"] = $Status['MissingLeft'] -join $Splitter
                $EveryOtherElement["$i-Remove"] = $Status['MissingRight'] -join $Splitter
            } else {
                $EveryOtherElement["$i-Add"] = $Status['MissingLeft']
                $EveryOtherElement["$i$I-Remove"] = $Status['MissingRight']
            }
            $Status
        }
        if ($IsSame.Status -notcontains $false) {
            $EveryOtherElement['Status'] = $true
        } else {
            $EveryOtherElement['Status'] = $false
        }

        if ($Summary) {
            [Array] $Collection = (0..($IsSame.Count - 1)).Where( { $IsSame[$_].Status -eq $true }, 'Split')
            if ($FormatDifferences) {
                $EveryOtherElement['Same'] = ($Collection[0] | ForEach-Object { $_ + 1 }) -join $Splitter
                $EveryOtherElement['Different'] = ($Collection[1] | ForEach-Object { $_ + 1 }) -join $Splitter
            } else {
                $EveryOtherElement['Same'] = $Collection[0] | ForEach-Object { $_ + 1 }
                $EveryOtherElement['Different'] = $Collection[1] | ForEach-Object { $_ + 1 }
            }
        }
        [PSCuStomObject] $EveryOtherElement
    }
}