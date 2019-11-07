function Get-ComputerTasks {
    [cmdletbinding()]
    param(
        [string] $ComputerName
    )
    # Querying CIM locally usually doesn't work. This means if you're querying same computer you neeed to skip CimSession/ComputerName if it's local query
    try {
        $LocalComputerDNSName = [System.Net.Dns]::GetHostByName($Env:COMPUTERNAME).HostName
    } catch {
        $LocalComputerDNSName = $ComputerName
    }

    if ($ComputerName -eq $Env:COMPUTERNAME -or $ComputerName -eq $LocalComputerDNSName) {
        $TaskParameters = @{}
    } else {
        $TaskParameters = @{
            CimSession = $ComputerName
        }
    }
    # Full code

    $Tasks = Get-ScheduledTask @TaskParameters #-CimSession $DC.HostName
    $More = foreach ($Task in $Tasks) {
        $Info = $Task | Get-ScheduledTaskInfo @TaskParameters #-CimSession $DC.HostName

        $Actions = foreach ($_ in $Info.Actions) {
            -join ($_.Execute, $_.Arguments)
        }

        [PSCustomObject] @{
            TaskName                                = $Task.TaskName
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

            TaskPath                                = $Task.TaskPath
            #Triggers                = $Task.Triggers
            URI                                     = $Task.URI
            Version                                 = $Task.Version
            LastRunTime                             = $Info.LastRunTime
            LastTaskResult                          = $Info.LastTaskResult
            NextRunTime                             = $Info.NextRunTime
            NumberOfMissedRuns                      = $Info.NumberOfMissedRuns
        }
    }
    $More
}

#$Tasks = Get-ComputerTasks -ComputerName $Env:COMPUTERNAME #| Format-Table -AutoSize
#$Tasks.SecurityDescriptor | ConvertFrom-SddlString