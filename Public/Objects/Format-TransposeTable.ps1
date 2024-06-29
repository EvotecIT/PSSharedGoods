function Format-TransposeTable {
    <#
    .SYNOPSIS
    Transposes (pivot) a table of objects

    .DESCRIPTION
    Transposes (pivot) a table of objects

    .PARAMETER AllObjects
    List of objects to transpose

    .PARAMETER Sort
    Legacy parameter to sort the output

    .PARAMETER Legacy
    Allows to transpose the table in a legacy way

    .PARAMETER Property
    Provides a property to name the column based on the property value

    .EXAMPLE
    $T = [PSCustomObject] @{
        Name   = "Server 1"
        Test   = 1
        Test2  = 7
        Ole    = 'bole'
        Trolle = 'A'
        Alle   = 'sd'
    }
    $T1 = [PSCustomObject] @{
        Name   = "Server 2"
        Test   = 2
        Test2  = 3
        Ole    = '1bole'
        Trolle = 'A'
        Alle   = 'sd'
    }

    Format-TransposeTable -Object @($T, $T1) -Property "Name" | Format-Table

    .EXAMPLE
    $T2 = [ordered] @{
        Name   = "Server 1"
        Test   = 1
        Test2  = 7
        Ole    = 'bole'
        Trolle = 'A'
        Alle   = 'sd'
    }
    $T3 = [ordered] @{
        Name   = "Server 2"
        Test   = 2
        Test2  = 3
        Ole    = '1bole'
        Trolle = 'A'
        Alle   = 'sd'
    }

    $Test = Format-TransposeTable -Object @($T2, $T3)
    $Test | Format-Table

    .NOTES
    General notes
    #>
    [CmdletBinding(DefaultParameterSetName = 'Pivot')]
    param (
        [Parameter(ParameterSetName = 'Legacy')]
        [Parameter(ParameterSetName = 'Pivot')]
        [Alias("Object")]
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)][System.Collections.ICollection] $AllObjects,

        [Parameter(ParameterSetName = 'Legacy')]
        [ValidateSet("ASC", "DESC", "NONE")][String] $Sort = 'NONE',

        [Parameter(ParameterSetName = 'Legacy')]
        [switch] $Legacy,

        [Parameter(ParameterSetName = 'Pivot')]
        [string] $Property,

        [Parameter(ParameterSetName = 'Pivot')]
        [string] $Name = "Object "
    )
    begin {
        $Object = [System.Collections.Generic.List[object]]::new()
    }
    process {
        foreach ($O in $AllObjects) {
            $Object.Add($O)
        }
    }
    end {
        if (-not $Legacy) {
            if ($Object[0] -is [System.Collections.IDictionary]) {
                # Handling of dictionaries
                $ListHeader = [System.Collections.Generic.List[string]]::new()
                $ListHeader.Add('Name')
                if ($Property) {
                    foreach ($myObject in $Object) {
                        $ListHeader.Add($myObject.$Property)
                    }
                } else {
                    for ($i = 0; $i -lt $Object.Count; $i++) {
                        $ListHeader.Add("$($Name)$i")
                    }
                }
                $CountOfProperties = $Object[0].GetEnumerator().Name.Count
                [Array] $ObjectsList = for ($i = 0; $i -lt $CountOfProperties; $i++) {
                    $TranslatedObject = [ordered] @{
                        'Name' = $Object[0].GetEnumerator().Name[$i]
                    }
                    foreach ($Header in $ListHeader) {
                        if ($Header -ne 'Name') {
                            $TranslatedObject[$Header] = ''
                        }
                    }
                    $TranslatedObject
                }
                for ($i = 0; $i -lt $ObjectsList.Count; $i++) {
                    for ($j = 0; $j -lt $Object.Count; $j++) {
                        $NameOfProperty = $ObjectsList[$i].Name
                        $ObjectsList[$i][$j + 1] = $Object[$j].$NameOfProperty
                    }
                    [PSCustomObject] $ObjectsList[$i]
                }
            } else {
                # PSCustomObject/Class handling
                $ListHeader = [System.Collections.Generic.List[string]]::new()
                $ListHeader.Add('Name')
                if ($Property) {
                    foreach ($myObject in $Object) {
                        $ListHeader.Add($myObject.$Property)
                    }
                } else {
                    for ($i = 0; $i -lt $Object.Count; $i++) {
                        $ListHeader.Add("$($Name)$i")
                    }
                }
                $CountOfProperties = $Object[0].PSObject.Properties.Name.Count
                [Array] $ObjectsList = for ($i = 0; $i -lt $CountOfProperties; $i++) {
                    $TranslatedObject = [ordered] @{
                        'Name' = $Object[0].PSObject.Properties.Name[$i]
                    }
                    foreach ($Header in $ListHeader) {
                        if ($Header -ne 'Name') {
                            $TranslatedObject[$Header] = ''
                        }
                    }
                    $TranslatedObject
                }
                for ($i = 0; $i -lt $ObjectsList.Count; $i++) {
                    for ($j = 0; $j -lt $Object.Count; $j++) {
                        $NameOfProperty = $ObjectsList[$i].Name
                        $ObjectsList[$i][$j + 1] = $Object[$j].$NameOfProperty
                    }
                    [PSCustomObject] $ObjectsList[$i]
                }
            }
        } else {
            foreach ($myObject in $Object) {
                if ($myObject -is [System.Collections.IDictionary]) {
                    if ($Sort -eq 'ASC') {
                        [PSCustomObject] $myObject.GetEnumerator() | Sort-Object -Property Name -Descending:$false
                    } elseif ($Sort -eq 'DESC') {
                        [PSCustomObject] $myObject.GetEnumerator() | Sort-Object -Property Name -Descending:$true
                    } else {
                        [PSCustomObject] $myObject
                    }
                } else {
                    $Output = [ordered] @{ }
                    if ($Sort -eq 'ASC') {
                        $myObject.PSObject.Properties | Sort-Object -Property Name -Descending:$false | ForEach-Object {
                            $Output["$($_.Name)"] = $_.Value
                        }
                    } elseif ($Sort -eq 'DESC') {
                        $myObject.PSObject.Properties | Sort-Object -Property Name -Descending:$true | ForEach-Object {
                            $Output["$($_.Name)"] = $_.Value
                        }
                    } else {
                        $myObject.PSObject.Properties | ForEach-Object {
                            $Output["$($_.Name)"] = $_.Value
                        }
                    }
                    $Output
                }
            }
        }
    }
}