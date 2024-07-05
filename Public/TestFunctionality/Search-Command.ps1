function Search-Command {
    <#
    .SYNOPSIS
    Searches for a specific command by name.

    .DESCRIPTION
    This function checks if a command with the specified name exists in the current session.

    .PARAMETER CommandName
    Specifies the name of the command to search for.

    .EXAMPLE
    Search-Command -CommandName "Get-Process"
    Returns $true if the command "Get-Process" exists, otherwise $false.

    .EXAMPLE
    Search-Command -CommandName "UnknownCommand"
    Returns $false as "UnknownCommand" does not exist as a command.

    #>
    [cmdletbinding()]
    param (
        [string] $CommandName
    )
    return [bool](Get-Command -Name $CommandName -ErrorAction SilentlyContinue)
}