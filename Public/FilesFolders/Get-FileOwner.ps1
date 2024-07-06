function Get-FileOwner {
    <#
    .SYNOPSIS
    Retrieves the owner of the specified file or folder.

    .DESCRIPTION
    This function retrieves the owner of the specified file or folder. It provides options to resolve the owner's identity and output the results as a hashtable or custom object.

    .PARAMETER Path
    Specifies the path to the file or folder.

    .PARAMETER Recursive
    Indicates whether to search for files recursively in subdirectories.

    .PARAMETER JustPath
    Specifies if only the path information should be returned.

    .PARAMETER Resolve
    Indicates whether to resolve the owner's identity.

    .PARAMETER AsHashTable
    Specifies if the output should be in hashtable format.

    .EXAMPLE
    Get-FileOwner -Path "C:\Example\File.txt"
    Retrieves the owner of the specified file "File.txt".

    .EXAMPLE
    Get-FileOwner -Path "C:\Example" -Recursive
    Retrieves the owners of all files in the "Example" directory and its subdirectories.

    .EXAMPLE
    Get-FileOwner -Path "C:\Example\File.txt" -Resolve
    Retrieves the owner of the specified file "File.txt" and resolves the owner's identity.

    .EXAMPLE
    Get-FileOwner -Path "C:\Example\File.txt" -AsHashTable
    Retrieves the owner of the specified file "File.txt" and outputs the result as a hashtable.

    #>
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
                    Get-ChildItem -LiteralPath $FullPath -Recurse:$Recursive -Force | ForEach-Object -Process {
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