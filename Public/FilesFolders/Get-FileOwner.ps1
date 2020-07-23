function Get-FileOwner {
    [cmdletBinding()]
    param(
        [Array] $Path,
        [switch] $Recursive,
        [switch] $JustPath,
        [switch] $Resolve,
        [switch] $AsHashTable
    )
    Begin {

    }
    Process {
        foreach ($P in $Path) {
            if ($P -is [System.IO.FileSystemInfo]) {
                $FullPath = $P.FullName
            } elseif ($P -is [string]) {
                $FullPath = $P
            }
            if ($FullPath -and (Test-Path -Path $FullPath)) {
                if ($JustPath) {
                    $FullPath | ForEach-Object -Process {
                        # $File = $_
                        $ACL = Get-Acl -Path $_
                        $Object = [ordered]@{
                            FullName = $_
                            Owner    = $ACL.Owner
                        }
                        if ($Resolve) {
                            $Identity = Convert-Identity -Identity $ACL.Owner
                            if ($Identity) {
                                $Object['OwnerName'] = $Identity.Name
                                $Object['OwnerSid'] = $Identity.SID
                                $Object['OwnerType'] = $Identity.Type
                            } else {
                                $Object['OwnerName'] = ''
                                $Object['OwnerSid'] = ''
                                $Object['OwnerType'] = ''
                            }
                        }
                        if ($AsHashTable) {
                            $Object
                        } else {
                            [PSCustomObject] $Object
                        }
                    }
                } else {
                    Get-ChildItem -LiteralPath $FullPath -Recurse:$Recursive | ForEach-Object -Process {
                        $File = $_
                        $ACL = Get-Acl -Path $File.FullName
                        $Object = [ordered] @{
                            FullName       = $_.FullName
                            Extension      = $_.Extension
                            CreationTime   = $_.CreationTime
                            LastAccessTime = $_.LastAccessTime
                            LastWriteTime  = $_.LastWriteTime
                            Attributes     = $_.Attributes
                            Owner          = $ACL.Owner
                        }
                        if ($Resolve) {
                            $Identity = Convert-Identity -Identity $ACL.Owner
                            if ($Identity) {
                                $Object['OwnerName'] = $Identity.Name
                                $Object['OwnerSid'] = $Identity.SID
                                $Object['OwnerType'] = $Identity.Type
                            } else {
                                $Object['OwnerName'] = ''
                                $Object['OwnerSid'] = ''
                                $Object['OwnerType'] = ''
                            }
                        }
                        if ($AsHashTable) {
                            $Object
                        } else {
                            [PSCustomObject] $Object
                        }
                    }
                }
            }
        }
    }
    End {

    }
}