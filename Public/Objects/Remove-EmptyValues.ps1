function Remove-EmptyValues {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Hashtable,
        [switch] $Recursive,
        [int] $Rerun
    )
    foreach ($_ in [string[]] $Hashtable.Keys) {
        if ($Recursive) {
            if ($Hashtable[$_] -is [System.Collections.IDictionary]) {

                if ($Hashtable[$_].Count -eq 0) {
                    $Hashtable.Remove($_)
                } else {
                    Remove-EmptyValues -Hashtable $Hashtable[$_] -Recursive:$Recursive
                }
            } else {
                if ($null -eq $Hashtable[$_]) {
                    $Hashtable.Remove($_)
                } elseif ($Hashtable[$_] -is [string] -and $Hashtable[$_] -eq '') {
                    $Hashtable.Remove($_)
                }
            }
        } else {
            if ($null -eq $Hashtable[$_]) {
                $Hashtable.Remove($_)
            } elseif ($Hashtable[$_] -is [string] -and $Hashtable[$_] -eq '') {
                $Hashtable.Remove($_)
            }
        }
    }
    if ($Rerun) {
        for ($i = 0; $i -lt $Rerun; $i++) {
            Remove-EmptyValues -Hashtable $Hashtable -Recursive:$Recursive
        }
    }
}