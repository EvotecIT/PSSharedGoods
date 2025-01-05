function Remove-FileItem {
    <#
    .SYNOPSIS
    Removes one or more files and/or folders using one of three methods:
    Remove-Item, .NET Delete(), or move to Recycle Bin.

    .DESCRIPTION
    - If the path is a file, removes it in one shot.
    - If the path is a folder and -SkipFolder is NOT used, removes that folder
      in one shot (recursively if -Recursive is specified).
    - If -SkipFolder is used (and the path is a folder), calls Remove-ChildItems
      to remove only the folder's contents, leaving the folder itself.

    Supports:
     - RemoveItem, DotNetDelete, RecycleBin
     - Retries
     - WhatIf/Confirm
     - Passthru (detailed objects)
     - SimpleReturn (boolean overall result)

    .PARAMETER Paths
    One or more paths to files/folders.

    .PARAMETER DeleteMethod
    "RemoveItem", "DotNetDelete", or "RecycleBin". Defaults to "RemoveItem".

    .PARAMETER Recursive
    If set, allows recursive removal for folder contents.

    .PARAMETER SkipTopFolder
    If set for a folder, removes the contents only, not the folder itself.

    .PARAMETER Retries
    Specifies how many times to attempt removal before giving up. Defaults to 1.

    .PARAMETER Include
    Patterns (e.g., *.log) to include if removing child items individually.
    Will work only if SkipTopFolder is used.

    .PARAMETER Exclude
    Patterns (e.g., *.log) to exclude if removing child items individually.
    Will work only if SkipTopFolder is used.

    .PARAMETER Filter
    Filter for Get-ChildItem when removing child items individually.
    Will work only if SkipTopFolder is used.

    .PARAMETER Passthru
    Outputs an object for each path with details on success or failure.

    .PARAMETER SimpleReturn
    Outputs a single boolean indicating overall success or failure.

    .EXAMPLE
    Remove-FileItem -Paths "C:\SomeFolder" -DeleteMethod RemoveItem -Recursive -WhatIf

    Shows which items would be removed, but doesn't actually remove them,
    because -WhatIf is in effect.

    .EXAMPLE
    Remove-FileItem -Paths "C:\SomeFolder", "C:\SomeFile.txt" -Passthru -DeleteMethod DotNetDelete

    Removes both the folder (and everything in it) and the file, then returns details on each removal attempt.

    #>
    [Alias('Remove-ItemAlternative')]
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Include')]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)][Alias('LiteralPath', 'Path')][string[]] $Paths,

        [ValidateSet("RemoveItem", "DotNetDelete", "RecycleBin")]
        [string] $DeleteMethod = "RecycleBin",

        [switch] $Recursive,

        [alias('SkipFolder')][switch] $SkipTopFolder,

        [int] $Retries = 1,

        [Parameter(ParameterSetName = 'Include')][string[]] $Include,

        [Parameter(ParameterSetName = 'Exclude')][string[]] $Exclude,

        [string] $Filter,

        [switch] $Passthru,

        [switch] $SimpleReturn
    )

    begin {
        $Results = [System.Collections.Generic.List[PSObject]]::new()
        $AllSucceeded = $true
    }

    process {
        foreach ($Path in $Paths) {
            # Resolve the path (handles .\.. style paths).
            $UnresolvedFullPath = $null
            try {
                $UnresolvedFullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
            } catch {
                $UnresolvedFullPath = $null
            }

            if (-not $UnresolvedFullPath) {
                $Message = "Remove-FileItem - Unable to resolve path '$Path'."
                if ($PSCmdlet.ErrorAction -eq 'Stop') {
                    throw $Message
                } else {
                    Write-Warning -Message $Message
                }
                $AllSucceeded = $false

                if ($Passthru) {
                    $Results.Add(
                        [PSCustomObject]@{
                            Path         = $Path
                            Status       = $false
                            Reason       = "Path could not be resolved."
                            AttemptCount = 0
                            WhatIf       = $WhatIfPreference
                        }
                    )
                }
                continue
            }

            if (-not (Test-Path -LiteralPath $UnresolvedFullPath)) {
                $Message = "Remove-FileItem - Path '$UnresolvedFullPath' does not exist."
                if ($PSCmdlet.ErrorAction -eq 'Stop') {
                    throw $Message
                } else {
                    Write-Warning -Message $Message
                }
                $AllSucceeded = $false
                if ($Passthru) {
                    $Results.Add(
                        [PSCustomObject]@{
                            Path         = $UnresolvedFullPath
                            Status       = $false
                            Reason       = "Path does not exist."
                            AttemptCount = 0
                            WhatIf       = $WhatIfPreference
                        }
                    )
                }
                continue
            }

            $ItemInfo = Get-Item -LiteralPath $UnresolvedFullPath -Force
            $IsDirectory = $ItemInfo.PSIsContainer

            if ($IsDirectory -and $SkipTopFolder) {
                # Remove only the contents, not the folder itself
                $removeChildItemsSplat = @{
                    TopLevelPath    = $UnresolvedFullPath
                    DeleteMethod    = $DeleteMethod
                    Recursive       = $Recursive
                    Retries         = $Retries
                    Include         = $Include
                    Exclude         = $Exclude
                    Filter          = $Filter
                    Passthru        = $Passthru
                    Results         = $Results
                    AllSucceededRef = ([ref]$AllSucceeded)
                }
                Remove-ChildItems @removeChildItemsSplat
            } else {
                # Remove this path (file or folder) in one shot
                $Attempt = 0
                $Deleted = $false
                $LastError = $null
                $WhatIfUsed = $WhatIfPreference

                while ($Attempt -lt $Retries -and -not $Deleted) {
                    $Attempt++
                    Write-Verbose -Message "Remove-FileItem - Attempting to remove '$UnresolvedFullPath' (Attempt $Attempt of $Retries)."

                    if ($WhatIfUsed) {
                        $LastError = "Skipped because -WhatIf was used."
                    }
                    if ($PSCmdlet.ShouldProcess($UnresolvedFullPath, "Remove top-level")) {
                        # If -WhatIf is set, ShouldProcess prints a "What if: ..." message,
                        # but we can also choose to skip the removal logic to reflect the fact
                        # that it wasn't physically removed.
                        try {
                            switch ($DeleteMethod) {
                                'RemoveItem' {
                                    if ($IsDirectory -and $Recursive) {
                                        Remove-Item -LiteralPath $UnresolvedFullPath -Recurse -Force -ErrorAction Stop
                                    } else {
                                        Remove-Item -LiteralPath $UnresolvedFullPath -Force -ErrorAction Stop
                                    }
                                }
                                'DotNetDelete' {
                                    if ($IsDirectory) {
                                        $DirInfo = [System.IO.DirectoryInfo] $UnresolvedFullPath
                                        if ($Recursive) {
                                            $DirInfo.Delete($true)
                                        } else {
                                            $DirInfo.Delete()
                                        }
                                    } else {
                                        $FileInfo = [System.IO.FileInfo] $UnresolvedFullPath
                                        $FileInfo.Delete()
                                    }
                                }
                                'RecycleBin' {
                                    $Shell = [Activator]::CreateInstance([Type]::GetTypeFromProgID("Shell.Application"))
                                    $FolderPath = Split-Path $UnresolvedFullPath
                                    $Leaf = Split-Path $UnresolvedFullPath -Leaf
                                    $Folder = $Shell.NameSpace($FolderPath)
                                    if (-not $Folder) {
                                        throw "Could not open folder: $FolderPath"
                                    }
                                    $ShellItem = $Folder.ParseName($Leaf)
                                    if (-not $ShellItem) {
                                        throw "Item '$Leaf' not found in folder: $FolderPath"
                                    }
                                    $ShellItem.InvokeVerb("delete")
                                }
                            }
                            $Deleted = $true
                        } catch {
                            $LastError = $_.Exception.Message
                            Write-Verbose -Message "Remove-FileItem - Error deleting '$UnresolvedFullPath': $LastError"

                            if ($PSCmdlet.ErrorAction -eq 'Stop') {
                                if ($Attempt -ge $Retries) {
                                    throw "Remove-FileItem - Couldn't delete '$UnresolvedFullPath' after $Retries attempts. Error: $LastError"
                                }
                            } else {
                                if ($Attempt -ge $Retries) {
                                    Write-Warning -Message "Remove-FileItem - Couldn't delete '$UnresolvedFullPath' after $Retries attempts. Error: $LastError"
                                }
                            }
                        }
                    }
                    # If it wasn't actually deleted, we may loop again (retry).
                }

                if (-not $Deleted -and -not $WhatIfUsed) {
                    $AllSucceeded = $false
                }

                # If -WhatIf was used, we consider it "skipped" but not a real failure.
                if ($WhatIfUsed) {
                    $AllSucceeded = $false
                }

                if ($Passthru) {
                    $Results.Add(
                        [PSCustomObject]@{
                            Path         = $UnresolvedFullPath
                            Status       = $Deleted
                            Reason       = if ($Deleted) { $null } else { $LastError }
                            AttemptCount = $Attempt
                            WhatIf       = $WhatIfUsed
                        }
                    )
                }
            }
        }
    }
    end {
        if ($Passthru) {
            $Results
        } elseif ($SimpleReturn) {
            $AllSucceeded
        }
    }
}