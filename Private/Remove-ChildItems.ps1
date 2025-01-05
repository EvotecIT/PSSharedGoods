function Remove-ChildItems {
    <#
    .SYNOPSIS
    Helper function that removes the child items of a given folder.

    .DESCRIPTION
    - Enumerates the folder's contents (recursively if requested).
    - Removes each child item individually, respecting the chosen DeleteMethod.
    - Respects -WhatIf and -Confirm (because of CmdletBinding with SupportsShouldProcess).
    - Records attempts in Passthru objects if desired.

    .PARAMETER TopLevelPath
    Specifies the path to the folder whose contents are to be removed.

    .PARAMETER DeleteMethod
    Specifies the removal method: RemoveItem, DotNetDelete, or RecycleBin.

    .PARAMETER Recursive
    Specifies whether to enumerate child items recursively.

    .PARAMETER Retries
    Number of retry attempts for each item.

    .PARAMETER Include
    Include patterns for Get-ChildItem.

    .PARAMETER Exclude
    Exclude patterns for Get-ChildItem.

    .PARAMETER Filter
    Filter for Get-ChildItem.

    .PARAMETER Passthru
    If true, records results in $Results.

    .PARAMETER Results
    [System.Collections.Generic.List[PSObject]] passed in from the parent function.

    .PARAMETER AllSucceededRef
    [ref] reference to a boolean tracking overall success/failure.

    .EXAMPLE
    Remove-ChildItems -TopLevelPath "C:\Folder" -DeleteMethod RemoveItem -Recursive -WhatIf

    Shows (via WhatIf) which items would be removed inside "C:\Folder".
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string] $TopLevelPath,

        [Parameter(Mandatory)][ValidateSet("RemoveItem", "DotNetDelete", "RecycleBin")]
        [string] $DeleteMethod,

        [switch] $Recursive,

        [int] $Retries,

        [string[]] $Include,

        [string[]] $Exclude,

        [string] $Filter,

        [switch] $Passthru,

        [System.Collections.Generic.List[PSObject]] $Results,

        [ref] $AllSucceededRef
    )
    begin {
        Write-Verbose -Message "Remove-ItemAlternative - Removing contents of '$TopLevelPath' (SkipFolder)."
        $getChildItemSplat = @{
            LiteralPath = $TopLevelPath
            Force       = $true
            Include     = $Include
            Exclude     = $Exclude
            Filter      = $Filter
            ErrorAction = 'SilentlyContinue'
        }
        Remove-EmptyValue -Hashtable $getChildItemSplat

        $Items = Get-ChildItem @getChildItemSplat
        if ($Recursive) {
            $Items = $Items | Sort-Object -Property FullName -Descending
        }

        # Detect if -WhatIf was explicitly set on this function call
        $WhatIfUsed = $WhatIfPreference
    }
    process {
        foreach ($Item in $Items) {
            $Attempt = 0
            $Deleted = $false
            $LastError = $null

            while ($Attempt -lt $Retries -and -not $Deleted) {
                $Attempt++
                Write-Verbose -Message "Remove-ItemAlternative - Attempting to remove '$($Item.FullName)' (Attempt $Attempt of $Retries)."

                if ($WhatIfUsed) {
                    # If -WhatIf is on, skip the actual removal
                    $LastError = "Skipped because -WhatIf was used."
                }
                if ($PSCmdlet.ShouldProcess($Item.FullName, "Remove child item")) {
                    try {
                        switch ($DeleteMethod) {
                            'RemoveItem' {
                                if ($Recursive -and $Item.PSIsContainer) {
                                    Remove-Item -LiteralPath $Item.FullName -Recurse -Force -ErrorAction Stop
                                } else {
                                    Remove-Item -LiteralPath $Item.FullName -Force -ErrorAction Stop
                                }
                            }
                            'DotNetDelete' {
                                if ($Item.PSIsContainer) {
                                    $Dir = [System.IO.DirectoryInfo] $Item.FullName
                                    if ($Recursive) {
                                        $Dir.Delete($true)
                                    } else {
                                        $Dir.Delete()
                                    }
                                } else {
                                    $File = [System.IO.FileInfo] $Item.FullName
                                    $File.Delete()
                                }
                            }
                            'RecycleBin' {
                                $Shell = [Activator]::CreateInstance([Type]::GetTypeFromProgID("Shell.Application"))
                                $FolderPath = Split-Path $Item.FullName
                                $Leaf = Split-Path $Item.FullName -Leaf
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
                        Write-Verbose -Message "Remove-ItemAlternative - Error deleting '$($Item.FullName)': $LastError"

                        if ($PSCmdlet.ErrorAction -eq 'Stop') {
                            if ($Attempt -ge $Retries) {
                                throw "Remove-ItemAlternative - Couldn't delete '$($Item.FullName)' after $Retries attempts. Error: $LastError"
                            }
                        } else {
                            if ($Attempt -ge $Retries) {
                                Write-Warning -Message "Remove-ItemAlternative - Couldn't delete '$($Item.FullName)' after $Retries attempts. Error: $LastError"
                            }
                        }
                    }

                }
            }

            # If it wasn't actually deleted and not just a -WhatIf skip, mark overall failure
            if (-not $Deleted -and -not $WhatIfUsed) {
                $AllSucceededRef.Value = $false
            }

            if ($Passthru) {
                $Results.Add(
                    [PSCustomObject]@{
                        Path         = $Item.FullName
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