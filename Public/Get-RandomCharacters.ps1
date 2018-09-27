function Get-RandomCharacters {
    param(
        $length,
        $characters
    )
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs = "" # https://blogs.msdn.microsoft.com/powershell/2006/07/15/psmdtagfaq-what-is-ofs/
    return [String]$characters[$random]
}