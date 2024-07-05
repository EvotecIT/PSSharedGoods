function ConvertTo-SID {
    <#
    .SYNOPSIS
    Converts a given identity to a Security Identifier (SID).

    .DESCRIPTION
    This function takes one or more identity strings and converts them to their corresponding Security Identifiers (SIDs). It caches the results for faster lookup.

    .PARAMETER Identity
    Specifies the identity strings to be converted to SIDs.

    .EXAMPLE
    ConvertTo-SID -Identity 'Administrator'
    Converts the 'Administrator' identity to its corresponding SID.

    .EXAMPLE
    ConvertTo-SID -Identity 'Guest', 'User1'
    Converts the 'Guest' and 'User1' identities to their corresponding SIDs.

    #>
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