function New-ArrayList {
    [CmdletBinding()]
    param()
    $List = New-Object System.Collections.ArrayList
    <#
    Mathias Rørbo Jessen:
        The pipeline will attempt to unravel the list on assignment,
        so you'll have to either wrap the empty arraylist in an array,
        like above, or call WriteObject explicitly and tell it not to, like so:
        $PSCmdlet.WriteObject($List,$false)
    #>
    return , $List
}
function Add-ToArray {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element
    )
    #Write-Verbose "Add-ToArray - Element: $Element"
    $List.Add($Element) > $null
}
function Add-ToArrayAdvanced {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element,
        [switch] $SkipNull,
        [switch] $RequireUnique,
        [switch] $FullComparison
    )
    if ($SkipNull -and $Element -eq $null) {
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
    $List.Add($Element) > $null
}
function Remove-FromArray {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element,
        [switch] $LastElement
    )
    if ($LastElement) {
        $LastID = $List.Count - 1
        $List.RemoveAt($LastID) > $null
    } else {
        $List.Remove($Element) > $null
    }
}
function Split-Array {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        Split an array
        .NOTES
        Version : July 2, 2017 - implemented suggestions from ShadowSHarmon for performance
        .PARAMETER inArray
        A one dimensional array you want to split
        .EXAMPLE
        Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -parts 3
        .EXAMPLE
        Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -size 3
    #>

    param($inArray, [int]$parts, [int]$size)
    if ($parts) {
        $PartSize = [Math]::Ceiling($inArray.count / $parts)
    }
    if ($size) {
        $PartSize = $size
        $parts = [Math]::Ceiling($inArray.count / $size)
    }
    $outArray = New-Object 'System.Collections.Generic.List[psobject]'
    for ($i = 1; $i -le $parts; $i++) {
        $start = (($i - 1) * $PartSize)
        $end = (($i) * $PartSize) - 1
        if ($end -ge $inArray.count) {$end = $inArray.count - 1}
        $outArray.Add(@($inArray[$start..$end]))
    }
    return , $outArray
}
