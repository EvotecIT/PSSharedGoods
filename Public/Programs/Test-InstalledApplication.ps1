Function Test-InstalledApplication {
    [CmdletBinding()]
    Param(
        [alias('ApplicationName')] [string] $DisplayName
    )
    $App = Get-InstalledApplication -DisplayName $DisplayName -Type UserInstalled
    return $App
}
