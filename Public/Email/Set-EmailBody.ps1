function Set-EmailBody($TableData, $TableWelcomeMessage) {
    $body = "<p><i>$TableWelcomeMessage</i>"
    if ($($TableData | Measure-Object).Count -gt 0) {
        $body += $TableData | ConvertTo-Html -Fragment | Out-String
        $body += "</p>"
    } else {
        $body += "<br><i>No changes happend during that period.</i></p>"
    }
    return $body
}