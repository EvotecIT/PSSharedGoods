function Convert-FileEncodingSingle {
    <#
    .SYNOPSIS
    Converts a single file from one encoding to another with validation and rollback protection.

    .DESCRIPTION
    Internal helper function that converts a single file's encoding with comprehensive validation.
    Includes content verification and automatic rollback on mismatch to prevent data corruption.

    .PARAMETER FilePath
    Full path to the file to convert.

    .PARAMETER SourceEncoding
    Expected source encoding of the file.

    .PARAMETER TargetEncoding
    Target encoding to convert the file to.

    .PARAMETER Force
    Convert file even if detected encoding doesn't match SourceEncoding.

    .PARAMETER NoRollbackOnMismatch
    Skip rolling back changes when content verification fails.

    .PARAMETER CreateBackup
    Create a backup file before conversion for additional safety.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [System.Text.Encoding] $SourceEncoding,

        [Parameter(Mandatory)]
        [System.Text.Encoding] $TargetEncoding,

        [switch] $Force,
        [switch] $NoRollbackOnMismatch,
        [switch] $CreateBackup
    )

    $bytesBefore = $null
    $backupPath = $null

    try {
        # Get current file encoding
        $detectedObj = Get-FileEncoding -Path $FilePath -AsObject
        $detected = $detectedObj.Encoding
        $detectedName = $detectedObj.EncodingName

        # More robust encoding comparison using encoding names from our detection
        $sourceExpected = if ($SourceEncoding -is [System.Text.UTF8Encoding] -and $SourceEncoding.GetPreamble().Length -eq 3) { 'UTF8BOM' }
                         elseif ($SourceEncoding -is [System.Text.UTF8Encoding]) { 'UTF8' }
                         elseif ($SourceEncoding -is [System.Text.UnicodeEncoding]) { 'Unicode' }
                         elseif ($SourceEncoding -is [System.Text.UTF7Encoding]) { 'UTF7' }
                         elseif ($SourceEncoding -is [System.Text.UTF32Encoding]) { 'UTF32' }
                         elseif ($SourceEncoding -is [System.Text.ASCIIEncoding]) { 'ASCII' }
                         elseif ($SourceEncoding -is [System.Text.BigEndianUnicodeEncoding]) { 'BigEndianUnicode' }
                         else { $SourceEncoding.WebName }

        # Check if source encoding matches detected encoding
        if ($detectedName -ne $sourceExpected -and -not $Force) {
            Write-Verbose "Skipping $FilePath because detected encoding '$detectedName' does not match expected '$sourceExpected'."
            return @{
                FilePath = $FilePath
                Status = 'Skipped'
                Reason = "Encoding mismatch: detected '$detectedName', expected '$sourceExpected'"
                DetectedEncoding = $detectedName
            }
        }

        # Check if already target encoding
        $targetExpected = if ($TargetEncoding -is [System.Text.UTF8Encoding] -and $TargetEncoding.GetPreamble().Length -eq 3) { 'UTF8BOM' }
                         elseif ($TargetEncoding -is [System.Text.UTF8Encoding]) { 'UTF8' }
                         elseif ($TargetEncoding -is [System.Text.UnicodeEncoding]) { 'Unicode' }
                         elseif ($TargetEncoding -is [System.Text.UTF7Encoding]) { 'UTF7' }
                         elseif ($TargetEncoding -is [System.Text.UTF32Encoding]) { 'UTF32' }
                         elseif ($TargetEncoding -is [System.Text.ASCIIEncoding]) { 'ASCII' }
                         elseif ($TargetEncoding -is [System.Text.BigEndianUnicodeEncoding]) { 'BigEndianUnicode' }
                         else { $TargetEncoding.WebName }

        if ($detectedName -eq $targetExpected) {
            Write-Verbose "Skipping $FilePath because encoding is already '$targetExpected'."
            return @{
                FilePath = $FilePath
                Status = 'Skipped'
                Reason = "Already target encoding '$targetExpected'"
                DetectedEncoding = $detectedName
            }
        }

        if ($PSCmdlet.ShouldProcess($FilePath, "Convert from '$detectedName' to '$targetExpected'")) {
            # Read original content and create backup
            $content = [System.IO.File]::ReadAllText($FilePath, $detected)
            $bytesBefore = [System.IO.File]::ReadAllBytes($FilePath)

            if ($CreateBackup) {
                $backupPath = "$FilePath.backup"
                $counter = 1
                while (Test-Path $backupPath) {
                    $backupPath = "$FilePath.backup$counter"
                    $counter++
                }
                [System.IO.File]::WriteAllBytes($backupPath, $bytesBefore)
                Write-Verbose "Created backup at: $backupPath"
            }

            # Convert the file
            [System.IO.File]::WriteAllText($FilePath, $content, $TargetEncoding)

            # Verify conversion
            $convertedContent = [System.IO.File]::ReadAllText($FilePath, $TargetEncoding)
            if ($convertedContent -ne $content) {
                $warningMsg = "Content verification failed for $FilePath - characters may have been lost during conversion"
                Write-Warning $warningMsg

                if (-not $NoRollbackOnMismatch) {
                    [System.IO.File]::WriteAllBytes($FilePath, $bytesBefore)
                    Write-Warning "Reverted changes to $FilePath due to content mismatch"

                    return @{
                        FilePath = $FilePath
                        Status = 'Failed'
                        Reason = 'Content verification failed - reverted'
                        DetectedEncoding = $detectedName
                        BackupPath = $backupPath
                    }
                } else {
                    return @{
                        FilePath = $FilePath
                        Status = 'Converted'
                        Reason = 'Content verification failed but conversion kept'
                        DetectedEncoding = $detectedName
                        TargetEncoding = $targetExpected
                        BackupPath = $backupPath
                        Warning = $warningMsg
                    }
                }
            }

            Write-Verbose "Successfully converted $FilePath from '$detectedName' to '$targetExpected'"
            return @{
                FilePath = $FilePath
                Status = 'Converted'
                Reason = 'Successfully converted'
                DetectedEncoding = $detectedName
                TargetEncoding = $targetExpected
                BackupPath = $backupPath
            }
        }
    } catch {
        $errorMsg = "Failed to convert ${FilePath}: $_"
        Write-Warning $errorMsg

        # Attempt rollback on error
        if (-not $NoRollbackOnMismatch -and $bytesBefore) {
            try {
                [System.IO.File]::WriteAllBytes($FilePath, $bytesBefore)
                Write-Verbose "Rolled back $FilePath due to conversion error"
            } catch {
                Write-Warning "Failed to rollback $FilePath after error: $_"
            }
        }

        return @{
            FilePath = $FilePath
            Status = 'Error'
            Reason = $errorMsg
            DetectedEncoding = $detectedName
            BackupPath = $backupPath
        }
    }
}
