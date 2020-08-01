function Select-Properties {
    <#
    .SYNOPSIS
    Allows for easy selecting property names from one or multiple objects

    .DESCRIPTION
    Allows for easy selecting property names from one or multiple objects. This is especially useful with using AllProperties parameter where we want to make sure to get all properties from all objects.

    .PARAMETER Objects
    One or more objects

    .PARAMETER Property
    Properties to include

    .PARAMETER ExcludeProperty
    Properties to exclude

    .PARAMETER AllProperties
    All unique properties from all objects

    .EXAMPLE
    $Object1 = [PSCustomobject] @{
        Name1 = '1'
        Name2 = '3'
        Name3 = '5'
    }
    $Object2 = [PSCustomobject] @{
        Name4 = '2'
        Name5 = '6'
        Name6 = '7'
    }

    Select-Properties -Objects $Object1, $Object2 -AllProperties

    #OR:

    $Object1, $Object2 | Select-Properties -AllProperties -ExcludeProperty Name6 -Property Name3

    .EXAMPLE
    $Object3 = [Ordered] @{
        Name1 = '1'
        Name2 = '3'
        Name3 = '5'
    }
    $Object4 = [Ordered] @{
        Name4 = '2'
        Name5 = '6'
        Name6 = '7'
    }

    Select-Properties -Objects $Object3, $Object4 -AllProperties

    $Object3, $Object4 | Select-Properties -AllProperties

    .NOTES
    General notes
    #>
    [CmdLetBinding()]
    param(
        [Array][Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)] $Objects,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $AllProperties
    )
    Begin {
        function Select-Unique {
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
        $ObjectsList = [System.Collections.Generic.List[Object]]::new()
    }
    Process {
        foreach ($Object in $Objects) {
            $ObjectsList.Add($Object)
        }
    }
    End {
        if ($ObjectsList.Count -eq 0) {
            Write-Warning 'Select-Properties - Unable to process. Objects count equals 0.'
            return
        }
        if ($ObjectsList[0] -is [System.Collections.IDictionary]) {
            if ($AllProperties) {
                [Array] $All = foreach ($_ in $ObjectsList) {
                    $_.Keys
                }
                #  $FirstObjectProperties = $All | Select-Object -Unique
                $FirstObjectProperties = Select-Unique -Object $All
            } else {
                $FirstObjectProperties = $ObjectsList[0].Keys
            }
            if ($Property.Count -gt 0 -and $ExcludeProperty.Count -gt 0) {
                #$FirstObjectProperties = $FirstObjectProperties | Where-Object { $Property -contains $_ -and $ExcludeProperty -notcontains $_ }
                $FirstObjectProperties = foreach ($_ in $FirstObjectProperties) {
                    if ($Property -contains $_ -and $ExcludeProperty -notcontains $_) {
                        $_
                        continue
                    }
                }

            } elseif ($Property.Count -gt 0) {
                # $FirstObjectProperties = $FirstObjectProperties | Where-Object { $Property -contains $_ }

                $FirstObjectProperties = foreach ($_ in $FirstObjectProperties) {
                    if ($Property -contains $_) {
                        $_
                        continue
                    }
                }
            } elseif ($ExcludeProperty.Count -gt 0) {
                #$FirstObjectProperties = $FirstObjectProperties | Where-Object { $ExcludeProperty -notcontains $_ }
                $FirstObjectProperties = foreach ($_ in $FirstObjectProperties) {
                    if ($ExcludeProperty -notcontains $_) {
                        $_
                        continue
                    }
                }
            }

        } else {
            if ($Property.Count -gt 0 -and $ExcludeProperty.Count -gt 0) {
                $ObjectsList = $ObjectsList | Select-Object -Property $Property -ExcludeProperty $ExcludeProperty
            } elseif ($Property.Count -gt 0) {
                $ObjectsList = $ObjectsList | Select-Object -Property $Property #-ExcludeProperty $ExcludeProperty
            } elseif ($ExcludeProperty.Count -gt 0) {
                $ObjectsList = $ObjectsList | Select-Object -Property '*' -ExcludeProperty $ExcludeProperty
            }
            if ($AllProperties) {
                [Array] $All = foreach ($_ in $ObjectsList) {
                    $_.PSObject.Properties.Name
                }
                #$FirstObjectProperties = $All | Select-Object -Unique
                $FirstObjectProperties = Select-Unique -Object $All
            } else {
                $FirstObjectProperties = $ObjectsList[0].PSObject.Properties.Name
            }
        }
        $FirstObjectProperties
    }
}