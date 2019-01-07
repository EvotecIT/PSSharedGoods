function Get-TimeSynchronization {
    param(

    )
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer
    Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient

}




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