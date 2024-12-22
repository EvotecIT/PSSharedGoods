function Set-LoggingCapabilities {
    <#
    .SYNOPSIS
    Sets up logging capabilities by managing log files.

    .DESCRIPTION
    This function sets up logging capabilities by creating the necessary directories and managing the number of log files based on the specified maximum.

    .PARAMETER LogPath
    The path where the log files will be stored.

    .PARAMETER ScriptPath
    The path of the script that generates the logs.

    .PARAMETER LogMaximum
    The maximum number of log files to keep. Older files will be deleted if this limit is exceeded.

    .PARAMETER ShowTime
    Switch to include timestamps in the log entries.

    .PARAMETER TimeFormat
    The format of the timestamps in the log entries.

    .EXAMPLE
    Set-LoggingCapabilities -LogPath "C:\Logs\log.log" -ScriptPath "C:\Scripts\script.ps1" -LogMaximum 10 -ShowTime -TimeFormat "yyyy-MM-dd HH:mm:ss"

    .NOTES
    This function is used in:
    - CleanupMonster
    - PasswordSolution
    - SharePointEssentials

    And many other scripts.
    #>
    [CmdletBinding()]
    param(
        [Alias('Path', 'Log', 'Folder', 'LiteralPath', 'FilePath')][string] $LogPath,
        [string] $ScriptPath,
        [Alias('Maximum')][int] $LogMaximum,
        [switch] $ShowTime,
        [string] $TimeFormat
    )

    $Script:PSDefaultParameterValues = @{
        "Write-Color:LogFile"    = $LogPath
        "Write-Color:ShowTime"   = if ($PSBoundParameters.ContainsKey('ShowTime')) { $ShowTime.IsPresent } else { $null }
        "Write-Color:TimeFormat" = $TimeFormat
    }
    if ($LogPath) {
        try {
            $FolderPath = [io.path]::GetDirectoryName($LogPath)
            if (-not (Test-Path -LiteralPath $FolderPath)) {
                $null = New-Item -Path $FolderPath -ItemType Directory -Force -WhatIf:$false
            }
            if ($LogMaximum -gt 0) {
                if ($ScriptPath) {
                    $ScriptPathFolder = [io.path]::GetDirectoryName($ScriptPath)
                    if ($ScriptPathFolder -eq $FolderPath) {
                        Write-Color -Text '[i] ', "LogMaximum is set to ", $LogMaximum, " but log files are in the same folder as the script. Cleanup disabled." -Color Yellow, White, DarkCyan, White
                        return
                    }
                    # Get the extension of the log file
                    $LogPathExtension = [io.path]::GetExtension($LogPath)
                    # Get the log files, sort them by creation time, and skip the first $LogMaximum
                    if ($LogPathExtension) {
                        # If the log file has an extension, filter the files by that extension to prevent deleting other files
                        $CurrentLogs = Get-ChildItem -LiteralPath $FolderPath -Filter "*$LogPathExtension" -ErrorAction Stop | Sort-Object -Property CreationTime -Descending | Select-Object -Skip $LogMaximum
                    } else {
                        $CurrentLogs = $null
                        Write-Color -Text '[i] ', "Log file has no extension (?!). Cleanup disabled." -Color Yellow, White, DarkCyan, White
                    }
                    if ($CurrentLogs) {
                        Write-Color -Text '[i] ', "Logs directory has more than ", $LogMaximum, " log files. Cleanup required..." -Color Yellow, DarkCyan, Red, DarkCyan
                        foreach ($Log in $CurrentLogs) {
                            try {
                                Remove-Item -LiteralPath $Log.FullName -Confirm:$false -WhatIf:$false
                                Write-Color -Text '[+] ', "Deleted ", "$($Log.FullName)" -Color Yellow, White, Green
                            } catch {
                                Write-Color -Text '[-] ', "Couldn't delete log file $($Log.FullName). Error: ', "$($_.Exception.Message) -Color Yellow, White, Red
                            }
                        }
                    }
                } else {
                    Write-Color -Text '[i] ', "LogMaximum is set to ", $LogMaximum, " but no script path detected. Most likely running interactively. Cleanup disabled." -Color Yellow, White, DarkCyan, White
                }
            } else {
                Write-Color -Text '[i] ', "LogMaximum is set to 0 (Unlimited). No log files will be deleted." -Color Yellow, DarkCyan
            }
        } catch {
            Write-Color -Text "[e] ", "Couldn't create the log directory. Error: $($_.Exception.Message)" -Color Yellow, Red
            $Script:PSDefaultParameterValues["Write-Color:LogFile"] = $null
        }
    } else {
        $Script:PSDefaultParameterValues["Write-Color:LogFile"] = $null
    }
    Remove-EmptyValue -Hashtable $Script:PSDefaultParameterValues
}