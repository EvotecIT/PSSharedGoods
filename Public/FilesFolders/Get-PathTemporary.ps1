function Get-PathTemporary {
    <#
    .SYNOPSIS
    Gets the path to the temporary directory.

    .DESCRIPTION
    This function retrieves the path to the system's temporary directory.

    .EXAMPLE
    Get-PathTemporary
    Output:
    C:\Users\Username\AppData\Local\Temp

    .NOTES
    The function uses [System.IO.Path]::GetTempPath() to get the temporary directory path.
    #>
    [CmdletBinding()]
    param()
    return [IO.path]::GetTempPath()
}