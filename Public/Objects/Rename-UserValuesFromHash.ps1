function Rename-UserValuesFromHash {
    <#
    .SYNOPSIS
    This function renames user values based on a hash table of match data.

    .DESCRIPTION
    The Rename-UserValuesFromHash function takes a list of users, a hash table of match data, and an array of field types. It then renames specific values in the user objects based on the match data provided.

    .PARAMETER Users
    The list of user objects to be processed.

    .PARAMETER MatchData
    A hash table containing the match data used for renaming values.

    .PARAMETER FieldTypes
    An array of field types to be considered for renaming.

    .EXAMPLE
    $users = @(
        [PSCustomObject]@{ UserPrincipalName = 'user1@test.com'; License = 'test:license'; ProxyAddress = 'proxy@test.com' }
        [PSCustomObject]@{ UserPrincipalName = 'user2@test.com'; License = 'test:license'; ProxyAddress = 'proxy@test.com' }
    )
    $matchData = @{
        'test.com' = 'newdomain.com'
        'test:' = 'newdomain:'
    }
    $fieldTypes = @('UserPrincipalName', 'License')
    Rename-UserValuesFromHash -Users $users -MatchData $matchData -FieldTypes $fieldTypes

    #>
    [CmdletBinding()]
    param(
        $Users,
        $MatchData,
        $FieldTypes
    )
    <#
    foreach ($User in $DataFinland) {
        $User.UserPrincipalName = $($User.UserPrincipalName).ToLower().Replace('@test.com', '@newdomain.com')
        $User.License = $($User.License).ToLower().Replace('test:', 'newdomain:')
        $User.ProxyAddress = $(($User.ProxyAddress).ToLower()).Replace('@test.com', '@newdomain.com').Replace('@test.onmicrosoft.com', '@newdomain.onmicrosoft.com')
    }
    #>
    Write-Verbose "FieldTypes: $($FieldTypes -join ',')"
    foreach ($User in $Users) {
        foreach ($Match in $MatchData.Keys) {
            $Key = $Match
            $Value = $MatchData.$Match
            Write-Verbose "User: $($User.UserPrincipalName) Key: $Key Value: $Value"
            foreach ($Field in $FieldTypes) {
                if ($User.$Field) {
                    $User.$Field = $($User.$Field).ToLower().Replace($Key, $Value)
                }
            }
        }
    }
    return $Users
}