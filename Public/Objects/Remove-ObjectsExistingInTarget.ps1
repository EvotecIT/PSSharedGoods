function Remove-ObjectsExistingInTarget {
    <#
    .SYNOPSIS
    Removes objects from the source list that exist in the target list based on specified properties.

    .DESCRIPTION
    This function compares two lists of objects and removes objects from the source list that have matching properties in the target list. It returns either the objects that do not exist in the target list or only the objects that exist in the target list based on the specified properties.

    .PARAMETER ObjectSource
    The list of objects to compare against the target list.

    .PARAMETER ObjectTarget
    The list of objects to compare with.

    .PARAMETER ComparePropertySource
    The property in the source objects to compare.

    .PARAMETER ComparePropertyTarget
    The property in the target objects to compare.

    .PARAMETER Reverse
    Switch to return only the objects that exist in the target list.

    .EXAMPLE
    $sourceList = @(
        [PSCustomObject]@{Id = 1; Name = "A"},
        [PSCustomObject]@{Id = 2; Name = "B"},
        [PSCustomObject]@{Id = 3; Name = "C"}
    )

    $targetList = @(
        [PSCustomObject]@{Id = 2; Name = "B"},
        [PSCustomObject]@{Id = 3; Name = "C"}
    )

    Remove-ObjectsExistingInTarget -ObjectSource $sourceList -ObjectTarget $targetList -ComparePropertySource "Id" -ComparePropertyTarget "Id"
    # Output: Id Name
    #        -- ----
    #         1 A

    .EXAMPLE
    $sourceList = @(
        [PSCustomObject]@{Id = 1; Name = "A"},
        [PSCustomObject]@{Id = 2; Name = "B"},
        [PSCustomObject]@{Id = 3; Name = "C"}
    )

    $targetList = @(
        [PSCustomObject]@{Id = 2; Name = "B"},
        [PSCustomObject]@{Id = 3; Name = "C"}
    )

    Remove-ObjectsExistingInTarget -ObjectSource $sourceList -ObjectTarget $targetList -ComparePropertySource "Id" -ComparePropertyTarget "Id" -Reverse
    # Output: Id Name
    #        -- ----
    #         2 B
    #         3 C
    #>
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