Function Convert-UAC ([int]$UAC) {
    $PropertyFlags = @(s
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
    #Possibility 1: One property per line (commented because I use the second one)
    #1..($PropertyFlags.Length) | Where-Object {$UAC -bAnd [math]::Pow(2,$_)} | ForEach-Object {$PropertyFlags[$_]}

    #Possibility 2: One line for all properties (suits my script better)
    $Attributes = ""
    1..($PropertyFlags.Length) | Where-Object {$UAC -bAnd [math]::Pow(2, $_)} | ForEach-Object {If ($Attributes.Length -EQ 0) {$Attributes = $PropertyFlags[$_]} Else {$Attributes = $Attributes + ", " + $PropertyFlags[$_]}}
    Return $Attributes
}