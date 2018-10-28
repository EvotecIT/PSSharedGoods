function Test-ConfigurationCredentials {
    [CmdletBinding()]
    param (
        [Object] $Configuration,
        $AllowEmptyKeys
    )
    $Object = @()
    foreach ($Key in $Configuration.Keys) {
        if ($AllowEmptyKeys -notcontains $Key -and [string]::IsNullOrWhiteSpace($Configuration.$Key)) {
            Write-Verbose "Test-ConfigurationCredentials - Configuration $Key is Null or Empty! Terminating"
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = "Credentials configuration $Key is Null or Empty!" }
        }
    }
    return $Object
}