
function Convert-ExchangeRecipient {
    <#
    .SYNOPSIS
    Convert msExchRemoteRecipientType, msExchRecipientDisplayType, msExchRecipientTypeDetails to their respective name

    .DESCRIPTION
    Convert msExchRemoteRecipientType, msExchRecipientDisplayType, msExchRecipientTypeDetails to their respective name

    .PARAMETER RecipientTypeDetails
    RecipientTypeDetails to convert

    .PARAMETER RecipientType
    RecipientType to convert

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

    .EXAMPLE
    Convert-ExchangeRecipient -msExchRemoteRecipientType 17
    Convert-ExchangeRecipient -msExchRecipientDisplayType 17
    Convert-ExchangeRecipient -msExchRecipientTypeDetails 17

    .NOTES
    Based on:
    - https://granikos.eu/exchange-recipient-type-values/
    - https://answers.microsoft.com/en-us/msoffice/forum/all/recipient-type-values/7c2620e5-9870-48ba-b5c2-7772c739c651
    - https://www.undocumented-features.com/2020/05/06/every-last-msexchrecipientdisplaytype-and-msexchrecipienttypedetails-value/
    #>
    [alias('Convert-ExchangeRecipientDetails')]
    [cmdletbinding(DefaultParameterSetName = 'msExchRecipientTypeDetails')]
    param(
        [parameter(ParameterSetName = 'msExchRecipientTypeDetails')][alias('RecipientTypeDetails')][string] $msExchRecipientTypeDetails,
        [parameter(ParameterSetName = 'msExchRecipientDisplayType')][alias('RecipientType')][string] $msExchRecipientDisplayType,
        [parameter(ParameterSetName = 'msExchRemoteRecipientType')][alias('RemoteRecipientType')][string] $msExchRemoteRecipientType,

        [parameter(ParameterSetName = 'msExchRecipientTypeDetails')]
        [parameter(ParameterSetName = 'msExchRecipientDisplayType')]
        [parameter(ParameterSetName = 'msExchRemoteRecipientType')]
        [switch] $All
    )

    if ($PSBoundParameters.ContainsKey('msExchRecipientTypeDetails')) {
        $ListMsExchRecipientTypeDetails = [ordered] @{
            '0'               = 'None'
            '1'               = 'UserMailbox'
            '2'               = 'LinkedMailbox'
            '4'               = 'SharedMailbox'
            '8'               = 'LegacyMailbox'
            '16'              = 'RoomMailbox'
            '32'              = 'EquipmentMailbox'
            '64'              = 'MailContact'
            '128'             = 'MailUser'
            '256'             = 'MailUniversalDistributionGroup'
            '512'             = 'MailNonUniversalGroup'
            '1024'            = 'MailUniversalSecurityGroup'
            '2048'            = 'DynamicDistributionGroup'
            '4096'            = 'PublicFolder'
            '8192'            = 'SystemAttendantMailbox'
            '16384'           = 'SystemMailbox'
            '32768'           = 'MailForestContact'
            '65536'           = 'User'
            '131072'          = 'Contact'
            '262144'          = 'UniversalDistributionGroup'
            '524288'          = 'UniversalSecurityGroup'
            '1048576'         = 'NonUniversalGroup'
            '2097152'         = 'Disable User'
            '4194304'         = 'MicrosoftExchange'
            '8388608'         = 'ArbitrationMailbox'
            '16777216'        = 'MailboxPlan'
            '33554432'        = 'LinkedUser'
            '268435456'       = 'RoomList'
            '536870912'       = 'DiscoveryMailbox'
            '1073741824'      = 'RoleGroup'
            '2147483648'      = 'RemoteUserMailbox'
            '4294967296'      = 'Computer'
            '8589934592'      = 'RemoteRoomMailbox'
            '17179869184'     = 'RemoteEquipmentMailbox'
            '34359738368'     = 'RemoteSharedMailbox'
            '68719476736'     = 'PublicFolderMailbox'
            '137438953472'    = 'Team Mailbox'
            '274877906944'    = 'RemoteTeamMailbox'
            '549755813888'    = 'MonitoringMailbox'
            '1099511627776'   = 'GroupMailbox'
            '2199023255552'   = 'LinkedRoomMailbox'
            '4398046511104'   = 'AuditLogMailbox'
            '8796093022208'   = 'RemoteGroupMailbox'
            '17592186044416'  = 'SchedulingMailbox'
            '35184372088832'  = 'GuestMailUser'
            '70368744177664'  = 'AuxAuditLogMailbox'
            '140737488355328' = 'SupervisoryReviewPolicyMailbox'
        }
        if ($All) {
            $ListMsExchRecipientTypeDetails
        } else {
            if ($null -ne $ListMsExchRecipientTypeDetails[$msExchRecipientTypeDetails]) {
                $ListMsExchRecipientTypeDetails[$msExchRecipientTypeDetails]
            } else {
                $msExchRecipientTypeDetails
            }
        }
    } elseif ($PSBoundParameters.ContainsKey('msExchRecipientDisplayType')) {
        $ListMsExchRecipientDisplayType = [ordered] @{
            '0'           = 'MailboxUser'
            '1'           = 'DistributionGroup'
            '2'           = 'PublicFolder'
            '3'           = 'DynamicDistributionGroup'
            '4'           = 'Organization'
            '5'           = 'PrivateDistributionList'
            '6'           = 'RemoteMailUser'
            '7'           = 'ConferenceRoomMailbox'
            '8'           = 'EquipmentMailbox'
            '10'          = 'ArbitrationMailbox'
            '11'          = 'MailboxPlan'
            '12'          = 'LinkedUser'
            '15'          = 'RoomList'
            '17'          = 'Microsoft365Group' # AT LEAST IT SEEMS SO
            '-2147483642' = 'SyncedMailboxUser'
            '-2147483391' = 'SyncedUDGasUDG'
            '-2147483386' = 'SyncedUDGasContact'
            '-2147483130' = 'SyncedPublicFolder'
            '-2147482874' = 'SyncedDynamicDistributionGroup'
            '-2147482106' = 'SyncedRemoteMailUser'
            '-2147481850' = 'SyncedConferenceRoomMailbox'
            '-2147481594' = 'SyncedEquipmentMailbox'
            '-2147481343' = 'SyncedUSGasUDG'
            '-2147481338' = 'SyncedUSGasContact'
            '-1073741818' = 'ACLableSyncedMailboxUser'
            '-1073740282' = 'ACLableSyncedRemoteMailUser'
            '-1073739514' = 'ACLableSyncedUSGasContact'
            '-1073739511' = 'SyncedUSGasUSG'
            '1043741833'  = 'SecurityDistributionGroup'
            '1073739511'  = 'SyncedUSGasUSG'
            '1073739514'  = 'ACLableSyncedUSGasContact'
            '1073741824'  = 'ACLableMailboxUser' # 'RBAC Role Group'
            '1073741830'  = 'ACLableRemoteMailUser'
        }
        if ($All) {
            $ListMsExchRecipientDisplayType
        } else {
            if ($null -ne $ListMsExchRecipientDisplayType[$msExchRecipientDisplayType]) {
                $ListMsExchRecipientDisplayType[$msExchRecipientDisplayType]
            } else {
                $msExchRecipientDisplayType
            }
        }
    } elseif ($PSBoundParameters.ContainsKey('msExchRemoteRecipientType')) {
        $ListMsExchRemoteRecipientType = [ordered] @{
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
        if ($All) {
            $ListMsExchRemoteRecipientType
        } else {
            if ($null -ne $ListMsExchRemoteRecipientType[$msExchRemoteRecipientType]) {
                $ListMsExchRemoteRecipientType[$msExchRemoteRecipientType]
            } else {
                $msExchRemoteRecipientType
            }
        }
    }
}

# Add-Type @'
#     using System;
#     [Flags]
#     public enum RemoteRecipientType
#     {
#         Mailbox = 0x1,
#         ProvisionArchive = 0x2,
#         Migrated = 0x4,
#         DeprovisionMailbox = 0x8,
#         DeprovisionArchive = 0x10,
#         RoomMailbox = 0x20,
#         EquipmentMailbox = 0x40,
#         //SharedMailbox = RoomMailbox | EquipmentMailbox
#     }
#     public enum RecipientType
#     {
#         SharedMailbox = 0x0,
#         MailUniversalDistributionGroup = 0x1,
#         MailContact = 0x6,
#         RoomMailbox = 0x7,
#         EquipmentMailbox = 0x8,
#         ACLableMailboxUser = 1073741824,
#         MailUniversalSecurityGroup = 1073741833,
#         SyncedMailboxUser = -2147483642,
#         SyncedUDGasUDG = -2147483391,
#         SyncedUDGasContact = -2147483386,
#         SyncedPublicFolder = -2147483130,
#         SyncedDynamicDistributionGroup = -2147482874,
#         SyncedRemoteMailUser = -2147482106,
#         SyncedConferenceRoomMailbox = -2147481850,
#         SyncedEquipmentMailbox = -2147481594,
#         SyncedUSGasUDG = -2147481343,
#         SyncedUSGasContact = -2147481338,
#         ACLableSyncedMailboxUser = -1073741818,
#         ACLableSyncedRemoteMailUser = -1073740282,
#         ACLableSyncedUSGasContact = -1073739514,
#         SyncedUSGasUSG = -1073739511
#     }
#     public enum RecipientTypeDetails: long
#     {
#         UserMailbox = 0x1,
#         LinkedMailbox = 0x2,
#         SharedMailbox = 0x4,
#         RoomMailbox = 0x10,
#         EquipmentMailbox = 0x20,
#         MailUser = 0x80,
#         RemoteUserMailbox = 2147483648, //hex does not work here
#         RemoteRoomMailbox = 8589934592,
#         RemoteEquipmentMailbox = 17179869184,
#         RemoteSharedMailbox = 34359738368
#     }
# '@