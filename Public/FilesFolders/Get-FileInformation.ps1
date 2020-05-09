function Get-FileInformation {
    [CmdletBinding()]
    param(
        [string] $File
    )
    if (Test-Path $File) {
        return Get-Item $File  | Select-Object Name, FullName, @{N = 'Size'; E = { Get-FileSize -Bytes $_.Length } }, IsReadOnly, LastWriteTime
    }
    return
}