
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
        [string] $Delimiter = ':'
    )
    Begin {
        $Output = [ordered] @{}
        function Add-HashTableKeys {
            [CmdletBinding()]
            param(
                [System.Collections.IDictionary] $HashTable,
                [string] $Name
            )
            $New = [ordered] @{}
            foreach ($SubKey in $HashTable.Keys) {
                $MergedName = -join ($Name, $Delimiter, $SubKey)
                if ($HashTable[$SubKey] -is [System.Collections.IDictionary]) {
                    $NestedHashtable = Add-HashTableKeys -HashTable $HashTable[$SubKey] -Name $MergedName
                    $New = $New + $NestedHashtable
                } else {
                    $New[$MergedName] = $HashTable[$SubKey]
                }
            }
            $New
        }
    }
    Process {
        foreach ($Key in $InputObject.Keys) {
            if ($InputObject[$Key] -is [System.Collections.IDictionary]) {
                $Found = Add-HashTableKeys -HashTable $InputObject[$Key] -Name $Key
                $Output = $Output + $Found
            } else {
                $Output[$Key] = $InputObject[$Key]
            }
        }
    }
    End {
        $Output
    }
}