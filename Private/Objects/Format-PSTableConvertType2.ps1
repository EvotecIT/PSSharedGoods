function Format-PSTableConvertType2 {
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
        $Object = $Object | Select-Object $Property
    }

    $Array = New-ArrayList
    $Titles = New-ArrayList
    if ($NoAliasOrScriptProperties) {$PropertyType = 'AliasProperty', 'ScriptProperty'  } else {$PropertyType = ''}
    #Write-Verbose "Format-PSTableConvertType2 - Option 2 - NoAliasOrScriptProperties: $NoAliasOrScriptProperties"

    # Get Titles first (to make sure order is correct for all rows)
    if ($PreScanHeaders) {
        $ObjectProperties = Get-ObjectProperties -Object $Object
        foreach ($Name in $ObjectProperties) {
            Add-ToArray -List $Titles -Element $Name
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
                    Add-ToArray -List $Titles -Element $Name
                }
                break
            }
            # Add Titles to Array (if not -SkipTitles)

        }
    }
    if (-not $SkipTitle) {
        Add-ToArray -List $Array -Element $Titles
    }
    # Extract data (based on Title)
    foreach ($O in $Object) {
        $ArrayValues = New-ArrayList
        foreach ($Name in $Titles) {
            Add-ToArray -List $ArrayValues -Element $O.$Name
        }
        Add-ToArray -List $Array -Element $ArrayValues
    }
    return , $Array
}