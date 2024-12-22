Function Set-WinADUserSettingGAL {
    <#
    .SYNOPSIS
    Sets the Exchange Global Address List (GAL) visibility for a specified user.

    .DESCRIPTION
    This function allows you to hide or show a user in the Global Address List (GAL) of Exchange. 
    It updates the msExchHideFromAddressLists attribute of the user object in Active Directory.

    .PARAMETER User
    Specifies the user object for which the GAL visibility needs to be set.

    .PARAMETER Option
    Specifies whether to 'Hide' or 'Show' the user in the GAL.

    .PARAMETER WhatIf
    Displays what would happen if the command runs without actually running the command.

    .EXAMPLE
    Set-WinADUserSettingGAL -User "JohnDoe" -Option "Hide"
    Hides the user "JohnDoe" from the Global Address List.

    .EXAMPLE
    Set-WinADUserSettingGAL -User "JaneSmith" -Option "Show"
    Shows the user "JaneSmith" in the Global Address List.

    #>
    [CmdletBinding()]
    [alias("Set-ADUserSettingGAL")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
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
                        Set-ADObject -Identity $User.DistinguishedName -Replace @{msExchHideFromAddressLists = $true}
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
                        Set-ADObject -Identity $User.DistinguishedName -Clear msExchHideFromAddressLists
                    }
                    $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Unhidden in GAL.' }
                } catch {
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                }
            }
        }
    }
    return $Object
}