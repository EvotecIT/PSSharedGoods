function Convert-ExchangeEmail {
    <#
    .SYNOPSIS
    Converts a list of Exchange email addresses into a readable and exportable format.
    
    .DESCRIPTION
    This function takes a list of Exchange email addresses and processes them to make them more readable and suitable for export.
    
    .PARAMETER Emails
    List of email addresses in Exchange or Exchange Online format, also known as proxy addresses.
    
    .PARAMETER Separator
    The separator to use between each processed email address. Default is ', '.
    
    .PARAMETER RemoveDuplicates
    Switch to remove duplicate email addresses from the list.
    
    .PARAMETER RemovePrefix
    Switch to remove any prefixes like 'SMTP:', 'SIP:', 'spo:', etc. from the email addresses.
    
    .PARAMETER AddSeparator
    Switch to join the processed email addresses using the specified separator.
    
    .EXAMPLE
    $Emails = @()
    $Emails += 'SIP:test@email.com'
    $Emails += 'SMTP:elo@maiu.com'
    $Emails += 'sip:elo@maiu.com'
    $Emails += 'Spo:dfte@sdsd.com'
    $Emails += 'SPO:myothertest@sco.com'

    Convert-ExchangeEmail -Emails $Emails -RemovePrefix -RemoveDuplicates -AddSeparator
    #>
    #>
    
    [CmdletBinding()]
    param(
        [string[]] $Emails,
        [string] $Separator = ', ',
        [switch] $RemoveDuplicates,
        [switch] $RemovePrefix,
        [switch] $AddSeparator
    )

    if ($RemovePrefix) {
        #$Emails = $Emails.Replace('SMTP:', '').Replace('SIP:', '').Replace('smtp:', '').Replace('sip:', '').Replace('spo:','')
        $Emails = $Emails -replace 'smtp:', '' -replace 'sip:', '' -replace 'spo:', ''
    }
    if ($RemoveDuplicates) {
        $Emails = $Emails | Sort-Object -Unique
    }
    if ($AddSeparator) {
        $Emails = $Emails -join $Separator
    }
    return $Emails
}