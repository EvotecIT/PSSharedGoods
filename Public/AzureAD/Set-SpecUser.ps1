function Set-SpecUser {
    [CmdletBinding()]
    param(
        $User,
        $UsersAzure
    )
    $UserAzure = $UsersAzure | where { $_.UserPrincipalName -eq $User.UserPrincipalName }
    if ($UserAzure) {
        Write-Color "Set-SpecUser - Processing user ", $User.DisplayName, ' - ObjectID: ', $($UserAzure.ObjectID), ' user password ', $User.Password  -Color White, Yellow

        $Password = $User.Password | ConvertTo-SecureString -AsPlainText -Force
        Set-AzureADUserPassword -ObjectId $UserAzure.ObjectID -Password $Password
    } else {
        Write-Color "Set-SpecUser - Skipping user ", $User.DisplayName, ' - ObjectID: ', $($UserAzure.ObjectID), ' user password ', $User.Password  -Color White, Yellow
    }
}