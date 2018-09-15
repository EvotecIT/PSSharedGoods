function Connect-Exchange {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Evotec',
        [string] $ConnectionURI = 'http://ex2013x3.ad.evotec.xyz/Powershell', # https://outlook.office365.com/powershell-liveid/
        [ValidateSet("Basic", "Kerberos")][String] $Authentication = 'Kerberos',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure
    )
    if ($UserName -and $Password) {
        if ($AsSecure) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        } else {
            $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
        }

    }

    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession.Availability -eq 'Available') {
        Write-Verbose 'Connect-Exchange - reusing session'
        return $ExistingSession
        #Import-PSSession -Session $ExistingSession -AllowClobber
    } else {
        Write-Verbose 'Connect-Exchange - creating new session'
        $SessionOption = New-PSSessionOption -SkipRevocationCheck -SkipCACheck -SkipCNCheck
        if ($Credentials) {
            $Session = New-PSSession -Credential $Credentials -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection
        } else {
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication $Authentication -SessionOption $sessionOption -Name $SessionName -AllowRedirection
        }
        return $Session
    }
}