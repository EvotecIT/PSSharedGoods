function Get-ServerRoles {
    [CmdletBinding()]
    param (
        $ComputerName = $env:COMPUTERNAME
    )
    $List = @(
        foreach ($Computer in $ComputerName) {
            $Output = Get-WindowsFeature -ComputerName $Computer | Where-Object { $_.installed -eq $true -and $_.featuretype -eq 'Role' } | Select-Object name, installed -ExcludeProperty subfeatures
            $Output | Select-Object Name, Installed , @{name = 'Server Name'; expression = { $Computer } }
        }
    )
    return $List
}