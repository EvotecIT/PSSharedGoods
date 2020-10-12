function Get-PSService {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Computers
    Parameter description

    .PARAMETER Services
    Parameter description

    .PARAMETER MaxRunspaces
    Parameter description

    .EXAMPLE
    Get-PSService -Services 'Dnscache', 'DNS', 'PeerDistSvc', 'WebClient','Netlogon' -Computers 'AD1.AD.EVOTEC.XYZ', 'AD2'

    .NOTES
    General notes
    #>

    [cmdletbinding()]
    param (
        [alias('Computer', 'Computers')][string[]] $ComputerName = $Env:COMPUTERNAME,
        [alias('Service')][string[]] $Services,
        [int] $MaxRunspaces = [int]$env:NUMBER_OF_PROCESSORS + 1
    )

    $sbGetService = {
        Param (
            [string]$Computer,
            [string]$ServiceName,
            [bool] $Verbose
        )
        $Measure = [System.Diagnostics.Stopwatch]::StartNew() # Timer Start
        $ServiceList = @(
            if ($Verbose) { $verbosepreference = 'continue' }
            try {
                if ($ServiceName -eq '') {
                    Write-Verbose "Get-PSService - [i] Processing $Computer for all services"
                    $GetServices = Get-Service -ComputerName $Computer -ErrorAction Stop

                } else {
                    Write-Verbose "Get-PSService - [i] Processing $Computer with $ServiceName"
                    $GetServices = Get-Service -ComputerName $Computer -ServiceName $ServiceName -ErrorAction Stop
                }
            } catch {
                [PsCustomObject] @{
                    ComputerName   = $Computer
                    Status         = 'N/A'
                    Name           = $ServiceName
                    ServiceType    = 'N/A'
                    StartType      = 'N/A'
                    DisplayName    = 'N/A'
                    TimeProcessing = $Measure.Elapsed
                    Comment        = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                }
            }
            foreach ($GetService in $GetServices) {
                if ($GetService) {
                    [PsCustomObject] @{
                        ComputerName   = $Computer
                        Status         = $GetService.Status
                        Name           = $GetService.Name
                        ServiceType    = $GetService.ServiceType
                        StartType      = $GetService.StartType
                        DisplayName    = $GetService.DisplayName
                        TimeProcessing = $Measure.Elapsed
                        Comment        = ''
                    }
                } else {
                    [PsCustomObject] @{
                        ComputerName   = $Computer
                        Status         = 'N/A'
                        Name           = $ServiceName
                        ServiceType    = 'N/A'
                        StartType      = 'N/A'
                        DisplayName    = 'N/A'
                        TimeProcessing = $Measure.Elapsed
                        Comment        = ''
                    }
                }
            }
        )
        Write-Verbose "Get-PSService - [i] Processed $Computer with $ServiceName - Time elapsed: $($Measure.Elapsed)"
        $Measure.Stop()
        return $ServiceList
    }

    if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) { $Verbose = $true } else { $Verbose = $false }
    Write-Verbose 'Get-PSService - Starting parallel processing....'
    $ComputersToProcess = ($ComputerName | Measure-Object).Count
    $ServicesToProcess = ($Services | Measure-Object).Count
    Write-Verbose -Message "Get-PSService - Computers to process: $ComputersToProcess"
    Write-Verbose -Message "Get-PSService - Computers List: $($ComputerName -join ', ')"
    Write-Verbose -Message "Get-PSService - Services to process: $ServicesToProcess"
    $MeasureTotal = [System.Diagnostics.Stopwatch]::StartNew() # Timer Start

    ### Define Runspace START
    $Pool = New-Runspace -maxRunspaces $maxRunspaces
    ### Define Runspace END
    $runspaces = @(
        foreach ($Computer in $ComputerName) {
            if ($null -ne $Services) {
                foreach ($ServiceName in $Services) {
                    Write-Verbose "Get-PSService - Getting service $ServiceName on $Computer"
                    # processing runspace start
                    $Parameters = @{
                        Computer    = $Computer
                        ServiceName = $ServiceName
                        Verbose     = $Verbose
                    }
                    Start-Runspace -ScriptBlock $sbGetService -Parameters $Parameters -RunspacePool $Pool
                    # processing runspace end
                }
            } else {
                Write-Verbose "Get-PSService - Getting all services on $Computer"
                $Parameters = @{
                    Computer    = $Computer
                    ServiceName = ''
                    Verbose     = $Verbose
                }
                Start-Runspace -ScriptBlock $sbGetService -Parameters $Parameters -RunspacePool $Pool
            }
        }
    )
    ### End Runspaces START
    $List = Stop-Runspace -Runspaces $runspaces -FunctionName 'Get-Service' -RunspacePool $Pool
    ### End Runspaces END
    $MeasureTotal.Stop()
    Write-Verbose "Get-PSService - Ending....$($measureTotal.Elapsed)"

    return $List
}