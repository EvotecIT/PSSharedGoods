function Get-DataInformation {
    [CmdletBinding()]
    param(
        [ScriptBlock] $Content,
        [string] $Text,
        [Array] $TypesRequired,
        [Array] $TypesNeeded,
        [Array] $Commands,
        [switch] $SkipAvailability
    )
    if (Find-TypesNeeded -TypesRequired $TypesRequired -TypesNeeded $TypesNeeded) {
        Write-Verbose -Message $Text
        $Time = Start-TimeLog

        if ($Commands.Count -gt 0 -and -not $SkipAvailability) {
            $Available = Test-AvailabilityCommands -Commands $Commands
            if ($Available -contains $false) {
                $EndTime = Stop-TimeLog -Time $Time -Option OneLiner
                Write-Warning "Get-DataInformation - Commands $($Commands -join ", ") is/are not available. Data gathering skipped."
                Write-Verbose "$Text - Time: $EndTime"
                return
            }
        }
        if ($null -ne $Content) {
            & $Content
        }
        $EndTime = Stop-TimeLog -Time $Time -Option OneLiner
        Write-Verbose "$Text - Time: $EndTime"
    }
}