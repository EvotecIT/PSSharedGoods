function Find-TypesNeeded {
    param (
        $TypesRequired,
        $TypesNeeded
    )

    foreach ($Type in $TypesNeeded) {
        if ($TypesRequired -contains $Type) {
            return $True
        }
    }
    return $False
}