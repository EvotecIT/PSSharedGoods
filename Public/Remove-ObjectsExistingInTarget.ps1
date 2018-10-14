function Remove-ObjectsExistingInTarget {
    param(
        $ObjectSource,
        $ObjectTarget,
        [string] $ComparePropertySource,
        [string] $ComparePropertyTarget,
        [switch] $Reverse # returns only existing objects
    )
    $ObjectsExistingInTarget = @()
    $ObjectsNotExistingInTarget = @()
    foreach ($Object in $ObjectSource) {
        if ($ObjectTarget.$ComparePropertySource -contains $Object.$ComparePropertyTarget) {
            $ObjectsExistingInTarget += $Object
        } else {
            $ObjectsNotExistingInTarget += $Object
        }
    }
    if ($Reverse) {
        return $ObjectsExistingInTarget
    } else {
        return $ObjectsNotExistingInTarget
    }
}