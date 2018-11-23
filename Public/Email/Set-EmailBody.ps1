function Set-EmailBody {
    [CmdletBinding()]
    param(
        [Object] $TableData,
        [alias('TableWelcomeMessage')][string] $TableMessageWelcome,
        [string] $TableMessageNoData = 'No changes happened during that period.'
    )
    $Body = "<p><i>$TableMessageWelcome</i>"
    if ($($TableData | Measure-Object).Count -gt 0) {
        $Body += $TableData | ConvertTo-Html -Fragment | Out-String
        $Body += "</p>"
    } else {
        $Body += "<br><i>$TableMessageNoData</i></p>"
    }
    return $body
}