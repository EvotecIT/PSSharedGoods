function Get-PathTemporary {
    [CmdletBinding()]
    param()
    return [IO.path]::GetTempPath()
}