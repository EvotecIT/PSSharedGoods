function ConvertFrom-X500Address {
    <#
    .EXAMPLE
    By default returns string without @evotec.pl in the end. This is because the string from NDR needs domain name removed to be able to add it back to Exchange
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=5209048016da47689b4421790ad1763f-EVOTEC+20PL+20Recepcja+20G@evotec.pl'
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=8bcad655e07c46788fe1f796162cd87f-EVOTEC+20PL+20Recepcja+20G@evotec.pl'
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl'
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl'

    .EXAMPLE
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=5209048016da47689b4421790ad1763f-EVOTEC+20PL+20Recepcja+20G@evotec.pl' -Full
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=8bcad655e07c46788fe1f796162cd87f-EVOTEC+20PL+20Recepcja+20G@evotec.pl' -Full
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl' -Full
    ConvertFrom-X500Address -IMCEAEXString 'IMCEAEX-_o=AD_ou=Exchange+20Administrative+20Group+20+28FYDIBOHF23SPDLT+29_cn=Recipients_cn=0d4540e9a8f845d798625c9c0ad753bf-Test-All-Group@evotec.pl' -Full
    #>
    param(
        [string] $IMCEAEXString,
        [switch] $Full
    )
    $Final = $IMCEAEXString.Replace("IMCEAEX-", "").Replace("_", "/").Replace("+20", " ").Replace("+28", "(").Replace("+29", ")").Replace("+2E", ".").Replace("+2C", ",").Replace("+5F", "_")
    if ($Full) {
        return $Final
    } else {
        return ($Final -split '@')[0]
    }
}