function Remove-WhiteSpace {
    <#
    .SYNOPSIS
    Removes leading, trailing, and extra white spaces from a given text string.

    .DESCRIPTION
    The Remove-WhiteSpace function removes any leading, trailing, and extra white spaces from the input text string. It ensures that only single spaces separate words within the text.

    .PARAMETER Text
    The input text string from which white spaces are to be removed.

    .EXAMPLE
    $MyValue = Remove-WhiteSpace -Text '   My    Field  '
    # $MyValue now contains 'My Field'

    #>
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