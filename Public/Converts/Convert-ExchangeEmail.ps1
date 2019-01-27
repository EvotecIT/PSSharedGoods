function Convert-ExchangeEmail {
    <#
    .SYNOPSIS
    Function that helps converting Exchange email address list into readable, exportable format.
    
    .DESCRIPTION
        Function that helps converting Exchange email address list into readable, exportable format.
    
    .PARAMETER Emails
    List of emails as available in Exchange or Exchange Online, otherwise known as proxy addresses list
    
    .PARAMETER Separator
    
    .PARAMETER RemoveDuplicates
    
    .PARAMETER RemovePrefix
    
    .PARAMETER AddSeparator
    
    .EXAMPLE
    
    $Emails = @()
    $Emails += 'SIP:test@email.com'
    $Emails += 'SMTP:elo@maiu.com'
    $Emails += 'sip:elo@maiu.com'
    $Emails += 'Spo:dfte@sdsd.com'
    $Emails += 'SPO:myothertest@sco.com'

    Convert-ExchangeEmail -Emails $Emails -RemovePrefix -RemoveDuplicates -AddSeparator
    
    .NOTES
    General notes
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