function Connect-WinAzureAD {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure AD',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [switch] $Output
    )
    if (-not $MultiFactorAuthentication) {
        Write-Verbose "Connect-WinAzureAD - Running connectivity without MFA"
        $Credentials = Request-Credentials -UserName $Username `
            -Password $Password `
            -AsSecure:$AsSecure `
            -FromFile:$FromFile `
            -Service $SessionName `
            -Output

        if ($Credentials -isnot [PSCredential]) {
            if ($Output) {
                return $Credentials
            } else {
                return
            }
        }
    }
    try {
           # If it's mfa $Credentials will be $null so it will ask with a prompt
        $Session = Connect-AzureAD -Credential $Credentials -ErrorAction Stop
    } catch {
        $Session = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinAzureAD - Failed with error message: $ErrorMessage"
            return
        }
    }
    if (-not $Session) {
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
        } else {
            return
        }
    }
    if ($Output) {
        return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
    }
}