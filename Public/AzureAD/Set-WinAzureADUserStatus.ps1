function Set-WinAzureADUserStatus {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Enable", "Disable")][String] $Option,
        [switch] $WhatIf
    )
    $Object = @()
    if ($Option -eq 'Enable' -and $User.BlockCredential -eq $true) {
        try {
            if (-not $WhatIf) {
                Set-MsolUser -UserPrincipalName $User.UserPrincipalName -BlockCredential $false
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Enabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Disable' -and $User.BlockCredential -eq $false) {
        try {
            if (-not $WhatIf) {
                Set-MsolUser -UserPrincipalName $User.UserPrincipalName -BlockCredential $true
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Disabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    }
    return $Object
}