function Get-ObjectType {
    [CmdletBinding()]
    param(
        [Object] $Object,
        [string] $ObjectName = 'Random Object Name',
        [switch] $VerboseOnly
    )
    $ReturnData = [ordered] @{}
    $ReturnData.ObjectName = $ObjectName

    if ($Object -ne $null) {
        try {
            $TypeInformation = $Object.GetType()
            $ReturnData.ObjectTypeName = $TypeInformation.Name
            $ReturnData.ObjectTypeBaseName = $TypeInformation.BaseType
            $ReturnData.SystemType = $TypeInformation.UnderlyingSystemType
        } catch {
            $ReturnData.ObjectTypeName = ''
            $ReturnData.ObjectTypeBaseName = ''
            $ReturnData.SystemType = ''
            #Write-Verbose "Get-ObjectType - Outside Error: $($_.Exception.Message)"
        }
        try {
            $TypeInformationInsider = $Object[0].GetType()
            $ReturnData.ObjectTypeInsiderName = $TypeInformationInsider.Name
            $ReturnData.ObjectTypeInsiderBaseName = $TypeInformationInsider.BaseType
            $ReturnData.SystemTypeInsider = $TypeInformationInsider.UnderlyingSystemType
        } catch {

            $ReturnData.ObjectTypeInsiderName = ''
            $ReturnData.ObjectTypeInsiderBaseName = ''
            $ReturnData.SystemTypeInsider = ''
            #Write-Verbose "Get-ObjectType - Inside Error: $($_.Exception.Message)"
        }
    } else {
        $ReturnData.ObjectTypeName = ''
        $ReturnData.ObjectTypeBaseName = ''
        $ReturnData.SystemType = ''
        $ReturnData.ObjectTypeInsiderName = ''
        $ReturnData.ObjectTypeInsiderBaseName = ''
        $ReturnData.SystemTypeInsider = ''
        #Write-Verbose "Get-ObjectType - No data to process - Object is empty?"
    }
    Write-Verbose "Get-ObjectType - ObjectTypeName: $($ReturnData.ObjectTypeName)"
    Write-Verbose "Get-ObjectType - ObjectTypeBaseName: $($ReturnData.ObjectTypeBaseName)"
    Write-Verbose "Get-ObjectType - SystemType: $($ReturnData.SystemType)"
    Write-Verbose "Get-ObjectType - ObjectTypeInsiderName: $($ReturnData.ObjectTypeInsiderName)"
    Write-Verbose "Get-ObjectType - ObjectTypeInsiderBaseName: $($ReturnData.ObjectTypeInsiderBaseName)"
    Write-Verbose "Get-ObjectType - SystemTypeInsider: $($ReturnData.SystemTypeInsider)"
    if ($VerboseOnly) { return } else { return Format-TransposeTable -Object $ReturnData }

}