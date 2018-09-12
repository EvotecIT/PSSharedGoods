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
            #Write-Verbose 'New-SqlTableMapping - Starting'

            # Gets the highest object
            foreach ($O in $Properties.HighestObject) {
                #if (-not $O.AddedWhen) {
                #    Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWhen" -Value (Get-Date)
                #}
                #if (-not $O.AddedWho) {
                #    Add-Member -InputObject $O -MemberType NoteProperty -Name "AddedWho" -Value ($Env:USERNAME)
                #}
                # goes thru properties (but not properties of highest object but for all properties of all objects
                # if there is value it will use the ones from highest object if not it will utilize nvarchar

                foreach ($Property in $Properties.Properties) {

                    #foreach ($E in $O.PSObject.Properties) {
                    $FieldName = $Property
                    $FieldValue = $O.$Property

                    $FieldNameSQL = $FieldName.Replace(' ', '') #.Replace('-', '')

                    if ($FieldValue -is [DateTime]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[datetime],null"
                        #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [DateTime] NULL"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: DateTime"
                    } elseif ($FieldValue -is [int] -or $FieldValue -is [Int64]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[bigint]"
                        #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [bigint] NULL"
                        # Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: BigInt"
                    } elseif ($FieldValue -is [bool]) {
                        $TableMapping.$FieldName = "$FieldNameSQL,[bit]"
                        #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [bit] NULL"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: Bit/Bool"
                    } else {
                        $TableMapping.$FieldName = "$FieldNameSQL"
                        #Add-ToArray -List $ArrayKeys -Element "[$MapValue] [nvarchar](max) NULL"
                        #Write-Verbose "New-SqlTableMapping - FieldName: $FieldName FieldValue: $FieldValue FieldNameSQL: $FieldNameSQL FieldDataType: NvarChar"
                    }
                }
            }
        }
    }
    #Write-Verbose 'New-SqlTableMapping - Ending'
    return $TableMapping
}