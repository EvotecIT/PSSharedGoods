function Get-ComputerSMB {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .EXAMPLE
    Get-ComputerSMB -ComputerName $ENV:COMPUTERNAME

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [string[]] $ComputerName
    )

    [Array] $CollectionComputers = $ComputerName.Where( { $_ -eq $Env:COMPUTERNAME }, 'Split')
    $SMB = @(
        if ($CollectionComputers[0].Count -gt 0) {
            $Output = Get-SmbServerConfiguration
            foreach ($_ in $Output) {
                [PSCustomObject] @{
                    ComputerName                    = $Env:COMPUTERNAME
                    AnnounceComment                 = $_.AnnounceComment
                    AnnounceServer                  = $_.AnnounceServer
                    AsynchronousCredits             = $_.AsynchronousCredits
                    AuditSmb1Access                 = $_.AuditSmb1Access
                    AutoDisconnectTimeout           = $_.AutoDisconnectTimeout
                    AutoShareServer                 = $_.AutoShareServer
                    AutoShareWorkstation            = $_.AutoShareWorkstation
                    CachedOpenLimit                 = $_.CachedOpenLimit
                    DurableHandleV2TimeoutInSeconds = $_.DurableHandleV2TimeoutInSeconds
                    EnableAuthenticateUserSharing   = $_.EnableAuthenticateUserSharing
                    EnableDownlevelTimewarp         = $_.EnableDownlevelTimewarp
                    EnableForcedLogoff              = $_.EnableForcedLogoff
                    EnableLeasing                   = $_.EnableLeasing
                    EnableMultiChannel              = $_.EnableMultiChannel
                    EnableOplocks                   = $_.EnableOplocks
                    EnableSecuritySignature         = $_.EnableSecuritySignature
                    EnableSMB1Protocol              = $_.EnableSMB1Protocol
                    EnableSMB2Protocol              = $_.EnableSMB2Protocol
                    EnableStrictNameChecking        = $_.EnableStrictNameChecking
                    EncryptData                     = $_.EncryptData
                    IrpStackSize                    = $_.IrpStackSize
                    KeepAliveTime                   = $_.KeepAliveTime
                    MaxChannelPerSession            = $_.MaxChannelPerSession
                    MaxMpxCount                     = $_.MaxMpxCount
                    MaxSessionPerConnection         = $_.MaxSessionPerConnection
                    MaxThreadsPerQueue              = $_.MaxThreadsPerQueue
                    MaxWorkItems                    = $_.MaxWorkItems
                    NullSessionPipes                = $_.NullSessionPipes
                    NullSessionShares               = $_.NullSessionShares
                    OplockBreakWait                 = $_.OplockBreakWait
                    PendingClientTimeoutInSeconds   = $_.PendingClientTimeoutInSeconds
                    RejectUnencryptedAccess         = $_.RejectUnencryptedAccess
                    RequireSecuritySignature        = $_.RequireSecuritySignature
                    ServerHidden                    = $_.ServerHidden
                    Smb2CreditsMax                  = $_.Smb2CreditsMax
                    Smb2CreditsMin                  = $_.Smb2CreditsMin
                    SmbServerNameHardeningLevel     = $_.SmbServerNameHardeningLevel
                    TreatHostAsStableStorage        = $_.TreatHostAsStableStorage
                    ValidateAliasNotCircular        = $_.ValidateAliasNotCircular
                    ValidateShareScope              = $_.ValidateShareScope
                    ValidateShareScopeNotAliased    = $_.ValidateShareScopeNotAliased
                    ValidateTargetName              = $_.ValidateTargetName
                }
            }
        }
        if ($CollectionComputers[1].Count -gt 0) {
            $Output = Get-SmbServerConfiguration -CimSession $CollectionComputers[1]
            foreach ($_ in $Output) {
                [PSCustomObject] @{
                    ComputerName                    = $_.PSComputerName
                    AnnounceComment                 = $_.AnnounceComment
                    AnnounceServer                  = $_.AnnounceServer
                    AsynchronousCredits             = $_.AsynchronousCredits
                    AuditSmb1Access                 = $_.AuditSmb1Access
                    AutoDisconnectTimeout           = $_.AutoDisconnectTimeout
                    AutoShareServer                 = $_.AutoShareServer
                    AutoShareWorkstation            = $_.AutoShareWorkstation
                    CachedOpenLimit                 = $_.CachedOpenLimit
                    DurableHandleV2TimeoutInSeconds = $_.DurableHandleV2TimeoutInSeconds
                    EnableAuthenticateUserSharing   = $_.EnableAuthenticateUserSharing
                    EnableDownlevelTimewarp         = $_.EnableDownlevelTimewarp
                    EnableForcedLogoff              = $_.EnableForcedLogoff
                    EnableLeasing                   = $_.EnableLeasing
                    EnableMultiChannel              = $_.EnableMultiChannel
                    EnableOplocks                   = $_.EnableOplocks
                    EnableSecuritySignature         = $_.EnableSecuritySignature
                    EnableSMB1Protocol              = $_.EnableSMB1Protocol
                    EnableSMB2Protocol              = $_.EnableSMB2Protocol
                    EnableStrictNameChecking        = $_.EnableStrictNameChecking
                    EncryptData                     = $_.EncryptData
                    IrpStackSize                    = $_.IrpStackSize
                    KeepAliveTime                   = $_.KeepAliveTime
                    MaxChannelPerSession            = $_.MaxChannelPerSession
                    MaxMpxCount                     = $_.MaxMpxCount
                    MaxSessionPerConnection         = $_.MaxSessionPerConnection
                    MaxThreadsPerQueue              = $_.MaxThreadsPerQueue
                    MaxWorkItems                    = $_.MaxWorkItems
                    NullSessionPipes                = $_.NullSessionPipes
                    NullSessionShares               = $_.NullSessionShares
                    OplockBreakWait                 = $_.OplockBreakWait
                    PendingClientTimeoutInSeconds   = $_.PendingClientTimeoutInSeconds
                    RejectUnencryptedAccess         = $_.RejectUnencryptedAccess
                    RequireSecuritySignature        = $_.RequireSecuritySignature
                    ServerHidden                    = $_.ServerHidden
                    Smb2CreditsMax                  = $_.Smb2CreditsMax
                    Smb2CreditsMin                  = $_.Smb2CreditsMin
                    SmbServerNameHardeningLevel     = $_.SmbServerNameHardeningLevel
                    TreatHostAsStableStorage        = $_.TreatHostAsStableStorage
                    ValidateAliasNotCircular        = $_.ValidateAliasNotCircular
                    ValidateShareScope              = $_.ValidateShareScope
                    ValidateShareScopeNotAliased    = $_.ValidateShareScopeNotAliased
                    ValidateTargetName              = $_.ValidateTargetName
                }
            }
        }
    )
    $SMB
}