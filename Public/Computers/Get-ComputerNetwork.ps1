function Get-ComputerNetwork {
    [alias('Get-ComputerNetworkCard')]
    <#
    .SYNOPSIS

    .DESCRIPTION
    Long description

    .PARAMETER ComputerName
    Parameter description

    .PARAMETER NetworkFirewallOnly
    Parameter description

    .PARAMETER NetworkFirewallSummaryOnly
    Parameter description

    .EXAMPLE

    Get-ComputerNetworkCard -ComputerName AD1, AD2, AD3

    Output

    Name          NetworkCardName             NetworkCardIndex     FirewallProfile FirewallStatus IPv4Connectivity IPv6Connectivity Caption Description ElementName DefaultInboundAction DefaultOutboundAction AllowInboundRules AllowLocalFirewallRules AllowLocalIPsecRules AllowUserApps AllowUserPorts AllowUnicastResponseToMulticast NotifyOnListen EnableStealthModeForIPsec LogFileName                                           LogMaxSizeKilobytes LogAllowed LogBlo
                                                                                                                                                                                                                                                                                                                                                                                                                                                                        cked
    ----          ---------------             ----------------     --------------- -------------- ---------------- ---------------- ------- ----------- ----------- -------------------- --------------------- ----------------- ----------------------- -------------------- ------------- -------------- ------------------------------- -------------- ------------------------- -----------                                           ------------------- ---------- ------
    ad.evotec.xyz vEthernet (External Switch)               13 DomainAuthenticated           True         Internet        NoTraffic                                        NotConfigured         NotConfigured     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured           True             NotConfigured %systemroot%\system32\LogFiles\Firewall\pfirewall.log                4096      False  False
    Network  2    Ethernet 2                                 2             Private           True         Internet        NoTraffic                                                Block                 Allow     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured          False             NotConfigured %systemroot%\system32\LogFiles\Firewall\pfirewall.log                4096      False  False
    Network       Ethernet                                   2             Private           True     LocalNetwork        NoTraffic                                        NotConfigured         NotConfigured     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured          False             NotConfigured %systemroot%\system32\LogFiles\Firewall\pfirewall.log                4096      False  False
    ad.evotec.xyz Ethernet 5                                 3 DomainAuthenticated          False         Internet        NoTraffic                                        NotConfigured         NotConfigured     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured          False             NotConfigured %systemroot%\system32\LogFiles\Firewall\pfirewall.log                4096      False  False
    Network 2     Ethernet 4                                12             Private          False     LocalNetwork        NoTraffic                                        NotConfigured         NotConfigured     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured          False             NotConfigured %systemroot%\system32\LogFiles\Firewall\pfirewall.log                4096      False  False

    .EXAMPLE

    Get-ComputerNetworkCard -ComputerName EVOWIN -NetworkFirewallOnly

    PSComputerName Profile Enabled DefaultInboundAction DefaultOutboundAction AllowInboundRules AllowLocalFirewallRules AllowLocalIPsecRules AllowUserApps AllowUserPorts AllowUnicastResponseToMulticast NotifyOnListen EnableStealthModeForIPsec LogMaxSizeKilobytes LogAllowed LogBlocked    LogIgnored Caption Description ElementName InstanceID                      DisabledInterfaceAliases LogFileName                                           Name    CimClass
    -------------- ------- ------- -------------------- --------------------- ----------------- ----------------------- -------------------- ------------- -------------- ------------------------------- -------------- ------------------------- ------------------- ---------- ----------    ---------- ------- ----------- ----------- ----------                      ------------------------ -----------                                           ----    --------
    EVOWIN         Domain     True        NotConfigured         NotConfigured     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured           True             NotConfigured                4096      False      False NotConfigured                                 MSFT|FW|FirewallProfile|Domain  {NotConfigured}          %systemroot%\system32\LogFiles\Firewall\pfirewall.log Domain  root/stand...
    EVOWIN         Private    True        NotConfigured         NotConfigured     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured           True             NotConfigured                4096      False      False NotConfigured                                 MSFT|FW|FirewallProfile|Private {NotConfigured}          %systemroot%\system32\LogFiles\Firewall\pfirewall.log Private root/stand...
    EVOWIN         Public     True        NotConfigured         NotConfigured     NotConfigured           NotConfigured        NotConfigured NotConfigured  NotConfigured                   NotConfigured           True             NotConfigured                4096      False      False NotConfigured                                 MSFT|FW|FirewallProfile|Public  {NotConfigured}          %systemroot%\system32\LogFiles\Firewall\pfirewall.log Public  root/stand...

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string[]] $ComputerName,
        [switch] $NetworkFirewallOnly,
        [switch] $NetworkFirewallSummaryOnly
    )
    [Array] $CollectionComputers = $ComputerName.Where( { $_ -eq $Env:COMPUTERNAME }, 'Split')

    $Firewall = @{ }
    $NetworkFirewall = @(
        if ($CollectionComputers[0].Count -gt 0) {
            $Firewall[$Env:COMPUTERNAME] = @{ }
            $Output = Get-NetFirewallProfile
            foreach ($_ in $Output) {
                Add-Member -InputObject $_ -Name 'PSComputerName' -Value $Env:COMPUTERNAME -Type NoteProperty -Force
                $_
                if ($_.Name -eq 'Domain') {
                    $Firewall[$Env:COMPUTERNAME]['DomainAuthenticated'] = $_
                } else {
                    $Firewall[$Env:COMPUTERNAME][$($_.Name)] = $_
                }
            }

        }
        if ($CollectionComputers[1].Count -gt 0) {
            foreach ($_ in $CollectionComputers[1]) {
                $Firewall[$_] = @{ }
            }
            $Output = Get-NetFirewallProfile -CimSession $CollectionComputers[1]
            foreach ($_ in $Output) {
                if ($_.Name -eq 'Domain') {
                    $Firewall[$_.PSComputerName]['DomainAuthenticated'] = $_
                    #  $Firewall[$_.PSComputerName]["DomainAuthenticatedEverything"] = $_
                } else {
                    $Firewall[$_.PSComputerName][$($_.Name)] = $_
                    #$Firewall[$_.PSComputerName]["$($_.Name)Everything"] = $_
                }

            }
        }
    )
    if ($NetworkFirewallOnly) {
        return $NetworkFirewall
    }
    if ($NetworkFirewallSummaryOnly) {
        <#
        Name                           Value
        ----                           -----
        AD1                            {Private, DomainAuthenticated, Public}
        DC1                            {Private, DomainAuthenticated, Public}
        AD2                            {Private, DomainAuthenticated, Public}
        EVOWIN                         {Private, DomainAuthenticated, Public}
        AD3                            {Private, DomainAuthenticated, Public}

        Where $T['EvoWin']['Private']

        Name                            : Private
        Enabled                         : True
        DefaultInboundAction            : NotConfigured
        DefaultOutboundAction           : NotConfigured
        AllowInboundRules               : NotConfigured
        AllowLocalFirewallRules         : NotConfigured
        AllowLocalIPsecRules            : NotConfigured
        AllowUserApps                   : NotConfigured
        AllowUserPorts                  : NotConfigured
        AllowUnicastResponseToMulticast : NotConfigured
        NotifyOnListen                  : True
        EnableStealthModeForIPsec       : NotConfigured
        LogFileName                     : %systemroot%\system32\LogFiles\Firewall\pfirewall.log
        LogMaxSizeKilobytes             : 4096
        LogAllowed                      : False
        LogBlocked                      : False
        LogIgnored                      : NotConfigured
        DisabledInterfaceAliases        : {NotConfigured}

        #>
        return $Firewall
    }
    $NetworkCards = @(
        if ($CollectionComputers[0].Count -gt 0) {
            $Output = Get-NetConnectionProfile
            foreach ($_ in $Output) {
                Add-Member -InputObject $_ -Name 'PSComputerName' -Value $Env:COMPUTERNAME -Type NoteProperty -Force
                $_

            }
        }
        if ($CollectionComputers[1].Count -gt 0) {
            Get-NetConnectionProfile -CimSession $CollectionComputers[1]
        }
    )
    foreach ($_ in $NetworkCards) {
        [PSCustomObject] @{
            Name                            = $_.Name
            NetworkCardName                 = $_.InterfaceAlias
            NetworkCardIndex                = $_.InterfaceIndex
            FirewallProfile                 = $_.NetworkCategory
            FirewallStatus                  = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].'Enabled'
            IPv4Connectivity                = $_.IPv4Connectivity
            IPv6Connectivity                = $_.IPv6Connectivity
            Caption                         = $_.Caption
            Description                     = $_.Description
            ElementName                     = $_.ElementName
            DefaultInboundAction            = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].DefaultInboundAction
            DefaultOutboundAction           = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].DefaultOutboundAction
            AllowInboundRules               = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].AllowInboundRules
            AllowLocalFirewallRules         = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].AllowLocalFirewallRules
            AllowLocalIPsecRules            = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].AllowLocalIPsecRules
            AllowUserApps                   = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].AllowUserApps
            AllowUserPorts                  = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].AllowUserPorts
            AllowUnicastResponseToMulticast = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].AllowUnicastResponseToMulticast
            NotifyOnListen                  = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].NotifyOnListen
            EnableStealthModeForIPsec       = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].EnableStealthModeForIPsec
            LogFileName                     = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].LogFileName
            LogMaxSizeKilobytes             = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].LogMaxSizeKilobytes
            LogAllowed                      = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].LogAllowed
            LogBlocked                      = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].LogBlocked
            LogIgnored                      = $Firewall[$_.PSComputerName]["$($_.NetworkCategory)"].LogIgnored
            ComputerName                    = $_.PSComputerName
        }
    }
}