function Test-ForestConnectivity {
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