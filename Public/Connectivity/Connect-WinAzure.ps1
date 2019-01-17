function Connect-WinAzure {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure MSOL',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [switch] $Output #, [System.Collections.IDictionary] $Credentials
    )
    if (-not $MultiFactorAuthentication) {
        Write-Verbose "Connect-WinAzure - Running connectivity without MFA"
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
        Connect-MsolService -Credential $Credentials -ErrorAction Stop
        $Connected = $true
    } catch {
        $Connected = $false
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinAzure - Failed with error message: $ErrorMessage"
            return
        }
    }
    if ($Connected -eq $false) {
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = 'Connection Failed.' }
        } else {
            return
        }
    } else {
        if ($Output) {
            return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
        } else {
            return
        }
    }
}