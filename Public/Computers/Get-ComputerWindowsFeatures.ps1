function Get-ComputerWindowsFeatures {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )

    $Data = Get-WmiObject Win32_OptionalFeature -ComputerName $vComputerName | Select-Object Caption , Installstate
    return $Data
}