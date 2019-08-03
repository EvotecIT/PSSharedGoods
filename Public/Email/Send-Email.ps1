function Send-Email {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [alias('EmailParameters')][System.Collections.IDictionary] $Email,
        [string] $Body = "",
        [string[]] $Attachment,
        [System.Collections.IDictionary] $InlineAttachments,
        [string] $Subject = "",
        [string[]] $To,
        [PSCustomObject] $Logger
    )
    try {
        # Following code makes sure both formats are accepted.
        if ($Email.EmailTo) {
            $EmailParameters = $Email.Clone()
        } else {
            $EmailParameters = @{
                EmailFrom                   = $Email.From
                EmailTo                     = $Email.To
                EmailCC                     = $Email.CC
                EmailBCC                    = $Email.BCC
                EmailReplyTo                = $Email.ReplyTo
                EmailServer                 = $Email.Server
                EmailServerPassword         = $Email.Password
                EmailServerPasswordAsSecure = $Email.PasswordAsSecure
                EmailServerPasswordFromFile = $Email.PasswordFromFile
                EmailServerPort             = $Email.Port
                EmailServerLogin            = $Email.Login
                EmailServerEnableSSL        = $Email.EnableSsl
                EmailEncoding               = $Email.Encoding
                EmailSubject                = $Email.Subject
                EmailPriority               = $Email.Priority
            }
        }
    } catch {
        return @{
            Status = $False
            Error  = $($_.Exception.Message)
            SentTo = ""
        }
    }
    $SmtpClient = New-Object -TypeName System.Net.Mail.SmtpClient
    if ($EmailParameters.EmailServer) {
        $SmtpClient.Host = $EmailParameters.EmailServer
    } else {
        return @{
            Status = $False
            Error  = "Email Server Host is not set."
            SentTo = ""
        }
    }
    # Adding parameters to login to server
    if ($EmailParameters.EmailServerPort) {
        $SmtpClient.Port = $EmailParameters.EmailServerPort
    } else {
        return @{
            Status = $False
            Error  = "Email Server Port is not set."
            SentTo = ""
        }
    }

    if ($EmailParameters.EmailServerLogin -ne '') {

        $Credentials = Request-Credentials -UserName $EmailParameters.EmailServerLogin `
            -Password $EmailParameters.EmailServerPassword `
            -AsSecure:$EmailParameters.EmailServerPasswordAsSecure `
            -FromFile:$EmailParameters.EmailServerPasswordFromFile `
            -NetworkCredentials #-Verbose
        $SmtpClient.Credentials = $Credentials
    }

    $SmtpClient.EnableSsl = $EmailParameters.EmailServerEnableSSL
    $MailMessage = New-Object -TypeName System.Net.Mail.MailMessage
    $MailMessage.From = $EmailParameters.EmailFrom
    if ($To) {
        foreach ($T in $To) { $MailMessage.To.add($($T)) }
    } else {
        if ($EmailParameters.Emailto) {
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
    $MailMessage.IsBodyHtml = $true
    if ($Subject -eq '') {
        $MailMessage.Subject = $EmailParameters.EmailSubject
    } else {
        $MailMessage.Subject = $Subject
    }

    $MailMessage.Priority = [System.Net.Mail.MailPriority]::$($EmailParameters.EmailPriority)

    #  Encoding
    $MailMessage.BodyEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)
    $MailMessage.SubjectEncoding = [System.Text.Encoding]::$($EmailParameters.EmailEncoding)

    # Inlining attachment (s)
    if ($PSBoundParameters.ContainsKey('InlineAttachments')) {
        $BodyPart = [Net.Mail.AlternateView]::CreateAlternateViewFromString( $Body, 'text/html' )
        $MailMessage.AlternateViews.Add( $BodyPart )
        foreach ( $Entry in $InlineAttachments.GetEnumerator() ) {
            try {

                $FilePath = $Entry.Value
                Write-Verbose $FilePath
                if ($Entry.Value.StartsWith('http')) {
                    $FileName = $Entry.Value.Substring($Entry.Value.LastIndexOf("/") + 1)
                    $FilePath = Join-Path $env:temp $FileName
                    Invoke-WebRequest -Uri $Entry.Value -OutFile $FilePath
                }
                $ContentType = Get-MimeType -FileName $FilePath
                $InAttachment = New-Object Net.Mail.LinkedResource($FilePath, $ContentType )
                $InAttachment.ContentId = $Entry.Key
                $BodyPart.LinkedResources.Add( $InAttachment )
            } catch {
                $MailMessage.Dispose()
                throw
            }
        }
    } else {
        $MailMessage.Body = $Body
    }

    #  Attaching file (s)
    if ($PSBoundParameters.ContainsKey('Attachment')) {
        foreach ($Attach in $Attachment) {
            if (Test-Path -LiteralPath $Attach) {
                try {
                    $File = New-Object Net.Mail.Attachment($Attach)
                    Write-Verbose "Send-Email - Attaching file $Attach"
                    $MailMessage.Attachments.Add($File)
                } catch {
                    # non critical error
                    $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                    if ($Logger) {
                        $Logger.AddErrorRecord("Error attaching file $Attach`: $ErrorMessage")
                    } else {
                        Write-Error "Error attaching file $Attach`: $ErrorMessage"
                    }
                }
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