function Format-PSTable {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Array] $Object,
        [switch] $SkipTitle,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [Object] $OverwriteHeaders,
        [switch] $PreScanHeaders,
        [string] $Splitter = ';'
    )
    if ($Object[0] -is [System.Collections.IDictionary]) {
        $Array = @(
            ### Add Titles
            if (-not $SkipTitles) {
                , @('Name', 'Value')
            }
            ### Add Data
            foreach ($O in $Object) {
                foreach ($Name in $O.Keys) {
                    $Value = $O[$Name]
                    # If array contains another array as one of the values we need to do something with it
                    if ($O[$Name].Count -gt 1) {
                        $Value = $O[$Name] -join $Splitter
                    } else {
                        $Value = $O[$Name]
                    }
                    , @($Name, $Value)
                }
            }
        )
        if ($Array.Count -eq 1) { , $Array } else { $Array }
    } elseif ($Object[0].GetType().Name -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {
        return $Object
    } else {
        if ($Property) {
            $Object = $Object | Select-Object -Property $Property
        }
        $Array = @(
            # Get Titles first (to make sure order is correct for all rows)
            if ($PreScanHeaders) {
                $Titles = Get-ObjectProperties -Object $Object
            } elseif ($OverwriteHeaders) {
                $Titles = $OverwriteHeaders
            } else {
                # If no prescan takes property names from first object
                $Titles = $Object[0].PSObject.Properties.Name
            }
            if (-not $SkipTitle) {
                # Add Titles to Array (if not -SkipTitles)
                , $Titles
            }
            # Extract data (based on Title)
            foreach ($O in $Object) {
                $ArrayValues = foreach ($Name in $Titles) {
                    $Value = $O."$Name"
                    # If array contains another array as one of the values we need to do something with it
                    if ($Value.Count -gt 1) {
                        $Value -join $Splitter
                    } else {
                        $Value
                    }
                }
                , $ArrayValues
            }

        )
        if ($Array.Count -eq 1) { , $Array } else { $Array }
    }
}