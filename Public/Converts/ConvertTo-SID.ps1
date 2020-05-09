function ConvertTo-SID {
    [cmdletBinding()]
    param(
        [string[]] $Identity
    )
    Begin {
        if (-not $Script:GlobalCacheSidConvert) {
            $Script:GlobalCacheSidConvert = @{ }
        }
    }
    Process {
        foreach ($Ident in $Identity) {
            if ($Script:GlobalCacheSidConvert[$Ident]) {
                $Script:GlobalCacheSidConvert[$Ident]
            } else {
                try {
                    $Script:GlobalCacheSidConvert[$Ident] = [PSCustomObject] @{
                        Name  = $Ident
                        Sid   = ([System.Security.Principal.NTAccount] $Ident).Translate([System.Security.Principal.SecurityIdentifier]).Value
                        Error = ''
                    }
                } catch {
                    [PSCustomObject] @{
                        Name  = $Ident
                        Sid   = ''
                        Error = $_.Exception.Message
                    }
                }
                $Script:GlobalCacheSidConvert[$Ident]
            }
        }
    }
    End {

    }
}