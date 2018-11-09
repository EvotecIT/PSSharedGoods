function ConvertTo-ImmutableID {
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