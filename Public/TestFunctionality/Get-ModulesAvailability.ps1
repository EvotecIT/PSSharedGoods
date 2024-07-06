Function Get-ModulesAvailability {
    <#
    .SYNOPSIS
    Checks the availability of a specified module and imports it if available.

    .DESCRIPTION
    This function checks if a specified module is available. If the module is not loaded, it attempts to import it. Returns $true if the module is successfully loaded, otherwise $false.

    .PARAMETER Name
    Specifies the name of the module to check and potentially import.

    .EXAMPLE
    Get-ModulesAvailability -Name "AzureRM"
    Checks if the "AzureRM" module is available and imports it if not already loaded.

    .EXAMPLE
    Get-ModulesAvailability -Name "ActiveDirectory"
    Checks the availability of the "ActiveDirectory" module and imports it if necessary.

    #>
    [cmdletBinding()]
    param(
        [string]$Name
    )
    if (-not(Get-Module -Name $Name)) {
        if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $Name }) {
            try {
                Import-Module -Name $Name
                return $true
            } catch {
                return $false
            }
        } else {
            #module not available
            return $false
        }
    } else {
        return $true
    } #module already loaded
}