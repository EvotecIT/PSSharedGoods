Function Set-ADUserSettingGAL {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [parameter(Mandatory = $true)][ValidateSet("Hide", "Show")][String]$Option
    )
    if ($User) {
        if ($Option -eq 'Hide') {
            if (-not $User.msExchHideFromAddressLists) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Hiding user ', $User.DisplayName, ' in GAL (Exchange Address Lists)' -Color White, Yellow, Green, White, Yellow
                Set-ADObject -Identity $User -Replace @{msExchHideFromAddressLists = $true}
                return $true
            }
        } elseif ($Option -eq 'Show') {
            if ($User.msExchHideFromAddressLists) {
                #Write-Color @Script:WriteParameters -Text '[i]', ' Unhiding user ', $User.DisplayName, ' in GAL (Exchange Address Lists)' -Color White, Yellow, Green, White, Yellow
                Set-ADObject -Identity $User -Clear msExchHideFromAddressLists
                return $true
            }
        }
    }
    return $false
}