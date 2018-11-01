function Set-EmailBodyReplacement {
    [CmdletBinding()]
    param(
        $Body,
        [hashtable] $ReplacementTable,
        [ValidateSet('Colors', 'Bold')][string] $Type
    )
    switch ($Type) {
        'Colors' {
            foreach ($Field in $ReplacementTable.Keys) {
                $Value = $ReplacementTable.$Field
                $Body = $Body -replace $Field, "<font color=`"$Value`">$Field</font>"
            }
        }
        'Bold' {
            foreach ($Field in $ReplacementTable.Keys) {
                $Value = $ReplacementTable.$Field
                if ($Value -eq $true) {
                    $Body = $Body -replace $Field, "<b>$Field</b>"
                }
            }
        }
    }
    return $Body
}

<#
$ReplacementTable = @{
    ' Added' = 'green'
}

$ReplacementTable = @{
    ' Added' = $true
}
#>