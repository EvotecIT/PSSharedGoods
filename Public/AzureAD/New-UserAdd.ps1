function New-UserAdd {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        $Users
    )

    $Success = @()
    $Failed = @()
    $Output = @()
    foreach ($User in $Users) {
        #New-MsolUser -UserPrincipalName $User.UserPrincipalName -FirstName $User.FirstName -LastName $User.LastName -DisplayName $User.DisplayName -UsageLocation $User.CountryCode -Country $User.Country -City $User.City -WhatIf
        $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
        $PasswordProfile.Password = $User.Password
        $PasswordProfile.EnforceChangePasswordPolicy = $false
        $PasswordProfile.ForceChangePasswordNextLogin = $false


        try {
            if ($pscmdlet.ShouldProcess("$($User.DisplayName)", "New-UserAdd")) {
                Write-Color "New-AzureADUser - Processing new user ", $User.DisplayName -Color White, Yellow
                if ($User.MailNickName) {

                    if ($User.FirstName -eq $null -or $User.FirstName.Trim() -eq '') {
                        $User.FirstName = 'Not set'
                    }
                    if ($User.LastName -eq $null -or $User.LastName.Trim() -eq '') {
                        $User.LastName = 'Not set'
                    }
                    $Output += New-AzureADUser -UserPrincipalName $User.UserPrincipalName `
                        -GivenName ([string] $User.FirstName) `
                        -Surname ([string] $User.LastName) `
                        -DisplayName ([string] $User.DisplayName) `
                        -UsageLocation ([string] $User.CountryCode) `
                        -Country ([string] $User.Country) `
                        -City ([string] $User.City) `
                        -PasswordProfile $PasswordProfile `
                        -AccountEnabled $true `
                        -MailNickName ([string] $User.MailNickName) `
                        -ErrorAction Stop

                    $Success += $User
                } else {
                    $Failed += $User
                }
            } else {
                # pretends WhatIf all success
                $Success += $User
            }
        } catch {
            $Failed += $User
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            Write-Warning "New-AzureADUser - Failed with error message: $ErrorMessage"
        }
    }
    $Data = @{}
    $Data.Failed = $Failed
    $Data.Success = $Success
    return $Data
}