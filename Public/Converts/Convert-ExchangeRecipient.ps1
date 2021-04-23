
function Convert-ExchangeRecipient {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER RecipientTypeDetails
    Parameter description

    .PARAMETER RecipientType
    Parameter description

    .PARAMETER RemoteRecipientType
    Parameter description

    .EXAMPLE
    $Users = Get-ADUser -Filter * -Properties Mail, ProxyAddresses, msExchRemoteRecipientType, msExchRecipientDisplayType, msExchRecipientTypeDetails, MailNickName
    $UsersModified = foreach ($User in $Users) {
        [PSCUstomObject] @{
            Name                       = $User.Name
            Mail                       = $User.Mail
            MailNickName               = $User.MailNickName
            msExchRemoteRecipientType  = Convert-ExchangeRecipient -msExchRemoteRecipientType $User.msExchRemoteRecipientType
            msExchRecipientDisplayType = Convert-ExchangeRecipient -msExchRecipientDisplayType $User.msExchRecipientDisplayType
            msExchRecipientTypeDetails = Convert-ExchangeRecipient -msExchRecipientTypeDetails $User.msExchRecipientTypeDetails
            ProxyAddresses             = Convert-ExchangeEmail -AddSeparator -RemovePrefix -RemoveDuplicates -Separator ',' -Emails $User.ProxyAddresses
        }
    }
    $UsersModified | Out-HtmlView -Filtering -ScrollX

    .NOTES
    General notes
    #>
    [cmdletbinding(DefaultParameterSetName = 'msExchRecipientTypeDetails')]
    param(
        [parameter(ParameterSetName = 'msExchRecipientTypeDetails')][alias('msExchRecipientTypeDetails')][string] $RecipientTypeDetails,
        [parameter(ParameterSetName = 'msExchRecipientDisplayType')][alias('msExchRecipientDisplayType')][string] $RecipientType,
        [parameter(ParameterSetName = 'msExchRemoteRecipientType')][alias('msExchRemoteRecipientType')][string] $RemoteRecipientType
    )

    if ($RecipientTypeDetails) {
        $msExchRecipientTypeDetails = [ordered] @{
            # RecipientTypeDetails
            '1'           = 'UserMailbox'
            '2'           = 'LinkedMailbox'
            '4'           = 'SharedMailbox'
            '16'          = 'RoomMailbox'
            '32'          = 'EquipmentMailbox'
            '128'         = 'MailUser'
            '2147483648'  = 'RemoteUserMailbox'
            '8589934592'  = 'RemoteRoomMailbox'
            '17179869184'	= 'RemoteEquipmentMailbox'
            '34359738368'	= 'RemoteSharedMailbox'
        }
        $msExchRecipientTypeDetails[$RecipientTypeDetails]
    } elseif ($RecipientType) {
        $msExchRecipientDisplayType = [ordered] @{
            # RecipientType
            '-2147483642' = 'MailUser (RemoteUserMailbox)'
            '-2147481850' = 'MailUser (RemoteRoomMailbox)'
            '-2147481594' = 'MailUser (RemoteEquipmentMailbox)'
            '0'           = 'UserMailbox (shared)'
            '1'           = 'MailUniversalDistributionGroup'
            '6'           = 'MailContact'
            '7'           = 'UserMailbox (room)'
            '8'           = 'UserMailbox (equipment)'
            '1073741824'  = 'UserMailbox'
            '1073741833'  = 'MailUniversalSecurityGroup'
        }
        $msExchRecipientDisplayType[$RecipientType]
    } elseif ($RemoteRecipientType) {
        $msExchRemoteRecipientType = [ordered] @{
            # RemoteRecipientType
            '1'   = 'ProvisionMailbox'
            '2'   = 'ProvisionArchive (On-Prem Mailbox)'
            '3'   = 'ProvisionMailbox, ProvisionArchive'
            '4'   = 'Migrated (UserMailbox)'
            '6'   = 'ProvisionArchive, Migrated'
            '8'   = 'DeprovisionMailbox'
            '10'  = 'ProvisionArchive, DeprovisionMailbox'
            '16'  = 'DeprovisionArchive (On-Prem Mailbox)'
            '17'  = 'ProvisionMailbox, DeprovisionArchive'
            '20'  = 'Migrated, DeprovisionArchive'
            '24'  = 'DeprovisionMailbox, DeprovisionArchive'
            '33'  = 'ProvisionMailbox, RoomMailbox'
            '35'  = 'ProvisionMailbox, ProvisionArchive, RoomMailbox'
            '36'  = 'Migrated, RoomMailbox'
            '38'  = 'ProvisionArchive, Migrated, RoomMailbox'
            '49'  = 'ProvisionMailbox, DeprovisionArchive, RoomMailbox'
            '52'  = 'Migrated, DeprovisionArchive, RoomMailbox'
            '65'  = 'ProvisionMailbox, EquipmentMailbox'
            '67'  = 'ProvisionMailbox, ProvisionArchive, EquipmentMailbox'
            '68'  = 'Migrated, EquipmentMailbox'
            '70'  = 'ProvisionArchive, Migrated, EquipmentMailbox'
            '81'  = 'ProvisionMailbox, DeprovisionArchive, EquipmentMailbox'
            '84'  = 'Migrated, DeprovisionArchive, EquipmentMailbox'
            '100'	= 'Migrated, SharedMailbox'
            '102'	= 'ProvisionArchive, Migrated, SharedMailbox'
            '116'	= 'Migrated, DeprovisionArchive, SharedMailbox'
        }
        $msExchRemoteRecipientType[$RemoteRecipientType]
    }
}