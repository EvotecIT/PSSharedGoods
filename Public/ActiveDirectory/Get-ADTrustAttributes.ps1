function Get-ADTrustAttributes {
    <#
    .SYNOPSIS
    Retrieves and interprets Active Directory trust attributes based on the provided value.

    .DESCRIPTION
    This function retrieves and interprets Active Directory trust attributes based on the provided value. It decodes the binary value into human-readable trust attributes.

    .PARAMETER Value
    Specifies the integer value representing the trust attributes.

    .EXAMPLE
    Get-ADTrustAttributes -Value 1
    Retrieves and interprets the trust attributes for the value 1.

    .EXAMPLE
    1, 2, 4 | Get-ADTrustAttributes
    Retrieves and interprets the trust attributes for the values 1, 2, and 4.

    .NOTES
    This function provides a convenient way to decode Active Directory trust attributes.
    #>
    [cmdletbinding()]
    Param(
        [parameter(Mandatory = $false, ValueFromPipeline = $True)][int32]$Value
    )
    # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/e9a2d23c-c31e-4a6f-88a0-6646fdb51a3c
    [String[]]$TrustAttributes = @(
        Foreach ($V in $Value) {
            if ([int32]$V -band 0x00000001) { "Non Transitive" } # TRUST_ATTRIBUTE_NON_TRANSITIVE
            if ([int32]$V -band 0x00000002) { "UpLevel Only" } # TRUST_ATTRIBUTE_UPLEVEL_ONLY
            if ([int32]$V -band 0x00000004) { "Quarantined Domain" } # TRUST_ATTRIBUTE_QUARANTINED_DOMAIN
            if ([int32]$V -band 0x00000008) { "Forest Transitive" } # TRUST_ATTRIBUTE_FOREST_TRANSITIVE
            if ([int32]$V -band 0x00000010) { "Cross Organization" } #TRUST_ATTRIBUTE_CROSS_ORGANIZATION
            if ([int32]$V -band 0x00000020) { "Within Forest" } # TRUST_ATTRIBUTE_WITHIN_FOREST
            if ([int32]$V -band 0x00000040) { "Treat as External" } # TRUST_ATTRIBUTE_TREAT_AS_EXTERNAL
            if ([int32]$V -band 0x00000080) { "Uses RC4 Encryption" } # TRUST_ATTRIBUTE_USES_RC4_ENCRYPTION
            if ([int32]$V -band 0x00000200) { "No TGT DELEGATION" } # TRUST_ATTRIBUTE_CROSS_ORGANIZATION_NO_TGT_DELEGATION
            if ([int32]$V -band 0x00000800) { "Enable TGT DELEGATION" } #TRUST_ATTRIBUTE_CROSS_ORGANIZATION_ENABLE_TGT_DELEGATION
            if ([int32]$V -band 0x00000400) { "PIM Trust" } #TRUST_ATTRIBUTE_PIM_TRUST
        }
    )
    return $TrustAttributes
}