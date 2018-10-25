function Get-WinADUserSnapshot {
    [CmdletBinding()]
    [alias("Get-ADUserSnapshot")]
    param (
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [string] $XmlPath,
        [switch] $WhatIf
    )
    $Object = @()
    try {
        $FullData = Get-ADUser -Identity $User -Properties *
        if (($XmlPath) -and (Test-Path $XmlPath)) {
            $FullPath = [IO.Path]::Combine($XmlPath, "$($User.SamAccountName).xml") #
            if (-not $WhatIf) {
                $FullData | Export-Clixml -Path $FullPath -ErrorAction Stop
            }
            $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = "Saved to $FullPath" }

        } else {
            $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = 'XmlPath Incorrect' }
        }
    } catch {
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
    }
    return $Object
}