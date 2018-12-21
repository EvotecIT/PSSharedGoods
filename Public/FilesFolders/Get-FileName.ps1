# https://docs.microsoft.com/en-us/dotnet/api/system.io.path.getfilenamewithoutextension?view=netframework-4.7.2
function Get-FileName {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Extension
    Parameter description

    .PARAMETER Temporary
    Parameter description

    .PARAMETER TemporaryFileOnly
    Parameter description

    .EXAMPLE
    Get-FileName -Temporary
    Output: 3ymsxvav.tmp

    .EXAMPLE

    Get-FileName -Temporary
    Output: C:\Users\pklys\AppData\Local\Temp\tmpD74C.tmp

    .EXAMPLE

    Get-FileName -Temporary -Extension 'xlsx'
    Output: C:\Users\pklys\AppData\Local\Temp\tmp45B6.xlsx


    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $Extension = 'tmp',
        [switch] $Temporary,
        [switch] $TemporaryFileOnly
    )

    if ($Temporary) {
        return "$($([System.IO.Path]::GetTempFileName()).Split('.')[0]).$Extension"
    }
    if ($TemporaryFileOnly) {
        # Generates 3ymsxvav.tmp
        return "$($([System.IO.Path]::GetRandomFileName()).Split('.')[0]).$Extension"
    }
}