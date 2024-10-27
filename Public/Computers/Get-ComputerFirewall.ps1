function Get-ComputerFirewall {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .EXAMPLE
    $Data = Get-ComputerFirewall
    $Data | Format-Table -AutoSize

    .EXAMPLE
    $Data = Get-ComputerFirewall
    $Data | Out-HtmlView -ScrollX -Filtering -Title "Firewall Rules" -DataStore JavaScript

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName
    )
    ## Cache rules and ports for cross referencing

    $CimData = [ordered] @{
        CimSession    = $ComputerName
        ErrorAction   = 'SilentlyContinue'
        ErrorVariable = 'ErrorVar'
    }
    Remove-EmptyValue -Hashtable $CimData

    if ($ComputerName) {
        $ComputerNameDisplay = $ComputerName
    } else {
        $ComputerNameDisplay = 'Localhost'
    }
    Write-Verbose -Message "Get-ComputerFirewall - Getting firewall rules ($ComputerNameDisplay)"
    $Allrules = Get-NetFirewallRule @CimData
    if ($ErrorVar) {
        Write-Warning -Message "Get-ComputerFirewall - Error getting firewall rules. Try running as admin? $($ErrorVar)"
    }
    Write-Verbose -Message "Get-ComputerFirewall - Getting firewall filters ($ComputerNameDisplay)"
    $Allports = Get-NetFirewallPortFilter @CimData
    if ($ErrorVar) {
        Write-Warning -Message "Get-ComputerFirewall - Error getting firewall ports. Try running as admin? $($ErrorVar)"
    }
    Write-Verbose -Message "Get-ComputerFirewall - Getting firewall filters ($ComputerNameDisplay)"
    $AllFilters = Get-NetFirewallApplicationFilter @CimData | Select-Object Program, AppPath, InstanceID, Description, Package
    if ($ErrorVar) {
        Write-Warning -Message "Get-ComputerFirewall - Error getting firewall filters. Try running as admin? $($ErrorVar)"
    }

    Write-Verbose -Message "Get-ComputerFirewall - Matching rules, ports and filters"
    $FiltersCache = @{}
    $RulesCache = @{}
    $PortCache = @{}
    foreach ($Rule in $Allrules) {
        $RulesCache[$Rule.Name] = $Rule
    }
    foreach ($Port in $Allports) {
        $PortCache[$Port.InstanceID] = $Port
    }
    foreach ($Filter in $AllFilters) {
        $FiltersCache[$Filter.InstanceID] = $Filter
    }

    foreach ($Rule in $RulesCache.Values) {
        [PSCustomObject]@{
            Name                          = $Rule.Name                          # : NETDIS-UPnPHost-Out-TCP
            ID                            = $Rule.ID                            # : NETDIS-UPnPHost-Out-TCP
            DisplayName                   = $Rule.DisplayName                   # : Network Discovery (UPnP-Out)
            Group                         = $Rule.Group                         # : @FirewallAPI.dll,-32752
            Enabled                       = $Rule.Enabled                       # : False
            Profile                       = $Rule.Profile                       # : Public
            Platform                      = $Rule.Platform                      # : {}
            Direction                     = $Rule.Direction                     # : Outbound
            Action                        = $Rule.Action                        # : Allow
            EdgeTraversalPolicy           = $Rule.EdgeTraversalPolicy           # : Block
            LSM                           = $Rule.LSM                           # : False
            PrimaryStatus                 = $Rule.PrimaryStatus                 # : OK
            Status                        = $Rule.Status                        # : The rule was parsed successfully from the store. (65536)
            EnforcementStatus             = $Rule.EnforcementStatus             # : NotApplicable
            PolicyStoreSourceType         = $Rule.PolicyStoreSourceType         # : Local
            Caption                       = $Rule.Caption                       # :
            Description                   = $Rule.Description                   # : Outbound rule for Network Discovery to allow use of Universal Plug and Play. [TCP]
            ElementName                   = $Rule.ElementName                   # : @FirewallAPI.dll,-32765
            InstanceID                    = $Rule.InstanceID                    # : NETDIS-UPnPHost-Out-TCP
            CommonName                    = $Rule.CommonName                    # :
            PolicyKeywords                = $Rule.PolicyKeywords                # :
            PolicyDecisionStrategy        = $Rule.PolicyDecisionStrategy        # : 2
            PolicyRoles                   = $Rule.PolicyRoles                   # :
            ConditionListType             = $Rule.ConditionListType             # : 3
            CreationClassName             = $Rule.CreationClassName             # : MSFT|FW|FirewallRule|NETDIS-UPnPHost-Out-TCP
            ExecutionStrategy             = $Rule.ExecutionStrategy             # : 2
            Mandatory                     = $Rule.Mandatory                     # :
            PolicyRuleName                = $Rule.PolicyRuleName                # :
            Priority                      = $Rule.Priority                      # :
            RuleUsage                     = $Rule.RuleUsage                     # :
            SequencedActions              = $Rule.SequencedActions              # : 3
            SystemCreationClassName       = $Rule.SystemCreationClassName       # :
            SystemName                    = $Rule.SystemName                    # :
            DisplayGroup                  = $Rule.DisplayGroup                  # : Network Discovery
            LocalOnlyMapping              = $Rule.LocalOnlyMapping              # : False
            LooseSourceMapping            = $Rule.LooseSourceMapping            # : False
            Owner                         = $Rule.Owner                         # :
            PackageFamilyName             = $Rule.PackageFamilyName             # :
            Platforms                     = $Rule.Platforms                     # : {}
            PolicyAppId                   = $Rule.PolicyAppId                   # :
            PolicyStoreSource             = $Rule.PolicyStoreSource             # : PersistentStore
            Profiles                      = $Rule.Profiles                      # : 4
            RemoteDynamicKeywordAddresses = $Rule.RemoteDynamicKeywordAddresses # : {}
            RuleGroup                     = $Rule.RuleGroup                     # : @FirewallAPI.dll,-32752
            StatusCode                    = $Rule.StatusCode                    # : 65536
            Program                       = $FiltersCache[$Rule.Name].Program
            AppPath                       = $FiltersCache[$Rule.Name].AppPath
            Protocol                      = $PortCache[$Rule.Name].Protocol      # : TCP
            LocalPort                     = $PortCache[$Rule.Name].LocalPort     # : Any
            RemotePort                    = $PortCache[$Rule.Name].RemotePort    # : 2869
            IcmpType                      = $PortCache[$Rule.Name].IcmpType      # : Any
            DynamicTarget                 = $PortCache[$Rule.Name].DynamicTarget # : Any
        }
    }
}