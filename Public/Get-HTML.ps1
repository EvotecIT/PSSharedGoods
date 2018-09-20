function Get-HTML($text) {
    $text = $text.Split("`r")
    foreach ($t in $text) {
        Write-Host $t
    }
}