function New-SqlTableMapping {
    [CmdletBinding()]
    param(
        [Object] $SqlTableMapping,
        [Object] $Object,
        $Properties,
        [switch] $BasedOnSqlTable
    )
    if ($SqlTableMapping) {
        $TableMapping = $SqlTableMapping
    } else {
        $TableMapping = @{}
        if ($BasedOnSqlTable) {
            foreach ($Property in $Properties) {
                $FieldName = $Property
                $FieldNameSql = $Property
                $TableMapping.$FieldName = $FieldNameSQL
            }
        } else {
            # Gets the highest object
            foreach ($O in $Properties.HighestObject) {
                # goes thru properties (but not properties of highest object but for all properties of all objects
                # if there is value it will use the ones from highest object if not it will utilize nvarchar

                foreach ($Property in $Properties.Properties) {

                    #foreach ($E in $O.PSObject.Properties) {
                    $FieldName = $Property
                    $FieldValue = $O.$Property

                    $FieldNameSQL = $FieldName.Replace(' ', '') #.Replace('-', '')

                    if ($FieldValue -is [DateTime]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[datetime],null"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: DateTime"
                    } elseif ($FieldValue -is [int] -or $FieldValue -is [Int64]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[bigint]"
                        # Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: BigInt"
                    } elseif ($FieldValue -is [bool]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[bit]"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: Bit/Bool"
                    } else {
                        $TableMapping.$FieldName = "$FieldNameSQL"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: NvarChar"
                    }
                }
            }
        }
    }
    #Write-Verbose 'New-SqlTableMapping - Ending'
    return $TableMapping
}