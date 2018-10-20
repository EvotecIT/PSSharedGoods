function Test-WinRM {
    [CmdletBinding()]
    param (
        $ComputerName
    )
    try {
        $WinRM = Test-WSMan -ComputerName $Server -ErrorAction Stop
        $Value = $true
    } catch {
        $Value = $false
    }
    return $Value
}