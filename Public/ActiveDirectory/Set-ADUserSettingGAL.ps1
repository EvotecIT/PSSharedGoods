Function Set-ADUserSettingGAL {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [parameter(Mandatory = $true)][ValidateSet("Hide", "Show")][String]$Option,
        [switch] $WhatIf
    )
    $Object = @()
    if ($User) {
        if ($Option -eq 'Hide') {
            if (-not $User.msExchHideFromAddressLists) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Hiding user ', $User.DisplayName, ' in GAL (Exchange Address Lists)' -Color White, Yellow, Green, White, Yellow
                try {
                    if (-not $WhatIf) {
                        Set-ADObject -Identity $User -Replace @{msExchHideFromAddressLists = $true}
                    }
                    $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Hidden from GAL.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                }
            }
        } elseif ($Option -eq 'Show') {
            if ($User.msExchHideFromAddressLists) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Unhiding user ', $User.DisplayName, ' in GAL (Exchange Address Lists)' -Color White, Yellow, Green, White, Yellow
                try {
                    if ($WhatIf) {
                        Set-ADObject -Identity $User -Clear msExchHideFromAddressLists
                    }
                    $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Unhidden in GAL.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                }
            }
        }
    } else {

    }
    return $Object
}