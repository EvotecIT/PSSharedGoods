function Remove-WhiteSpace {
    param(
        [string] $Text
    )
    $Text = $Text -replace '(^\s+|\s+$)','' -replace '\s+',' '
    return $Text
}