function Get-FileName {
    <#
    .SYNOPSIS
    Generates a temporary file name with the specified extension.

    .DESCRIPTION
    This function generates a temporary file name based on the provided extension.
    It can generate a temporary file name in the system's temporary folder or just the file name itself.

    .PARAMETER Name
    Specifies the name of the temporary file. If not specified, the function generates a random file name.

    .PARAMETER Extension
    Specifies the extension for the temporary file name. Default is 'tmp'.

    .PARAMETER Temporary
    Indicates whether to generate a temporary file name in the system's temporary folder.

    .PARAMETER TemporaryFileOnly
    Indicates whether to generate only the temporary file name without the path.

    .EXAMPLE
    Get-FileName
    Generates a temporary file name in the system's temporary folder.
    Example output: C:\Users\przemyslaw.klys\AppData\Local\Temp\3ymsxvav.tmp

    .EXAMPLE
    Get-FileName -Temporary
    Generates a temporary file name in the system's temporary folder.
    Example output: C:\Users\przemyslaw.klys\AppData\Local\Temp\3ymsxvav.tmp

    .EXAMPLE
    Get-FileName -Temporary -Extension 'xlsx'
    Generates a temporary file name with the specified extension in the system's temporary folder.
    Example output: C:\Users\przemyslaw.klys\AppData\Local\Temp\3ymsxvav.xlsx

    .EXAMPLE
    Get-FileName -Name 'MyFile' -Temporary
    Generates a temporary file name with the specified name in the system's temporary folder.
    Example output: C:\Users\przemyslaw.klys\AppData\Local\Temp\MyFile_3ymsxvav.xlsx

    .EXAMPLE
    Get-FileName -Extension 'xlsx' -TemporaryFileOnly
    Generates a temporary file name with the specified extension without the path.
    Example output: 3ymsxvav.xlsx

    .EXAMPLE
    Get-FileName -Name 'MyFile' -TemporaryFileOnly
    Generates a temporary file name with the specified name without the path.
    Example output: MyFile_3ymsxvav.xlsx

    .EXAMPLE
    Get-FileName -Name 'MyFile' -Extension 'xlsx'
    Generates a temporary file name with the specified name and extension.
    Example output: C:\Users\przemyslaw.klys\AppData\Local\Temp\MyFile.xlsx
    #>
    [CmdletBinding()]
    param(
        [string] $Name,
        [string] $Extension = 'tmp',
        [switch] $Temporary,
        [switch] $TemporaryFileOnly
    )

    if ($Name -and $Temporary) {
        $NewName = "$($Name)_$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension"
        return [io.path]::Combine([System.IO.Path]::GetTempPath(), $NewName)
    } elseif ($Name -and $TemporaryFileOnly) {
        return "$($Name)_$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension"
    } elseif ($Name) {
        $NewName = "$Name.$Extension"
        return [io.path]::Combine([System.IO.Path]::GetTempPath(), $NewName)
    } elseif ($Temporary) {
        # C:\Users\przemyslaw.klys\AppData\Local\Temp\p0v4bbif.xlsx
        return [io.path]::Combine([System.IO.Path]::GetTempPath(), "$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension")
    } elseif ($TemporaryFileOnly) {
        # Generates 3ymsxvav.tmp
        return "$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension"
    } else {
        return [io.path]::Combine([System.IO.Path]::GetTempPath(), "$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension")
    }
}