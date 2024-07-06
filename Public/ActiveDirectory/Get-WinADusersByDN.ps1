function Get-WinADUsersByDN {
    <#
    .SYNOPSIS
    Retrieves Active Directory user information based on the provided DistinguishedName(s).

    .DESCRIPTION
    This function retrieves Active Directory user information based on the provided DistinguishedName(s). It returns specific user properties for the given DistinguishedName(s).

    .PARAMETER DistinguishedName
    Specifies the DistinguishedName(s) of the user(s) to retrieve information for.

    .PARAMETER Field
    Specifies the specific field to return for each user. Default value is 'DisplayName'.

    .PARAMETER All
    Indicates whether to return all properties of the user(s).

    .EXAMPLE
    Get-WinADUsersByDN -DistinguishedName "CN=John Doe,OU=Users,DC=contoso,DC=com"
    Retrieves the DisplayName of the user with the specified DistinguishedName.

    .EXAMPLE
    Get-WinADUsersByDN -DistinguishedName "CN=Jane Smith,OU=Users,DC=contoso,DC=com" -Field "EmailAddress"
    Retrieves the EmailAddress of the user with the specified DistinguishedName.

    .EXAMPLE
    Get-WinADUsersByDN -DistinguishedName "CN=Admin,OU=Users,DC=contoso,DC=com" -All
    Retrieves all properties of the user with the specified DistinguishedName.

    #>
    param(
        [alias('DN')][string[]]$DistinguishedName,
        [string] $Field = 'DisplayName', # return field
        [switch] $All
    )
    $Properties = 'DistinguishedName', 'Enabled', 'GivenName', 'Name', 'SamAccountName', 'SID', 'Surname', 'UserPrincipalName', 'EmailAddress', 'DisplayName'

    $Users = foreach ($DN in $DistinguishedName) {
        try {
            get-aduser -Identity $DN -Properties $Properties
        } catch {
            # returns empty, basically ignores stuff
        }
    }

    if ($All) {
        return $Users #.PSObject.Properties.Name
    } else {
        return $Users.$Field
    }
}