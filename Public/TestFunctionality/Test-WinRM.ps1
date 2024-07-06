function Test-WinRM {
    <#
    .SYNOPSIS
    Tests the WinRM connectivity on the specified computers.

    .DESCRIPTION
    The Test-WinRM function tests the WinRM connectivity on the specified computers and returns the status of the connection.

    .PARAMETER ComputerName
    Specifies the names of the computers to test WinRM connectivity on.

    .EXAMPLE
    Test-WinRM -ComputerName "Server01", "Server02"
    Tests the WinRM connectivity on Server01 and Server02.

    .EXAMPLE
    Test-WinRM -ComputerName "Server03"
    Tests the WinRM connectivity on Server03.

    #>
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