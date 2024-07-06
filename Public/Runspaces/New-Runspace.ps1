function New-Runspace {
    <#
    .SYNOPSIS
    Creates a new runspace pool with the specified minimum and maximum runspaces.

    .DESCRIPTION
    This function creates a new runspace pool with the specified minimum and maximum runspaces. It allows for concurrent execution of PowerShell scripts.

    .PARAMETER minRunspaces
    The minimum number of runspaces to be created in the runspace pool. Default is 1.

    .PARAMETER maxRunspaces
    The maximum number of runspaces to be created in the runspace pool. Default is the number of processors plus 1.

    .EXAMPLE
    $pool = New-Runspace -minRunspaces 2 -maxRunspaces 5
    Creates a runspace pool with a minimum of 2 and a maximum of 5 runspaces.

    .EXAMPLE
    $pool = New-Runspace
    Creates a runspace pool with default minimum and maximum runspaces.

    #>
    [cmdletbinding()]
    param (
        [int] $minRunspaces = 1,
        [int] $maxRunspaces = [int]$env:NUMBER_OF_PROCESSORS + 1
    )
    $RunspacePool = [RunspaceFactory]::CreateRunspacePool($minRunspaces, $maxRunspaces)
    #ApartmentState is not available in PowerShell 6+
    #$RunspacePool.ApartmentState = "MTA"
    $RunspacePool.Open()
    return $RunspacePool
}