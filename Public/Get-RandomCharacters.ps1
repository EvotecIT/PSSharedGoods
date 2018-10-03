function Get-RandomCharacters {
    param(
        [int] $length,
        [string] $characters
    )
    if ($length -ne 0 -and $characters -ne '') {
        $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
        $private:ofs = "" # https://blogs.msdn.microsoft.com/powershell/2006/07/15/psmdtagfaq-what-is-ofs/
        return [String]$characters[$random]
    } else {
        return
    }
}