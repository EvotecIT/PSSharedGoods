function Remove-DuplicateObjects {
    <#
    .SYNOPSIS
    Removes duplicate objects from a list based on specified properties.

    .DESCRIPTION
    This function removes duplicate objects from the input list based on the specified properties. It retains only unique objects in the list.

    .PARAMETER Object
    The list of objects to remove duplicates from.

    .PARAMETER Property
    The properties to consider when identifying duplicates.

    .EXAMPLE
    $Array = @()
    $Array += [PSCustomObject] @{ 'Name' = 'Test'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}
    $Array += [PSCustomObject] @{ 'Name' = 'Test'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}
    $Array += [PSCustomObject] @{ 'Name' = 'Test1'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}
    $Array += [PSCustomObject] @{ 'Name' = 'Test1'; 'Val1' = 'Testor2'; 'Val2' = 'Testor2'}

    Write-Color 'Before' -Color Red
    $Array | Format-Table -A

    Write-Color 'After' -Color Green
    $Array = $Array | Sort-Object -Unique -Property 'Name', 'Val1','Val2'
    $Array | Format-Table -AutoSize

    .NOTES
    This function removes duplicate objects from a list based on specified properties.
    #>
    [CmdletBinding()]
    param(
        [System.Collections.IList] $Object,
        [string[]] $Property
    )
    if ($Object.Count -eq 0) {
        return $Object
    } else {
        return $Object | Sort-Object -Property $Property -Unique
    }
}