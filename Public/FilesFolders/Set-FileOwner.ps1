function Set-FileOwner {
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
                        $ACL = Get-Acl -Path $File
                        if ($ACL.Owner -notin $Exlude -and $ACL.Owner -ne $OwnerTranslated) {
                            if ($PSCmdlet.ShouldProcess($File, "Replacing owner $($ACL.Owner) to $OwnerTranslated")) {
                                try {
                                    $ACL.SetOwner($OwnerTranslated)
                                    Set-Acl -Path $File -AclObject $ACL
                                } catch {
                                    Write-Warning "Set-FileOwner - Replacing owner $($ACL.Owner) to $OwnerTranslated failed with error: $($_.Exception.Message)"
                                }
                            }
                        }
                    }
                } else {
                    Get-ChildItem -LiteralPath $FullPath -Recurse:$Recursive | ForEach-Object -Process {
                        $File = $_
                        $ACL = Get-Acl -Path $File.FullName
                        if ($ACL.Owner -notin $Exlude -and $ACL.Owner -ne $OwnerTranslated) {
                            if ($PSCmdlet.ShouldProcess($File.FullName, "Replacing owner $($ACL.Owner) to $OwnerTranslated")) {
                                try {
                                    $ACL.SetOwner($OwnerTranslated)
                                    Set-Acl -Path $File.FullName -AclObject $ACL
                                } catch {
                                    Write-Warning "Set-FileOwner - Replacing owner $($ACL.Owner) to $OwnerTranslated failed with error: $($_.Exception.Message)"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    End {

    }
}