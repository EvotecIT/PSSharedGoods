
<#
Format-ToTitleCase 'me'

'me i feel good' | Format-ToTitleCase

'me i feel', 'not feel' |Format-ToTitleCase
#>

function Format-ToTitleCase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)][string[]] $Text
    )
    Begin {}
    Process {
        $Conversion = foreach ($T in $Text) {
            (Get-Culture).TextInfo.ToTitleCase($T)
        }
    }
    End {
        return $Conversion
    }
}