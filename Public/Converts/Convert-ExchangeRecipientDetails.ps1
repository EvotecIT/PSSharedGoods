function Convert-ExchangeRecipientDetails {
    [cmdletbinding()]
    param(
        [string] $RecipientType,
        [switch] $FromKey
    ) 
    $RecipientTypeDetails = @{
        UserMailbox            = 1
        LinkedMailbox          = 2
        SharedMailbox          = 4 
        RoomMailbox            = 16
        EquipmentMailbox       = 32
        MailUser               = 128
        RemoteUserMailbox      = 2147483648
        RemoteRoomMailbox      = 8589934592
        RemoteEquipmentMailbox = 17179869184
        RemoteSharedMailbox    = 34359738368
    }

    $RecipientTypeDetails.GetEnumerator() | Where-Object { $_.Value -eq $RecipientType }
}