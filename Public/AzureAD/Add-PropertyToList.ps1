function Add-PropertyToList {
    param(
        $List,
        [ValidateSet("Password", "MailNickName")][string] $PropertyName
    )
    foreach ($Object in $List) {
        if ($PropertyName -eq 'Password') {
            $PropertyValue = Get-RandomPassword
            $Object | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue -Force
        }
        if ($PropertyName -eq 'MailNickName') {
            $PropertyValue = ($Object.UserPrincipalName).Split('@')[0]
            #$PropertyValue = $Split[0]
            $Object | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue -Force
        }
    }
    return $List
}