function Test-WinRM {
    [CmdletBinding()]
    param (
        [alias('Server')][string[]] $ComputerName
    )
    $Output = foreach ($Computer in $ComputerName) {
        $Test = [PSCustomObject] @{
            Output       = $null
            Status       = $null
            ComputerName = $Computer
        }
        try {
            $Test.Output = Test-WSMan -ComputerName $Computer -ErrorAction Stop
            $Test.Status = $true
        } catch {
            $Test.Status = $false
        }
        $Test
    }
    $Output
}

#Test-WinRM -ComputerName AD1, AD2