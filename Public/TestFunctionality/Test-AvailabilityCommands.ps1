function Test-AvailabilityCommands {
    <#
    .SYNOPSIS
    Tests the availability of specified commands.

    .DESCRIPTION
    The Test-AvailabilityCommands function checks whether the specified commands are available in the current environment.

    .PARAMETER Commands
    Specifies an array of command names to test for availability.

    .EXAMPLE
    Test-AvailabilityCommands -Commands "Get-Process", "Get-Service"
    This example tests the availability of the "Get-Process" and "Get-Service" commands.

    .EXAMPLE
    Test-AvailabilityCommands -Commands "Get-Command", "Get-Help"
    This example tests the availability of the "Get-Command" and "Get-Help" commands.

    #>
    [cmdletBinding()]
    param (
        [string[]] $Commands
    )
    $CommandsStatus = foreach ($Command in $Commands) {
        $Exists = Get-Command -Name $Command -ErrorAction SilentlyContinue
        if ($Exists) {
            Write-Verbose "Test-AvailabilityCommands - Command $Command is available."
        } else {
            Write-Verbose "Test-AvailabilityCommands - Command $Command is not available."
        }
        $Exists
    }
    return $CommandsStatus
}