Function Compare-ObjectProperties {
    Param(
        [PSObject]$ReferenceObject,
        [PSObject]$DifferenceObject
    )
    $objprops = $ReferenceObject | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name
    $objprops += $DifferenceObject | Get-Member -MemberType Property, NoteProperty | ForEach-Object Name
    $objprops = $objprops | Sort | Select -Unique
    $diffs = foreach ($objprop in $objprops) {
        $diff = Compare-Object $ReferenceObject $DifferenceObject -Property $objprop
        if ($diff) {
            $diffprops = [PsCustomObject] @{
                PropertyName = $objprop
                RefValue     = ($diff | Where-Object {$_.SideIndicator -eq '<='} | % $($objprop))
                DiffValue    = ($diff | Where-Object {$_.SideIndicator -eq '=>'} | % $($objprop))
            }
            $diffprops
            #New-Object PSObject -Property $diffprops
        }
    }
    if ($diffs) {return ($diffs | Select PropertyName, RefValue, DiffValue)}
}
<#
https://blogs.technet.microsoft.com/janesays/2017/04/25/compare-all-properties-of-two-objects-in-windows-powershell/

$ad1 = Get-ADUser amelia.mitchell -Properties *
$ad2 = Get-ADUser carolyn.quinn -Properties *
Compare-ObjectProperties $ad1 $ad2
#>