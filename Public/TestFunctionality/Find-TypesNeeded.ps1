function Find-TypesNeeded {
    [CmdletBinding()]
    param (
        $TypesRequired,
        $TypesNeeded
    )
    [bool] $Found = $False
    foreach ($Type in $TypesNeeded) {
        if ($TypesRequired -contains $Type) {
            $Found = $true
            break
        }
    }
    return $Found
}