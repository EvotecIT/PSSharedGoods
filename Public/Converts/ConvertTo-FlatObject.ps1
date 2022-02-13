Function ConvertTo-FlatObject {
    <#
    .SYNOPSIS
    Flattends a nested object into a single level object.

    .DESCRIPTION
    Flattends a nested object into a single level object.

    .PARAMETER Objects
    The object (or objects) to be flatten.

    .PARAMETER Separator
    The separator used between the recursive property names

    .PARAMETER Base
    The first index name of an embedded array:
    - 1, arrays will be 1 based: <Parent>.1, <Parent>.2, <Parent>.3, …
    - 0, arrays will be 0 based: <Parent>.0, <Parent>.1, <Parent>.2, …
    - "", the first item in an array will be unnamed and than followed with 1: <Parent>, <Parent>.1, <Parent>.2, …

    .PARAMETER Depth
    The maximal depth of flattening a recursive property. Any negative value will result in an unlimited depth and could cause a infinitive loop.

    .PARAMETER Uncut
    The maximal depth of flattening a recursive property. Any negative value will result in an unlimited depth and could cause a infinitive loop.

    .EXAMPLE
    $Object3 = [PSCustomObject] @{
        "Name"    = "Przemyslaw Klys"
        "Age"     = "30"
        "Address" = @{
            "Street"  = "Kwiatowa"
            "City"    = "Warszawa"

            "Country" = [ordered] @{
                "Name" = "Poland"
            }
            List      = @(
                [PSCustomObject] @{
                    "Name" = "Adam Klys"
                    "Age"  = "32"
                }
                [PSCustomObject] @{
                    "Name" = "Justyna Klys"
                    "Age"  = "33"
                }
                [PSCustomObject] @{
                    "Name" = "Justyna Klys"
                    "Age"  = 30
                }
                [PSCustomObject] @{
                    "Name" = "Justyna Klys"
                    "Age"  = $null
                }
            )
        }
        ListTest  = @(
            [PSCustomObject] @{
                "Name" = "Sława Klys"
                "Age"  = "33"
            }
        )
    }

    $Object3 | ConvertTo-FlatObject

    .NOTES
    Based on https://powersnippets.com/convertto-flatobject/
    #>
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeLine)][Object[]]$Objects,
        [String]$Separator = ".",
        [ValidateSet("", 0, 1)]$Base = 1,
        [int]$Depth = 5,
        [Parameter(DontShow)][String[]]$Path,
        [Parameter(DontShow)][System.Collections.IDictionary] $OutputObject
    )
    Begin {
        # $PipeLine = $Input | ForEach-Object { $_ }
        # If ($PipeLine) {
        #     $Objects = $PipeLine
        # }
        $InputObjects = [System.Collections.Generic.List[Object]]::new()
    }
    Process {
        foreach ($O in $Objects) {
            $InputObjects.Add($O)
        }
    }
    End {
        If ($PSBoundParameters.ContainsKey("OutputObject")) {
            $Object = $InputObjects[0]
            $Iterate = [ordered] @{}
            if ($null -eq $Object) {
                #Write-Verbose -Message "ConvertTo-FlatObject - Object is null"
            } elseif ($Object.GetType().Name -in 'String', 'DateTime', 'TimeSpan', 'Version', 'Enum') {
                $Object = $Object.ToString()
            } elseif ($Depth) {
                $Depth--
                If ($Object -is [System.Collections.IDictionary]) {
                    $Iterate = $Object
                } elseif ($Object -is [Array]) {
                    $i = $Base
                    foreach ($Item in $Object.GetEnumerator()) {
                        $Iterate["$i"] = $Item
                        $i += 1
                    }
                } else {
                    foreach ($Prop in $Object.PSObject.Properties) {
                        if ($Prop.IsGettable) {
                            $Iterate["$($Prop.Name)"] = $Object.$($Prop.Name)
                        }
                    }
                }
            }
            If ($Iterate.Keys.Count) {
                foreach ($Key in $Iterate.Keys) {
                    ConvertTo-FlatObject -Objects @(, $Iterate["$Key"]) -Separator $Separator -Base $Base -Depth $Depth -Path ($Path + $Key) -OutputObject $OutputObject
                }
            } else {
                $Property = $Path -Join $Separator
                #$Property = (($Path | Where-Object { $_ }) -Join $Separator)
                $OutputObject[$Property] = $Object
            }
        } elseif ($InputObjects.Count -gt 0) {
            $Output = [System.Collections.Generic.List[Object]]::new()
            foreach ($ItemObject in $InputObjects) {
                $OutputObject = [ordered]@{}
                ConvertTo-FlatObject -Objects @(, $ItemObject) -Separator $Separator -Base $Base -Depth $Depth -Path $Path -OutputObject $OutputObject
                $Output.Add([PSCustomObject] $OutputObject)
            }
            $Output
        }
    }
}