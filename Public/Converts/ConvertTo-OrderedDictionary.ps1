function ConvertTo-OrderedDictionary {
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