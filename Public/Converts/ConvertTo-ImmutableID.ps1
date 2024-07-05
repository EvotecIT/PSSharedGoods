function ConvertTo-ImmutableID {
    <#
    .SYNOPSIS
    Converts an Active Directory user's ObjectGUID to an ImmutableID.

    .DESCRIPTION
    This function takes an Active Directory user object or a GUID as input and converts the ObjectGUID to an ImmutableID, which is commonly used in Azure AD.

    .PARAMETER User
    Specifies the Active Directory user object to convert. This parameter is mutually exclusive with the 'ObjectGUID' parameter.

    .PARAMETER ObjectGUID
    Specifies the GUID to convert to ImmutableID. This parameter is mutually exclusive with the 'User' parameter.

    .EXAMPLE
    ConvertTo-ImmutableID -User $ADUser
    Converts the ObjectGUID of the specified Active Directory user to an ImmutableID.

    .EXAMPLE
    ConvertTo-ImmutableID -ObjectGUID "12345678-1234-1234-1234-1234567890AB"
    Converts the specified GUID to an ImmutableID.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = 'User')]
        [alias('ADuser')]
        [Microsoft.ActiveDirectory.Management.ADAccount] $User,

        [Parameter(Mandatory = $false, ParameterSetName = 'Guid')]
        [alias('GUID')]
        [string] $ObjectGUID
    )
    if ($User) {
        if ($User.ObjectGUID) {
            $ObjectGUID = $User.ObjectGuid
        }
    }
    if ($ObjectGUID) {
        $ImmutableID = [System.Convert]::ToBase64String(($User.ObjectGUID).ToByteArray())
        return $ImmutableID
    }
    return
}