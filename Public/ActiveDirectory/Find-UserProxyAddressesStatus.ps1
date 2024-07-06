# not sure why I have it, or where it's used. Need to find out
function Find-UsersProxyAddressesStatus {
    <#
    .SYNOPSIS
    This function checks the status of user proxy addresses.

    .DESCRIPTION
    The function takes a user object as input and determines the status of their proxy addresses. It checks if the user has any proxy addresses, if the primary proxy address is missing, if there are multiple primary proxy addresses, or if all proxy addresses are correctly set up.

    .PARAMETER User
    Specifies the user object for which the proxy addresses status needs to be checked.

    .EXAMPLE
    Find-UsersProxyAddressesStatus -User $user
    Checks the proxy addresses status for the specified user object.

    .NOTES
    File Name      : Find-UserProxyAddressesStatus.ps1
    Prerequisite   : This function requires a valid user object with proxy addresses.
    #>
    param(
        $User
    )
    $status = 'No proxy'
    if ($null -ne $user.proxyAddresses) {
        $count = 0
        foreach ($proxy in $($user.ProxyAddresses)) {
            if ($proxy.SubString(0, 4) -ceq 'SMTP') { $count++ }
        }
        if ($count -eq 0) {
            $status = 'Missing primary proxy'
        } elseif ($count -gt 1) {
            $status = 'Multiple primary proxy'
        } else {
            $status = 'All OK'
        }
    } else {
        $status = 'Missing all proxy'
    }
    return $status
}