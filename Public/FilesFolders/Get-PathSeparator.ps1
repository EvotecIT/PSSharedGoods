function Get-PathSeparator {
    <#
    .SYNOPSIS
    Gets the path separator character used by the operating system.

    .DESCRIPTION
    This function retrieves the path separator character used by the operating system. It can be useful for handling file paths in a platform-independent manner.

    .EXAMPLE
    Get-PathSeparator
    Output:
    \

    .NOTES
    The function uses [System.IO.Path]::PathSeparator to get the path separator character.
    #>
    [CmdletBinding()]
    param()
    return [IO.Path]::PathSeparator
}