function Set-WinADUserFields {
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