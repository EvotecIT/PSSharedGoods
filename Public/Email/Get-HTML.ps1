function Get-HTML {
    [CmdletBinding()]
    param (
        $text
    )
    $text = $text.Split("`r")
    foreach ($t in $text) {
        Write-Host $t
    }
}