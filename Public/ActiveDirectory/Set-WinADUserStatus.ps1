function Set-WinADUserStatus {
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