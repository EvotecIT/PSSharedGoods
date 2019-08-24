function Select-Properties {
    [CmdLetBinding()]
    param(
        [Array] $Objects,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $AllProperties
    )
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
    if ($Objects.Count -eq 0) {
        Write-Warning 'Select-Properties - Unable to process. Objects count equals 0.'
        return
    }
    if ($Objects[0] -is [System.Collections.IDictionary]) {
        if ($AllProperties) {
            [Array] $All = foreach ($_ in $Objects) {
                $_.Keys
            }
            #  $FirstObjectProperties = $All | Select-Object -Unique
            $FirstObjectProperties = Select-Unique -Object $All
        } else {
            $FirstObjectProperties = $Objects[0].Keys
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
            $FirstObjectProperties = Select-Unique -Object $All
        } else {
            $FirstObjectProperties = $Objects[0].PSObject.Properties.Name
        }
    }
    return $FirstObjectProperties
}