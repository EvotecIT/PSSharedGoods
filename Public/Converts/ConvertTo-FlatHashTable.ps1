
function ConvertTo-FlatHashtable {
    <#
    .SYNOPSIS
    Converts nested hashtable into flat hashtable using delimiter

    .DESCRIPTION
    Converts nested hashtable into flat hashtable using delimiter

    .PARAMETER InputObject
    Ordered Dictionary or Hashtable

    .PARAMETER Delimiter
    Delimiter for key name when merging nested hashtables. By default colon is used

    .EXAMPLE
    ConvertTo-FlatHashTable -InputObject ([ordered] @{
        RootEntry       = 'OK1'
        Parent          = @{
            Child1 = 'OK2'
            Child2 = 'Ok3'
        }
        ParentDifferent = @{
            Child7 = 'NotOk'
            Child8 = @{
                Child10 = 'OKLetsSee'
                Child11 = @{
                    SpecialCase = 'Oooop'
                }
            }
        }
    }) | Format-Table *

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $InputObject,
        [string] $Delimiter = ':',
        [Parameter(DontShow)][string] $Name
    )
    Begin {
        $Output = [ordered] @{}
    }
    Process {
        foreach ($Key in $InputObject.Keys) {
            if ($Name) {
                $MergedName = -join ($Name, $Delimiter, $Key)
            } else{
                $MergedName = $Key
            }
            if ($InputObject[$Key] -is [System.Collections.IDictionary]) {

                $Found = ConvertTo-FlatHashtable -InputObject $InputObject[$Key] -Name $MergedName
                $Output = $Output + $Found
            } else {
                $Output[$MergedName] = $InputObject[$Key]
            }
        }
    }
    End {
        $Output
    }
}