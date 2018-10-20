function Rename-UserValuesFromHash {
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