function Remove-EmptyValues {
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Hashtable
    )
    foreach ($_ in [string[]] $Hashtable.Keys) {
        if ($null -eq $Hashtable[$_] -or $Hashtable[$_] -eq '') {
            $Hashtable.Remove($_)
        }
    }
}