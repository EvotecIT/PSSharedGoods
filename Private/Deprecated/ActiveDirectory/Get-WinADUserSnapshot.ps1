function Get-WinADUserSnapshot {
    <#
    .SYNOPSIS
    Retrieves a snapshot of Active Directory user information and saves it to an XML file.

    .DESCRIPTION
    The Get-WinADUserSnapshot function retrieves detailed information about an Active Directory user and saves it to an XML file specified by the XmlPath parameter.

    .PARAMETER User
    Specifies the Active Directory user object for which to retrieve the snapshot.

    .PARAMETER XmlPath
    Specifies the path where the XML snapshot file will be saved.

    .PARAMETER WhatIf
    Indicates whether the operation should only be simulated without actually saving the snapshot.

    .EXAMPLE
    Get-WinADUserSnapshot -User $userObject -XmlPath "C:\Snapshots" -WhatIf
    Retrieves a snapshot of the user object and simulates saving it to the specified path.

    .EXAMPLE
    Get-WinADUserSnapshot -User $userObject -XmlPath "C:\Snapshots"
    Retrieves a snapshot of the user object and saves it to the specified path.

    #>
    [CmdletBinding()]
    [alias("Get-ADUserSnapshot")]
    param (
        [parameter(Mandatory = $true)][Object] $User,
        [string] $XmlPath,
        [switch] $WhatIf
    )
    $Object = @()
    try {
        $FullData = Get-ADUser -Identity $User.DistinguishedName -Properties *
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