function Convert-FolderEncoding {
    <#
    .SYNOPSIS
    Converts files in folders to a target encoding based on file extensions.

    .DESCRIPTION
    A user-friendly wrapper around Convert-FileEncoding that makes it easy to target specific file types
    by their extensions across one or more folders. This function is ideal for scenarios where you want to convert encoding for
    specific file types across directories without needing to know filter syntax.

    The function supports both single and multiple file extensions, with smart defaults for PowerShell
    compatibility. It provides comprehensive feedback and safety features including WhatIf support
    and backup creation.

    .PARAMETER Path
    The directory path to search for files. Can be a single directory or an array of directories.
    Use '.' for the current directory.

    .PARAMETER Extensions
    File extensions to target for conversion. Can be specified with or without the leading dot.
    Examples: 'ps1', '.ps1', @('ps1', 'psm1'), @('.cs', '.vb')

    Common presets available via -FileType parameter for convenience.

    .PARAMETER FileType
    Predefined file type groups for common scenarios:
    - PowerShell: .ps1, .psm1, .psd1, .ps1xml
    - CSharp: .cs, .csx
    - Web: .html, .css, .js, .json, .xml
    - Scripts: .ps1, .py, .rb, .sh, .bat, .cmd
    - Text: .txt, .md, .log, .config
    - All: Processes all common text file types

    .PARAMETER SourceEncoding
    Expected source encoding of files. Default is 'UTF8BOM'.

    .PARAMETER TargetEncoding
    Target encoding for conversion.
    Default is 'UTF8BOM' for PowerShell compatibility (prevents PS 5.1 ASCII misinterpretation).

    .PARAMETER ExcludeDirectories
    Directory names to exclude from processing (e.g., '.git', 'bin', 'obj', 'node_modules').
    Default excludes common build and version control directories.

    .PARAMETER Recurse
    Process files in subdirectories recursively. Default is $true.

    .PARAMETER CreateBackups
    Create backup files before conversion for additional safety.
    Backups are created with .bak extension in the same directory.

    .PARAMETER Force
    Convert files even when their detected encoding doesn't match SourceEncoding.

    .PARAMETER NoRollbackOnMismatch
    Skip rolling back files when verification detects content changes during conversion.

    .PARAMETER MaxDepth
    Maximum directory depth to recurse when -Recurse is enabled. Default is unlimited.

    .PARAMETER PassThru
    Return conversion results for further processing.

    .EXAMPLE
    Convert-FolderEncoding -Path . -Extensions 'ps1' -WhatIf

    Preview what PowerShell files in the current directory would be converted.

    .EXAMPLE
    Convert-FolderEncoding -Path @('.\Scripts', '.\Modules') -FileType PowerShell -CreateBackups

    Convert all PowerShell files in Scripts and Modules directories to UTF8BOM with backups.

    .EXAMPLE
    Convert-FolderEncoding -Path . -Extensions @('cs', 'vb') -TargetEncoding UTF8 -Recurse

    Convert all C# and VB.NET files recursively to UTF8 (without BOM).

    .EXAMPLE
    Convert-FolderEncoding -Path .\Source -FileType Web -ExcludeDirectories @('node_modules', 'dist') -Force

    Convert web files, excluding build directories, forcing conversion regardless of detected encoding.

    .NOTES
    Author: PowerShell Encoding Tools

    This function provides a more user-friendly interface than Convert-FileEncoding for common scenarios.
    For complex filtering requirements, use Convert-FileEncoding directly.

    PowerShell Encoding Notes:
    - UTF8BOM is recommended for PowerShell files to ensure PS 5.1 compatibility
    - UTF8 without BOM can cause PS 5.1 to misinterpret files as ASCII
    - Always test with -WhatIf first and consider using -CreateBackups
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Extensions')]
    param(
        [Parameter(Mandatory)]
        [Alias('Directory', 'Folder')]
        [string[]] $Path,

        [Parameter(ParameterSetName = 'Extensions', Mandatory)]
        [string[]] $Extensions,

        [Parameter(ParameterSetName = 'FileType', Mandatory)]
        [ValidateSet('PowerShell', 'CSharp', 'Web', 'Scripts', 'Text', 'All')]
        [string] $FileType,

        [ValidateSet('Ascii', 'BigEndianUnicode', 'Unicode', 'UTF7', 'UTF8', 'UTF8BOM', 'UTF32', 'Default', 'OEM')]
        [string] $SourceEncoding = 'UTF8BOM',

        [ValidateSet('Ascii', 'BigEndianUnicode', 'Unicode', 'UTF7', 'UTF8', 'UTF8BOM', 'UTF32', 'Default', 'OEM')]
        [string] $TargetEncoding = 'UTF8BOM',

        [string[]] $ExcludeDirectories = @('.git', '.vs', 'bin', 'obj', 'packages', 'node_modules', '.vscode', 'dist', 'build'),

        [bool] $Recurse = $true,

        [switch] $CreateBackups,

        [switch] $Force,

        [switch] $NoRollbackOnMismatch,

        [int] $MaxDepth,

        [switch] $PassThru
    )

    # Validate paths
    foreach ($singlePath in $Path) {
        if (-not (Test-Path -LiteralPath $singlePath -PathType Container)) {
            throw "Directory path '$singlePath' not found or is not a directory"
        }
    }

    # Define file type mappings
    $fileTypeMappings = @{
        'PowerShell' = @('.ps1', '.psm1', '.psd1', '.ps1xml')
        'CSharp'     = @('.cs', '.csx', '.csproj')
        'Web'        = @('.html', '.htm', '.css', '.js', '.json', '.xml', '.xsl', '.xslt')
        'Scripts'    = @('.ps1', '.py', '.rb', '.sh', '.bash', '.bat', '.cmd')
        'Text'       = @('.txt', '.md', '.log', '.config', '.ini', '.conf', '.yaml', '.yml')
        'All'        = @('.ps1', '.psm1', '.psd1', '.ps1xml', '.cs', '.csx', '.html', '.htm', '.css', '.js', '.json', '.xml', '.txt', '.md', '.py', '.rb', '.sh', '.bat', '.cmd', '.config', '.ini', '.yaml', '.yml')
    }

    # Determine target extensions
    if ($PSCmdlet.ParameterSetName -eq 'FileType') {
        $targetExtensions = $fileTypeMappings[$FileType]
        Write-Verbose "Using $FileType file type: $($targetExtensions -join ', ')"
    } else {
        # Normalize extensions (ensure they start with a dot)
        $targetExtensions = $Extensions | ForEach-Object {
            if ($_.StartsWith('.')) { $_ } else { ".$_" }
        }
        Write-Verbose "Target extensions: $($targetExtensions -join ', ')"
    }

    # Collect all files to process
    $allFiles = @()
    $summary = @{
        TotalDirectories     = $Path.Count
        ProcessedDirectories = 0
        TotalFiles           = 0
        ProcessedFiles       = 0
        ConvertedFiles       = 0
        SkippedFiles         = 0
        ErrorFiles           = 0
        StartTime            = Get-Date
    }

    Write-Verbose "Scanning directories for files..."

    foreach ($singlePath in $Path) {
        Write-Verbose "Processing directory: $singlePath"
        $summary.ProcessedDirectories++

        try {
            $gciParams = @{
                LiteralPath = $singlePath
                File        = $true
            }

            if ($Recurse) {
                $gciParams.Recurse = $true
                if ($MaxDepth) { $gciParams.Depth = $MaxDepth }
            }

            $directoryFiles = Get-ChildItem @gciParams | Where-Object {
                # Filter by extension
                $extension = $_.Extension.ToLower()
                $extensionMatch = $targetExtensions -contains $extension

                # Exclude directories if specified
                $directoryExcluded = $false
                if ($ExcludeDirectories -and $_.DirectoryName) {
                    $relativePath = $_.DirectoryName.Replace($singlePath, '').TrimStart('\', '/')
                    $directoryExcluded = $ExcludeDirectories | Where-Object { $relativePath -like "*$_*" }
                }

                return $extensionMatch -and -not $directoryExcluded
            }

            $allFiles += $directoryFiles
            $summary.TotalFiles += $directoryFiles.Count

            Write-Verbose "Found $($directoryFiles.Count) matching files in $singlePath"

        } catch {
            Write-Error "Error processing directory '$singlePath': $($_.Exception.Message)"
            continue
        }
    }

    if ($allFiles.Count -eq 0) {
        Write-Warning "No files found matching the specified criteria."
        Write-Verbose "Extensions searched: $($targetExtensions -join ', ')"
        Write-Verbose "Paths searched: $($Path -join ', ')"
        return
    }

    Write-Verbose "Found $($allFiles.Count) files across $($summary.ProcessedDirectories) directories"
    Write-Verbose "Target extensions: $($targetExtensions -join ', ')"
    Write-Verbose "Converting: $SourceEncoding → $TargetEncoding"

    if ($PSCmdlet.ShouldProcess("$($allFiles.Count) files", "Convert encoding from $SourceEncoding to $TargetEncoding")) {

        $results = @()
        $progressCounter = 0

        foreach ($file in $allFiles) {
            $progressCounter++
            $percentComplete = [math]::Round(($progressCounter / $allFiles.Count) * 100, 1)

            Write-Progress -Activity "Converting file encodings" -Status "Processing $($file.Name) ($progressCounter of $($allFiles.Count))" -PercentComplete $percentComplete

            try {
                # Create backup if requested
                if ($CreateBackups) {
                    $backupPath = "$($file.FullName).bak"
                    Copy-Item -LiteralPath $file.FullName -Destination $backupPath -Force
                    Write-Verbose "Created backup: $backupPath"
                }

                # Convert the file
                $convertParams = @{
                    Path                 = $file.FullName
                    SourceEncoding       = $SourceEncoding
                    TargetEncoding       = $TargetEncoding
                    Force                = $Force
                    NoRollbackOnMismatch = $NoRollbackOnMismatch
                    WhatIf               = $WhatIfPreference
                }

                Convert-FileEncoding @convertParams

                $summary.ProcessedFiles++
                $summary.ConvertedFiles++

                if ($PassThru) {
                    $results += [PSCustomObject]@{
                        FilePath      = $file.FullName
                        Extension     = $file.Extension
                        Status        = 'Converted'
                        BackupCreated = $CreateBackups
                    }
                }

            } catch {
                $summary.ErrorFiles++
                Write-Error "Error converting '$($file.FullName)': $($_.Exception.Message)"

                if ($PassThru) {
                    $results += [PSCustomObject]@{
                        FilePath  = $file.FullName
                        Extension = $file.Extension
                        Status    = 'Error'
                        Error     = $_.Exception.Message
                    }
                }
            }
        }

        Write-Progress -Activity "Converting file encodings" -Completed
    }

    # Display summary
    $summary.EndTime = Get-Date
    $summary.Duration = $summary.EndTime - $summary.StartTime

    Write-Verbose "Conversion Summary:"
    Write-Verbose "  Directories processed: $($summary.ProcessedDirectories)"
    Write-Verbose "  Files found: $($summary.TotalFiles)"
    Write-Verbose "  Files processed: $($summary.ProcessedFiles)"
    Write-Verbose "  Files converted: $($summary.ConvertedFiles)"
    Write-Verbose "  Files with errors: $($summary.ErrorFiles)"
    Write-Verbose "  Duration: $($summary.Duration.TotalSeconds.ToString('F2')) seconds"

    if ($CreateBackups -and $summary.ConvertedFiles -gt 0) {
        Write-Verbose "  Backups created with .bak extension"
    }

    if ($PassThru) {
        return $results
    }
}
