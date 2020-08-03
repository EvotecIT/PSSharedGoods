function Remove-EmptyValue {
    [alias('Remove-EmptyValues')]
    [CmdletBinding()]
    param(
        [alias('Splat', 'IDictionary')][Parameter(Mandatory)][System.Collections.IDictionary] $Hashtable,
        [string[]] $ExcludeParameter,
        [switch] $Recursive,
        [int] $Rerun
    )
    foreach ($Key in [string[]] $Hashtable.Keys) {
        if ($Key -notin $ExcludeParameter) {
            if ($Recursive) {
                if ($Hashtable[$Key] -is [System.Collections.IDictionary]) {
                    if ($Hashtable[$Key].Count -eq 0) {
                        $Hashtable.Remove($Key)
                    } else {
                        Remove-EmptyValue -Hashtable $Hashtable[$Key] -Recursive:$Recursive
                    }
                } else {
                    if ($null -eq $Hashtable[$Key] -or ($Hashtable[$Key] -is [string] -and $Hashtable[$Key] -eq '') -or ($Hashtable[$Key] -is [System.Collections.IList] -and $Hashtable[$Key].Count -eq 0)) {
                        $Hashtable.Remove($Key)
                    }
                }
            } else {
                if ($null -eq $Hashtable[$Key] -or ($Hashtable[$Key] -is [string] -and $Hashtable[$Key] -eq '') -or ($Hashtable[$Key] -is [System.Collections.IList] -and $Hashtable[$Key].Count -eq 0)) {
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