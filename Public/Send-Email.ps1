function Send-Email ([hashtable] $EmailParameters, [string] $Body = "", $Attachment = $null, [string] $Subject = "", $To = "") {
    #     $SendMail = Send-Email -EmailParameters $EmailParameters -Body $EmailBody -Attachment $Reports -Subject $TemporarySubject
    #  Preparing the Email properties
    $SmtpClient = New-Object -TypeName system.net.mail.smtpClient
    $SmtpClient.host = $EmailParameters.EmailServer

    # Adding parameters to login to server
    $SmtpClient.Port = $EmailParameters.EmailServerPort
    if ($EmailParameters.EmailServerLogin -ne "") {
        $SmtpClient.Credentials = New-Object System.Net.NetworkCredential($EmailParameters.EmailServerLogin, $EmailParameters.EmailServerPassword)
    }
    $SmtpClient.EnableSsl = $EmailParameters.EmailServerEnableSSL
    $MailMessage = New-Object -TypeName system.net.mail.mailmessage
    $MailMessage.From = $EmailParameters.EmailFrom
    if ($To -ne "") {
        foreach ($T in $To) { $MailMessage.To.add($($T)) }
    } else {
        if ($EmailParameters.Emailto -ne "") {
            foreach ($To in $EmailParameters.Emailto) { $MailMessage.To.add($($To)) }
        }
    }
    if ($EmailParameters.EmailCC -ne "") {
        foreach ($CC in $EmailParameters.EmailCC) { $MailMessage.CC.add($($CC)) }
    }
    if ($EmailParameters.EmailBCC -ne "") {
        foreach ($BCC in $EmailParameters.EmailBCC) { $MailMessage.BCC.add($($BCC)) }
    }
    $Exists = Test-Key $EmailParameters "EmailParameters" "EmailReplyTo" -DisplayProgress $false
    if ($Exists -eq $true) {
        if ($EmailParameters.EmailReplyTo -ne "") {
            $MailMessage.ReplyTo = $EmailParameters.EmailReplyTo
        }
    }
    $MailMessage.IsBodyHtml = 1
    if ($Subject -eq "") {
        $MailMessage.Subject = $EmailParameters.EmailSubject
    } else {
        $MailMessage.Subject = $Subject
    }
    $MailMessage.Body = $Body
    $MailMessage.Priority = [System.Net.Mail.MailPriority]::$($EmailParameters.EmailPriority)

    #  Encoding
    $MailMessage.BodyEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)
    $MailMessage.SubjectEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)

    #  Attaching file (s)
    if ($Attachment -ne $null) {
        foreach ($Attach in $Attachment) {
            if (Test-Path $Attach) {
                $File = new-object Net.Mail.Attachment($Attach)
                $MailMessage.Attachments.Add($File)
            }
        }
    }

    #  Sending the Email
    try {
        $SmtpClient.Send($MailMessage)
        #$att.Dispose();
        $MailMessage.Dispose();
        return @{
            Status = $True
            Error  = ""
        }
    } catch {
        $MailMessage.Dispose();
        return @{
            Status = $False
            Error  = $($_.Exception.Message)
        }
    }
}