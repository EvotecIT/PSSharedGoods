function Format-PSTableConvertID {
    [CmdletBinding()]
    param (
        [Object] $Object,
        [switch] $SkipTitles,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders
    )
    $Array = [System.Collections.ArrayList]::new()
    ### Add Titles
    if (-not $SkipTitles) {
        $Titles = [System.Collections.ArrayList]::new()
        $null = $Titles.Add('Name')
        $null = $Titles.Add('Value')
        $null = $Array.Add($Titles)
    }
    ### Add Data
    foreach ($O in $Object) {
        foreach ($Name in $O.Keys) {
            #$ArrayValues = New-ArrayList
            $ArrayValues = [System.Collections.ArrayList]::new()
            if ($Property) {
                if ($Property -contains $Name) {
                     $null = $ArrayValues.Add($Name)
                    $null = $ArrayValues.Add($Object.$Name)
                    $null = $Array.Add($ArrayValues)
                }
            } else {
                if ($ExcludeProperty -notcontains $Name) {
                    $null = $ArrayValues.Add($Name)
                    $null = $ArrayValues.Add($O[$Name])
                    $null = $Array.Add($ArrayValues)
                }
            }
        }
    }
    if ($Array.Count -eq 1) { , $Array } else { $Array }
}