#requires -Module PSWriteColor
<#
    .SYNOPSIS
    Returns an instance of the logger object.

    .EXAMPLE with full log name
    $Logger = Get-Logger -ShowTime -LogPath 'C:\temp\test.log'
    $Logger.AddErrorRecord("test error")
    $Logger.AddInfoRecord("test info")
    $Logger.AddSuccessRecord("test success")
    $Logger.AddRecord("test record")

    .EXAMPLE with directory name and auto-generated log name
    $Logger = Get-Logger -ShowTime -LogsDir 'C:\temp'
    $Logger.AddErrorRecord("test error")

    .EXAMPLE with directory name and logo name defined separately
    $Logger = Get-Logger -ShowTime -Directory 'C:\temp' -Filename 'test.log'
    $Logger.AddErrorRecord("test error")

    .EXAMPLE without logfile, only console output
    $Logger = Get-Logger -ShowTime
    $Logger.AddErrorRecord("test error")
#>

function Get-Logger {
    [CmdletBinding(DefaultParameterSetName="All")]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Logpath')]
        [string] $LogPath,
        [Parameter(Mandatory = $false, ParameterSetName = 'Complexpath')]
        [string] $LogsDir,
        [Parameter(Mandatory = $false, ParameterSetName = 'Complexpath')]
        [string] $Filename,
        [switch] $ShowTime,
        [string] $TimeFormat = 'yyyy-MM-dd HH:mm:ss'
    )

    if ($PSCmdlet.ParameterSetName -eq 'Complexpath') {
        if (-not $Filename) {
            $Filename = "$([datetime]::Now.ToString($TimeFormat) -replace('[^.\-\w]', '_'))_ADReporting.log"
        }
        $LogPath = Join-Path $LogsDir $Filename
    }

    if ($LogPath) {
        $LogsDir = [System.IO.Path]::GetDirectoryName($LogPath)
        New-Item $LogsDir -ItemType Directory -Force | Out-Null
        New-Item $LogPath -ItemType File -Force | Out-Null
    }

    $Logger = [PSCustomObject]@{
        LogPath    = $LogPath
        ShowTime   = $ShowTime
        TimeFormat = $TimeFormat
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddErrorRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Error] ", $String -Color Red, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Error] ", $String -Color Red, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddInfoRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Info] ", $String -Color Yellow, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Info] ", $String -Color Yellow, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddWarningRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Warning] ", $String -Color Magenta, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Warning] ", $String -Color Magenta, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }

    Add-Member -InputObject $Logger -MemberType ScriptMethod AddRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text " $String" -Color White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text " $String" -Color White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }
    Add-Member -InputObject $Logger -MemberType ScriptMethod AddSuccessRecord -Value {
        param(
            [Parameter(Mandatory = $true)]
            [string]$String
        )
        if (-not $this.LogPath) {
            Write-Color -Text "[Success] ", $String -Color Green, White -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        } else {
            Write-Color -Text "[Success] ", $String -Color Green, White -LogFile:$this.LogPath -ShowTime:$this.ShowTime -TimeFormat $this:TimeFormat
        }
    }
    return $Logger
}