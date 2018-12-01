function Remove-WhiteSpace {
    param(
        [string] $Text
    )
    $Text = $Text -replace '(^\s+|\s+$)','' -replace '\s+',' '
    return $Text
}
<#
$MyValue = Remove-WhiteSpace -Text 'My Field  '
Write-Color $MyValue, 'No' -Color White, Yellow

#>