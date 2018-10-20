function Format-PSTable {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)] $Object,
        [switch] $SkipTitle,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders,
        [switch] $PreScanHeaders
    )

    $Type = Get-ObjectType -Object $Object
    #Write-Verbose "Format-PSTable - Type: $($Type.ObjectTypeName) NoAliasOrScriptProperties: $NoAliasOrScriptProperties DisplayPropertySet: $DisplayPropertySet"
    if ($Type.ObjectTypeName -eq 'Object[]' -or
        $Type.ObjectTypeName -eq 'Object' -or $Type.ObjectTypeName -eq 'PSCustomObject' -or
        $Type.ObjectTypeName -eq 'Collection`1') {
        #Write-Verbose 'Level 0-0'
        if ($Type.ObjectTypeInsiderName -match 'string|bool|byte|char|decimal|double|float|int|long|sbyte|short|uint|ulong|ushort') {
            #Write-Verbose 'Level 1-0'
            return $Object
            #return Format-PSTableConvertType1 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
        } elseif ($Type.ObjectTypeInsiderName -eq 'Object' -or $Type.ObjectTypeInsiderName -eq 'PSCustomObject') {
            # Write-Verbose 'Level 1-1'
            return Format-PSTableConvertType2 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders -PreScanHeaders:$PreScanHeaders
        } elseif ($Type.ObjectTypeInsiderName -eq 'HashTable' -or $Type.ObjectTypeInsiderName -eq 'OrderedDictionary' ) {
            # Write-Verbose 'Level 1-2'
            return Format-PSTableConvertType3 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
        } else {
            # Covers ADDriveInfo and other types of objects
            # Write-Verbose 'Level 1-3'
            return Format-PSTableConvertType2 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders -PreScanHeaders:$PreScanHeaders
        }
    } elseif ($Type.ObjectTypeName -eq 'HashTable' -or $Type.ObjectTypeName -eq 'OrderedDictionary' ) {
        #Write-Verbose 'Level 0-1'
        return Format-PSTableConvertType3 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders
    } elseif ($Type.ObjectTypeName -match 'bool|byte|char|datetime|decimal|double|ExcelHyperLink|float|int|long|sbyte|short|string|timespan|uint|ulong|URI|ushort') {
        return $Object
    } else {
        #Write-Verbose 'Level 0-2'
        # Covers ADDriveInfo and other types of objects
        return Format-PSTableConvertType2 -Object $Object -SkipTitle:$SkipTitle -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -OverwriteHeaders $OverwriteHeaders -PreScanHeaders:$PreScanHeaders
    }
    throw 'Not supported? Weird'
}
