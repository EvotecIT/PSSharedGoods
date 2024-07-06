function Test-ForestConnectivity {
    <#
    .SYNOPSIS
    Tests the connectivity to the Active Directory forest.

    .DESCRIPTION
    This function tests the connectivity to the Active Directory forest by attempting to retrieve the forest information.

    .EXAMPLE
    Test-ForestConnectivity
    Tests the connectivity to the Active Directory forest.

    #>
    [CmdletBinding()]
    param(

    )
    Try {
        $null = Get-ADForest
        return $true
    } catch {
        #Write-Warning 'No connectivity to forest/domain.'
        return $False
    }
}