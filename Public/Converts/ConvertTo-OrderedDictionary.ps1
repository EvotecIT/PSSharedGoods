function ConvertTo-OrderedDictionary {
    <#
    .SYNOPSIS
    Converts a hashtable into an ordered dictionary.

    .DESCRIPTION
    This function takes a hashtable as input and converts it into an ordered dictionary. The ordered dictionary maintains the order of elements as they were added to the hashtable.

    .PARAMETER HashTable
    Specifies the hashtable to be converted into an ordered dictionary.

    .EXAMPLE
    $HashTable = @{
        "Key3" = "Value3"
        "Key1" = "Value1"
        "Key2" = "Value2"
    }
    ConvertTo-OrderedDictionary -HashTable $HashTable
    # Outputs an ordered dictionary where the keys are in the order they were added to the hashtable.

    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true)] $HashTable
    )
    # $TimeToGenerate = Start-TimeLog
    $OrderedDictionary = [ordered]@{ }
    if ($HashTable -is [System.Collections.IDictionary]) {
        $Keys = $HashTable.Keys | Sort-Object
        foreach ($_ in $Keys) {
            $OrderedDictionary.Add($_, $HashTable[$_])
        }
    } elseif ($HashTable -is [System.Collections.ICollection]) {
        for ($i = 0; $i -lt $HashTable.count; $i++) {
            $OrderedDictionary.Add($i, $HashTable[$i])
        }
    } else {
        Write-Error "ConvertTo-OrderedDictionary - Wrong input type."
    }
    # $EndTime = Stop-TimeLog -Time $TimeToGenerate
    #Write-Verbose "ConvertTo-OrderedDictionary - Time to convert: $EndTime"
    return $OrderedDictionary
}