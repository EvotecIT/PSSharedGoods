function Get-WinADUsersByDN {
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