Function Compare-ObjectProperties {
    <#
    .SYNOPSIS
    Compares the properties of two objects and returns the differences.

    .DESCRIPTION
    This function compares the properties of two objects and returns the differences found between them. It compares each property of the reference object with the corresponding property of the difference object.

    .PARAMETER ReferenceObject
    The reference object to compare properties against.

    .PARAMETER DifferenceObject
    The object whose properties are compared against the reference object.

    .PARAMETER CaseSensitive
    Indicates whether the comparison should be case-sensitive. Default is false.

    .EXAMPLE
    $ad1 = Get-ADUser amelia.mitchell -Properties *
    $ad2 = Get-ADUser carolyn.quinn -Properties *
    Compare-ObjectProperties $ad1 $ad2
    #>
    Param(
        [PSObject]$ReferenceObject,
        [PSObject]$DifferenceObject,
        [switch]$CaseSensitive = $false
    )
    $objprops = @(
                  $($ReferenceObject | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name),
                  $($DifferenceObject | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name)
                  )
    $objprops = $objprops | Sort-Object -Unique
    $diffs = foreach ($objprop in $objprops) {
        $diff = Compare-Object $ReferenceObject $DifferenceObject -Property $objprop -CaseSensitive:$CaseSensitive
        if ($diff) {
            $diffprops = [PsCustomObject] @{
                PropertyName = $objprop
                RefValue     = ($diff | Where-Object {$_.SideIndicator -eq '<='} | ForEach-Object $($objprop))
                DiffValue    = ($diff | Where-Object {$_.SideIndicator -eq '=>'} | ForEach-Object $($objprop))
            }
            $diffprops
            #New-Object PSObject -Property $diffprops
        }
    }
    if ($diffs) {return ($diffs | Select-Object PropertyName, RefValue, DiffValue)}
}
<#
https://blogs.technet.microsoft.com/janesays/2017/04/25/compare-all-properties-of-two-objects-in-windows-powershell/

$ad1 = Get-ADUser amelia.mitchell -Properties *
$ad2 = Get-ADUser carolyn.quinn -Properties *
Compare-ObjectProperties $ad1 $ad2
#>
