function Test-AvailabilityCommands {
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