function Find-TypesNeeded {
    [CmdletBinding()]
    param (
        [Array] $TypesRequired,
        [Array] $TypesNeeded
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