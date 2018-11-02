Function Get-ModulesAvailability {
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