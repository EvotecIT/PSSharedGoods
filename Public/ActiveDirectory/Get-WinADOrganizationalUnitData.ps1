function Get-WinADOrganizationalUnitData {
    <#
    .SYNOPSIS
    Retrieves detailed information about Active Directory Organizational Units.

    .DESCRIPTION
    This function retrieves detailed information about the specified Active Directory Organizational Units, including properties like CanonicalName, City, Country, Description, and more.

    .PARAMETER OrganizationalUnit
    Specifies the Organizational Units to retrieve information for.

    .EXAMPLE
    Get-WinADOrganizationalUnitData -OrganizationalUnit 'OU=Users-O365,OU=Production,DC=ad,DC=evotec,DC=xyz'
    Retrieves information for the specified Organizational Unit 'Users-O365' under 'Production' in the Active Directory domain 'ad.evotec.xyz'.

    .NOTES
    Output of function:
        CanonicalName                   : ad.evotec.xyz/Production/Users-O365
        City                            :
        CN                              :
        Country                         : PL
        Created                         : 09.11.2018 17:38:32
        Description                     : OU for Synchronization of Users to Office 365
        DisplayName                     :
        DistinguishedName               : OU=Users-O365,OU=Production,DC=ad,DC=evotec,DC=xyz
        LinkedGroupPolicyObjects        : {cn={74D09C6F-35E9-4743-BCF7-F87D7010C60D},cn=policies,cn=system,DC=ad,DC=evotec,DC=xyz}
        ManagedBy                       :
        Modified                        : 19.11.2018 22:54:47
        Name                            : Users-O365
        PostalCode                      :
        ProtectedFromAccidentalDeletion : True
        State                           :
        StreetAddress                   :

    #>
    [CmdletBinding()]
    param(
        [string[]] $OrganizationalUnit
    )
    $Output = foreach ($OU in $OrganizationalUnit) {
        $Data = Get-ADOrganizationalUnit -Identity $OU -Properties CanonicalName, City, CN, Country, Created, Description, DisplayName, DistinguishedName, ManagedBy, Modified, Name, OU, PostalCode, ProtectedFromAccidentalDeletion, State, StreetAddress

        [PsCustomobject][Ordered] @{
            CanonicalName                   = $Data.CanonicalName
            City                            = $Data.City
            CN                              = $Data.CN
            Country                         = $Data.Country
            Created                         = $Data.Created
            Description                     = $Data.Description
            DisplayName                     = $Data.DisplayName
            DistinguishedName               = $Data.DistinguishedName
            LinkedGroupPolicyObjects        = $Data.LinkedGroupPolicyObjects
            ManagedBy                       = Get-WinADUsersByDN -DistinguishedName $U.ManagedBy
            Modified                        = $Data.Modified
            Name                            = $Data.Name
            PostalCode                      = $Data.PostalCode
            ProtectedFromAccidentalDeletion = $Data.ProtectedFromAccidentalDeletion
            State                           = $Data.State
            StreetAddress                   = $Data.StreetAddress
        }
    }
    return $Output
}