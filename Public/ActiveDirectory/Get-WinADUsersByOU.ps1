function Get-WinADUsersByOU {
    [CmdletBinding()]
    param (
        $OrganizationalUnit
    )
    $OU = Get-ADOrganizationalUnit $OrganizationalUnit
    if ($OU.ObjectClass -eq 'OrganizationalUnit') {
        try {
            $Users = Get-ADUser -SearchBase $OU -Filter * -Properties $Script:UserProperties
        } catch {
            Write-Color @Script:WriteParameters -Text '[i]', ' One or more properties are invalid - Terminating', ' Terminating' -Color Yellow, White, Red
            return
        }
    }
    return $Users
}