Function Get-ModulesAvailability {
    param(
        [string]$Name
    )
    if (-not(Get-Module -name $name)) {
        if (Get-Module -ListAvailable | Where-Object { $_.name -eq $name }) {
            try {
                Import-Module -Name $name
                return $true
            } catch {
                return $false
            }
        } else { return $false } #module not available
    } else { return $true } #module already loaded
}