function Format-PSTable {
    <#
    .SYNOPSIS
    Formats a collection of objects into a table for display.

    .DESCRIPTION
    The Format-PSTable function takes a collection of objects and formats them into a table for easy display. It provides options to customize the output by selecting specific properties, excluding certain properties, and more.

    .PARAMETER Object
    Specifies the collection of objects to format.

    .PARAMETER SkipTitle
    Indicates whether to skip displaying the title row in the table.

    .PARAMETER Property
    Specifies an array of property names to include in the table.

    .PARAMETER ExcludeProperty
    Specifies an array of property names to exclude from the table.

    .PARAMETER OverwriteHeaders
    Specifies an object to use as headers for the table.

    .PARAMETER PreScanHeaders
    Indicates whether to pre-scan the object properties to determine headers.

    .PARAMETER Splitter
    Specifies the delimiter to use when joining array values.

    .EXAMPLE
    $data | Format-PSTable

    Description:
    Formats the $data collection into a table with default settings.

    .EXAMPLE
    $data | Format-PSTable -Property Name, Age

    Description:
    Formats the $data collection into a table displaying only the 'Name' and 'Age' properties.

    .EXAMPLE
    $data | Format-PSTable -ExcludeProperty ID

    Description:
    Formats the $data collection into a table excluding the 'ID' property.

    #>
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][System.Collections.ICollection] $Object,
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
            if (-not $SkipTitle) {
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
                    } elseif ($Value.Count -eq 1) {
                        if ($Value.Value) {
                           $Value.Value
                           #$Value
                        } else {
                            $Value
                        }
                    } else {
                        ''
                    }
                }
                , $ArrayValues
            }

        )
        if ($Array.Count -eq 1) { , $Array } else { $Array }
    }
}