function Set-EmailBodyPreparedTable ($TableData, $TableWelcomeMessage) {
    $body = "<p><i><u>$TableWelcomeMessage</u></i></p>"
    $body += $TableData
    return $body
}