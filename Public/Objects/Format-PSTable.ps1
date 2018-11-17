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
    $Type = Get-ObjectType -Object $Object -Verbose:$false
    if ($Type.ObjectTypeName -eq 'Object[]' -or
        $Type.ObjectTypeName -eq 'Object' -or
        $Type.ObjectTypeName -eq 'PSCustomObject' -or
        $Type.ObjectTypeName -eq 'Collection`1') {

        if ($Type.ObjectTypeInsiderName -match 'string|bool|byte|char|decimal|double|float|int|long|sbyte|short|uint|ulong|ushort') {

            return $Object
            #return Format-PSTableConvertType1 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
        } elseif ($Type.ObjectTypeInsiderName -eq 'Object' -or $Type.ObjectTypeInsiderName -eq 'PSCustomObject') {
            # Write-Verbose 'Level 1-1'
            return Format-PSTableConvertType2 -Object $Object `
                -SkipTitle:$SkipTitle `
                -ExcludeProperty $ExcludeProperty `
                -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
                -DisplayPropertySet:$DisplayPropertySet `
                -OverwriteHeaders $OverwriteHeaders `
                -PreScanHeaders:$PreScanHeaders `
                -Property $Property
        } elseif ($Type.ObjectTypeInsiderName -eq 'HashTable' -or $Type.ObjectTypeInsiderName -eq 'OrderedDictionary' ) {

            return Format-PSTableConvertType3 -Object $Object `
                -SkipTitle:$SkipTitle `
                -ExcludeProperty $ExcludeProperty `
                -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
                -DisplayPropertySet:$DisplayPropertySet `
                -OverwriteHeaders $OverwriteHeaders `
                -Property $Property
        } else {
            # Covers ADDriveInfo and other types of objects

            return Format-PSTableConvertType2 -Object $Object `
                -SkipTitle:$SkipTitle `
                -ExcludeProperty $ExcludeProperty `
                -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
                -DisplayPropertySet:$DisplayPropertySet `
                -OverwriteHeaders $OverwriteHeaders `
                -PreScanHeaders:$PreScanHeaders `
                -Property $Property
        }
    } elseif ($Type.ObjectTypeName -eq 'HashTable' -or $Type.ObjectTypeName -eq 'OrderedDictionary' ) {

        return Format-PSTableConvertType3 -Object $Object `
            -SkipTitle:$SkipTitle `
            -ExcludeProperty $ExcludeProperty `
            -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
            -DisplayPropertySet:$DisplayPropertySet `
            -OverwriteHeaders $OverwriteHeaders `
            -Property $Property
    } elseif ($Type.ObjectTypeName -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {
        return $Object
    } else {
        # Covers ADDriveInfo and other types of objects
        return Format-PSTableConvertType2 -Object $Object `
            -SkipTitle:$SkipTitle `
            -ExcludeProperty $ExcludeProperty `
            -NoAliasOrScriptProperties:$NoAliasOrScriptProperties `
            -DisplayPropertySet:$DisplayPropertySet `
            -OverwriteHeaders $OverwriteHeaders `
            -PreScanHeaders:$PreScanHeaders `
            -Property $Property
    }
    throw 'Not supported? Weird'
}
