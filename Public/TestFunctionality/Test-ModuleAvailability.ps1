function Test-ModuleAvailability {
    <#
    .SYNOPSIS
    Tests the availability of required modules.

    .DESCRIPTION
    This function checks if the required modules are available for use.

    .EXAMPLE
    Test-ModuleAvailability
    Checks if the 'Get-AdForest' module is available.

    #>
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