function Set-ADUserName {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [parameter(Mandatory = $false)][ValidateSet("Before", "After")][String] $Option,
        [string] $TextToAdd,
        [string] $TextToRemove,
        [string[]] $Fields
    )
    $Object = @()
    if ($TextToAdd -and $User.DisplayName -notlike "*$TextToAdd*") {
        if ($Option -eq 'After') {
            $NewName = "$($User.DisplayName)$TextToAdd"
        } elseif ($Option -eq 'Before') {
            $NewName = "$TextToAdd$($User.DisplayName)"
        }
        if ($NewName -ne $User.DisplayName) {
            #Write-Color @Script:WriteParameters -Text '[i]', ' Renaming user by adding text "', $TextToAdd, '". Name will be added ', $Option, ' Display Name ', $User.DisplayName, '. New expected name: ', $NewName -Color White, Yellow, Green, White, Yellow, White, Yellow, White
            try {
                Set-ADUser -Identity $User -DisplayName $NewName #-WhatIf
                Rename-ADObject -Identity $User -NewName $NewName #-WhatIf
                $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Renamed user.' }
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
            }
        }
    }
    if ($TextToRemove) {
        foreach ($Field in $Fields) {
            if ($User."$Field" -like "*$TextToRemove*") {
                $NewName = $($User."$Field").Replace($TextToRemove, '')
                if ($Field -eq 'Name') {
                    try {
                        Rename-ADObject -Identity $User -NewName $NewName #-WhatIf
                        $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed account (Name) for user." }
                    } catch {
                        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                        $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = "Field: $Field Error: $ErrorMessage" }
                    }
                } else {
                    $Splat = @{
                        Identity = $User
                        "$Field" = $NewName
                    }
                    try {
                        Set-ADUser @Splat #-WhatIf
                        $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Renamed field $Field for user." }
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