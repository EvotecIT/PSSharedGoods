function Find-TypesNeeded {
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
    if ($AllTypes -contains $False) {
        return $False
    } else {
        return $true
    }
}