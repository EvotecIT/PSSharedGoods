function Get-ObjectCount {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Object]$Object
    )
    return $($Object | Measure-Object).Count
}
function Convert-KeyToKeyValue {
    [CmdletBinding()]
    param (
        [object] $Object
    )
    $NewHash = [ordered] @{}
    foreach ($O in $Object.Keys) {
        $KeyName = "$O ($($Object.$O))"
        $KeyValue = $Object.$O
        $NewHash.$KeyName = $KeyValue
    }
    return $NewHash
}
function Get-ObjectKeys {
    param(
        [object] $Object,
        [string] $Ignore
    )
    $Data = $Object.Keys | Where { $_ -notcontains $Ignore }
    return $Data
}
## This methods converts 2 Arrays into 1 Array
## Administrators  + 0 = Administrators (0)
function Convert-TwoArraysIntoOne {
    [CmdletBinding()]
    param (
        $Object,
        $ObjectToAdd
    )

    $Value = @()
    for ($i = 0; $i -lt $Object.Count; $i++) {
        $Value += "$($Object[$i]) ($($ObjectToAdd[$i]))"
    }
    return $Value
}
function Get-ObjectTitles {
    [CmdletBinding()]
    param(
        $Object
    )
    $ArrayList = New-Object System.Collections.ArrayList
    Write-Verbose "Get-ObjectTitles - ObjectType $($Object.GetType())"
    foreach ($Title in $Object.PSObject.Properties) {
        Write-Verbose "Get-ObjectTitles - Value added to array: $($Title.Name)"
        $ArrayList.Add($Title.Name) | Out-Null
    }
    Write-Verbose "Get-ObjectTitles - Array size: $($ArrayList.Count)"
    return $ArrayList
}
function Get-ObjectData {
    [CmdletBinding()]
    param(
        $Object,
        $Title,
        [switch] $DoNotAddTitles
    )
    $ArrayList = New-Object System.Collections.ArrayList
    $Values = $Object.$Title
    Write-Verbose "Get-ObjectData1: Title $Title Values: $Values"
    if ((Get-ObjectCount $values) -eq 1 -and $DoNotAddTitles -eq $false) {
        $ArrayList.Add("$Title - $Values") | Out-Null
    } else {
        if ($DoNotAddTitles -eq $false) { $ArrayList.Add($Title) | Out-Null }
        foreach ($Value in $Values) {
            $ArrayList.Add("$Value") | Out-Null
        }
    }
    Write-Verbose "Get-ObjectData2: Title $Title Values: $(Get-ObjectCount $ArrayList)"
    return $ArrayList
}
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