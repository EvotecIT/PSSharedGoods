function Set-FileOwner {
    <#
    .SYNOPSIS
    Sets the owner of a file or folder.

    .DESCRIPTION
    This function sets the owner of a specified file or folder to the provided owner.

    .PARAMETER Path
    Specifies the path to the file or folder.

    .PARAMETER Recursive
    Indicates whether to process the items in the specified path recursively.

    .PARAMETER Owner
    Specifies the new owner for the file or folder.

    .PARAMETER Exclude
    Specifies an array of owners to exclude from ownership change.

    .PARAMETER JustPath
    Indicates whether to only change the owner of the specified path without recursing into subfolders.

    .EXAMPLE
    Set-FileOwner -Path "C:\Example\File.txt" -Owner "DOMAIN\User1"

    Description:
    Sets the owner of the file "File.txt" to "DOMAIN\User1".

    .EXAMPLE
    Set-FileOwner -Path "C:\Example\Folder" -Owner "DOMAIN\User2" -Recursive

    Description:
    Sets the owner of the folder "Folder" and all its contents to "DOMAIN\User2" recursively.

    #>
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [Array] $Path,
        [switch] $Recursive,
        [string] $Owner,
        [string[]] $Exlude,
        [switch] $JustPath
    )
    <#
    System.Security.Principal.NTAccount new(string domainName, string accountName)
    System.Security.Principal.NTAccount new(string name)
    #>
    Begin { }
    Process {
        foreach ($P in $Path) {
            if ($P -is [System.IO.FileSystemInfo]) {
                $FullPath = $P.FullName
            } elseif ($P -is [string]) {
                $FullPath = $P
            }
            $OwnerTranslated = [System.Security.Principal.NTAccount]::new($Owner)
            if ($FullPath -and (Test-Path -Path $FullPath)) {
                if ($JustPath) {
                    $FullPath | ForEach-Object -Process {
                        $File = $_
                        try {
                            $ACL = Get-Acl -Path $File -ErrorAction Stop
                        } catch {
                            Write-Warning "Set-FileOwner - Getting ACL failed with error: $($_.Exception.Message)"
                        }
                        if ($ACL.Owner -notin $Exlude -and $ACL.Owner -ne $OwnerTranslated) {
                            if ($PSCmdlet.ShouldProcess($File, "Replacing owner $($ACL.Owner) to $OwnerTranslated")) {
                                try {
                                    $ACL.SetOwner($OwnerTranslated)
                                    Set-Acl -Path $File -AclObject $ACL -ErrorAction Stop
                                } catch {
                                    Write-Warning "Set-FileOwner - Replacing owner $($ACL.Owner) to $OwnerTranslated failed with error: $($_.Exception.Message)"
                                }
                            }
                        }
                    }
                } else {
                    Get-ChildItem -LiteralPath $FullPath -Recurse:$Recursive -ErrorAction SilentlyContinue -ErrorVariable err | ForEach-Object -Process {
                        $File = $_
                        try {
                            $ACL = Get-Acl -Path $File.FullName -ErrorAction Stop
                        } catch {
                            Write-Warning "Set-FileOwner - Getting ACL failed with error: $($_.Exception.Message)"
                        }
                        if ($ACL.Owner -notin $Exlude -and $ACL.Owner -ne $OwnerTranslated) {
                            if ($PSCmdlet.ShouldProcess($File.FullName, "Replacing owner $($ACL.Owner) to $OwnerTranslated")) {
                                try {
                                    $ACL.SetOwner($OwnerTranslated)
                                    Set-Acl -Path $File.FullName -AclObject $ACL -ErrorAction Stop
                                } catch {
                                    Write-Warning "Set-FileOwner - Replacing owner $($ACL.Owner) to $OwnerTranslated failed with error: $($_.Exception.Message)"
                                }
                            }
                        }
                    }
                    foreach ($e in $err) {
                        Write-Warning "Set-FileOwner - Errors processing $($e.Exception.Message) ($($e.CategoryInfo.Reason))"
                    }
                }
            }
        }
    }
    End {

    }
}