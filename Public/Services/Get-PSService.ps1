function Get-PSService {
    <#
    .SYNOPSIS
    Alternative way to Get-Service

    .DESCRIPTION
    Alternative way to Get-Service which works using CIM queries

    .PARAMETER ComputerName
    ComputerName(s) to query for services

    .PARAMETER Protocol
    Protocol to use to gather services

    .PARAMETER Service
    Limit output to just few services

    .PARAMETER All
    Return all data without filtering

    .PARAMETER Extended
    Return more data

    .EXAMPLE
    Get-PSService -ComputerName AD1, AD2, AD3, AD4 -Service 'Dnscache', 'DNS', 'PeerDistSvc', 'WebClient', 'Netlogon'

    .EXAMPLE
    Get-PSService -ComputerName AD1, AD2 -Extended

    .EXAMPLE
    Get-PSService

    .EXAMPLE
    Get-PSService -Extended

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [alias('Computer', 'Computers')][string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [alias('Services')][string[]] $Service,
        [switch] $All,
        [switch] $Extended
    )
    [string] $Class = 'win32_service'
    [string] $Properties = '*'
    <# Disabled as per https://github.com/EvotecIT/PSSharedGoods/issues/14
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = @(
            'Name'
            'Status'
            'ExitCode'
            'DesktopInteract'
            'ErrorControl'
            'PathName'
            'ServiceType'
            'StartMode'
            'Caption'
            'Description'
            #'InstallDate'
            'Started'
            'SystemName'
            'AcceptPause'
            'AcceptStop'
            'DisplayName'
            'ServiceSpecificExitCode'
            'StartName'
            'State'
            'TagId'
            'CheckPoint'
            'DelayedAutoStart'
            'ProcessId'
            'WaitHint'
            'PSComputerName'
        )
    }
    #>
    # instead of looping multiple times we create cache for services
    if ($Service) {
        $CachedServices = @{}
        foreach ($S in $Service) {
            $CachedServices[$S] = $true
        }
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        if ($Service) {
            foreach ($Entry in $Information) {
                if ($CachedServices[$Entry.Name]) {
                    $Entry
                }
            }
        } else {
            $Information
        }
    } else {
        foreach ($Data in $Information) {
            # # Remember to expand if changing properties above
            if ($Service) {
                if (-not $CachedServices[$Data.Name]) {
                    continue
                }
            }
            $OutputService = [ordered] @{
                ComputerName = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                Status       = $Data.State
                Name         = $Data.Name
                ServiceType  = $Data.ServiceType
                StartType    = $Data.StartMode
                DisplayName  = $Data.DisplayName
            }
            if ($Extended) {
                $OutputServiceExtended = [ordered] @{
                    StatusOther             = $Data.Status
                    ExitCode                = $Data.ExitCode
                    DesktopInteract         = $Data.DesktopInteract
                    ErrorControl            = $Data.ErrorControl
                    PathName                = $Data.PathName
                    Caption                 = $Data.Caption
                    Description             = $Data.Description
                    #InstallDate             = $Data.InstallDate
                    Started                 = $Data.Started
                    SystemName              = $Data.SystemName
                    AcceptPause             = $Data.AcceptPause
                    AcceptStop              = $Data.AcceptStop
                    ServiceSpecificExitCode = $Data.ServiceSpecificExitCode
                    StartName               = $Data.StartName
                    #State                   = $Data.State
                    TagId                   = $Data.TagId
                    CheckPoint              = $Data.CheckPoint
                    DelayedAutoStart        = $Data.DelayedAutoStart
                    ProcessId               = $Data.ProcessId
                    WaitHint                = $Data.WaitHint
                }
                [PSCustomObject] ($OutputService + $OutputServiceExtended)
            } else {
                [PSCustomObject] $OutputService
            }
        }

    }
}