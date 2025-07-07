function Get-FileEncoding {
    <#
    .SYNOPSIS
    Get the encoding of a file (ASCII, UTF8, UTF8BOM, Unicode, BigEndianUnicode, UTF7, UTF32).

    .DESCRIPTION
    Detects the encoding of a file using its byte order mark or by scanning for non‑ASCII characters.
    Encoding is determined by the first few bytes of the file (BOM) or by the presence of non-ASCII characters.
    Returns a string with the encoding name or a custom object when -AsObject is used.

    .PARAMETER Path
    Path to the file to check. Supports pipeline input and can accept FullName property from Get-ChildItem.

    .PARAMETER AsObject
    Returns a custom object with Path, Encoding, and EncodingName properties instead of just the encoding name string.

    .EXAMPLE
    Get-FileEncoding -Path 'C:\temp\test.txt'
    Returns the encoding name as a string (e.g., 'UTF8BOM', 'ASCII', 'Unicode')

    .EXAMPLE
    Get-FileEncoding -Path 'C:\temp\test.txt' -AsObject
    Returns a custom object with detailed encoding information

    .EXAMPLE
    Get-ChildItem -Path 'C:\temp\*.txt' | Get-FileEncoding
    Gets encoding for all text files in the directory via pipeline

    .NOTES
    Supported encodings: ASCII, UTF8, UTF8BOM, Unicode (UTF-16LE), BigEndianUnicode (UTF-16BE), UTF7, UTF32
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias('FullName')]
        [string] $Path,

        [switch] $AsObject
    )
    process {
        if (-not (Test-Path -LiteralPath $Path)) {
            $msg = "Get-FileEncoding - File not found: $Path"
            if ($ErrorActionPreference -eq 'Stop') { throw $msg }
            Write-Warning $msg
            return
        }

        $fs = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
        try {
            $bom = [byte[]]::new(4)
            $null = $fs.Read($bom, 0, 4)
            $enc = [System.Text.Encoding]::ASCII

            # Check for BOMs in order of specificity (longer BOMs first)
            if ($bom[0] -eq 0x00 -and $bom[1] -eq 0x00 -and $bom[2] -eq 0xfe -and $bom[3] -eq 0xff) {
                $enc = [System.Text.Encoding]::UTF32
            } elseif ($bom[0] -eq 0xef -and $bom[1] -eq 0xbb -and $bom[2] -eq 0xbf) {
                $enc = [System.Text.UTF8Encoding]::new($true)
            } elseif ($bom[0] -eq 0xff -and $bom[1] -eq 0xfe) {
                $enc = [System.Text.Encoding]::Unicode
            } elseif ($bom[0] -eq 0xfe -and $bom[1] -eq 0xff) {
                $enc = [System.Text.Encoding]::BigEndianUnicode
            } elseif ($bom[0] -eq 0x2b -and $bom[1] -eq 0x2f -and $bom[2] -eq 0x76) {
                $enc = [System.Text.Encoding]::UTF7
            } else {
                # No BOM detected - scan for non-ASCII characters to distinguish UTF8 from ASCII
                $fs.Position = 0
                $byte = [byte[]]::new(1)
                while ($fs.Read($byte, 0, 1) -gt 0) {
                    if ($byte[0] -gt 0x7F) {
                        $enc = [System.Text.UTF8Encoding]::new($false)
                        break
                    }
                }
            }
        } finally {
            $fs.Close()
            $fs.Dispose()
        }

        # Determine encoding name for consistent return values
        $encName = if ($enc -is [System.Text.UTF8Encoding] -and $enc.GetPreamble().Length -eq 3) {
            'UTF8BOM'
        } elseif ($enc -is [System.Text.UTF8Encoding]) {
            'UTF8'
        } elseif ($enc -is [System.Text.UnicodeEncoding]) {
            'Unicode'
        } elseif ($enc -is [System.Text.UTF7Encoding]) {
            'UTF7'
        } elseif ($enc -is [System.Text.UTF32Encoding]) {
            'UTF32'
        } elseif ($enc -is [System.Text.ASCIIEncoding]) {
            'ASCII'
        } elseif ($enc -is [System.Text.BigEndianUnicodeEncoding]) {
            'BigEndianUnicode'
        } else {
            $enc.WebName
        }

        if ($AsObject) {
            [PSCustomObject]@{
                Path         = $Path
                Encoding     = $enc
                EncodingName = $encName
            }
        } else {
            $encName
        }
    }
}

