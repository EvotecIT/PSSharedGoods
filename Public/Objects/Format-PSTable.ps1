function Format-PSTable {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)] $Object,
        [switch] $SkipTitle,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders,
        [switch] $PreScanHeaders,
        [ref] $StringLenghts
    )
   
    [int] $Type = 0   
    if ($Object -is [Array]) {
        if ($Object[0].GetType().Name -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {  
            $Type = 0
        } elseif ($Object[0] -is [System.Collections.IDictionary]) {
            $Type = 1
        } else {
            $Type = 2
        }
    } else {
        if ($Object.GetType().Name -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {  
            $Type = 0
        } elseif ($Object -is [System.Collections.IDictionary]) {
            $Type = 1
        } else {
            $Type = 2
        }
    }
    if ($Type -eq 0) {
        return $Object
    } elseif ($Type -eq 1) {
        return Format-PSTableConvertID -Object $Object `
            -SkipTitle:$SkipTitle `
            -ExcludeProperty $ExcludeProperty `
            -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
            -DisplayPropertySet:$DisplayPropertySet `
            -OverwriteHeaders $OverwriteHeaders `
            -Property $Property
    } else {
        return Format-PSTableConvertCO -Object $Object `
            -SkipTitle:$SkipTitle `
            -ExcludeProperty $ExcludeProperty `
            -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
            -DisplayPropertySet:$DisplayPropertySet `
            -OverwriteHeaders $OverwriteHeaders `
            -PreScanHeaders:$PreScanHeaders `
            -Property $Property
    }
}
