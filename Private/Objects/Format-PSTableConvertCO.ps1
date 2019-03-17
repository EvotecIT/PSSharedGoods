function Format-PSTableConvertCO {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [switch] $SkipTitles,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders,
        [switch] $PreScanHeaders
    )
    if ($Property) {
        $Object = $Object | Select-Object -Property $Property
    }
    $Array = [System.Collections.ArrayList]::new()
    $Titles = [System.Collections.ArrayList]::new()

    if ($NoAliasOrScriptProperties) {$PropertyType = 'AliasProperty', 'ScriptProperty'  } else {$PropertyType = ''}

    # Get Titles first (to make sure order is correct for all rows)
    if ($PreScanHeaders) {
        $ObjectProperties = Get-ObjectProperties -Object $Object
        foreach ($Name in $ObjectProperties) {
            $null = $Titles.Add($Name)
        }
    } else {
        if ($OverwriteHeaders) {
            $Titles = $OverwriteHeaders
        } else {
            foreach ($O in $Object) {
                if ($DisplayPropertySet -and $O.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames) {
                    $ObjectProperties = $O.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames.Where( { $ExcludeProperty -notcontains $_  } ) #.Name
                } else {
                    $ObjectProperties = $O.PSObject.Properties.Where( { $PropertyType -notcontains $_.MemberType -and $ExcludeProperty -notcontains $_.Name  } ).Name
                }
                foreach ($Name in $ObjectProperties) {
                    $null = $Titles.Add($Name)
                }
                break
            }
            # Add Titles to Array (if not -SkipTitles)
        }
    }
    if (-not $SkipTitle) {
        $null = $Array.Add($Titles)
    }
    # Extract data (based on Title)
    foreach ($O in $Object) {
        $ArrayValues = [System.Collections.ArrayList]::new()
        foreach ($Name in $Titles) {
            $null = $ArrayValues.Add($O.$Name)
        }
        $null = $Array.Add($ArrayValues)
    }
    if ($Array.Count -eq 1) { , $Array } else { $Array }
}