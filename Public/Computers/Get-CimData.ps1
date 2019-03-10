function Get-CimData {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [string] $Class,
        [string[]] $Properties = '*'
    ) 
    $CimObject = @(
        # requires removal of this property for query
        [string[]] $PropertiesOnly = $Properties | Where-Object { $_ -ne 'PSComputerName' }   
        # Process all remote computers
        $Computers = $ComputerName | Where-Object { $_ -ne $Env:COMPUTERNAME }
        if ($Computers.Count -gt 0) {
            if ($Protocol = 'Default') {
                Get-CimInstance -ClassName $Class -ComputerName $Computers -ErrorAction SilentlyContinue -Property $PropertiesOnly | Select-Object $Properties
         
            } else {                
                $Option = New-CimSessionOption -Protocol 
                $Session = New-CimSession -ComputerName $Computers -SessionOption $Option
                $Info = Get-CimInstance -ClassName $Class -CimSession $Session -ErrorAction SilentlyContinue -Property $PropertiesOnly | Select-Object $Properties
                $null = Remove-CimSession -CimSession $Session                    
                $Info
            }
        }
        # Process local computer
        $Computers = $ComputerName | Where-Object { $_ -eq $Env:COMPUTERNAME }
        if ($Computers.Count -gt 0) {
            $Info = Get-CimInstance -ClassName $Class -ErrorAction SilentlyContinue -Property $PropertiesOnly | Select-Object $Properties
            $Info | Add-Member -Name 'PSComputerName' -Value $Env:COMPUTERNAME -MemberType NoteProperty -Force
            $Info        
        }
    )
    # Find computers that are not part of data return and warn user
    $CimComputers = $CimObject.PSComputerName | Sort-Object -Unique
    foreach ($Computer in $ComputerName) {
        if ($CimComputers -notcontains $Computer) {
            Write-Warning "Get-ComputerSystem - No data for computer $Computer. Most likely an error on receiving side." 
        }
    }
    return $CimObject
}