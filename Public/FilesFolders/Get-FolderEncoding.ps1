function Get-FolderEncoding {
    <#
    .SYNOPSIS
    Analyzes file encodings in folders based on file extensions.

    .DESCRIPTION
    A user-friendly wrapper that analyzes encoding distribution across files in one or more folders,
    filtered by file extensions. This function is ideal for understanding the current encoding state
    of specific file types before performing conversions.

    The function supports both single and multiple file extensions, with predefined file type groups
    for common scenarios. It provides comprehensive analysis including encoding distribution,
    inconsistencies, and recommendations.

    .PARAMETER Path
    The directory path to analyze. Can be a single directory or an array of directories.
    Use '.' for the current directory.

    .PARAMETER Extensions
    File extensions to analyze. Can be specified with or without the leading dot.
    Examples: 'ps1', '.ps1', @('ps1', 'psm1'), @('.cs', '.vb')

    Common presets available via -FileType parameter for convenience.

    .PARAMETER FileType
    Predefined file type groups for common scenarios:
    - PowerShell: .ps1, .psm1, .psd1, .ps1xml
    - CSharp: .cs, .csx
    - Web: .html, .css, .js, .json, .xml
    - Scripts: .ps1, .py, .rb, .sh, .bat, .cmd
    - Text: .txt, .md, .log, .config
    - All: Analyzes all common text file types

    .PARAMETER ExcludeDirectories
    Directory names to exclude from analysis (e.g., '.git', 'bin', 'obj', 'node_modules').
    Default excludes common build and version control directories.

    .PARAMETER Recurse
    Process files in subdirectories recursively. Default is $true.

    .PARAMETER MaxDepth
    Maximum directory depth to recurse when -Recurse is enabled. Default is unlimited.

    .PARAMETER GroupByExtension
    Group results by file extension to show encoding distribution per file type.

    .PARAMETER ShowFiles
    Include individual file details in the output. Default is $true.
    Use -ShowFiles:$false to disable if you only want summary statistics.

    .PARAMETER RecommendTarget
    Provide encoding recommendations based on file types (e.g., UTF8BOM for PowerShell files).
    Default is $true. Use -RecommendTarget:$false to disable recommendations.

    .EXAMPLE
    Get-FolderEncoding -Path . -Extensions 'ps1'

    Analyze PowerShell files in the current directory with file details and recommendations (default behavior).

    .EXAMPLE
    Get-FolderEncoding -Path @('.\Scripts', '.\Modules') -FileType PowerShell -GroupByExtension

    Analyze all PowerShell files in Scripts and Modules directories, grouped by extension.

    .EXAMPLE
    Get-FolderEncoding -Path . -Extensions @('cs', 'vb') -ShowFiles:$false

    Analyze C# and VB.NET files showing only summary statistics, no individual file details.

    .EXAMPLE
    Get-FolderEncoding -Path .\Source -FileType Web -ExcludeDirectories @('node_modules', 'dist')

    Analyze web files, excluding build directories, with full details and recommendations.

    .OUTPUTS
    PSCustomObject with the following properties:
    - Summary: Overall statistics and recommendations
    - EncodingDistribution: Hashtable of encoding counts
    - ExtensionAnalysis: Analysis grouped by file extension (if -GroupByExtension)
    - Files: Individual file details (default: included)
    - Recommendations: Encoding recommendations (default: included)

    .NOTES
    Author: PowerShell Encoding Tools

    This function provides analysis capabilities to complement Convert-FolderEncoding.
    Use this to understand your current encoding state before performing conversions.

    PowerShell Encoding Notes:
    - UTF8BOM is recommended for PowerShell files to ensure PS 5.1 compatibility
    - Mixed encodings within a project can cause issues
    - ASCII files are compatible with UTF8 but may need BOM for PowerShell
    #>
    [CmdletBinding(DefaultParameterSetName = 'Extensions')]
    param(
        [Parameter(Mandatory)]
        [Alias('Directory', 'Folder')]
        [string[]] $Path,

        [Parameter(ParameterSetName = 'Extensions', Mandatory)]
        [string[]] $Extensions,

        [Parameter(ParameterSetName = 'FileType', Mandatory)]
        [ValidateSet('PowerShell', 'CSharp', 'Web', 'Scripts', 'Text', 'All')]
        [string] $FileType,

        [string[]] $ExcludeDirectories = @('.git', '.vs', 'bin', 'obj', 'packages', 'node_modules', '.vscode', 'dist', 'build'),

        [bool] $Recurse = $true,

        [int] $MaxDepth,

        [switch] $GroupByExtension,

        [bool] $ShowFiles = $true,

        [bool] $RecommendTarget = $true
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

    # Define encoding recommendations by file type
    $encodingRecommendations = @{
        '.ps1'    = 'UTF8BOM'
        '.psm1'   = 'UTF8BOM'
        '.psd1'   = 'UTF8BOM'
        '.ps1xml' = 'UTF8BOM'
        '.cs'     = 'UTF8'
        '.csx'    = 'UTF8'
        '.html'   = 'UTF8'
        '.htm'    = 'UTF8'
        '.css'    = 'UTF8'
        '.js'     = 'UTF8'
        '.json'   = 'UTF8'
        '.xml'    = 'UTF8'
        '.txt'    = 'UTF8'
        '.md'     = 'UTF8'
        '.py'     = 'UTF8'
        '.rb'     = 'UTF8'
        '.sh'     = 'UTF8'
        '.bat'    = 'UTF8'
        '.cmd'    = 'UTF8'
        '.config' = 'UTF8'
        '.ini'    = 'UTF8'
        '.yaml'   = 'UTF8'
        '.yml'    = 'UTF8'
    }

    # Determine target extensions
    if ($PSCmdlet.ParameterSetName -eq 'FileType') {
        $targetExtensions = $fileTypeMappings[$FileType]
        Write-Verbose "Analyzing $FileType file type: $($targetExtensions -join ', ')"
    } else {
        # Normalize extensions (ensure they start with a dot)
        $targetExtensions = $Extensions | ForEach-Object {
            if ($_.StartsWith('.')) { $_ } else { ".$_" }
        }
        Write-Verbose "Target extensions: $($targetExtensions -join ', ')"
    }

    # Load encoding detection function
    if (-not (Get-Command Get-FileEncoding -ErrorAction SilentlyContinue)) {
        throw "Get-FileEncoding function not found. Please ensure the encoding detection module is loaded."
    }

    # Collect all files to analyze
    $allFiles = @()
    $summary = @{
        TotalDirectories     = $Path.Count
        ProcessedDirectories = 0
        TotalFiles           = 0
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

    Write-Verbose "Analyzing $($allFiles.Count) files across $($summary.ProcessedDirectories) directories"

    # Analyze file encodings
    $encodingDistribution = @{}
    $extensionAnalysis = @{}
    $fileDetails = @()
    $inconsistentExtensions = @()

    $progressCounter = 0
    foreach ($file in $allFiles) {
        $progressCounter++
        $percentComplete = [math]::Round(($progressCounter / $allFiles.Count) * 100, 1)

        Write-Progress -Activity "Analyzing file encodings" -Status "Processing $($file.Name) ($progressCounter of $($allFiles.Count))" -PercentComplete $percentComplete

        try {
            $encoding = Get-FileEncoding -Path $file.FullName
            $extension = $file.Extension.ToLower()

            # Update encoding distribution
            if ($encodingDistribution.ContainsKey($encoding)) {
                $encodingDistribution[$encoding]++
            } else {
                $encodingDistribution[$encoding] = 1
            }

            # Update extension analysis
            if (-not $extensionAnalysis.ContainsKey($extension)) {
                $extensionAnalysis[$extension] = @{}
            }
            if ($extensionAnalysis[$extension].ContainsKey($encoding)) {
                $extensionAnalysis[$extension][$encoding]++
            } else {
                $extensionAnalysis[$extension][$encoding] = 1
            }

            # Store file details if requested
            if ($ShowFiles) {
                $recommendedEncoding = if ($RecommendTarget -and $encodingRecommendations.ContainsKey($extension)) {
                    $encodingRecommendations[$extension]
                } else {
                    $null
                }

                $fileDetails += [PSCustomObject]@{
                    FullPath            = $file.FullName
                    RelativePath        = $file.FullName.Replace((Get-Location).Path, '.').TrimStart('\', '/')
                    Extension           = $extension
                    CurrentEncoding     = $encoding
                    RecommendedEncoding = $recommendedEncoding
                    NeedsConversion     = $recommendedEncoding -and ($encoding -ne $recommendedEncoding)
                    Size                = $file.Length
                    LastModified        = $file.LastWriteTime
                }
            }

        } catch {
            Write-Warning "Could not analyze encoding for '$($file.FullName)': $($_.Exception.Message)"
            continue
        }
    }

    Write-Progress -Activity "Analyzing file encodings" -Completed

    # Identify extensions with mixed encodings
    foreach ($ext in $extensionAnalysis.Keys) {
        if ($extensionAnalysis[$ext].Keys.Count -gt 1) {
            $inconsistentExtensions += $ext
        }
    }

    # Generate recommendations
    $recommendations = @()
    if ($RecommendTarget) {
        foreach ($ext in $targetExtensions) {
            $recommendedEncoding = $encodingRecommendations[$ext]
            if ($recommendedEncoding -and $extensionAnalysis.ContainsKey($ext)) {
                $currentEncodings = $extensionAnalysis[$ext]
                $needsConversion = $currentEncodings.Keys | Where-Object { $_ -ne $recommendedEncoding }

                if ($needsConversion) {
                    $totalFiles = ($currentEncodings.Values | Measure-Object -Sum).Sum
                    $nonCompliantFiles = $needsConversion | ForEach-Object { $currentEncodings[$_] } | Measure-Object -Sum | Select-Object -ExpandProperty Sum

                    $recommendations += [PSCustomObject]@{
                        Extension           = $ext
                        RecommendedEncoding = $recommendedEncoding
                        TotalFiles          = $totalFiles
                        CompliantFiles      = $totalFiles - $nonCompliantFiles
                        NonCompliantFiles   = $nonCompliantFiles
                        CurrentEncodings    = $currentEncodings
                    }
                }
            }
        }
    }

    # Build summary
    $summary.EndTime = Get-Date
    $summary.Duration = $summary.EndTime - $summary.StartTime
    $summary.UniqueEncodings = $encodingDistribution.Keys.Count
    $summary.MostCommonEncoding = ($encodingDistribution.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Key
    $summary.HasMixedEncodings = $inconsistentExtensions.Count -gt 0
    $summary.InconsistentExtensions = $inconsistentExtensions

    Write-Verbose "Analysis completed: $($summary.TotalFiles) files, $($summary.UniqueEncodings) unique encodings"
    Write-Verbose "Most common encoding: $($summary.MostCommonEncoding)"
    if ($summary.HasMixedEncodings) {
        Write-Verbose "Extensions with mixed encodings: $($inconsistentExtensions -join ', ')"
    }

    # Build result object
    $result = [PSCustomObject]@{
        Summary              = [PSCustomObject]@{
            TotalDirectories       = $summary.TotalDirectories
            ProcessedDirectories   = $summary.ProcessedDirectories
            TotalFiles             = $summary.TotalFiles
            UniqueEncodings        = $summary.UniqueEncodings
            MostCommonEncoding     = $summary.MostCommonEncoding
            HasMixedEncodings      = $summary.HasMixedEncodings
            InconsistentExtensions = $summary.InconsistentExtensions
            Duration               = $summary.Duration
            StartTime              = $summary.StartTime
            EndTime                = $summary.EndTime
        }
        EncodingDistribution = $encodingDistribution
        Files                = if ($ShowFiles) { $fileDetails } else { $null }
        Recommendations      = if ($RecommendTarget) { $recommendations } else { $null }
    }

    if ($GroupByExtension) {
        $result | Add-Member -NotePropertyName 'ExtensionAnalysis' -NotePropertyValue $extensionAnalysis
    }

    # Add a display summary method for better default output
    $result | Add-Member -MemberType ScriptMethod -Name 'DisplaySummary' -Value {
        Write-Host ""
        Write-Host "📊 Folder Encoding Analysis Summary" -ForegroundColor Green
        Write-Host "=================================="
        Write-Host "📁 Directories analyzed: $($this.Summary.ProcessedDirectories)" -ForegroundColor Cyan
        Write-Host "📄 Total files found: $($this.Summary.TotalFiles)" -ForegroundColor Cyan
        Write-Host "🔤 Unique encodings: $($this.Summary.UniqueEncodings)" -ForegroundColor Cyan
        Write-Host "⭐ Most common encoding: $($this.Summary.MostCommonEncoding)" -ForegroundColor Green
        Write-Host "⚠️  Mixed encodings: $($this.Summary.HasMixedEncodings)" -ForegroundColor $(if ($this.Summary.HasMixedEncodings) { 'Yellow' } else { 'Green' })

        if ($this.Summary.HasMixedEncodings) {
            Write-Host "📝 Inconsistent extensions: $($this.Summary.InconsistentExtensions -join ', ')" -ForegroundColor Yellow
        }

        Write-Host ""
        Write-Host "📈 Encoding Distribution:" -ForegroundColor Blue
        $this.EncodingDistribution.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
            $percentage = [math]::Round(($_.Value / $this.Summary.TotalFiles) * 100, 1)
            Write-Host "  $($_.Key): $($_.Value) files ($percentage%)" -ForegroundColor White
        }

        if ($this.Recommendations -and $this.Recommendations.Count -gt 0) {
            Write-Host ""
            Write-Host "💡 Recommendations:" -ForegroundColor Magenta
            foreach ($rec in $this.Recommendations) {
                Write-Host "  $($rec.Extension) files:" -ForegroundColor White
                Write-Host "    Target encoding: $($rec.RecommendedEncoding)" -ForegroundColor Green
                Write-Host "    Files needing conversion: $($rec.NonCompliantFiles)/$($rec.TotalFiles)" -ForegroundColor Yellow
            }
        }

        Write-Host ""
        Write-Host "⏱️  Analysis duration: $($this.Summary.Duration.TotalSeconds.ToString('F2')) seconds" -ForegroundColor Gray
    }

    # Add a custom ToString method for better default display
    $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Value {
        return "Folder Encoding Analysis: $($this.Summary.TotalFiles) files, $($this.Summary.UniqueEncodings) encodings, Most common: $($this.Summary.MostCommonEncoding)"
    } -Force

    return $result
}
