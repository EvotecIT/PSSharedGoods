function Connect-WinSharePoint {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Microsoft SharePoint',
        [string] $Username,
        [string] $Password,
        [alias('PasswordAsSecure')][switch] $AsSecure,
        [alias('PasswordFromFile')][switch] $FromFile,
        [alias('mfa')][switch] $MultiFactorAuthentication,
        [alias('uri', 'url', 'ConnectionUrl')][Uri] $ConnectionURI,
        [switch] $Output
    )
    if (-not $MultiFactorAuthentication) {
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
        Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
        $Session = Connect-SPOService -Url $ConnectionURI -Credential $Credentials
    } catch {
        $Session = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        if ($Output) {
            return @{ Status = $false; Output = $SessionName; Extended = "Connection failed with $ErrorMessage" }
        } else {
            Write-Warning "Connect-WinSharePoint - Failed with error message: $ErrorMessage"
            return
        }
    }
    if ($Output) {
        return @{ Status = $true; Output = $SessionName; Extended = 'Connection Established.' }
    }
}