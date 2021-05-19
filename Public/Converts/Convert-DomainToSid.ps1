function Convert-DomainToSid {
    <#
    .SYNOPSIS
    Converts Domain Name to SID

    .DESCRIPTION
    Converts Domain Name to SID

    .PARAMETER DomainName
    DomainName for current forest or trusted forest

    .EXAMPLE
    Convert-DomainToSid -DomainName 'test.evotec.pl'

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [parameter(Mandatory)][string] $DomainName
    )
    try {
        $BinarySID = ([ADSI]"LDAP://$DomainName").objectsid
        $DomainSidValue = [System.Security.Principal.SecurityIdentifier]::new($BinarySID.Value, 0).Value
        $DomainSidValue
    } catch {
        Write-Warning -Message "Convert-DomainToSid - Failed conversion with error $($_.Exception.Message)"
    }
}