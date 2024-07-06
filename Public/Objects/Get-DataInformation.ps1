function Get-DataInformation {
    <#
    .SYNOPSIS
    Retrieves data information based on specified criteria.

    .DESCRIPTION
    This function retrieves data information based on the specified criteria. It checks for required types, availability of commands, and executes content if provided.

    .PARAMETER Content
    The script block to execute for gathering data.

    .PARAMETER Text
    The text message to display when gathering data.

    .PARAMETER TypesRequired
    An array of types required for data gathering.

    .PARAMETER TypesNeeded
    An array of types needed for data gathering.

    .PARAMETER Commands
    An array of commands to check for availability.

    .PARAMETER SkipAvailability
    Switch to skip availability check for commands.

    .EXAMPLE
    Get-DataInformation -Content { Get-Process } -Text "Gathering process information" -TypesRequired @("System.Diagnostics.Process") -TypesNeeded @("System.Diagnostics.Process") -Commands @("Get-Process")

    Description:
    Retrieves process information using the Get-Process command.

    .EXAMPLE
    Get-DataInformation -Content { Get-Service } -Text "Gathering service information" -TypesRequired @("System.ServiceProcess.ServiceController") -TypesNeeded @("System.ServiceProcess.ServiceController") -Commands @("Get-Service")

    Description:
    Retrieves service information using the Get-Service command.
    #>
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