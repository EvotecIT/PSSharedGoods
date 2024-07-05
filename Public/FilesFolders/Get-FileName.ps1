function Get-FileName {
    <#
    .SYNOPSIS
    Generates a temporary file name with the specified extension.

    .DESCRIPTION
    This function generates a temporary file name based on the provided extension. It can generate a temporary file name in the system's temporary folder or just the file name itself.

    .PARAMETER Extension
    Specifies the extension for the temporary file name. Default is 'tmp'.

    .PARAMETER Temporary
    Indicates whether to generate a temporary file name in the system's temporary folder.

    .PARAMETER TemporaryFileOnly
    Indicates whether to generate only the temporary file name without the path.

    .EXAMPLE
    Get-FileName -Temporary
    Generates a temporary file name in the system's temporary folder. Example output: 3ymsxvav.tmp

    .EXAMPLE
    Get-FileName -Temporary
    Generates a temporary file name without the path. Example output: tmpD74C.tmp

    .EXAMPLE
    Get-FileName -Temporary -Extension 'xlsx'
    Generates a temporary file name with the specified extension in the system's temporary folder. Example output: tmp45B6.xlsx

    .NOTES
    These examples demonstrate how to use the Get-FileName function to generate temporary file names.
    #>
    [CmdletBinding()]
    param(
        [string] $Extension = 'tmp',
        [switch] $Temporary,
        [switch] $TemporaryFileOnly
    )

    if ($Temporary) {
        # C:\Users\przemyslaw.klys\AppData\Local\Temp\p0v4bbif.xlsx
        return [io.path]::Combine([System.IO.Path]::GetTempPath(), "$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension")
    }
    if ($TemporaryFileOnly) {
        # Generates 3ymsxvav.tmp
        return "$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension"
    }
}