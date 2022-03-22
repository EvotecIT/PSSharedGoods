function Test-PSRegistry {
    [cmdletbinding()]
    param(
        [alias('Path')][string[]] $RegistryPath,
        [string] $ComputerName = $Env:COMPUTERNAME,
        [string] $Key
    )
    $Output = Get-PSRegistry -RegistryPath $RegistryPath -ComputerName $ComputerName
    if ($Output.PSConnection -eq $true -and $Output.PSError -eq $false) {
        if ($Key) {
            if ($null -ne $Output.$Key) {
                return $true
            } else {
                return $false
            }
        } else {
            return $true
        }
    } else {
        return $false
    }
}