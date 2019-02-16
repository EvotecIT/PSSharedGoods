function Set-ServiceRecovery {
    <#
    .SYNOPSIS
    #
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ServiceDisplayName
    Parameter description
    
    .PARAMETER Server
    Parameter description
    
    .PARAMETER action1
    Parameter description
    
    .PARAMETER time1
    Parameter description
    
    .PARAMETER action2
    Parameter description
    
    .PARAMETER time2
    Parameter description
    
    .PARAMETER actionLast
    Parameter description
    
    .PARAMETER timeLast
    Parameter description
    
    .PARAMETER resetCounter
    Parameter description
    
    .EXAMPLE
    Set-ServiceRecovery -ServiceDisplayName "Pulseway" -Server "MAIL1"
    
    .NOTES
    General notes
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
    $services = Get-CimInstance -ClassName 'Win32_Service' -ComputerName $Server| Where-Object {$_.DisplayName -imatch $ServiceDisplayName}
    $action = $action1 + "/" + $time1 + "/" + $action2 + "/" + $time2 + "/" + $actionLast + "/" + $timeLast
    foreach ($service in $services) {
        # https://technet.microsoft.com/en-us/library/cc742019.aspx
        $output = sc.exe $serverPath failure $($service.Name) actions= $action reset= $resetCounter
    }
}