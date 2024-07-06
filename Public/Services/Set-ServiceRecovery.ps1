function Set-ServiceRecovery {
    <#
    .SYNOPSIS
    Configures the recovery options for a specified Windows service.

    .DESCRIPTION
    This function sets the recovery options for a Windows service on a remote server. It allows you to define the actions to take upon service failure and the time intervals between these actions.

    .PARAMETER ServiceDisplayName
    The display name of the service for which recovery options need to be set.

    .PARAMETER Server
    The name of the server where the service is located.

    .PARAMETER action1
    The action to take for the first failure. Default is "restart".

    .PARAMETER time1
    The time interval (in milliseconds) before the first action is taken. Default is 30000 milliseconds.

    .PARAMETER action2
    The action to take for the second failure. Default is "restart".

    .PARAMETER time2
    The time interval (in milliseconds) before the second action is taken. Default is 30000 milliseconds.

    .PARAMETER actionLast
    The action to take for subsequent failures. Default is "restart".

    .PARAMETER timeLast
    The time interval (in milliseconds) before the subsequent action is taken. Default is 30000 milliseconds.

    .PARAMETER resetCounter
    The time interval (in seconds) after which the failure counter is reset. Default is 4000 seconds.

    .EXAMPLE
    Set-ServiceRecovery -ServiceDisplayName "Pulseway" -Server "MAIL1"
    Configures the recovery options for the "Pulseway" service on the server "MAIL1" with default settings.

    .NOTES
    For more information on service recovery options, refer to: https://technet.microsoft.com/en-us/library/cc742019.aspx
    #>
    [alias('Set-Recovery')]
    param
    (
        [string] [Parameter(Mandatory = $true)] $ServiceDisplayName,
        [string] [Parameter(Mandatory = $true)] $Server,
        [string] $action1 = "restart",
        [int] $time1 = 30000, # in miliseconds
        [string] $action2 = "restart",
        [int] $time2 = 30000, # in miliseconds
        [string] $actionLast = "restart",
        [int] $timeLast = 30000, # in miliseconds
        [int] $resetCounter = 4000 # in seconds
    )
    $serverPath = "\\" + $server
    $services = Get-CimInstance -ClassName 'Win32_Service' -ComputerName $Server | Where-Object { $_.DisplayName -imatch $ServiceDisplayName }
    $action = $action1 + "/" + $time1 + "/" + $action2 + "/" + $time2 + "/" + $actionLast + "/" + $timeLast
    foreach ($service in $services) {
        # https://technet.microsoft.com/en-us/library/cc742019.aspx
        $output = sc.exe $serverPath failure $($service.Name) actions= $action reset= $resetCounter
    }
}