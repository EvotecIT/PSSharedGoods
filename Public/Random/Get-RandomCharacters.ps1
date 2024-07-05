function Get-RandomCharacters {
    <#
    .SYNOPSIS
    Generates a random string of characters from a specified character set.

    .DESCRIPTION
    This function generates a random string of characters from a specified character set with the given length.

    .PARAMETER length
    The length of the random string to generate.

    .PARAMETER characters
    The set of characters from which to generate the random string.

    .EXAMPLE
    Get-RandomCharacters -length 8 -characters 'abcdef123'
    Generates a random string of 8 characters from the character set 'abcdef123'.

    .EXAMPLE
    Get-RandomCharacters -length 12 -characters 'ABC123!@#'
    Generates a random string of 12 characters from the character set 'ABC123!@#'.
    #>
    [cmdletbinding()]
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