function Get-WinADUsersByOU {
    <#
    .SYNOPSIS
    Retrieves Active Directory users within a specified Organizational Unit.

    .DESCRIPTION
    This function retrieves Active Directory users within the specified Organizational Unit.
    
    .PARAMETER OrganizationalUnit
    Specifies the Organizational Unit from which to retrieve users.

    .EXAMPLE
    Get-WinADUsersByOU -OrganizationalUnit "OU=Sales,DC=Contoso,DC=com"
    Retrieves all users within the Sales Organizational Unit in the Contoso domain.

    #>
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