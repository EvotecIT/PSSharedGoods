function Get-ComputerSMBShare {
    <#
    .SYNOPSIS
    Retrieves SMB shares information from specified computers.

    .DESCRIPTION
    The Get-ComputerSMBShare function retrieves SMB share information from the specified computers. It can return basic share details or detailed information based on the 'Translated' switch.

    .PARAMETER ComputerName
    Specifies the names of the computers from which to retrieve SMB share information.

    .PARAMETER Translated
    Indicates whether to return detailed translated information about the SMB shares.

    .EXAMPLE
    Get-ComputerSMBShare -ComputerName "Server01" -Translated
    Retrieves detailed translated information about SMB shares from Server01.

    .EXAMPLE
    Get-ComputerSMBShare -ComputerName "Server01", "Server02"
    Retrieves basic SMB share information from Server01 and Server02.

    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName,
        [switch] $Translated
    )
    [Array] $CollectionComputers = Get-ComputerSplit -ComputerName $ComputerName

    if ($CollectionComputers[0].Count -gt 0) {
        $Output = Get-SmbShare
        foreach ($O in $Output) {
            if (-not $Translated) {
                Add-Member -InputObject $_ -Name 'PSComputerName' -Value $Env:COMPUTERNAME -MemberType NoteProperty -Force
                $O
            } else {
                [PSCustomObject] @{
                    Name                  = $O.Name                   #: ADMIN$
                    ScopeName             = $O.ScopeName              #: *
                    Path                  = $O.Path                   #: C:\Windows
                    Description           = $O.Description            #: Remote Admin
                    ComputerName          = $O.PSComputerName         #: AD1
                    PresetPathAcl         = $O.PresetPathAcl          #:
                    ShareState            = $O.ShareState.ToString()             #: Online
                    AvailabilityType      = $O.AvailabilityType.ToString()       #: NonClustered
                    ShareType             = $O.ShareType.ToString()              #: FileSystemDirectory
                    FolderEnumerationMode = $O.FolderEnumerationMode.ToString()  #: Unrestricted
                    CachingMode           = $O.CachingMode.ToString()            #: Manual
                    LeasingMode           = $O.LeasingMode.ToString()            #:
                    QoSFlowScope          = $O.QoSFlowScope           #:
                    SmbInstance           = $O.SmbInstance.ToString()            #: Default
                    CATimeout             = $O.CATimeout              #: 0
                    ConcurrentUserLimit   = $O.ConcurrentUserLimit    #: 0
                    ContinuouslyAvailable = $O.ContinuouslyAvailable  #: False
                    CurrentUsers          = $O.CurrentUsers           #: 0
                    EncryptData           = $O.EncryptData            #: False
                    Scoped                = $O.Scoped                 #: False
                    SecurityDescriptor    = $O.SecurityDescriptor     #: O:SYG:SYD:(A;;GA;;;BA)(A;;GA;;;BO)(A;;GA;;;IU)
                    ShadowCopy            = $O.ShadowCopy             #: False
                    Special               = $O.Special                #: True
                    Temporary             = $O.Temporary              #: False
                    Volume                = $O.Volume                 #: \\?\Volume{2014dd39-5b27-44a6-be88-1d650346016d}\
                }
            }
        }
    }
    if ($CollectionComputers[1].Count -gt 0) {
        $Output = Get-SmbShare -CimSession $CollectionComputers[1]
        foreach ($O in $Output) {
            if (-not $Translated) {
                $O
            } else {
                [PSCustomObject] @{
                    Name                  = $O.Name                   #: ADMIN$
                    ScopeName             = $O.ScopeName              #: *
                    Path                  = $O.Path                   #: C:\Windows
                    Description           = $O.Description            #: Remote Admin
                    ComputerName          = $O.PSComputerName         #: AD1
                    PresetPathAcl         = $O.PresetPathAcl          #:
                    ShareState            = $O.ShareState.ToString()             #: Online
                    AvailabilityType      = $O.AvailabilityType.ToString()       #: NonClustered
                    ShareType             = $O.ShareType.ToString()              #: FileSystemDirectory
                    FolderEnumerationMode = $O.FolderEnumerationMode.ToString()  #: Unrestricted
                    CachingMode           = $O.CachingMode.ToString()            #: Manual
                    LeasingMode           = $O.LeasingMode #.ToString()            #:
                    QoSFlowScope          = $O.QoSFlowScope           #:
                    SmbInstance           = $O.SmbInstance.ToString()            #: Default
                    CATimeout             = $O.CATimeout              #: 0
                    ConcurrentUserLimit   = $O.ConcurrentUserLimit    #: 0
                    ContinuouslyAvailable = $O.ContinuouslyAvailable  #: False
                    CurrentUsers          = $O.CurrentUsers           #: 0
                    EncryptData           = $O.EncryptData            #: False
                    Scoped                = $O.Scoped                 #: False
                    SecurityDescriptor    = $O.SecurityDescriptor     #: O:SYG:SYD:(A;;GA;;;BA)(A;;GA;;;BO)(A;;GA;;;IU)
                    ShadowCopy            = $O.ShadowCopy             #: False
                    Special               = $O.Special                #: True
                    Temporary             = $O.Temporary              #: False
                    Volume                = $O.Volume                 #: \\?\Volume{2014dd39-5b27-44a6-be88-1d650346016d}\
                }
            }
        }
    }
}