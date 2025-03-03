function Set-ReportingCapabilities {
    <#
    .SYNOPSIS
    Sets up reporting capabilities by managing report files.

    .DESCRIPTION
    This function sets up reporting capabilities by creating the necessary directories and managing the number of report files based on the specified maximum.

    .PARAMETER ReportPath
    The path where the report files will be stored.

    .PARAMETER ScriptPath
    The path of the script that generates the reports.

    .PARAMETER ReportMaximum
    The maximum number of report files to keep. Older files will be deleted if this limit is exceeded.

    .EXAMPLE
    Set-ReportingCapabilities -ReportPath "C:\Reports\report.log" -ScriptPath "C:\Scripts\script.ps1" -ReportMaximum 10

    .NOTES
    This function is used in:
    - CleanupMonster
    - PasswordSolution
    - SharePointEssentials

    And many other scripts.
    #>
    [CmdletBinding()]
    param(
        [alias('Path', 'LiteralPath', 'FilePath')][string] $ReportPath,
        [string] $ScriptPath,
        [Alias('Maximum', 'Count')][int] $ReportMaximum
    )
    if ($ReportPath) {
        try {
            $FolderPath = [io.path]::GetDirectoryName($ReportPath)
            if (-not (Test-Path -LiteralPath $FolderPath -ErrorAction Stop)) {
                $null = New-Item -Path $FolderPath -ItemType Directory -Force -WhatIf:$false -ErrorAction Stop
            }
            if ($ReportMaximum -gt 0) {
                if ($ScriptPath) {
                    $ScriptPathFolder = [io.path]::GetDirectoryName($ScriptPath)
                    if ($ScriptPathFolder -eq $FolderPath) {
                        Write-Color -Text '[i] ', "ReportMaximum is set to ", $ReportMaximum, " but report files are in the same folder as the script. Cleanup disabled." -Color Yellow, White, DarkCyan, White
                        return
                    }
                }
                # Get the extension of the report file
                $ReportPathExtension = [io.path]::GetExtension($ReportPath)
                # Get the report files, sort them by creation time, and skip the first $ReportMaximum
                if ($ReportPathExtension) {
                    # If the report file has an extension, filter the files by that extension to prevent deleting other files
                    $CurrentReports = Get-ChildItem -LiteralPath $FolderPath -Filter "*$ReportPathExtension" -ErrorAction Stop | Sort-Object -Property CreationTime -Descending | Select-Object -Skip $ReportMaximum
                } else {
                    $CurrentReports = $null
                    Write-Color -Text '[i] ', "Report file has no extension (?!). Cleanup disabled." -Color Yellow, White, DarkCyan, White
                }
                if ($CurrentReports) {
                    Write-Color -Text '[i] ', "Reporting directory has more than ", $ReportMaximum, " report files. Cleanup required..." -Color Yellow, DarkCyan, Red, DarkCyan
                    foreach ($Report in $CurrentReports) {
                        try {
                            Remove-Item -LiteralPath $Report.FullName -Confirm:$false -WhatIf:$false
                            Write-Color -Text '[+] ', "Deleted ", "$($Report.FullName)" -Color Yellow, White, Green
                        } catch {
                            Write-Color -Text '[-] ', "Couldn't delete report file $($Report.FullName). Error: ', "$($_.Exception.Message) -Color Yellow, White, Red
                        }
                    }
                }
            } else {
                Write-Color -Text '[i] ', "ReportMaximum is set to 0 (Unlimited). No report files will be deleted." -Color Yellow, DarkCyan
            }
        } catch {
            Write-Color -Text "[e] ", "Couldn't create the reporting directory. Error: $($_.Exception.Message)" -Color Yellow, Red
        }
    }
}