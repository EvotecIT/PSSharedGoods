function Test-ConfigurationCredentials {
    <#
    .SYNOPSIS
    Tests the configuration credentials for any null or empty values.

    .DESCRIPTION
    This function tests the configuration credentials provided to ensure that no keys have null or empty values.

    .PARAMETER Configuration
    The configuration object containing the credentials to be tested.

    .PARAMETER AllowEmptyKeys
    Specifies whether empty keys are allowed to be present in the configuration.

    .EXAMPLE
    Test-ConfigurationCredentials -Configuration $Config -AllowEmptyKeys $true
    Tests the configuration credentials in $Config allowing empty keys.

    .EXAMPLE
    Test-ConfigurationCredentials -Configuration $Config -AllowEmptyKeys $false
    Tests the configuration credentials in $Config without allowing empty keys.
    #>
    [CmdletBinding()]
    param (
        [Object] $Configuration,
        $AllowEmptyKeys
    )
    $Object = foreach ($Key in $Configuration.Keys) {
        if ($AllowEmptyKeys -notcontains $Key -and [string]::IsNullOrWhiteSpace($Configuration.$Key)) {
            Write-Verbose "Test-ConfigurationCredentials - Configuration $Key is Null or Empty! Terminating"
            @{ Status = $false; Output = $User.SamAccountName; Extended = "Credentials configuration $Key is Null or Empty!" }
        }
    }
    return $Object
}