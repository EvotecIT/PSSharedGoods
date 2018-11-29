Function Convert-UAC {
    <#
    .SYNOPSIS
        Converts values from Events into proper format

    .DESCRIPTION
        Converts values from Events into proper format

    .PARAMETER UAC
        Parameter description

    .EXAMPLE
        Convert-UAC -UAC '%%1793'
        Convert-UAC -UAC '1793'
        Output: TEMP_DUPLICATE_ACCOUNT, NORMAL_ACCOUNT, RESERVED

        Convert-UAC -UAC '1793', '1794'

        Convert-UAC -UAC '121793'
        Output: PASSWD_CANT_CHANGE, ENCRYPTED_TEXT_PWD_ALLOWED, TEMP_DUPLICATE_ACCOUNT, NORMAL_ACCOUNT, INTERDOMAIN_TRUST_ACCOUNT, WORKSTATION_TRUST_ACCOUNT, RESERVED, RESERVED, DONT_EXPIRE_PASSWORD

        Convert-UAC -UAC 'C:\Onet33'
        Output: Same input as output

        Convert-UAC -UAC '121793' -OutputPerLine
        Output: One entry per line
            PASSWD_CANT_CHANGE
            ENCRYPTED_TEXT_PWD_ALLOWED
            TEMP_DUPLICATE_ACCOUNT
            NORMAL_ACCOUNT
            INTERDOMAIN_TRUST_ACCOUNT
            WORKSTATION_TRUST_ACCOUNT
            RESERVED
            RESERVED
            DONT_EXPIRE_PASSWORD

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string[]] $UAC,
        [string] $Separator
    )
    $Output = foreach ($String in $UAC) {
        $NumberAsString = $String.Replace('%', '') -as [int]
        if ($null -eq $NumberAsString) {
            return $UAC
        }

        $PropertyFlags = @(
            "SCRIPT",
            "ACCOUNTDISABLE",
            "RESERVED",
            "HOMEDIR_REQUIRED",
            "LOCKOUT",
            "PASSWD_NOTREQD",
            "PASSWD_CANT_CHANGE",
            "ENCRYPTED_TEXT_PWD_ALLOWED",
            "TEMP_DUPLICATE_ACCOUNT",
            "NORMAL_ACCOUNT",
            "RESERVED",
            "INTERDOMAIN_TRUST_ACCOUNT",
            "WORKSTATION_TRUST_ACCOUNT",
            "SERVER_TRUST_ACCOUNT",
            "RESERVED",
            "RESERVED",
            "DONT_EXPIRE_PASSWORD",
            "MNS_LOGON_ACCOUNT",
            "SMARTCARD_REQUIRED",
            "TRUSTED_FOR_DELEGATION",
            "NOT_DELEGATED",
            "USE_DES_KEY_ONLY",
            "DONT_REQ_PREAUTH",
            "PASSWORD_EXPIRED",
            "TRUSTED_TO_AUTH_FOR_DELEGATION",
            "RESERVED",
            "PARTIAL_SECRETS_ACCOUNT"
            "RESERVED"
            "RESERVED"
            "RESERVED"
            "RESERVED"
            "RESERVED"
        )
        1..($PropertyFlags.Length) | Where-Object { $NumberAsString -bAnd [math]::Pow(2, $_)} | ForEach-Object {$PropertyFlags[$_]}
    }
    if ($Separator -eq '') {
        $Output
    } else {
        $Output -join $Separator
    }
}