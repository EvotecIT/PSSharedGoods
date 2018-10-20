function Get-FileInformation {
    [CmdletBinding()]
    param(
        [string] $File
    )
    if (Test-Path $File) {
        return get-item $File  | Select-Object Name, FullName, @{N = 'Size'; E = {Get-FileSize -Bytes $_.Length}}, IsReadOnly, LastWriteTime
    }
    return
}