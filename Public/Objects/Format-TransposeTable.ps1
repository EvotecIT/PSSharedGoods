function Format-TransposeTable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][System.Collections.ICollection] $Object,
        [ValidateSet("ASC", "DESC", "NONE")][String] $Sort = 'NONE'
    )
    process {
        foreach ($myObject in $Object) {
            if ($myObject -is [System.Collections.IDictionary]) {
                if ($Sort -eq 'ASC') {
                    [PSCustomObject] $myObject.GetEnumerator() | Sort-Object -Property Name -Descending:$false
                } elseif ($Sort -eq 'DESC') {
                    [PSCustomObject] $myObject.GetEnumerator() | Sort-Object -Property Name -Descending:$true
                } else {
                    [PSCustomObject] $myObject
                }
            } else {
                $Output = [ordered] @{ }
                if ($Sort -eq 'ASC') {
                    $myObject.PSObject.Properties | Sort-Object -Property Name -Descending:$false | ForEach-Object {
                        $Output["$($_.Name)"] = $_.Value
                    }
                } elseif ($Sort -eq 'DESC') {
                    $myObject.PSObject.Properties | Sort-Object -Property Name -Descending:$true | ForEach-Object {
                        $Output["$($_.Name)"] = $_.Value
                    }
                } else {
                    $myObject.PSObject.Properties | ForEach-Object {
                        $Output["$($_.Name)"] = $_.Value
                    }
                }
                $Output

            }
        }
    }
}
<#

$T = [PSCustomObject] @{
    Test   = 1
    Test2  = 7
    Ole    = 'bole'
    Trolle = 'A'
    Alle   = 'sd'
}

$T1 = [PSCustomObject] @{
    Test   = 1
    Test2  = 7
    Ole    = 'bole'
    Trolle = 'A'
    Alle   = 'sd'
}

$T2 = [ordered] @{
    Test   = 1
    Test2  = 7
    Ole    = 'bole'
    Trolle = 'A'
    Alle   = 'sd'
}
$T3 = @{
    Test   = 1
    Test2  = 7
    Ole    = 'bole'
    Trolle = 'A'
    Alle   = 'sd'
}
Clear-Host
Format-TransposeTable -Object @($T) -Sort ASC | Format-Table
Format-TransposeTable -Object @($T) -Sort DESC | Format-Table
Format-TransposeTable -Object @($T) | Format-Table

Format-TransposeTable -Object @($T2) -Sort ASC | Format-Table
Format-TransposeTable -Object @($T2) -Sort DESC | Format-Table
Format-TransposeTable -Object @($T2) | Format-Table
#>