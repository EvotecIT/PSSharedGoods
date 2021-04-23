function Convert-Office365License {
    <#
    .SYNOPSIS
    This function helps converting Office 365 licenses from/to their SKU equivalent

    .DESCRIPTION
    This function helps converting Office 365 licenses from/to their SKU equivalent

    .PARAMETER License
    License SKU or License Name. Takes multiple values.

    .PARAMETER ToSku
    Converts license name to SKU

    .PARAMETER Separator

    .PARAMETER ReturnArray

    .EXAMPLE
    Convert-Office365License -License 'VISIOCLIENT','PROJECTONLINE_PLAN_1','test','tenant:VISIOCLIENT'

    .EXAMPLE
    Convert-Office365License -License "Office 365 (Plan A3) for Faculty","Office 365 (Enterprise Preview)", 'test' -ToSku
    #>

    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline)][Array] $License,
        [alias('SKU')][switch] $ToSku,
        [string] $Separator = ', ',
        [switch] $ReturnArray
    )
    Begin {
        $O365SKU = @{
            "O365_BUSINESS_ESSENTIALS"           = "Microsoft 365 Business Basic"
            "O365_BUSINESS_PREMIUM"              = "Microsoft 365 Business Standard"
            "SPB"                                = "Microsoft 365 Business Premium"
            "DESKLESSPACK"                       = "Office 365 (Plan F1)"
            "DESKLESSWOFFPACK"                   = "Office 365 (Plan F2)"
            "LITEPACK"                           = "Office 365 Small Business"
            "M365_F1"                            = "Microsoft 365 F1"
            "SPE_F1"                             = "Microsoft 365 F3"
            "EXCHANGESTANDARD"                   = "Exchange Online (Plan 1)"
            "STANDARDPACK"                       = "Office 365 E1"
            "STANDARDWOFFPACK"                   = "Office 365 E2"
            "ENTERPRISEPACK"                     = "Office 365 E3"
            "ENTERPRISEPACKLRG"                  = "Office 365 Enterprise E3"
            "ENTERPRISEWITHSCAL"                 = "Office 365 E4"
            "STANDARDPACK_STUDENT"               = "Office 365 (Plan A1) for Students"
            "STANDARDWOFFPACKPACK_STUDENT"       = "Office 365 (Plan A2) for Students"
            "ENTERPRISEPACK_STUDENT"             = "Office 365 (Plan A3) for Students"
            "ENTERPRISEWITHSCAL_STUDENT"         = "Office 365 (Plan A4) for Students"
            "STANDARDPACK_FACULTY"               = "Office 365 (Plan A1) for Faculty"
            "STANDARDWOFFPACKPACK_FACULTY"       = "Office 365 (Plan A2) for Faculty"
            "ENTERPRISEPACK_FACULTY"             = "Office 365 (Plan A3) for Faculty"
            "ENTERPRISEWITHSCAL_FACULTY"         = "Office 365 (Plan A4) for Faculty"
            "ENTERPRISEPACK_B_PILOT"             = "Office 365 (Enterprise Preview)"
            "STANDARD_B_PILOT"                   = "Office 365 (Small Business Preview)"
            "VISIOCLIENT"                        = "Visio Online Plan 2"
            "POWER_BI_ADDON"                     = "Power BI for Office 365 Add-on"
            "POWER_BI_INDIVIDUAL_USE"            = "Power BI Individual User"
            "POWER_BI_STANDALONE"                = "Power BI Stand Alone"
            "POWER_BI_STANDARD"                  = "Power BI (free)"
            "PROJECTESSENTIALS"                  = "Project Online Essentials"
            "PROJECTCLIENT"                      = "Project for Office 365"
            "PROJECTONLINE_PLAN_1"               = "Project Online Premium (without Project Client)"
            "PROJECT_P1"                         = "Project Plan 1"
            "PROJECTONLINE_PLAN_2"               = "Project Online with Project for Office 365"
            "PROJECTPREMIUM"                     = "Project Online Premium (Project Plan 5)"
            "PROJECTPROFESSIONAL"                = "Project Online Professional (Project Plan 3)"
            "ECAL_SERVICES"                      = "ECAL"
            "EMS"                                = "Enterprise Mobility + Security E3"
            "RIGHTSMANAGEMENT_ADHOC"             = "Windows Azure Rights Management"
            "MCOMEETADV"                         = "Microsoft 365 Audio Conferencing"
            "SHAREPOINTSTORAGE"                  = "SharePoint Storage"
            "PLANNERSTANDALONE"                  = "Planner Standalone"
            "CRMIUR"                             = "CMRIUR"
            "BI_AZURE_P1"                        = "Power BI Reporting and Analytics"
            "INTUNE_A"                           = "Intune"
            "PROJECTWORKMANAGEMENT"              = "Office 365 Planner Preview"
            "ATP_ENTERPRISE"                     = "Office 365 Advanced Threat Protection (Plan 1)"
            "EQUIVIO_ANALYTICS"                  = "Office 365 Advanced Compliance"
            "AAD_BASIC"                          = "Azure Active Directory Basic"
            "RMS_S_ENTERPRISE"                   = "Azure Active Directory Rights Management"
            "AAD_PREMIUM"                        = "Azure Active Directory Premium P1"
            "MFA_PREMIUM"                        = "Azure Multi-Factor Authentication"
            "STANDARDPACK_GOV"                   = "Microsoft Office 365 (Plan G1) for Government"
            "STANDARDWOFFPACK_GOV"               = "Microsoft Office 365 (Plan G2) for Government"
            "ENTERPRISEPACK_GOV"                 = "Microsoft Office 365 (Plan G3) for Government"
            "ENTERPRISEWITHSCAL_GOV"             = "Microsoft Office 365 (Plan G4) for Government"
            "DESKLESSPACK_GOV"                   = "Microsoft Office 365 (Plan F1) for Government"
            "ESKLESSWOFFPACK_GOV"                = "Microsoft Office 365 (Plan F2) for Government"
            "EXCHANGESTANDARD_GOV"               = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
            "EXCHANGEENTERPRISE_GOV"             = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
            "SHAREPOINTDESKLESS_GOV"             = "SharePoint Online Kiosk"
            "EXCHANGE_S_DESKLESS_GOV"            = "Exchange Kiosk"
            "RMS_S_ENTERPRISE_GOV"               = "Windows Azure Active Directory Rights Management"
            "OFFICESUBSCRIPTION_GOV"             = "Office ProPlus"
            "MCOSTANDARD_GOV"                    = "Lync Plan 2G"
            "SHAREPOINTWAC_GOV"                  = "Office Online for Government"
            "SHAREPOINTENTERPRISE_GOV"           = "SharePoint Plan 2G"
            "EXCHANGE_S_ENTERPRISE_GOV"          = "Exchange Plan 2G"
            "EXCHANGE_S_ARCHIVE_ADDON_GOV"       = "Exchange Online Archiving"
            "EXCHANGE_S_DESKLESS"                = "Exchange Online Kiosk"
            "SHAREPOINTDESKLESS"                 = "SharePoint Online Kiosk"
            "SHAREPOINTWAC"                      = "Office Online"
            "YAMMER_ENTERPRISE"                  = "Yammer for the Starship Enterprise"
            "EXCHANGE_L_STANDARD"                = "Exchange Online (Plan 1)"
            "MCOLITE"                            = "Skype for Business Online (Plan 1)"
            "SHAREPOINTLITE"                     = "SharePoint Online (Plan 1)"
            "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
            "EXCHANGE_S_STANDARD_MIDMARKET"      = "Exchange Online (Plan 1)"
            "MCOSTANDARD_MIDMARKET"              = "Skype for Business Online (Plan 1)"
            "SHAREPOINTENTERPRISE_MIDMARKET"     = "SharePoint Online (Plan 1)"
            "OFFICESUBSCRIPTION"                 = "Microsoft 365 Apps for Enterprise"
            "YAMMER_MIDSIZE"                     = "Yammer"
            "DYN365_ENTERPRISE_PLAN1"            = "Dynamics 365 Customer Engagement Plan Enterprise Edition"
            "ENTERPRISEPREMIUM_NOPSTNCONF"       = "Office 365 E5 (without Audio Conferencing)"
            "ENTERPRISEPREMIUM"                  = "Office 365 E5 (with Audio Conferencing)"
            "MCOSTANDARD"                        = "Skype for Business Online Standalone Plan 2"
            "PROJECT_MADEIRA_PREVIEW_IW_SKU"     = "Dynamics 365 for Financials for IWs"
            "STANDARDWOFFPACK_IW_STUDENT"        = "Office 365 Education for Students"
            "STANDARDWOFFPACK_IW_FACULTY"        = "Office 365 Education for Faculty"
            "EOP_ENTERPRISE_FACULTY"             = "Exchange Online Protection for Faculty"
            "EXCHANGESTANDARD_STUDENT"           = "Exchange Online (Plan 1) for Students"
            "OFFICESUBSCRIPTION_STUDENT"         = "Office ProPlus Student Benefit"
            "STANDARDWOFFPACK_FACULTY"           = "Office 365 Education E1 for Faculty"
            "STANDARDWOFFPACK_STUDENT"           = "Microsoft Office 365 (Plan A2) for Students"
            "DYN365_FINANCIALS_BUSINESS_SKU"     = "Dynamics 365 for Financials Business Edition"
            "DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
            "FLOW_FREE"                          = "Microsoft Power Automate Free"
            "POWER_BI_PRO"                       = "Power BI Pro"
            "O365_BUSINESS"                      = "Microsoft 365 Apps for Business"
            "DYN365_ENTERPRISE_SALES"            = "Dynamics 365 for Enterprise Sales Edition"
            "RIGHTSMANAGEMENT"                   = "Azure Information Protection Plan 1"
            "VISIOONLINE_PLAN1"                  = "Visio Online Plan 1"
            "EXCHANGEENTERPRISE"                 = "Exchange Online (Plan 2)"
            "DYN365_ENTERPRISE_P1_IW"            = "Dynamics 365 P1 Trial for Information Workers"
            "DYN365_ENTERPRISE_TEAM_MEMBERS"     = "Dynamics 365 For Team Members Enterprise Edition"
            "CRMSTANDARD"                        = "Microsoft Dynamics CRM Online Professional"
            "EXCHANGEARCHIVE_ADDON"              = "Exchange Online Archiving For Exchange Online"
            "EXCHANGEDESKLESS"                   = "Exchange Online Kiosk"
            "SPZA_IW"                            = "App Connect"
            "WINDOWS_STORE"                      = "Windows Store for Business"
            "MCOEV"                              = "Microsoft 365 Phone System"
            "VIDEO_INTEROP"                      = "Polycom Skype Meeting Video Interop for Skype for Business"
            "SPE_E5"                             = "Microsoft 365 E5"
            "SPE_E3"                             = "Microsoft 365 E3"
            "ATA"                                = "Advanced Threat Analytics"
            "MCOPSTN2"                           = "Domestic and International Calling Plan"
            "FLOW_P1"                            = "Microsoft Flow Plan 1"
            "FLOW_P2"                            = "Microsoft Flow Plan 2"
            "FLOW_PER_USER"                      = "Power Automate per user plan"
            "POWERAPPS_VIRAL"                    = "Microsoft PowerApps Plan 2"
            "MIDSIZEPACK"                        = "Office 365 Midsize Business"
            "AAD_PREMIUM_P2"                     = "Azure Active Directory Premium P2"
            "RIGHTSMANAGEMENT_STANDARD_FACULTY"  = "Information Rights Management for Faculty"
            "PROJECTONLINE_PLAN_1_FACULTY"       = "Project Online for Faculty Plan 1"
            "PROJECTONLINE_PLAN_2_FACULTY"       = "Project Online for Faculty Plan 2"
            "PROJECTONLINE_PLAN_1_STUDENT"       = "Project Online for Students Plan 1"
            "PROJECTONLINE_PLAN_2_STUDENT"       = "Project Online for Students Plan 2"
            "TEAMS1"                             = "Microsoft Teams"
            "TEAMS_EXPLORATORY"                  = "Microsoft Teams Exploratory"
            "RIGHTSMANAGEMENT_STANDARD_STUDENT"  = "Information Rights Management for Students"
            "EXCHANGEENTERPRISE_FACULTY"         = "Exchange Online Plan 2 for Faculty"
            "SHAREPOINTSTANDARD"                 = "SharePoint Online Plan 1"
            "CRMPLAN2"                           = "Dynamics CRM Online Plan 2"
            "CRMSTORAGE"                         = "Microsoft Dynamics CRM Online Additional Storage"
            "EMSPREMIUM"                         = "Enterprise Mobility + Security E5"
            "POWER_BI_INDIVIDUAL_USER"           = "Power BI for Office 365 Individual"
            "DESKLESSPACK_YAMMER"                = "Office 365 Enterprise F1 with Yammer"
            "MICROSOFT_BUSINESS_CENTER"          = "Microsoft Business Center"
            "STREAM"                             = "Microsoft Stream"
            "OFFICESUBSCRIPTION_FACULTY"         = "Office 365 ProPlus for Faculty"
            "WACSHAREPOINTSTD"                   = "Office Online STD"
            "POWERAPPS_INDIVIDUAL_USER"          = "Microsoft PowerApps and Logic flows"
            "IT_ACADEMY_AD"                      = "Microsoft Imagine Academy"
            "SHAREPOINTENTERPRISE"               = "SharePoint Online (Plan 2)"
            "MCOPSTN1"                           = "Microsoft 365 Domestic Calling Plan"
            "MEE_FACULTY"                        = "Minecraft Education Edition Faculty"
            "LITEPACK_P2"                        = "Office 365 Small Business Premium"
            "EXCHANGE_S_ENTERPRISE"              = "Exchange Online Plan 2 S"
            "INTUNE_A_VL"                        = "Intune (Volume License)"
            "ENTERPRISEPACKWITHOUTPROPLUS"       = "Office 365 Enterprise E3 without ProPlus Add-on"
            "ATP_ENTERPRISE_FACULTY"             = "Exchange Online Advanced Threat Protection"
            "EXCHANGE_S_STANDARD"                = "Exchange Online (Plan 2)"
            "MEE_STUDENT"                        = "Minecraft Education Edition Student"
            "EQUIVIO_ANALYTICS_FACULTY"          = "Office 365 Advanced Compliance for faculty"
            "MFA_STANDALONE"                     = "Microsoft Azure Multi-Factor Authentication"
            "MS_TEAMS_IW"                        = "Microsoft Teams"
            "Win10_VDA_E3"                       = "Windows 10 Enterprise E3"
            "WIN10_PRO_ENT_SUB"                  = "Windows 10 Enterprise E3"
            "WIN10_VDA_E5"                       = "Windows 10 Enterprise E5"
            "SMB_APPS"                           = "Microsoft Bookings"
            "BUSINESS_VOICE_DIRECTROUTING"       = "Microsoft 365 Business Voice (without calling plan)"
            "FORMS_PRO"                          = "Dynamics 365 Customer Voice Trial"
            "CCIBOTS_PRIVPREV_VIRAL"             = "Power Virtual Agents Viral Trial"
        }
    }
    Process {
        if (-not $ToSku) {
            $ConvertedLicenses = foreach ($LicenseToProcess in $License) {
                if ($LicenseToProcess -is [string]) {
                    $L = $LicenseToProcess
                } elseif ($LicenseToProcess -is [Microsoft.Online.Administration.UserLicense]) {
                    $L = $LicenseToProcess.AccountSkuId
                } else {
                    continue
                }
                # Remove tenant from SKU
                #if ($L -match ':') {
                #    $Split = $L -split ':'
                #    $L = $Split[-1]
                #}

                # Removes : from tenant:VisioClient
                $L = $L -replace '.*(:)'

                $Conversion = $O365SKU[$L]
                if ($null -eq $Conversion) {
                    $L
                } else {
                    $Conversion
                }
            }
        } else {
            $ConvertedLicenses = :Outer foreach ($L in $License) {
                $Conversion = foreach ($_ in $O365SKU.GetEnumerator()) {
                    if ($_.Value -eq $L) {
                        $_.Name
                        continue Outer
                    }
                }
                if ($null -eq $Conversion) {
                    $L
                }
            }
        }
        if ($ReturnArray) {
            $ConvertedLicenses
        } else {
            $ConvertedLicenses -join $Separator
        }
    }
    End {}
}
