function Resolve-Encoding {
    <#
    .SYNOPSIS
        Resolves encoding names to .NET System.Text.Encoding objects.

    .DESCRIPTION
        Converts encoding name strings to proper .NET encoding objects, with special handling
        for UTF8BOM (UTF8 with BOM) and OEM encodings that aren't directly available in
        System.Text.Encoding static properties.

    .PARAMETER Name
        The name of the encoding to resolve. Supports common encodings used in text file processing.

    .EXAMPLE
        Resolve-Encoding -Name 'UTF8BOM'
        Returns a UTF8Encoding object configured to emit a BOM.

    .EXAMPLE
        Resolve-Encoding -Name 'ASCII'
        Returns the ASCII encoding object.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Ascii','BigEndianUnicode','Unicode','UTF7','UTF8','UTF8BOM','UTF32','Default','OEM')]
        [string] $Name
    )

    switch ($Name.ToUpperInvariant()) {
        'UTF8BOM' {
            return [System.Text.UTF8Encoding]::new($true)
        }
        'UTF8' {
            return [System.Text.UTF8Encoding]::new($false)
        }
        'OEM' {
            return [System.Text.Encoding]::GetEncoding([Console]::OutputEncoding.CodePage)
        }
        default {
            try {
                return [System.Text.Encoding]::$Name
            } catch {
                throw "Failed to resolve encoding '$Name': $($_.Exception.Message)"
            }
        }
    }
}
