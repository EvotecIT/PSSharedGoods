Function Get-WinADForestOptions {
    <#
    .SYNOPSIS
        This Cmdlet gets Active Directory Site Options.
    .DESCRIPTION
        This Cmdlet gets Active Directory Site Options.
        We can fill out the rest of this comment-based help later.
    .LINK
        http://myotherpcisacloud.com

    .LINK
        https://serverfault.com/questions/543143/detecting-ad-site-options-using-powershell

    .NOTES
        Written by Ryan Ries, October 2013. ryanries09@gmail.com.
    #>
    [CmdletBinding()]
    Param()
    BEGIN {
        # This enum comes from NtDsAPI.h in the Windows SDK.
        # Also thanks to Jason Scott for pointing it out to me. http://serverfault.com/users/23067/jscott
        Add-Type -TypeDefinition @"
                                   [System.Flags]
                                   public enum nTDSSiteSettingsFlags {
                                   NTDSSETTINGS_OPT_IS_AUTO_TOPOLOGY_DISABLED            = 0x00000001,
                                   NTDSSETTINGS_OPT_IS_TOPL_CLEANUP_DISABLED             = 0x00000002,
                                   NTDSSETTINGS_OPT_IS_TOPL_MIN_HOPS_DISABLED            = 0x00000004,
                                   NTDSSETTINGS_OPT_IS_TOPL_DETECT_STALE_DISABLED        = 0x00000008,
                                   NTDSSETTINGS_OPT_IS_INTER_SITE_AUTO_TOPOLOGY_DISABLED = 0x00000010,
                                   NTDSSETTINGS_OPT_IS_GROUP_CACHING_ENABLED             = 0x00000020,
                                   NTDSSETTINGS_OPT_FORCE_KCC_WHISTLER_BEHAVIOR          = 0x00000040,
                                   NTDSSETTINGS_OPT_FORCE_KCC_W2K_ELECTION               = 0x00000080,
                                   NTDSSETTINGS_OPT_IS_RAND_BH_SELECTION_DISABLED        = 0x00000100,
                                   NTDSSETTINGS_OPT_IS_SCHEDULE_HASHING_ENABLED          = 0x00000200,
                                   NTDSSETTINGS_OPT_IS_REDUNDANT_SERVER_TOPOLOGY_ENABLED = 0x00000400,
                                   NTDSSETTINGS_OPT_W2K3_IGNORE_SCHEDULES                = 0x00000800,
                                   NTDSSETTINGS_OPT_W2K3_BRIDGES_REQUIRED                = 0x00001000  }
"@
        ForEach ($Site In (Get-ADObject -Filter 'objectClass -eq "site"' -Searchbase (Get-ADRootDSE).ConfigurationNamingContext)) {
            $SiteSettings = Get-ADObject "CN=NTDS Site Settings,$($Site.DistinguishedName)" -Properties Options
            If (!$SiteSettings.PSObject.Properties.Match('Options').Count -OR $SiteSettings.Options -EQ 0) {
                # I went with '(none)' here to give it a more classic repadmin.exe feel.
                # You could also go with $Null, or omit the property altogether for a more modern, Powershell feel.
                [PSCustomObject]@{
                    SiteName          = $Site.Name
                    DistinguishedName = $Site.DistinguishedName
                    SiteOptions       = '(none)'
                }
            } Else {
                [PSCustomObject]@{
                    SiteName          = $Site.Name
                    DistinguishedName = $Site.DistinguishedName
                    SiteOptions       = [Enum]::Parse('nTDSSiteSettingsFlags', $SiteSettings.Options)
                }
            }
        }
    }
}