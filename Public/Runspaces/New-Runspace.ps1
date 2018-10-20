function New-Runspace {
    [cmdletbinding()]
    param (
        [int] $minRunspaces = 1,
        [int] $maxRunspaces = [int]$env:NUMBER_OF_PROCESSORS + 1
    )
    $RunspacePool = [RunspaceFactory]::CreateRunspacePool($minRunspaces, $maxRunspaces)
    $RunspacePool.ApartmentState = "MTA"
    $RunspacePool.Open()
    return $RunspacePool
}