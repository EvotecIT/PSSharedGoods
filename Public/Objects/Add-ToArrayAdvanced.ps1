function Add-ToArrayAdvanced {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element,
        [switch] $SkipNull,
        [switch] $RequireUnique,
        [switch] $FullComparison,
        [switch] $Merge
    )
    if ($SkipNull -and $null -eq $Element) {
        #Write-Verbose "Add-ToArrayAdvanced - SkipNull used"
        return
    }
    if ($RequireUnique) {
        if ($FullComparison) {
            foreach ($ListElement in $List) {
                if ($ListElement -eq $Element) {
                    $TypeLeft = Get-ObjectType -Object $ListElement
                    $TypeRight = Get-ObjectType -Object $Element
                    if ($TypeLeft.ObjectTypeName -eq $TypeRight.ObjectTypeName) {
                        #Write-Verbose "Add-ToArrayAdvanced - RequireUnique with full comparison used"
                        return
                    }
                }
            }
        } else {
            if ($List -contains $Element) {
                #Write-Verbose "Add-ToArrayAdvanced - RequireUnique on name used"
                return
            }
        }
    }
    #Write-Verbose "Add-ToArrayAdvanced - Adding ELEMENT: $Element"
    if ($Merge) {
        [void] $List.AddRange($Element) # > $null
    } else {
        [void] $List.Add($Element) # > $null
    }
}