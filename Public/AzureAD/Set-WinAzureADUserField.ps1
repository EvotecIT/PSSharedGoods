function Set-WinAzureADUserField {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $false)][Object] $Value,
        [switch] $WhatIf
    )

    $Splat = @{}
    $Splat.UserPrincipalName = $User.UserPrincipalName
    $Splat.ErrorAction = 'Stop'
    if ($Value) {
        $Field = "$($Value.Field)"
        if ($Field -eq 'UserPrincipalName') {
            # if UserPrincipalName it means user wants to rename UserPrincipalName
            # that requires different method
            $Field = 'NewUserPrincipalName'
        }
        $Data = $Value.Value
        $Splat.$Field = $Data
    }

    $Object = @()
    if ($User.$Field -ne $Data) {
        try {
            if (-not $WhatIf) {
                if ($Field -eq 'UserPrincipalName') {
                    Set-MsolUserPrincipalName @Splat
                } else {
                    Set-MsolUser @Splat
                }
            }

            $Object += @{ Status = $true; Output = $User.UserPrincipalName; Extended = "Set $Field to $Data" }
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " " -Replace '  ',' '
            $Object += @{ Status = $false; Output = $User.UserPrincipalName; Extended = $ErrorMessage }
        }
    }
    return $Object
}