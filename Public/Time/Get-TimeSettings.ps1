
<#
function Get-TimeSynchronization {
    [CmdletBinding()]
    param(

    )
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient

}
#>
<#
w32tm /config /manualpeerlist:"0.uk.pool.ntp.org,0x1 1.uk.pool.ntp.org,0x1 2.uk.pool.ntp.org,0x1 3.uk.pool.ntp.org,0x1"
w32tm /config /reliable:yes
Restart-Service -Name 'w32time'
#>

<#
w32tm /resync /nowait
w32tm /query /configuration
w32tm /query /source
w32tm /query /peers
w32tm /query /status
w32tm /config /syncfromflags:domhier /update
#>

<#
    net stop w32time
    w32tm /unregister
    w32tm /register
    net start w32time
#>
<#
$Servers = 'localhost','127.0.0.1'

$w32tm = Invoke-Command -Computer $Servers -ArgumentList $Servers -Scriptblock {
    Param ($Servers)
    Foreach ($Server in $Servers)
    {
        $Check = w32tm /monitor /computers:$Server /nowarn
        $ICMP = (($Check | Select-String "ICMP")-Replace "ICMP: " , "").Trim()
        $ICMPVal = [int]($ICMP -split "ms")[0]
        $Source = w32tm /query /source
        $Name = Hostname

        Switch ($ICMPVal)
            {
                {$ICMPVal -le 0} {$Status = "Optimal time synchronisation"}
                #you probably need another value here since you'll get no status if it is between 0 and 2m
                {$ICMPVal -lt 100000} {$Status = "0-2 Minute time difference"}
                {$ICMPVal -ge 100000} {$Status = "Warning, 2 minutes time difference"}
                {$ICMPVal -ge 300000} {$Status = "Critical. Over 5 minutes time difference!"}
            }
        $String = $Name + " - $Status " + "- $ICMP " + " - Source: $Source"
        Write-Output $String
    }
}

$w32tm
#>


function Get-TimeSetttings {
    [alias('Get-TimeSynchronization')]
    param(
        [string[]] $ComputerName,
       # [string] $Domain,
        [switch] $Formatted,
        [string] $Splitter
    )
    # https://icookservers.blog/2014/09/12/windows-ntp-server-cookbook/
    # https://docs.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings
    $Types = @{
        NT5DS   = 'The time service synchronizes from the domain hierarchy.' # Use on computers that are joined to a domain.
        NTP     = 'The time service synchronizes from the servers specified in the NtpServer registry entry.'  #Use on computers that are not joined to a domain.
        ALLSync = 'The time service uses all the available synchronization mechanisms.'
        NoSync  = 'The time service does not synchronize with other sources.'

        # The default value on domain members is NT5DS. The default value on stand-alone clients and servers is NTP.
    }

    $NtpServerIntervals = @{
        '0x1' = 'SpecialInterval' # flag indicate sync time with external server in special interval configured in “SpecialPollInterval” registry value.
        '0x2' = 'UseAsFallbackOnly' #  use this as UseAsFallbackOnly time source – if primary is not available then sync to this server.
        '0x4' = 'SymmetricActive' #- For more information about this mode, see Windows Time Server: 3.3 Modes of Operation.
        '0x8' = 'Client' #use client mode association while sync time to external time source.
        '0x9' = 'SpecialInterval+Client' # use special interval + client mode association to external time source. This is a good value when your machine sync time to an external time source.
        #'0x10' = 'Unknown'
    }


    $CrossSiteSyncFlags = @{
        '0' = 'None'
        '1' = 'PdcOnly'
        '2' = 'All'

        # Entry determines whether the service chooses synchronization partners outside the domain of the computer. The options and values are:
        # This value is ignored if the NT5DS value is not set. The default value for domain members is 2. The default value for stand-alone clients and servers is 2.
    }


    $AnnounceFlags = @{
        '0'  = 'Not a time server'
        '1'  = 'Always time server'
        '2'  = 'Automatic time server'
        '4'  = 'Always reliable time server'
        '8'  = 'Automatic reliable time server'
        '10' = 'The default value for domain members is 10. The default value for stand-alone clients and servers is 10.'
    }

   # if ($Domain) {
    #    $DomainInformation = Get-ADDomain -Server $Domain
    #    $PDCName = $DomainInformation.PDCEmulator
  #  }

    foreach ($_ in $ComputerName) {
        $TimeParameters = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
        $TimeConfig = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config"
        #Get-PSRegistry -ComputerName $ComputerName -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Security"
        $TimeNTPClient = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NTPClient"
        $TimeNTPServer = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NTPServer"
        #$TimeSecureLimits = Get-PSRegistry -ComputerName $_ -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\SecureTimeLimits"
        $TimeVMProvider = Get-PSRegistry -ComputerName $ComputerName -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\VMICTimeProvider"
        #Get-PSRegistry -ComputerName $ComputerName -RegistryPath "HKLM\SYSTEM\CurrentControlSet"

        $NtpServers = $TimeParameters.NtpServer -split ' '
        $Ntp = foreach ($NtpServer in $NtpServers) {
            $SplitNTP = $NtpServer -split ','
            [PSCustomObject] @{
                NtpServer = $SplitNTP[0]
                Intervals = $NtpServerIntervals[$SplitNTP[1]]
            }
        }

        #$FullName = Resolve-DnsName -Name $_ -ErrorAction SilentlyContinue

        [PSCustomObject] @{
            ComputerName                = $_
            #IsPDC                       = ($PDCName -eq $FullName.Name)
            NtpServer                   = if ($Splitter) { $Ntp.NtpServer -join $Splitter } else { $Ntp.NtpServer }
            NtpServerIntervals          = if ($Splitter) { $Ntp.Intervals -join $Splitter } else { $Ntp.Intervals }
            NtpType                     = $TimeParameters.Type
            NtpTypeComment              = $Types["$($TimeParameters.Type)"]
            VMTimeProvider              = [bool] $TimeVMProvider.Enabled
            AnnounceFlags               = $TimeConfig.AnnounceFlags
            AnnounceFlagsComment        = $AnnounceFlags["$($TimeConfig.AnnounceFlags)"]
            NtpServerEnabled            = [bool]$TimeNTPServer.Enabled
            NtpServerInputProvider      = [bool]$TimeNTPServer.InputProvider
            MaxPosPhaseCorrection       = $TimeConfig.MaxPosPhaseCorrection
            MaxnegPhaseCorrection       = $TimeConfig.MaxnegPhaseCorrection
            MaxAllowedPhaseOffset       = $TimeConfig.MaxAllowedPhaseOffset
            MaxPollInterval             = $TimeConfig.MaxPollInterval
            MinPollInterval             = $TimeConfig.MinPollInterval
            UpdateInterval              = $TimeConfig.UpdateInterval
            ResolvePeerBackoffMinutes   = $TimeNTPClient.ResolvePeerBackoffMinutes
            ResolvePeerBackoffMaxTimes  = $TimeNTPClient.ResolvePeerBackoffMaxTimes
            SpecialPollInterval         = $TimeNTPClient.SpecialPollInterval
            EventLogFlags               = $TimeConfig.EventLogFlags
            NtpClientEnabled            = [bool] $TimeNTPClient.Enabled
            NtpClientCrossSiteSyncFlags = $CrossSiteSyncFlags["$($TimeNTPClient.CrossSiteSyncFlags)"]
            NtpClientInputProvider      = [bool] $TimeNTPClient.InputProvider
            TimeNTPClient               = $TimeNTPClient.SpecialPollInterval
        }
    }
}

#$ComputersDC = @( 'AD1', 'AD2', 'AD3', 'DC1', 'EVOWIN', 'ADPreview2019')

#Get-PSRegistry -ComputerName AD1 -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters", "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config"
#Get-PSRegistry -ComputerName EVOWIN -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Security"
#Get-PSRegistry -ComputerName AD1 -RegistryPath "HKLM\SYSTEM\CurrentControlSet"


<#
Get-PSRegistry -ComputerName $ComputersDC -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" | ft -AutoSize *
Get-PSRegistry -ComputerName $ComputersDC -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config" | ft -AutoSize *
Get-PSRegistry -ComputerName $ComputersDC -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NTPClient" | ft -AutoSize *
Get-PSRegistry -ComputerName $ComputersDC -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NTPServer" | ft -AutoSize *
Get-PSRegistry -ComputerName $ComputersDC -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\VMICTimeProvider" | ft -AutoSize *
Get-PSRegistry -ComputerName $ComputersDC -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\SecureTimeLimits" | ft -AutoSize *
Get-PSRegistry -ComputerName $ComputersDC -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\SecureTimeLimits\RunTime" | ft -AutoSize *
#>

# https://www.mczerniawski.pl/hyperv/proper-time-configuration-for-virtualized-dc/
#https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-registry-entries?view=powershell-6
# https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc773263(v=ws.10)
# HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\VMICTimeProvider




#$ComputersDC = @('EVOWIN', 'ADPreview2019')

#Get-TimeSetttings -ComputerName $ComputersDC | Out-HtmlView
#get-TimeSetttings -ComputerName $ComputersDC | ft -a *