
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


function Get-TimeSettings {
    <#
    .SYNOPSIS
    Retrieves and displays time synchronization settings for the specified computer(s).

    .DESCRIPTION
    The Get-TimeSettings function retrieves and displays time synchronization settings for the specified computer(s). It provides information on the type of time synchronization mechanism being used, NTP server flags, cross-site synchronization flags, and announce flags.

    .PARAMETER ComputerName
    Specifies the computer(s) for which time synchronization settings are to be retrieved. If not specified, the local computer name is used.

    .PARAMETER Formatted
    Switch parameter to format the output in a structured manner.

    .PARAMETER Splitter
    Specifies the character used to split the output if Formatted parameter is used.

    .EXAMPLE
    Get-TimeSettings -ComputerName 'Server01'
    Retrieves time synchronization settings for a single computer named 'Server01'.

    .EXAMPLE
    Get-TimeSettings -ComputerName 'Server01','Server02' -Formatted -Splitter ','
    Retrieves time synchronization settings for multiple computers named 'Server01' and 'Server02' in a formatted output separated by commas.

    #>
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

    [flags()]
    enum NtpServerFlags {
        None = 0
        SpecialInterval = 0x1 # flag indicate sync time with external server in special interval configured in “SpecialPollInterval” registry value.
        UseAsFallbackOnly = 0x2 # use this as UseAsFallbackOnly time source – if primary is not available then sync to this server.
        SymmetricActive = 0x4 # For more information about this mode, see Windows Time Server: 3.3 Modes of Operation.
        Client = 0x8 # use client mode association while sync time to external time source.
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

    if ($null -eq $ComputerName) {
        $ComputerName = $env:COMPUTERNAME
    }
    foreach ($_ in $ComputerName) {
        [bool] $AppliedGPO = $false
        $TimeParameters = Get-PSRegistry -ComputerName $_ -RegistryPath "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\W32time\Parameters"
        if ($null -eq $TimeParameters.NtpServer) {
            $TimeParameters = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
            $AppliedGPO = $true
        }

        $TimeConfig = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config"
        #Get-PSRegistry -ComputerName $ComputerName -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Security"
        $TimeNTPClient = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient"
        if ($null -eq $TimeNTPClient.CrossSiteSyncFlags) {
            $TimeNTPClient = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NTPClient"
        }
        $TimeNTPServer = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NTPServer"
        #$TimeSecureLimits = Get-PSRegistry -ComputerName $_ -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\SecureTimeLimits"
        $TimeVMProvider = Get-PSRegistry -ComputerName $_ -RegistryPath "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\VMICTimeProvider"
        #Get-PSRegistry -ComputerName $ComputerName -RegistryPath "HKLM\SYSTEM\CurrentControlSet"

        $SecureTimeSeeding = Get-PSRegistry -ComputerName $_ -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Config" -Key 'UtilizeSslTimeData'

        $NtpServers = $TimeParameters.NtpServer -split ' '
        $Ntp = foreach ($NtpServer in $NtpServers) {
            $SplitNTP = $NtpServer -split ','

            if ($SplitNTP.Count -eq 2) {

                # sanity check what should be a small hex value
                if ($flagVal = $SplitNTP[1] -as [int]) {
                    # make sure it's within the bounds of our supported flags
                    if ($flags = $flagVal -as [NtpServerFlags]) {
                        $Intervals = $flags.ToString().Replace(', ', '+')
                    } else {
                        Write-Warning -Message "Get-TimeSettings - NtpServer flag value `"$flagVal`" could not be converted to NtpServerFlags enum"
                        $Intervals = 'Incorrect'
                    }
                } else {
                    Write-Warning -Message "Get-TimeSettings - NtpServer flag value `"$($SplitNTP[1])`" could not be parsed as an integer"
                    $Intervals = 'Incorrect'
                }

            } else {
                $Intervals = 'Missing'
            }

            [PSCustomObject] @{
                NtpServer = $SplitNTP[0]
                Intervals = $Intervals
            }
        }

        #$FullName = Resolve-DnsName -Name $_ -ErrorAction SilentlyContinue

        if ($null -eq $TimeConfig.UtilizeSslTimeData) {
            $WSTSType = $true
        } elseif ($TimeConfig.UtilizeSslTimeData -eq 0) {
            $WSTSType = $false
        } else {
            $WSTSType = $true
        }

        if ($null -eq $SecureTimeSeeding.PSType) {
            $WSTSStatus = $false # Windows Secure Time Seeding is enabl;ed (bad)
            $WSTSType = $true
        } elseif ($SecureTimeSeeding.PSType -eq 'DWord' -and $SecureTimeSeeding.PSValue -eq 0) {
            $WSTSStatus = $false # Windows Secure Time Seeding is disabled
            $WSTSType = $true
        } elseif ($SecureTimeSeeding.PSType -eq 'DWord' -and $SecureTimeSeeding.PSValue -eq 1) {
            $WSTSStatus = $true # Windows Secure Time Seeding is disabled
            $WSTSType = $true
        } else {
            $WSTSStatus = $true # Windows Secure Time Seeding is enabled
            $WSTSType = $false
        }


        [PSCustomObject] @{
            ComputerName                        = $_
            #IsPDC                       = ($PDCName -eq $FullName.Name)
            NtpServer                           = if ($Splitter) { $Ntp.NtpServer -join $Splitter } else { $Ntp.NtpServer }
            NtpServerIntervals                  = if ($Splitter) { $Ntp.Intervals -join $Splitter } else { $Ntp.Intervals }
            NtpType                             = $TimeParameters.Type
            NtpTypeComment                      = $Types["$($TimeParameters.Type)"]
            AppliedGPO                          = $AppliedGPO
            VMTimeProvider                      = [bool] $TimeVMProvider.Enabled
            # Windows Secure Time Seeding (UtilizeSslTimeData)
            WindowsSecureTimeSeeding            = $WSTSStatus
            WindowsSecureTimeSeedingTypeCorrect = $WSTSType
            AnnounceFlags                       = $TimeConfig.AnnounceFlags
            AnnounceFlagsComment                = $AnnounceFlags["$($TimeConfig.AnnounceFlags)"]
            NtpServerEnabled                    = [bool]$TimeNTPServer.Enabled
            NtpServerInputProvider              = [bool]$TimeNTPServer.InputProvider
            MaxPosPhaseCorrection               = $TimeConfig.MaxPosPhaseCorrection
            MaxnegPhaseCorrection               = $TimeConfig.MaxnegPhaseCorrection
            MaxAllowedPhaseOffset               = $TimeConfig.MaxAllowedPhaseOffset
            MaxPollInterval                     = $TimeConfig.MaxPollInterval
            MinPollInterval                     = $TimeConfig.MinPollInterval
            UpdateInterval                      = $TimeConfig.UpdateInterval
            ResolvePeerBackoffMinutes           = $TimeNTPClient.ResolvePeerBackoffMinutes
            ResolvePeerBackoffMaxTimes          = $TimeNTPClient.ResolvePeerBackoffMaxTimes
            SpecialPollInterval                 = $TimeNTPClient.SpecialPollInterval
            EventLogFlags                       = $TimeConfig.EventLogFlags
            NtpClientEnabled                    = [bool] $TimeNTPClient.Enabled
            NtpClientCrossSiteSyncFlags         = $CrossSiteSyncFlags["$($TimeNTPClient.CrossSiteSyncFlags)"]
            NtpClientInputProvider              = [bool] $TimeNTPClient.InputProvider
            TimeNTPClient                       = $TimeNTPClient.SpecialPollInterval
        }
    }
}

#Get-TimeSettings -ComputerName DC1, AD1 | Format-List *WindowsSecureTimeSeeding*

#Get-PSRegistry -ComputerName AD1 -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
#Get-PSRegistry -ComputerName AD1 -RegistryPath "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\W32time\Parameters"

#Get-PSRegistry -ComputerName DC1 -RegistryPath "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
#Get-PSRegistry -ComputerName DC1 -RegistryPath "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\W32time\Parameters"


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