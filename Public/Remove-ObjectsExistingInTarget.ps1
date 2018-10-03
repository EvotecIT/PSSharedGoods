function Remove-ObjectsExistingInTarget {
    param(
        $ObjectSource,
        $ObjectTarget,
        [string] $ComparePropertySource,
        [string] $ComparePropertyTarget
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
    return $ObjectsNotExistingInTarget
}