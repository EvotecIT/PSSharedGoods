Clear-Host
Import-Module PSSharedGoods -Force -Verbose

$Configuration = @{
    Options    = @{
        LogsPath = 'C:\Support\Logs\Automated.log'
    }
    Office365  = [ordered] @{
        Credentials      = [ordered] @{
            Username                  = 'przemyslaw.klys@evotec.pl'
            Password                  = 'C:\Support\Important\Password-O365-Evotec.txt'
            PasswordAsSecure          = $true
            PasswordFromFile          = $true
            MultiFactorAuthentication = $false
        }
        Azure            = [ordered] @{
            Use         = $false
            SessionName = 'O365 Azure MSOL' # MSOL
        }
        AzureAD          = [ordered] @{
            Use         = $false
            SessionName = 'O365 Azure AD' # Azure
            Prefix      = ''
        }
        ExchangeOnline   = [ordered] @{
            Use            = $false
            Authentication = 'Basic'
            ConnectionURI  = 'https://outlook.office365.com/powershell-liveid/'
            Prefix         = 'O365'
            SessionName    = 'O365 Exchange'
        }
        SecurityCompliance = [ordered] @{
            Use            = $true
            Authentication = 'Basic'
            ConnectionURI  = 'https://ps.compliance.protection.outlook.com/PowerShell-LiveId'
            Prefix         = 'O365'
            SessionName    = 'O365 Security And Compliance'
        }
        SharePointOnline = [ordered] @{
            Use           = $false
            ConnectionURI = 'https://evotecpoland-admin.sharepoint.com'
        }
        SkypeOnline      = [ordered] @{
            Use         = $false
            SessionName = 'O365 Skype'
        }
        Teams            = [ordered] @{
            Use         = $false
            Prefix      = ''
            SessionName = 'O365 Teams'
        }
    }
    OnPremises = @{
        Credentials = [ordered] @{
            Username         = 'przemyslaw.klys@evotec.pl'
            Password         = 'C:\Support\Important\Password-O365-Evotec.txt'
            PasswordAsSecure = $true
            PasswordFromFile = $true
        }
        Exchange    = [ordered] @{
            Use            = $false
            Authentication = 'Kerberos'
            ConnectionURI  = 'http://PLKATO365Exch.evotec.pl/PowerShell'
            Prefix         = ''
            SessionName    = 'Exchange'
        }
    }
}

$Connected = @()

$BundleCredentials = $Configuration.Office365.Credentials
$BundleCredentialsOnPremises = $Configuration.OnPremises.Credentials

if ($Configuration.Office365.Azure.Use) {
    $Connected += Connect-WinAzure @BundleCredentials -Output -SessionName $Configuration.Office365.Azure.SessionName -Verbose
}
if ($Configuration.Office365.AzureAD.Use) {
    $Connected += Connect-WinAzureAD @BundleCredentials -Output -SessionName $Configuration.Office365.AzureAD.SessionName -Verbose
}
if ($Configuration.Office365.ExchangeOnline.Use) {
    $Connected += Connect-WinExchange @BundleCredentials -Output -SessionName $Configuration.Office365.ExchangeOnline.SessionName -ConnectionURI $Configuration.Office365.ExchangeOnline.ConnectionURI -Authentication $Configuration.Office365.ExchangeOnline.Authentication -Verbose
}
if ($Configuration.Office365.SecurityCompliance.Use) {
    $Connected += Connect-WinSecurityCompliance @BundleCredentials -Output -SessionName $Configuration.Office365.SecurityCompliance.SessionName -ConnectionURI $Configuration.Office365.SecurityCompliance.ConnectionURI -Authentication $Configuration.Office365.SecurityCompliance.Authentication -Verbose
}
if ($Configuration.Office365.SkypeOnline.Use) {
    $Connected += Connect-WinSkype @BundleCredentials -Output -SessionName $Configuration.Office365.SkypeOnline.SessionName -Verbose
}
if ($Configuration.Office365.SharePointOnline.Use) {
    $Connected += Connect-WinSharePoint @BundleCredentials -Output -SessionName $Configuration.Office365.SharePointOnline.SessionName -ConnectionURI $Configuration.Office365.SharePointOnline.ConnectionURI -Verbose
}
if ($Configuration.Office365.MicrosoftTeams.Use) {
    $Connected += Connect-WinTeams @BundleCredentials -Output -SessionName $Configuration.Office365.Teams.SessionName -Verbose
}
if ($Configuration.OnPremises.Exchange.Use) {
    $Connected += Connect-WinExchange @BundleCredentialsOnPremises -Output -SessionName $Configuration.OnPremises.Exchange.SessionName -ConnectionURI $Configuration.OnPremises.Exchange.ConnectionURI -Authentication $Configuration.OnPremises.Exchange.Authentication -Verbose
}

if ($Connected.Status -contains $false) {
    foreach ($C in $Connected | Where-Object { $_.Status -eq $false }) {
        Write-Color -Text 'Connecting to tenant failed for ', $C.Output, ' with error ', $Connected.Extended -Color White, Red, White, Red -LogFile $Configuration.Options.LogsPath
    }
    return
}