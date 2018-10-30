<#

$Emails = @()
$Emails += 'SIP:test@email.com'
$Emails += 'SMTP:elo@maiu.com'
$Emails += 'SIP:elo@maiu.com'

Convert-ExchangeEmail -Emails $Emails -RemovePrefix -RemoveDuplicates -AddSeparator
#>

function Convert-ExchangeEmail {
    [cmdletbinding()]
    param(
        [string[]] $Emails,
        [string] $Separator = ', ',
        [switch] $RemoveDuplicates,
        [switch] $RemovePrefix,
        [switch] $AddSeparator
    )

    if ($RemovePrefix) {
        $Emails = $Emails.Replace('SMTP:', '').Replace('SIP:', '')
    }
    if ($RemoveDuplicates) {
        $Emails = $Emails | Sort-Object -Unique
    }
    if ($AddSeparator) {
        $Emails = $Emails -join $Separator
    }
    return $Emails
}
