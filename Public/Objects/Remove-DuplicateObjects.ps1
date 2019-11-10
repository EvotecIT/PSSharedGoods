function Remove-DuplicateObjects {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Object
    Parameter description

    .PARAMETER Property
    Parameter description

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
    General notes
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