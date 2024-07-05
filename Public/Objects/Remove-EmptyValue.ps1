function Remove-EmptyValue {
    <#
    .SYNOPSIS
    Removes empty values from a hashtable recursively.

    .DESCRIPTION
    This function removes empty values from a given hashtable. It can be used to clean up a hashtable by removing keys with null, empty string, empty array, or empty dictionary values. The function supports recursive removal of empty values.

    .PARAMETER Hashtable
    The hashtable from which empty values will be removed.

    .PARAMETER ExcludeParameter
    An array of keys to exclude from the removal process.

    .PARAMETER Recursive
    Indicates whether to recursively remove empty values from nested hashtables.

    .PARAMETER Rerun
    Specifies the number of times to rerun the removal process recursively.

    .PARAMETER DoNotRemoveNull
    If specified, null values will not be removed.

    .PARAMETER DoNotRemoveEmpty
    If specified, empty string values will not be removed.

    .PARAMETER DoNotRemoveEmptyArray
    If specified, empty array values will not be removed.

    .PARAMETER DoNotRemoveEmptyDictionary
    If specified, empty dictionary values will not be removed.

    .EXAMPLE
    $hashtable = @{
        'Key1' = '';
        'Key2' = $null;
        'Key3' = @();
        'Key4' = @{}
    }
    Remove-EmptyValue -Hashtable $hashtable -Recursive

    Description
    -----------
    This example removes empty values from the $hashtable recursively.

    #>
    [alias('Remove-EmptyValues')]
    [CmdletBinding()]
    param(
        [alias('Splat', 'IDictionary')][Parameter(Mandatory)][System.Collections.IDictionary] $Hashtable,
        [string[]] $ExcludeParameter,
        [switch] $Recursive,
        [int] $Rerun,
        [switch] $DoNotRemoveNull,
        [switch] $DoNotRemoveEmpty,
        [switch] $DoNotRemoveEmptyArray,
        [switch] $DoNotRemoveEmptyDictionary
    )
    foreach ($Key in [string[]] $Hashtable.Keys) {
        if ($Key -notin $ExcludeParameter) {
            if ($Recursive) {
                if ($Hashtable[$Key] -is [System.Collections.IDictionary]) {
                    if ($Hashtable[$Key].Count -eq 0) {
                        if (-not $DoNotRemoveEmptyDictionary) {
                            $Hashtable.Remove($Key)
                        }
                    } else {
                        Remove-EmptyValue -Hashtable $Hashtable[$Key] -Recursive:$Recursive
                    }
                } else {
                    if (-not $DoNotRemoveNull -and $null -eq $Hashtable[$Key]) {
                        $Hashtable.Remove($Key)
                    } elseif (-not $DoNotRemoveEmpty -and $Hashtable[$Key] -is [string] -and $Hashtable[$Key] -eq '') {
                        $Hashtable.Remove($Key)
                    } elseif (-not $DoNotRemoveEmptyArray -and $Hashtable[$Key] -is [System.Collections.IList] -and $Hashtable[$Key].Count -eq 0) {
                        $Hashtable.Remove($Key)
                    }
                }
            } else {
                if (-not $DoNotRemoveNull -and $null -eq $Hashtable[$Key]) {
                    $Hashtable.Remove($Key)
                } elseif (-not $DoNotRemoveEmpty -and $Hashtable[$Key] -is [string] -and $Hashtable[$Key] -eq '') {
                    $Hashtable.Remove($Key)
                } elseif (-not $DoNotRemoveEmptyArray -and $Hashtable[$Key] -is [System.Collections.IList] -and $Hashtable[$Key].Count -eq 0) {
                    $Hashtable.Remove($Key)
                }
            }
        }
    }
    if ($Rerun) {
        for ($i = 0; $i -lt $Rerun; $i++) {
            Remove-EmptyValue -Hashtable $Hashtable -Recursive:$Recursive
        }
    }
}


<#
$SplatDictionary = [ordered] @{
    Test  = $NotExistingParameter
    Test1 = 'Existing Entry'
    Test2 = $null
    Test3 = ''
    Test5 = 0
    Test6 = 6
    Test7 = @{}
}

Remove-EmptySplatProperty -Splat $SplatDictionary -Recursive -ExcludeParameter 'Test7'

$SplatDictionary
#>