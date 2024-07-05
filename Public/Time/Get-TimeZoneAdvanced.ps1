function Get-TimeZoneAdvanced {
    <#
    .SYNOPSIS
    Retrieves the time zone information for the specified computer(s).

    .DESCRIPTION
    This function retrieves the time zone information for the specified computer(s) including the computer name, time zone caption, and current local time.

    .PARAMETER ComputerName
    Specifies the name(s) of the computer(s) to retrieve the time zone information from. Default is the local computer.

    .PARAMETER Credential
    Specifies the credentials to use for accessing remote computers.

    .EXAMPLE
    Get-TimeZoneAdvanced
    # Retrieves time zone information for the local computer.

    .EXAMPLE
    Get-TimeZoneAdvanced -ComputerName "Server01", "Server02" -Credential $cred
    # Retrieves time zone information for Server01 and Server02 using specified credentials.

    #>
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