function Get-PathTemporary {
    param(

    )
    return [IO.path]::GetTempPath()
}