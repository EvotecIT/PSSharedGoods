function Set-WinAzureADUserLicense {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Microsoft.Online.Administration.User] $User,
        [parameter(Mandatory = $true)][ValidateSet("Add", "Remove")][String] $Option,
        [parameter(Mandatory = $true)][string] $License,
        [switch] $WhatIf
    )
    $Object = @()
    if ($Option -eq 'Add' -and $User.Enabled -eq $false) {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Added license to user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Remove' -and $User.Enabled -eq $true) {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = 'Removed license from user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    }
    return $Object
}