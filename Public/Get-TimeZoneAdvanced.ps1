function Get-TimeZoneAdvanced {
    param(
        [string[]]$ComputerName = $Env:COMPUTERNAME,
        [System.Management.Automation.PSCredential] $Credential = [System.Management.Automation.PSCredential]::Empty
    )
    foreach ($computer in $computerName) {
        $TimeZone = Get-WmiObject -Class win32_timezone -ComputerName $computer -Credential $Credential
        $LocalTime = Get-WmiObject -Class win32_localtime -ComputerName $computer -Credential $Credential
        $Output = @{
            'ComputerName' = $localTime.__SERVER;
            'TimeZone'     = $timeZone.Caption;
            'CurrentTime'  = (Get-Date -Day $localTime.Day -Month $localTime.Month);
        }
        $Object = New-Object -TypeName PSObject -Property $Output
        Write-Output $Object
    }
}