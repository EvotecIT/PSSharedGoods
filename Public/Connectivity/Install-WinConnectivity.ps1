function Install-WinConnectity {
    param(
        [ValidateSet('MSOnline', 'AzureAD', 'SharePoint', 'ExchangeOnline' )][string[]] $Module,
        [switch] $All
    )

    if ($Module -eq 'MSOnline' -or $All) {
        Install-Module -Name MSOnline
    }
    if ($Module -eq 'AzureAD' -or $All) {
        Install-Module -Name AzureAD
    }
    #Install-Module SkypeOnlineConnector
    if ($Module -eq 'SharePoint' -or $All) {
        Install-Module -Name Microsoft.Online.SharePoint.PowerShell
    }
    if ($Module -eq 'ExchangeOnline' -or $All) {
        $App = Test-InstalledApplication -DisplayName "Microsoft Exchange Online Powershell Module"
        if ($null -ne $App) {
            # Manifest for Exchange Online Click Once App
            Install-ApplicationClickOnce -Manifest "https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application"
        }
    }
}