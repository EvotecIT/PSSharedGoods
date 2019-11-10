function Test-ModuleAvailability {
    [CmdletBinding()]
    param(

    )
    if (Search-Command -CommandName 'Get-AdForest') {
        # future use
    } else {
        Write-Warning 'Modules required to run not found.'
        Exit
    }
}