function Get-FileEncoding {
    <#
    .SYNOPSIS
    Get the encoding of a file (ASCII, UTF8, UTF8BOM, Unicode, BigEndianUnicode, UTF7)

    .DESCRIPTION
    Get the encoding of a file (ASCII, UTF8, UTF8BOM, Unicode, BigEndianUnicode, UTF7).
    Encoding is determined by the first few bytes of the file or by the presence of non-ASCII characters.

    .PARAMETER Path
    Path to the file to check

    .EXAMPLE
    Get-FileEncoding -Path 'C:\Users\pklys\Desktop\test.txt'

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Path
    )
    if (-not (Test-Path -Path $Path)) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw "Get-FileEncoding - File not found: $Path"
        }
        Write-Warning -Message "Get-FileEncoding - File not found: $Path"
        return
    }
    $fileStream = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
    $byte = [byte[]]::new(4)
    $null = $fileStream.Read($byte, 0, 4)
    $fileStream.Close()

    if ($byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf) {
        return 'UTF8BOM'
    } elseif ($byte[0] -eq 0xff -and $byte[1] -eq 0xfe) {
        return 'Unicode'
    } elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff) {
        return 'BigEndianUnicode'
    } elseif ($byte[0] -eq 0x2b -and $byte[1] -eq 0x2f -and $byte[2] -eq 0x76) {
        return 'UTF7'
    } else {
        # Check if the file contains any non-ASCII characters
        $fileStream = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
        $byte = [byte[]]::new(1)
        while ($fileStream.Read($byte, 0, 1) -gt 0) {
            if ($byte[0] -gt 0x7F) {
                $fileStream.Close()
                return 'UTF8'
            }
        }
        $fileStream.Close()
        return 'ASCII'
    }
}
