function Get-ADEncryptionTypes {
    <#
    .SYNOPSIS
    Retrieves the supported encryption types based on the specified value.

    .DESCRIPTION
    This function returns the list of encryption types supported by Active Directory based on the provided value. Each encryption type is represented by a string.

    .PARAMETER Value
    Specifies the integer value representing the encryption types to retrieve.

    .EXAMPLE
    Get-ADEncryptionTypes -Value 24

    Retrieves the following encryption types:
    - AES128-CTS-HMAC-SHA1-96
    - AES256-CTS-HMAC-SHA1-96

    .NOTES
    This function is designed to provide information about encryption types supported by Active Directory.
    #>
    [cmdletbinding()]
    Param(
        [parameter(Mandatory = $false, ValueFromPipeline = $True)][int32]$Value
    )
    # https://lists.samba.org/archive/cifs-protocol/attachments/20100111/e8bb3520/attachment-0001.pdf
    # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-kile/6cfc7b50-11ed-4b4d-846d-6f08f0812919
    # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-kile/1163bb03-7035-433e-b5a4-802247262d18#Appendix_A_9
    [String[]]$EncryptionTypes = @(
        Foreach ($V in $Value) {
            if ([int32]$V -band 0x00000001) { "DES-CBC-CRC" } # KERB_ENCTYPE_DES_CBC_CRC -> CRC
            if ([int32]$V -band 0x00000002) { "DES-CBC-MD5" } # KERB_ENCTYPE_DES_CBC_MD5 -> MD5
            if ([int32]$V -band 0x00000004) { "RC4-HMAC" } # KERB_ENCTYPE_RC4_HMAC_MD5 -> RC4
            if ([int32]$V -band 0x00000008) { "AES128-CTS-HMAC-SHA1-96" } # KERB_ENCTYPE_AES128_CTS_HMAC_SHA1_96 -> A128
            if ([int32]$V -band 0x00000010) { "AES256-CTS-HMAC-SHA1-96" } # KERB_ENCTYPE_AES256_CTS_HMAC_SHA1_96 -> A256
            if ([int32]$V -band 0x00000020) { "FAST-supported" } #
            if ([int32]$V -band 0x00000040) { "Compound-identity-supported" } #
            if ([int32]$V -band 0x00000080) { "Claims-supported" } #
            if ([int32]$V -band 0x00000200) { "Resource-SID-compression-disabled" } #
        }
    )
    $EncryptionTypes
}