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
        [pscredential] $Credential
    )
    $credentialSplat = @{}
    if ($PSBoundParameters.ContainsKey('Credential')) {
        $credentialSplat['Credential'] = $Credential
    }
    Try {
        $null = Get-ADForest @credentialSplat
        return $true
    } catch {
        #Write-Warning 'No connectivity to forest/domain.'
        return $False
    }
}
