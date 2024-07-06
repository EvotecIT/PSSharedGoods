function Set-WinADUserStatus {
    <#
    .SYNOPSIS
    Enables or disables a user account in Active Directory.

    .DESCRIPTION
    The Set-WinADUserStatus function enables or disables a specified user account in Active Directory based on the provided option. It also provides an option to simulate the action using the WhatIf switch.

    .PARAMETER User
    Specifies the user account to enable or disable.

    .PARAMETER Option
    Specifies whether to enable or disable the user account. Valid values are "Enable" or "Disable".

    .PARAMETER WhatIf
    Indicates that the cmdlet should display what would happen if it were to run, without actually performing any action.

    .EXAMPLE
    Set-WinADUserStatus -User $user -Option "Enable"
    Enables the user account specified by $user in Active Directory.

    .EXAMPLE
    Set-WinADUserStatus -User $user -Option "Disable" -WhatIf
    Displays what would happen if the user account specified by $user were to be disabled in Active Directory, without actually disabling it.

    #>
    [CmdletBinding()]
    [alias("Set-ADUserStatus")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $true)][ValidateSet("Enable", "Disable")][String] $Option,
        [switch] $WhatIf
        # $WriteParameters
    )
    $Object = @()
    if ($Option -eq 'Enable' -and $User.Enabled -eq $false) {
        #if (-not $WriteParameters) {
        #    Write-Color @Script:WriteParameters -Text 'Enabling user ', $User.DisplayName, ' in Active Directory.' -Color Yellow, Green, White, Yellow
        #} else {
        #    Write-Color @WriteParameters
        #}
        try {
            if (-not $WhatIf) {
                Set-ADUser -Identity $User.DistinguishedName -Enabled $true
            }
            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Enabled user.' }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
        }
    } elseif ($Option -eq 'Disable' -and $User.Enabled -eq $true) {
        #if (-not $WriteParameters) {
        #    Write-Color @Script:WriteParameters -Text 'Disabling user ', $User.DisplayName, 'in Active Directory.' -Color Yellow, Green, White, Yellow
        #} else {
        #    Write-Color @WriteParameters
        #}
        try {
            if (-not $WhatIf) {
                Set-ADUser -Identity $User.DistinguishedName -Enabled $false
            }
            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Disabled user.' }

        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
        }
    }
    return $Object
}