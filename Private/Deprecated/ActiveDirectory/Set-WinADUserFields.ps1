function Set-WinADUserFields {
    <#
    .SYNOPSIS
    Sets specified fields for an Active Directory user with additional options.

    .DESCRIPTION
    This function allows setting specified fields for an Active Directory user with the option to add text before or after the existing field value.

    .PARAMETER User
    Specifies the Active Directory user object to modify.

    .PARAMETER Option
    Specifies whether to add the text before or after the existing field value. Valid values are 'Before' and 'After'.

    .PARAMETER TextToAdd
    Specifies the text to add before or after the existing field value.

    .PARAMETER TextToRemove
    Specifies the text to remove from the existing field value.

    .PARAMETER Fields
    Specifies an array of fields to modify for the user.

    .PARAMETER WhatIf
    Indicates that the cmdlet should display what changes would occur without actually making any changes.

    .EXAMPLE
    Set-WinADUserFields -User $user -Option 'After' -TextToAdd 'New' -Fields 'Name'
    Adds the text 'New' after the existing 'Name' field value for the specified user.

    .EXAMPLE
    Set-WinADUserFields -User $user -Option 'Before' -TextToAdd 'Old' -Fields 'Description'
    Adds the text 'Old' before the existing 'Description' field value for the specified user.
    #>
    [CmdletBinding()]
    [alias("Set-ADUserName")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [parameter(Mandatory = $false)][ValidateSet("Before", "After")][String] $Option,
        [string] $TextToAdd,
        [string] $TextToRemove,
        [string[]] $Fields,
        [switch] $WhatIf
    )
    $Object = @()
    if ($TextToAdd) {
        foreach ($Field in $Fields) {
            if ($User.$Field -notlike "*$TextToAdd*") {

                if ($Option -eq 'After') {
                    $NewName = "$($User.$Field)$TextToAdd"
                } elseif ($Option -eq 'Before') {
                    $NewName = "$TextToAdd$($User."$Field")"
                }
                if ($NewName -ne $User.$Field) {
                    if ($Field -eq 'Name') {
                        try {
                            if (-not $WhatIf) {
                                Rename-ADObject -Identity $User.DistinguishedName -NewName $NewName #-WhatIf
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed account '$Field' to '$NewName'" }

                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                        }
                    } else {
                        $Splat = @{
                            Identity = $User.DistinguishedName
                            "$Field" = $NewName
                        }
                        try {
                            if (-not $WhatIf) {
                                Set-ADUser @Splat
                            }
                            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed field '$Field' to '$NewName'" }

                        } catch {
                            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
                        }
                    }


                }

            }
        }
    }
    if ($TextToRemove) {
        foreach ($Field in $Fields) {
            if ($User.$Field -like "*$TextToRemove*") {
                $NewName = $($User.$Field).Replace($TextToRemove, '')
                if ($Field -eq 'Name') {
                    try {
                        if (-not $WhatIf) {
                            Rename-ADObject -Identity $User.DistinguishedName -NewName $NewName #-WhatIf
                        }
                        $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed account '$Field' to '$NewName'" }

                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = "Field: '$Field' Error: '$ErrorMessage'" }
                    }
                } else {
                    $Splat = @{
                        Identity = $User.DistinguishedName
                        "$Field" = $NewName
                    }
                    try {
                        if (-not $WhatIf) {
                            Set-ADUser @Splat #-WhatIf
                        }
                        $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed field $Field to $NewName" }

                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = "Field: $Field Error: $ErrorMessage" }
                    }
                }
            }
        }

    }
    return $Object
}