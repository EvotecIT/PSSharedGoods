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
                        "AAD_BASIC" = "Azure Active Directory Basic"
                        "AAD_PREMIUM" = "Azure Active Directory Premium P1"
                        "AAD_PREMIUM_P2" = "Azure Active Directory Premium P2"
                        "ADALLOM_O365" = "Office 365 Cloud App Security"
                        "ADALLOM_STANDALONE" = "Microsoft Cloud App Security"
                        "ADV_COMMS" = "Advanced Communications"
                        "ATA" = "Microsoft Defender for Identity"
                        "ATP_ENTERPRISE" = "Microsoft Defender for Office 365 (Plan 1)"
                        "ATP_ENTERPRISE_FACULTY" = "Microsoft Defender for Office 365 (Plan 1) Faculty"
                        "AX7_USER_TRIAL" = "Microsoft Dynamics AX7 User Trial"
                        "BI_AZURE_P1" = "Power BI Reporting and Analytics"
                        "BUSINESS_VOICE_DIRECTROUTING" = "Microsoft 365 Business Voice (without calling plan)"
                        "BUSINESS_VOICE_DIRECTROUTING_MED" = "Microsoft 365 Business Voice (without Calling Plan) for US"
                        "BUSINESS_VOICE_MED2_TELCO" = "Microsoft 365 Business Voice (US)"
                        "CCIBOTS_PRIVPREV_VIRAL" = "Power Virtual Agents Viral Trial"
                        "CDS_DB_CAPACITY" = "Common Data Service Database Capacity"
                        "CDS_LOG_CAPACITY" = "Common Data Service Log Capacity"
                        "CDSAICAPACITY" = "AI Builder Capacity add-on"
                        "CPC_B_2C_4RAM_64GB" = "Windows 365 Business 2 vCPU 4 GB 64 GB"
                        "CPC_B_2C_4RAM_64GB_WHB" = "Windows 365 Business 2 vCPU, 4 GB, 64 GB (with Windows Hybrid Benefit)"
                        "CPC_B_4C_16RAM_128GB_WHB" = "Windows 365 Business 4 vCPU 16 GB 128 GB (with Windows Hybrid Benefit)"
                        "CPC_E_2C_4GB_64GB" = "Windows 365 Enterprise 2 vCPU 4 GB 64 GB"
                        "CRM_ONLINE_PORTAL" = "Dynamics 365 Enterprise Edition - Additional Portal (Qualified Offer)"
                        "CRMINSTANCE" = "Dynamics 365 - Additional Production Instance (Qualified Offer)"
                        "CRMIUR" = "CMRIUR"
                        "CRMPLAN2" = "Dynamics CRM Online Plan 2"
                        "CRMSTANDARD" = "Microsoft Dynamics CRM Online Professional"
                        "CRMSTORAGE" = "Dynamics 365 - Additional Database Storage (Qualified Offer)"
                        "CRMTESTINSTANCE" = "Dynamics 365 - Additional Non-Production Instance (Qualified Offer)"
                        "D365_SALES_ENT_ATTACH" = "Dynamics 365 Sales Enterprise Attach to Qualifying Dynamics 365 Base Offer"
                        "DEFENDER_ENDPOINT_P1" = "Microsoft Defender for Endpoint P1"                       
                        "DESKLESSPACK" = "OFFICE 365 F3"
                        "DESKLESSPACK_GOV" = "Microsoft Office 365 (Plan F1) for Government"
                        "DESKLESSPACK_YAMMER" = "Office 365 Enterprise F1 with Yammer"
                        "DESKLESSWOFFPACK" = "Office 365 (Plan F2)"
                        "DEVELOPERPACK" = "OFFICE 365 E3 DEVELOPER"
                        "DYN365_AI_SERVICE_INSIGHTS" = "Dynamics 365 Customer Service Insights Trial"
                        "DYN365_ASSETMANAGEMENT" = "Dynamics 365 Asset Management Addl Assets"
                        "DYN365_BUSCENTRAL_ADD_ENV_ADDON" = "Dynamics 365 Business Central Additional Environment Addon"
                        "DYN365_BUSCENTRAL_DB_CAPACITY" = "Dynamics 365 Business Central Database Capacity"
                        "DYN365_BUSCENTRAL_ESSENTIAL" = "Dynamics 365 Business Central Essentials"
                        "DYN365_BUSCENTRAL_PREMIUM" = "Dynamics 365 Business Central Premium"
                        "DYN365_CUSTOMER_SERVICE_PRO" = "Dynamics 365 Customer Service Professional"
                        "DYN365_CUSTOMER_VOICE_ADDON" = "Dynamics 365 Customer Voice Additional Responses"
                        "DYN365_ENTERPRISE_CUSTOMER_SERVICE" = "DYNAMICS 365 FOR CUSTOMER SERVICE ENTERPRISE EDITION"
                        "DYN365_ENTERPRISE_P1_IW" = "Dynamics 365 P1 Trial for Information Workers"
                        "DYN365_ENTERPRISE_PLAN1" = "Dynamics 365 Customer Engagement Plan"
                        "DYN365_ENTERPRISE_SALES" = "Dynamics 365 for Enterprise Sales Edition"
                        "DYN365_ENTERPRISE_SALES_CUSTOMERSERVICE" = "DYNAMICS 365 FOR SALES AND CUSTOMER SERVICE ENTERPRISE EDITION"
                        "DYN365_ENTERPRISE_TEAM_MEMBERS" = "Dynamics 365 For Team Members Enterprise Edition"
                        "DYN365_FINANCE" = "Dynamics 365 Finance"
                        "DYN365_FINANCIALS_ACCOUNTANT_SKU" = "Dynamics 365 Business Central External Accountant"
                        "DYN365_FINANCIALS_BUSINESS_SKU" = "Dynamics 365 for Financials Business Edition"
                        "DYN365_FINANCIALS_TEAM_MEMBERS_SKU" = "Dynamics 365 for Team Members Business Edition"
                        "DYN365_IOT_INTELLIGENCE_ADDL_MACHINES" = "Sensor Data Intelligence Additional Machines Add-in for Dynamics 365 Supply Chain Management"
                        "DYN365_IOT_INTELLIGENCE_SCENARIO" = "Sensor Data Intelligence Scenario Add-in for Dynamics 365 Supply Chain Management"
                        "DYN365_SCM" = "DYNAMICS 365 FOR SUPPLY CHAIN MANAGEMENT"
                        "DYN365_TEAM_MEMBERS" = "DYNAMICS 365 TEAM MEMBERS"
                        "Dynamics_365_for_Operations" = "DYNAMICS 365 UNF OPS PLAN ENT EDITION"
                        "Dynamics_365_for_Operations_Devices" = "Dynamics 365 Operations - Device"
                        "Dynamics_365_for_Operations_Sandbox_Tier2_SKU" = "Dynamics 365 Operations - Sandbox Tier 2:Standard Acceptance Testing"
                        "Dynamics_365_for_Operations_Sandbox_Tier4_SKU" = "Dynamics 365 Operations - Sandbox Tier 4:Standard Performance Testing"
                        "Dynamics_365_Onboarding_SKU" = "Dynamics 365 Talent: Onboard"
                        "ECAL_SERVICES" = "ECAL"
                        "EMS" = "Enterprise Mobility + Security E3"
                        "EMS_GOV" = "Enterprise Mobility + Security G3 GCC"
                        "EMSPREMIUM" = "Enterprise Mobility + Security E5"
                        "EMSPREMIUM_GOV" = "Enterprise Mobility + Security G5 GCC"
                        "ENTERPRISEPACK" = "Office 365 E3"
                        "ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)"
                        "ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty"
                        "ENTERPRISEPACK_GOV" = "Microsoft Office 365 (Plan G3) for Government"
                        "ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students"
                        "ENTERPRISEPACK_USGOV_DOD" = "Office 365 E3_USGOV_DOD"
                        "ENTERPRISEPACK_USGOV_GCCHIGH" = "Office 365 E3_USGOV_GCCHIGH"
                        "ENTERPRISEPACKLRG" = "Office 365 Enterprise E3"
                        "ENTERPRISEPACKPLUS_FACULTY" = "Office 365 A3 for faculty"
                        "ENTERPRISEPACKPLUS_STUDENT" = "Office 365 A3 for students"
                        "ENTERPRISEPACKWITHOUTPROPLUS" = "Office 365 Enterprise E3 without ProPlus Add-on"
                        "ENTERPRISEPREMIUM" = "Office 365 E5"
                        "ENTERPRISEPREMIUM_FACULTY" = "Office 365 A5 for faculty"
                        "ENTERPRISEPREMIUM_GOV" = "Office 365 G5 GCC"
                        "ENTERPRISEPREMIUM_NOPSTNCONF" = "Office 365 E5 (without Audio Conferencing)"
                        "ENTERPRISEPREMIUM_STUDENT" = "Office 365 A5 for students"
                        "ENTERPRISEWITHSCAL" = "Office 365 E4"
                        "ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty"
                        "ENTERPRISEWITHSCAL_GOV" = "Microsoft Office 365 (Plan G4) for Government"
                        "ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students"
                        "EOP_ENTERPRISE_FACULTY" = "Exchange Online Protection for Faculty"
                        "EOP_ENTERPRISE_PREMIUM" = "Exchange Enterprise CAL Services (EOP DLP)"
                        "EQUIVIO_ANALYTICS" = "Office 365 Advanced Compliance"
                        "EQUIVIO_ANALYTICS_FACULTY" = "Office 365 Advanced Compliance for faculty"
                        "ESKLESSWOFFPACK_GOV" = "Microsoft Office 365 (Plan F2) for Government"
                        "EXCHANGE_L_STANDARD" = "Exchange Online (Plan 1)"
                        "EXCHANGE_S_ARCHIVE_ADDON_GOV" = "Exchange Online Archiving"
                        "EXCHANGE_S_DESKLESS" = "Exchange Online Kiosk"
                        "EXCHANGE_S_DESKLESS_GOV" = "Exchange Kiosk"
                        "EXCHANGE_S_ENTERPRISE" = "Exchange Online Plan 2 S"
                        "EXCHANGE_S_ENTERPRISE_GOV" = "Exchange Plan 2G"
                        "EXCHANGE_S_ESSENTIALS" = "EXCHANGE ONLINE ESSENTIALS"
                        "EXCHANGE_S_STANDARD" = "Exchange Online (Plan 2)"
                        "EXCHANGE_S_STANDARD_MIDMARKET" = "Exchange Online (Plan 1)"
                        "EXCHANGEARCHIVE" = "EXCHANGE ONLINE ARCHIVING FOR EXCHANGE SERVER"
                        "EXCHANGEARCHIVE_ADDON" = "Exchange Online Archiving For Exchange Online"
                        "EXCHANGEDESKLESS" = "Exchange Online Kiosk"
                        "EXCHANGEENTERPRISE" = "Exchange Online (Plan 2)"
                        "EXCHANGEENTERPRISE_FACULTY" = "Exchange Online Plan 2 for Faculty"
                        "EXCHANGEENTERPRISE_GOV" = "Microsoft Office 365 Exchange Online (Plan 2) only for Government"
                        "EXCHANGEESSENTIALS" = "EXCHANGE ONLINE ESSENTIALS (ExO P1 BASED)"
                        "EXCHANGESTANDARD" = "Exchange Online (Plan 1)"
                        "EXCHANGESTANDARD_GOV" = "Microsoft Office 365 Exchange Online (Plan 1) only for Government"
                        "EXCHANGESTANDARD_STUDENT" = "Exchange Online (Plan 1) for Students"
                        "EXCHANGETELCO" = "EXCHANGE ONLINE POP"
                        "EXPERTS_ON_DEMAND" = "Microsoft Threat Experts - Experts on Demand"
                        "FLOW_BUSINESS_PROCESS" = "Power Automate per flow plan"
                        "FLOW_FREE" = "Microsoft Power Automate Free"
                        "FLOW_P1" = "Microsoft Flow Plan 1"
                        "FLOW_P2" = "MICROSOFT POWER AUTOMATE PLAN 2"
                        "FLOW_PER_USER" = "Power Automate per user plan"
                        "FLOW_PER_USER_DEPT" = "Power Automate per user plan dept"
                        "FORMS_PRO" = "Dynamics 365 Customer Voice Trial"
                        "Forms_Pro_AddOn" = "Dynamics 365 Customer Voice Additional Responses"
                        "Forms_Pro_USL" = "Dynamics 365 Customer Voice USL"
                        "GUIDES_USER" = "Dynamics 365 Guides"
                        "IDENTITY_THREAT_PROTECTION" = "Microsoft 365 E5 Security"
                        "IDENTITY_THREAT_PROTECTION_FOR_EMS_E5" = "Microsoft 365 E5 Security for EMS E5"
                        "INFORMATION_PROTECTION_COMPLIANCE" = "Microsoft 365 E5 Compliance"
                        "Intelligent_Content_Services" = "SharePoint Syntex"
                        "INTUNE_A" = "Intune"
                        "INTUNE_A_D" = "Microsoft Intune Device"
                        "INTUNE_A_D_GOV" = "MICROSOFT INTUNE DEVICE FOR GOVERNMENT"
                        "INTUNE_A_VL" = "Intune (Volume License)"
                        "INTUNE_SMB" = "MICROSOFT INTUNE SMB"
                        "IT_ACADEMY_AD" = "Microsoft Imagine Academy"
                        "LITEPACK" = "Office 365 Small Business"
                        "LITEPACK_P2" = "Office 365 Small Business Premium"
                        "MDATP_Server" = "Microsoft Defender for Endpoint Server"
                        "M365_E5_SUITE_COMPONENTS" = "Microsoft 365 E5 Suite features"
                        "M365_F1" = "Microsoft 365 F1"
                        "M365_F1_COMM" = "Microsoft 365 F1"
                        "M365_G3_GOV" = "MICROSOFT 365 G3 GCC"
                        "M365_SECURITY_COMPLIANCE_FOR_FLW" = "Microsoft 365 Security and Compliance for Firstline Workers"
                        "M365EDU_A1" = "Microsoft 365 A1"
                        "M365EDU_A3_FACULTY" = "Microsoft 365 A3 for Faculty"
                        "M365EDU_A3_STUDENT" = "MICROSOFT 365 A3 FOR STUDENTS"
                        "M365EDU_A3_STUUSEBNFT" = "Microsoft 365 A3 for students use benefit"
                        "M365EDU_A3_STUUSEBNFT_RPA1" = "Microsoft 365 A3 - Unattended License for students use benefit"
                        "M365EDU_A5_FACULTY" = "Microsoft 365 A5 for Faculty"
                        "M365EDU_A5_NOPSTNCONF_STUUSEBNFT" = "Microsoft 365 A5 without Audio Conferencing for students use benefit"
                        "M365EDU_A5_STUDENT" = "MICROSOFT 365 A5 FOR STUDENTS"
                        "M365EDU_A5_STUUSEBNFT" = "Microsoft 365 A5 for students use benefit"
                        "MCOCAP" = "Common Area Phone"
                        "MCOCAP_GOV" = "Common Area Phone for GCC"
                        "MCOEV" = "Microsoft 365 Phone System"
                        "MCOEV_DOD" = "MICROSOFT 365 PHONE SYSTEM FOR DOD"
                        "MCOEV_FACULTY" = "MICROSOFT 365 PHONE SYSTEM FOR FACULTY"
                        "MCOEV_GCCHIGH" = "MICROSOFT 365 PHONE SYSTEM FOR GCCHIGH"
                        "MCOEV_GOV" = "MICROSOFT 365 PHONE SYSTEM FOR GCC"
                        "MCOEV_STUDENT" = "MICROSOFT 365 PHONE SYSTEM FOR STUDENTS"
                        "MCOEV_TELSTRA" = "MICROSOFT 365 PHONE SYSTEM FOR TELSTRA"
                        "MCOEV_USGOV_DOD" = "MICROSOFT 365 PHONE SYSTEM_USGOV_DOD"
                        "MCOEV_USGOV_GCCHIGH" = "MICROSOFT 365 PHONE SYSTEM_USGOV_GCCHIGH"
                        "MCOEVSMB_1" = "MICROSOFT 365 PHONE SYSTEM FOR SMALL AND MEDIUM BUSINESS"
                        "MCOIMP" = "SKYPE FOR BUSINESS ONLINE (PLAN 1)"
                        "MCOLITE" = "Skype for Business Online (Plan 1)"
                        "MCOMEETADV" = "Microsoft 365 Audio Conferencing"
                        "MCOMEETADV_GOC" = "MICROSOFT 365 AUDIO CONFERENCING FOR GCC"
                        "MCOMEETADV_GOV" = "MICROSOFT 365 AUDIO CONFERENCING FOR GCC"
                        "MCOPSTN_1_GOV" = "Microsoft 365 Domestic Calling Plan for GCC"
                        "MCOPSTN_5" = "MICROSOFT 365 DOMESTIC CALLING PLAN (120 Minutes)"
                        "MCOPSTN1" = "Microsoft 365 Domestic Calling Plan"
                        "MCOPSTN2" = "Domestic and International Calling Plan"
                        "MCOPSTN5" = "SKYPE FOR BUSINESS PSTN DOMESTIC CALLING (120 Minutes)"
                        "MCOPSTNC" = "Communications Credits"
                        "MCOPSTNEAU2" = "TELSTRA CALLING FOR O365"
                        "MCOSTANDARD" = "Skype for Business Online Standalone Plan 2"
                        "MCOSTANDARD_GOV" = "Lync Plan 2G"
                        "MCOSTANDARD_MIDMARKET" = "Skype for Business Online (Plan 1)"
                        "MDATP_Server" = "Microsoft Defender for Endpoint Server"
                        "MDATP_XPLAT" = "Microsoft Defender for Endpoint P2"
                        "MEE_FACULTY" = "Minecraft Education Edition Faculty"
                        "MEE_STUDENT" = "Minecraft Education Edition Student"
                        "MEETING_ROOM" = "Microsoft Teams Rooms Standard"
                        "MFA_PREMIUM" = "Azure Multi-Factor Authentication"
                        "MFA_STANDALONE" = "Microsoft Azure Multi-Factor Authentication"
                        "MICROSOFT_BUSINESS_CENTER" = "Microsoft Business Center"
                        "MICROSOFT_REMOTE_ASSIST" = "Dynamics 365 Remote Assist"
                        "MICROSOFT_REMOTE_ASSIST_HOLOLENS" = "Dynamics 365 Remote Assist HoloLens"
                        "MIDSIZEPACK" = "Office 365 Midsize Business"
                        "MS_TEAMS_IW" = "Microsoft Teams Trial"
                        "MTR_PREM" = "Teams Rooms Premium"
                        "O365_BUSINESS" = "Microsoft 365 Apps for Business"
                        "O365_BUSINESS_ESSENTIALS" = "Microsoft 365 Business Basic"
                        "O365_BUSINESS_PREMIUM" = "Microsoft 365 Business Standard"
                        "OFFICE_PRO_PLUS_SUBSCRIPTION_SMBIZ" = "Office ProPlus"
                        "OFFICE365_MULTIGEO" = "Multi-Geo Capabilities in Office 365"
                        "OFFICESUBSCRIPTION" = "Microsoft 365 Apps for Enterprise"
                        "OFFICESUBSCRIPTION_FACULTY" = "Office 365 ProPlus for Faculty"
                        "OFFICESUBSCRIPTION_GOV" = "Office ProPlus"
                        "OFFICESUBSCRIPTION_STUDENT" = "Office ProPlus Student Benefit"
                        "PBI_PREMIUM_P1_ADDON" = "Power BI Premium P1"
                        "PBI_PREMIUM_PER_USER" = "Power BI Premium Per User"
                        "PBI_PREMIUM_PER_USER_ADDON" = "Power BI Premium Per User Add-On"
                        "PBI_PREMIUM_PER_USER_DEPT" = "Power BI Premium Per User Dept"
                        "PHONESYSTEM_VIRTUALUSER" = "MICROSOFT 365 PHONE SYSTEM - VIRTUAL USER"
                        "PHONESYSTEM_VIRTUALUSER_GOV" = "Microsoft 365 Phone System - Virtual User for GCC"
                        "PLANNERSTANDALONE" = "Planner Standalone"
                        "POWERAPPS_DEV" = "Microsoft PowerApps for Developer"
                        "POWER_BI_ADDON" = "Power BI for Office 365 Add-on"
                        "POWER_BI_INDIVIDUAL_USER" = "Power BI"
                        "POWER_BI_PRO" = "Power BI Pro"
                        "POWER_BI_PRO_CE" = "Power BI Pro CE"
                        "POWER_BI_PRO_DEPT" = "Power BI Pro Dept"
                        "POWER_BI_STANDALONE" = "Power BI Stand Alone"
                        "POWER_BI_STANDARD" = "Power BI (free)"
                        "POWERAPPS_INDIVIDUAL_USER" = "Microsoft PowerApps and Logic flows"
                        "POWERAPPS_PER_APP" = "Power Apps per app plan"
                        "POWERAPPS_PER_APP_IW" = "PowerApps per app baseline access"
                        "POWERAPPS_PER_USER" = "Power Apps per user plan"
                        "POWERAPPS_VIRAL" = "Microsoft Power Apps Plan 2 Trial"
                        "POWERAUTOMATE_ATTENDED_RPA" = "Power Automate per user with attended RPA plan"
                        "POWERAUTOMATE_UNATTENDED_RPA" = "Power Automate unattended RPA add-on"
                        "POWERFLOW_P2" = "Microsoft Power Apps Plan 2 (Qualified Offer)"
                        "PROJECT_MADEIRA_PREVIEW_IW_SKU" = "Dynamics 365 Business Central for IWs"
                        "PROJECT_P1" = "Project Plan 1"
                        "PROJECT_PLAN1_DEPT" = "Project Plan 1 (for Department)"
                        "PROJECT_PLAN3_DEPT" = "Project Plan 3 (for Department)"
                        "PROJECTCLIENT" = "Project for Office 365"
                        "PROJECTESSENTIALS" = "Project Online Essentials"
                        "PROJECTONLINE_PLAN_1" = "Project Online Premium (without Project Client)"
                        "PROJECTONLINE_PLAN_1_FACULTY" = "Project Online for Faculty Plan 1"
                        "PROJECTONLINE_PLAN_1_STUDENT" = "Project Online for Students Plan 1"
                        "PROJECTONLINE_PLAN_2" = "Project Online with Project for Office 365"
                        "PROJECTONLINE_PLAN_2_FACULTY" = "Project Online for Faculty Plan 2"
                        "PROJECTONLINE_PLAN_2_STUDENT" = "Project Online for Students Plan 2"
                        "PROJECTPREMIUM" = "Project Plan 5"
                        "PROJECTPREMIUM_GOV" = "Project Plan 5 for GCC"
                        "PROJECTPROFESSIONAL" = "Project Plan 3"
                        "PROJECTPROFESSIONAL_GOV" = "Project Plan 3 for GCC"
                        "PROJECTWORKMANAGEMENT" = "Office 365 Planner Preview"
                        "RIGHTSMANAGEMENT" = "Azure Information Protection Plan 1"
                        "RIGHTSMANAGEMENT_ADHOC" = "Rights Management Adhoc"
                        "RIGHTSMANAGEMENT_STANDARD_FACULTY" = "Information Rights Management for Faculty"
                        "RIGHTSMANAGEMENT_STANDARD_STUDENT" = "Information Rights Management for Students"
                        "RMS_S_ENTERPRISE" = "Azure Active Directory Rights Management"
                        "RMS_S_ENTERPRISE_GOV" = "Windows Azure Active Directory Rights Management"
                        "RMSBASIC" = "Rights Management Service Basic Content Protection"
                        "SHAREPOINTDESKLESS" = "SharePoint Online Kiosk"
                        "SHAREPOINTDESKLESS_GOV" = "SharePoint Online Kiosk"
                        "SHAREPOINTENTERPRISE" = "SharePoint Online (Plan 2)"
                        "SHAREPOINTENTERPRISE_GOV" = "SharePoint Plan 2G"
                        "SHAREPOINTENTERPRISE_MIDMARKET" = "SharePoint Online (Plan 1)"
                        "SHAREPOINTLITE" = "SharePoint Online (Plan 1)"
                        "SHAREPOINTSTANDARD" = "SharePoint Online Plan 1"
                        "SHAREPOINTSTORAGE" = "Office 365 Extra File Storage"
                        "SHAREPOINTSTORAGE_GOV" = "Office 365 Extra File Storage for GCC"
                        "SHAREPOINTWAC" = "Office Online"
                        "SHAREPOINTWAC_GOV" = "Office Online for Government"
                        "SKU_Dynamics_365_for_HCM_Trial" = "Dynamics 365 for Talent"
                        "SMB_APPS" = "Business Apps (free)"
                        "SMB_BUSINESS" = "MICROSOFT 365 APPS FOR BUSINESS"
                        "SMB_BUSINESS_ESSENTIALS" = "MICROSOFT 365 BUSINESS BASIC"
                        "SMB_BUSINESS_PREMIUM" = "MICROSOFT 365 BUSINESS STANDARD - PREPAID LEGACY"
                        "SPB" = "Microsoft 365 Business Premium"
                        "SPE_E3" = "Microsoft 365 E3"
                        "SPE_E3_RPA1" = "Microsoft 365 E3 - Unattended License"
                        "SPE_E3_USGOV_DOD" = "Microsoft 365 E3_USGOV_DOD"
                        "SPE_E3_USGOV_GCCHIGH" = "Microsoft 365 E3_USGOV_GCCHIGH"
                        "SPE_E5" = "Microsoft 365 E5"
                        "SPE_F1" = "Microsoft 365 F3"
                        "SPZA_IW" = "App Connect IW"
                        "STANDARD_B_PILOT" = "Office 365 (Small Business Preview)"
                        "STANDARDPACK" = "Office 365 E1"
                        "STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty"
                        "STANDARDPACK_GOV" = "Microsoft Office 365 (Plan G1) for Government"
                        "STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students"
                        "STANDARDWOFFPACK" = "Office 365 E2"
                        "STANDARDWOFFPACK_FACULTY" = "Office 365 Education E1 for Faculty"
                        "STANDARDWOFFPACK_GOV" = "Microsoft Office 365 (Plan G2) for Government"
                        "STANDARDWOFFPACK_IW_FACULTY" = "Office 365 Education for Faculty"
                        "STANDARDWOFFPACK_IW_STUDENT" = "Office 365 Education for Students"
                        "STANDARDWOFFPACK_STUDENT" = "Microsoft Office 365 (Plan A2) for Students"
                        "STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty"
                        "STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students"
                        "STREAM" = "Microsoft Stream"
                        "STREAM_P2" = "Microsoft Stream Plan 2"
                        "STREAM_STORAGE" = "Microsoft Stream Storage Add-On (500 GB)"
                        "TEAMS_COMMERCIAL_TRIAL" = "Microsoft Teams Commercial Cloud"
                        "TEAMS_EXPLORATORY" = "Microsoft Teams Exploratory"
                        "TEAMS_FREE" = "MICROSOFT TEAMS (FREE)"
                        "TEAMS1" = "Microsoft Teams"
                        "THREAT_INTELLIGENCE" = "Microsoft Defender for Office 365 (Plan 2)"
                        "THREAT_INTELLIGENCE_GOV" = "Microsoft Defender for Office 365 (Plan 2) GCC"
                        "TOPIC_EXPERIENCES" = "Viva Topics"
                        "UNIVERSAL_PRINT" = "Universal Print"
                        "VIDEO_INTEROP" = "Polycom Skype Meeting Video Interop for Skype for Business"
                        "VIRTUAL_AGENT_BASE" = "Power Virtual Agent"
                        "VISIO_PLAN1_DEPT" = "Visio Plan 1"
                        "VISIO_PLAN2_DEPT" = "Visio Plan 2"
                        "VISIOCLIENT" = "Visio Plan 2"
                        "VISIOCLIENT_GOV" = "VISIO PLAN 2 FOR GCC"
                        "VISIOONLINE_PLAN1" = "Visio Online Plan 1"
                        "WACONEDRIVEENTERPRISE" = "OneDrive for Business (Plan 2)"
                        "WACONEDRIVESTANDARD" = "ONEDRIVE FOR BUSINESS (PLAN 1)"
                        "WACSHAREPOINTSTD" = "Office Online STD"
                        "WIN_DEF_ATP" = "Microsoft Defender for Endpoint P1"
                        "WIN10_ENT_A3_FAC" = "Windows 10 Enterprise A3 for faculty"
                        "WIN10_ENT_A3_STU" = "Windows 10 Enterprise A3 for students"
                        "WIN10_PRO_ENT_SUB" = "Windows 10 Enterprise E3"
                        "Win10_VDA_E3" = "Windows 10 Enterprise E3"
                        "WIN10_VDA_E5" = "Windows 10 Enterprise E5"
                        "WINDOWS_STORE" = "Windows Store for Business"
                        "WINE5_GCC_COMPAT" = "Windows 10 Enterprise E5 Commercial (GCC Compatible)"
                        "WORKPLACE_ANALYTICS" = "Microsoft Workplace Analytics"
                        "YAMMER_ENTERPRISE" = "Yammer Enterprise"
                        "YAMMER_MIDSIZE" = "Yammer"

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
