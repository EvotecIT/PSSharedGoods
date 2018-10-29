function Send-Email {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [hashtable] $EmailParameters,
        [string] $Body = "",
        [string[]] $Attachment,
        [hashtable]$InlineAttachments,
        [string] $Subject = "",
        [string] $To = ""
    )
    function Get-ContentType {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            [string]
            $FileName
        )

        $MimeMappings = @{
            '.jpeg' = 'image/jpeg'
            '.jpg'  = 'image/jpeg'
            '.png'  = 'image/png'
        }

        $Extension = [System.IO.Path]::GetExtension( $FileName )
        $ContentType = $MimeMappings[ $Extension ]

        if ([string]::IsNullOrEmpty($ContentType)) {
            return New-Object System.Net.Mime.ContentType
        } else {
            return New-Object System.Net.Mime.ContentType($ContentType)
        }
    }
    #  $SendMail = Send-Email -EmailParameters $EmailParameters -Body $EmailBody -Attachment $Reports -Subject $TemporarySubject
    #  Preparing the Email properties
    $SmtpClient = New-Object -TypeName System.Net.Mail.SmtpClient
    $SmtpClient.Host = $EmailParameters.EmailServer

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
    
    $BodyPart = [Net.Mail.AlternateView]::CreateAlternateViewFromString( $Body, 'text/html' )
    $MailMessage.AlternateViews.Add( $BodyPart )
    $MailMessage.Priority = [System.Net.Mail.MailPriority]::$($EmailParameters.EmailPriority)

    #  Encoding
    $MailMessage.BodyEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)
    $MailMessage.SubjectEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)

    # Inlining attachment (s)
    if ($PSBoundParameters.ContainsKey('InlineAttachments')) {
        foreach ( $Entry in $InlineAttachments.GetEnumerator() ) {
            try {
                $FilePath = $Entry.Value
                if ($Entry.Value.StartsWith('http')) {
                    $FileName = $Entry.Value.Substring($Entry.Value.LastIndexOf("/") + 1)
                    $FilePath = Join-Path $env:temp $FileName
                    Invoke-WebRequest -Uri $Entry.Value -OutFile $FilePath 
                }
                $ContentType = Get-ContentType -FileName $FilePath
                $InAttachment = New-Object Net.Mail.LinkedResource($FilePath, $ContentType )
                $InAttachment.ContentId = $Entry.Key
                $BodyPart.LinkedResources.Add( $InAttachment )
            } catch {
                $MailMessage.Dispose()
                throw
            }
        }
    }

    #  Attaching file (s)
    if ($PSBoundParameters.ContainsKey('Attachments')) {
        foreach ($Attach in $Attachment) {
            if (Test-Path $Attach) {
                $File = New-Object Net.Mail.Attachment($Attach)
                $MailMessage.Attachments.Add($File)
            }
        }
    }

    #  Sending the Email
    try {
        $MailSentTo = "$($MailMessage.To) $($MailMessage.CC) $($MailMessage.BCC)".Trim()
        if ($pscmdlet.ShouldProcess("$MailSentTo", "Send-Email")) {
            $SmtpClient.Send($MailMessage)
            #$att.Dispose();
            $MailMessage.Dispose();


            return @{
                Status = $True
                Error  = ""
                SentTo = $MailSentTo
            }
        }
    } catch {
        $MailMessage.Dispose();
        return @{
            Status = $False
            Error  = $($_.Exception.Message)
            SentTo = ""
        }
    }
}