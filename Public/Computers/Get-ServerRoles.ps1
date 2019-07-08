function Get-ServerRoles {
    [CmdletBinding()]
    param (
        $ComputerName = $env:COMPUTERNAME
    )
    $List = @()
    foreach ($Computer in $ComputerName) {
        $Output = get-windowsfeature -ComputerName $Computer |  Where-Object {$_.installed -eq $true -and $_.featuretype -eq 'Role'} |  Select-Object name, installed -ExcludeProperty subfeatures
        $List += $Output | Select-Object name, installed , @{name = 'Server Name'; expression = {$Computer}}
    }
    return $List
}