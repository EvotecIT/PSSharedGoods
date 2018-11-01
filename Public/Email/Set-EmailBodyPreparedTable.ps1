function Set-EmailBodyPreparedTable ($TableData, $TableWelcomeMessage) {
    $body = "<p><i>$TableWelcomeMessage</i>"
    $body += $TableData
    return $body
}