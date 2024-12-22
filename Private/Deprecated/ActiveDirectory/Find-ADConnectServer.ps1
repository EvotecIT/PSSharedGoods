function Find-ADConnectServer {
    <#
    .SYNOPSIS
    Finds and retrieves information about AD Connect servers based on user descriptions.

    .DESCRIPTION
    This function searches for AD Connect servers based on user descriptions containing specific patterns. It extracts server name, tenant name, installation ID, and type of account created.

    .PARAMETER Description
    Specifies the user description to search for AD Connect server information.

    .EXAMPLE
    Find-ADConnectServer -Description "Account created by John Doe on computer Server1 to tenant Contoso. This is the installation identifier 12345 running on Server1 configured."

    Retrieves information about the AD Connect server named Server1 with tenant Contoso, installation ID 12345, and account created by John Doe.

    .NOTES
    File Name      : Find-ADConnectServer.ps1
    Prerequisite   : Requires Active Directory module.
    #>
    [alias('Find-ADSyncServer')]
    param(

    )
    $Description = Get-ADUser -Filter { Name -like "MSOL*" } -Properties Description | Select-Object Description -ExpandProperty Description

    foreach ($Desc in $Description) {
        $PatternType = "(?<=(Account created by ))(.*)(?=(with installation identifier))"
        $PatternServerName = "(?<=(on computer ))(.*)(?=(configured))"
        $PatternTenantName = "(?<=(to tenant ))(.*)(?=(. This))"
        $PatternInstallationID = "(?<=(installation identifier ))(.*)(?=( running on ))"
        if ($Desc -match $PatternServerName) {
            $ServerName = ($Matches[0]).Replace("'", '').Replace(' ', '')

            if ($Desc -match $PatternTenantName) {
                $TenantName = ($Matches[0]).Replace("'", '').Replace(' ', '')
            } else {
                $TenantName = ''
            }
            if ($Desc -match $PatternInstallationID) {
                $InstallationID = ($Matches[0]).Replace("'", '').Replace(' ', '')
            } else {
                $InstallationID = ''
            }
            if ($Desc -match $PatternType) {
                $Type = ($Matches[0]).Replace("'", '').Replace('by ', '').Replace('the ', '')
            } else {
                $Type = ''
            }


            $Data = Get-ADComputer -Identity $ServerName
            [PSCustomObject] @{
                Name              = $Data.Name
                FQDN              = $Data.DNSHostName
                DistinguishedName = $Data.DistinguishedName
                Type              = $Type
                TenantName        = $TenantName
                InstallatioNID    = $InstallationID 
            }
        }
    }
}