Clear-Host
Import-Module PSSharedGoods # -Force

$Configuration = @{
    Office365 = [ordered] @{
        Credentials    = [ordered] @{
            Username         = 'przemyslaw.klys@evotec.pl'
            Password         = 'C:\Support\Important\Password-O365-Evotec.txt'
            PasswordAsSecure = $true
            PasswordFromFile = $true
        }
        Azure          = [ordered] @{
            Use         = $true
            SessionName = 'O365 Azure MSOL' # MSOL
        }
        AzureAD        = [ordered] @{
            Use         = $false
            SessionName = 'O365 Azure AD' # Azure
            Prefix      = ''
        }
        ExchangeOnline = [ordered] @{
            Use            = $false
            Authentication = 'Basic'
            ConnectionURI  = 'https://outlook.office365.com/powershell-liveid/'
            Prefix         = 'O365'
            SessionName    = 'O365 Exchange'
        }
        Teams          = [ordered] @{
            Use         = $false
            Prefix      = ''
            SessionName = 'O365 Teams'
        }
    }
}

$Connected = @()
if ($Configuration.Office365.Azure.Use) {
    $Connected = Connect-WinAzure -Output -SessionName $Configuration.Office365.Azure.SessionName -Username $Configuration.Office365.Credentials.UserName -Password $Configuration.Office365.Credentials.Password -AsSecure:$Configuration.Office365.Credentials.PasswordAsSecure -FromFile:$Configuration.Office365.Credentials.PasswordFromFile
}
if ($Configuration.Office365.AzureAD.Use) {
    $Connected = Connect-WinAzureAD -Output -SessionName $Configuration.Office365.AzureAD.SessionName -Username  $Configuration.Office365.Credentials.UserName -Password $Configuration.Office365.Credentials.Password -AsSecure:$Configuration.Office365.Credentials.PasswordAsSecure -FromFile:$Configuration.Office365.Credentials.PasswordFromFile
}
if ($Configuration.Office365.ExchangeOnline.Use) {
    $Connected = Connect-WinExchange -Output -SessionName $Configuration.Office365.ExchangeOnline.SessionName -Username  $Configuration.Office365.Credentials.UserName -Password $Configuration.Office365.Credentials.Password -AsSecure:$Configuration.Office365.Credentials.PasswordAsSecure -FromFile:$Configuration.Office365.Credentials.PasswordFromFile -ConnectionURI $Configuration.Office365.ExchangeOnline.ConnectionURI -Authentication $Configuration.Office365.ExchangeOnline.Authentication
}
if ($Configuration.Office365.MicrosoftTeams.Use) {
    $Connected = Connect-WinTeams -Output -SessionName $Configuration.Office365.Teams.SessionName -Username  $Configuration.Office365.Credentials.UserName -Password $Configuration.Office365.Credentials.Password -AsSecure:$Configuration.Office365.Credentials.PasswordAsSecure -FromFile:$Configuration.Office365.Credentials.PasswordFromFile
}
if ($Connected.Status -contains $false) {
    Write-Color -Text 'Connecting to tenant failed in one of those 3 options above.' -Color Red
    return
}