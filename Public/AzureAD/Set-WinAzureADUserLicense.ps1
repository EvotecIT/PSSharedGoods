function Set-WinAzureADUserLicense {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Add", "Remove", "RemoveAll", "Replace")][String] $Option,
        [parameter(Mandatory = $false)][string] $License,
        [parameter(Mandatory = $false)][string] $LicenseToReplace,
        [switch] $WhatIf
    )
    $Object = @()
    if ($Option -eq 'Add') {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Added license $License to user." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Remove') {
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $License from user." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'RemoveAll') {
        try {
            foreach ($License in $User.Licenses.AccountSKUID) {
                if (-not $WhatIf) {
                    Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
                }
                $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $License from user." }
            }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Replace') {
        [bool] $Success = $true
        try {
            if (-not $WhatIf) {
                Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License
            }
            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Added license $License to user before removing $LicenseToReplace." }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
            $Success = $false
        }
        if ($Success) {
            try {
                if (-not $WhatIf) {
                    Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses $License -ErrorAction Stop
                }
                $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Removed license $LicenseToReplace from user." }
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
            }
        }
    }
    return $Object
}