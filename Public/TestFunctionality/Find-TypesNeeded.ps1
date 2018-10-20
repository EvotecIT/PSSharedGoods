function Find-TypesNeeded {
    [CmdletBinding()]
    param (
        $TypesRequired,
        $TypesNeeded
    )
    $AllTypes = @()
    foreach ($Type in $TypesNeeded) {
        if ($TypesRequired -contains $Type) {
            $AllTypes += $True
        } else {
            $AllTypes += $False
        }
    }
    if ($AllTypes -contains $True) {
        return $True
    } else {
        return $False
    }
}