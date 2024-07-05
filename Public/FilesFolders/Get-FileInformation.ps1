function Get-FileInformation {
    <#
    .SYNOPSIS
    Get information about file such as Name, FullName and Size

    .DESCRIPTION
    Get information about file such as Name, FullName and Size

    .PARAMETER File
    File to get information about

    .EXAMPLE
    Get-FileInformation -File 'C:\Support\GitHub\PSSharedGoods\Public\FilesFolders\Get-FileInformation.ps1'

    #>
    [CmdletBinding()]
    param(
        [alias('LiteralPath', 'Path')][string] $File
    )
    if (Test-Path -LiteralPath $File) {
        $Item = Get-Item -LiteralPath $File
        [PSCustomObject] @{
            Name          = $Item.Name
            FullName      = $Item.FullName
            Size          = Get-FileSize -Bytes $Item.Length
            IsReadOnly    = $Item.IsReadOnly
            LastWriteTime = $Item.LastWriteTime
        }
    }
}