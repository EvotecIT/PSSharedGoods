function Get-ComputerTask {
    <#
    .SYNOPSIS
    Get Task Schedule information

    .DESCRIPTION
    Get Task Schedule information

    .PARAMETER ComputerName
    Specifies computer on which you want to run the operation.

    .EXAMPLE
    Get-ComputerTask | Format-Table

    .NOTES
    General notes
    #>
    [alias('Get-ComputerTasks')]
    [cmdletbinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME
    )
    foreach ($Computer in $ComputerName) {
        # Querying CIM locally usually doesn't work. This means if you're querying same computer you neeed to skip CimSession/ComputerName if it's local query
        try {
            $LocalComputerDNSName = [System.Net.Dns]::GetHostByName($Env:COMPUTERNAME).HostName
        } catch {
            $LocalComputerDNSName = $Computer
        }

        if ($Computer -eq $Env:COMPUTERNAME -or $Computer -eq $LocalComputerDNSName) {
            $TaskParameters = @{}
        } else {
            $TaskParameters = @{
                CimSession = $Computer
            }
        }
        # Full code

        $Tasks = Get-ScheduledTask @TaskParameters
        foreach ($Task in $Tasks) {
            $Info = $Task | Get-ScheduledTaskInfo @TaskParameters

            $Actions = foreach ($_ in $Info.Actions) {
                -join ($_.Execute, $_.Arguments)
            }

            [PSCustomObject] @{
                ComputerName                            = $Computer
                TaskName                                = $Task.TaskName
                TaskPath                                = $Task.TaskPath
                State                                   = $Task.State
                Actions                                 = $Actions
                Author                                  = $Task.Author
                Date                                    = $Task.Date
                Description                             = $Task.Description
                Documentation                           = $Task.Documentation
                PrincipalDisplayName                    = $Task.Principal.DisplayName
                PrincipalGroupID                        = $Task.Principal.GroupID
                PrincipalLogonType                      = $Task.Principal.LogonType
                PrincipalRunLevel                       = $Task.Principal.RunLevel
                PrincipalProcessTokenSidType            = $Task.Principal.ProcessTokenSidType
                PrincipalRequiredPrivilege              = $Task.Principal.RequiredPrivilege

                #SecurityDescriptor                      = $Task.SecurityDescriptor #  | ConvertFrom-SddlString
                #Settings                                = $Task.Settings
                SettingsAllowDemandStart                = $Task.Settings.AllowDemandStart
                SettingsAllowHardTerminate              = $Task.Settings.AllowHardTerminate
                SettingsCompatibility                   = $Task.Settings.Compatibility
                SettingsDeleteExpiredTaskAfter          = $Task.Settings.DeleteExpiredTaskAfter
                SettingsDisallowStartIfOnBatteries      = $Task.Settings.DisallowStartIfOnBatteries
                SettingsEnabled                         = $Task.Settings.Enabled
                SettingsExecutionTimeLimit              = $Task.Settings.ExecutionTimeLimit
                SettingsHidden                          = $Task.Settings.Hidden
                SettingsIdleSettings                    = $Task.Settings.IdleSettings
                SettingsMultipleInstances               = $Task.Settings.MultipleInstances
                SettingsNetworkSettings                 = $Task.Settings.NetworkSettings
                SettingsPriority                        = $Task.Settings.Priority
                SettingsRestartCount                    = $Task.Settings.RestartCount
                SettingsRestartInterval                 = $Task.Settings.RestartInterval
                SettingsRunOnlyIfIdle                   = $Task.Settings.RunOnlyIfIdle
                SettingsRunOnlyIfNetworkAvailable       = $Task.Settings.RunOnlyIfNetworkAvailable
                SettingsStartWhenAvailable              = $Task.Settings.StartWhenAvailable
                SettingsStopIfGoingOnBatteries          = $Task.Settings.StopIfGoingOnBatteries
                SettingsWakeToRun                       = $Task.Settings.WakeToRun
                SettingsDisallowStartOnRemoteAppSession = $Task.Settings.DisallowStartOnRemoteAppSession
                SettingsUseUnifiedSchedulingEngine      = $Task.Settings.UseUnifiedSchedulingEngine
                SettingsMaintenanceSettings             = $Task.Settings.MaintenanceSettings
                SettingsVolatile                        = $Task.Settings.volatile
                Source                                  = $Task.Source
                #Triggers                = $Task.Triggers
                URI                                     = $Task.URI
                Version                                 = $Task.Version
                LastRunTime                             = $Info.LastRunTime
                LastTaskResult                          = $Info.LastTaskResult
                NextRunTime                             = $Info.NextRunTime
                NumberOfMissedRuns                      = $Info.NumberOfMissedRuns
            }
        }
    }
}

#$Tasks = Get-ComputerTasks -ComputerName $Env:COMPUTERNAME #| Format-Table -AutoSize
#$Tasks.SecurityDescriptor | ConvertFrom-SddlString