function Format-Dictionary {
    <#
    .SYNOPSIS
    Sorts dictionary/hashtable keys including nested hashtables and returns ordered dictionary

    .DESCRIPTION
    Sorts dictionary/hashtable keys including nested hashtables and returns ordered dictionary

    .PARAMETER Hashtable
    Hashtable to sort

    .EXAMPLE
    $Hashtable = [ordered] @{
        ModuleVersion          = '2.0.X'
        #PreReleaseTag          = 'Preview5'
        CompatiblePSEditions   = @('Desktop', 'Core')

        RunMe                  = @{
            Name = 'RunMe'
            Type = 'Script'
            Path = 'RunMe.ps1'
        }
        GUID                   = 'eb76426a-1992-40a5-82cd-6480f883ef4d'
        Author                 = 'Przemyslaw Klys'
        CompanyName            = 'Evotec'
        Copyright              = "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved."
        Description            = 'Simple project allowing preparing, managing, building and publishing modules to PowerShellGallery'
        PowerShellVersion      = '5.1'
        Tags                   = @('Windows', 'MacOS', 'Linux', 'Build', 'Module')
        IconUri                = 'https://evotec.xyz/wp-content/uploads/2019/02/PSPublishModule.png'
        ProjectUri             = 'https://github.com/EvotecIT/PSPublishModule'
        DotNetFrameworkVersion = '4.5.2'
    }
    $Hashtable = Format-Dictionary -Hashtable $Hashtable
    $Hashtable

    .EXAMPLE
    $Hashtable = Format-Dictionary -Hashtable $Hashtable -ByValue
    $Hashtable

    .EXAMPLE
    $Hashtable = Format-Dictionary -Hashtable $Hashtable -ByValue -Descending
    $Hashtable

    .NOTES
    General notes
    #>
    [alias('Sort-Dictionary')]
    [CmdletBinding()]
    param(
        [alias('Dictionary', 'OrderedDictionary')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Collections.IDictionary] $Hashtable,
        [switch] $Descending,
        [switch] $ByValue
    )
    $Ordered = [ordered] @{}
    if ($ByValue) {
        # sort by value
        $Hashtable.GetEnumerator() | Sort-Object -Property Value -Descending:$Descending.IsPresent | ForEach-Object {
            if ($_.Value -is [System.Collections.IDictionary]) {
                $Ordered[$_.Key] = Format-Dictionary -Hashtable $_.Value -Descending:$Descending.IsPresent -ByValue:$ByValue.IsPresent
            } else {
                $Ordered[$_.Key] = $_.Value
            }
        }
    } else {
        foreach ($K in [string[]] $Hashtable.Keys | Sort-Object -Descending:$Descending.IsPresent) {
            if ($Hashtable[$K] -is [System.Collections.IDictionary]) {
                $Ordered[$K] = Format-Dictionary -Hashtable $Hashtable[$K] -Descending:$Descending.IsPresent -ByValue:$ByValue.IsPresent
            } else {
                $Ordered[$K] = $Hashtable[$K]
            }
        }
    }
    $Ordered
}