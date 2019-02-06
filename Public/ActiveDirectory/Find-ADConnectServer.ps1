function Find-ADConnectServer {
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