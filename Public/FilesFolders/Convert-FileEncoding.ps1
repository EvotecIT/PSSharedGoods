function Convert-FileEncoding {
    <#
    .SYNOPSIS
    Converts files from one encoding to another.

    .DESCRIPTION
    Reads a single file or all files within a directory and rewrites them using a new encoding.
    Useful for converting files from UTF8 with BOM to UTF8 without BOM or any other supported encoding.
    Files are only converted when their detected encoding matches the provided SourceEncoding unless -Force is used.
    If a file already uses the target encoding it is skipped.
    After conversion the content is verified to ensure it matches the original string.
    If the content differs the change is rolled back by default unless -NoRollbackOnMismatch is specified.
    Supports -WhatIf for previewing changes.

    .PARAMETER Path
    Specifies the file or directory to process.

    .PARAMETER Filter
    Filters which files are processed when Path is a directory. Wildcards are supported.

    .PARAMETER SourceEncoding
    Encoding used when reading files. The default is UTF8BOM.

    .PARAMETER TargetEncoding
    Encoding used when writing files. The default is UTF8.

    .PARAMETER Recurse
    When Path is a directory, process files in all subdirectories as well.

    .PARAMETER Force
    Convert files even when their detected encoding does not match SourceEncoding.

    .PARAMETER NoRollbackOnMismatch
    Skip rolling back files when the verification step detects that content changed during conversion.

    .EXAMPLE
    Convert-FileEncoding -Path 'C:\Scripts' -Filter '*.ps1' -SourceEncoding UTF8BOM -TargetEncoding UTF8

    Converts all PowerShell scripts under C:\Scripts from UTF8 with BOM to UTF8.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [string] $Filter = '*.*',

        [ValidateSet('Ascii','BigEndianUnicode','Unicode','UTF7','UTF8','UTF8BOM','UTF32','Default','OEM')]
        [string] $SourceEncoding = 'UTF8BOM',

        [ValidateSet('Ascii','BigEndianUnicode','Unicode','UTF7','UTF8','UTF8BOM','UTF32','Default','OEM')]
        [string] $TargetEncoding = 'UTF8',

        [switch] $Recurse,
        [switch] $Force,
        [switch] $NoRollbackOnMismatch
    )

    $source = Resolve-Encoding -Name $SourceEncoding
    $target = Resolve-Encoding -Name $TargetEncoding

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $files = Get-Item -LiteralPath $Path
    } elseif (Test-Path -LiteralPath $Path -PathType Container) {
        $gciParams = @{ LiteralPath = $Path; File = $true; Filter = $Filter }
        if ($Recurse) { $gciParams.Recurse = $true }
        $files = Get-ChildItem @gciParams
    } else {
        throw "Path $Path not found"
    }

    foreach ($file in $files) {
        $result = Convert-FileEncodingSingle -FilePath $file.FullName -SourceEncoding $source -TargetEncoding $target -Force:$Force -NoRollbackOnMismatch:$NoRollbackOnMismatch -WhatIf:$WhatIfPreference

        if ($result) {
            Write-Verbose "File: $($result.FilePath) - Status: $($result.Status) - Reason: $($result.Reason)"
            if ($result.Warning) {
                Write-Warning $result.Warning
            }
        }
    }
}
