function Get-ComputerCulture {
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME
    )
    $ScriptBlock = {
        Get-Culture | Select-Object KeyboardLayoutId, DisplayName, @{Expression = { $_.ThreeLetterWindowsLanguageName }; Label = "Windows Language" }
    }
    if ($ComputerName -eq $Env:COMPUTERNAME) {
        $Data8 = Invoke-Command -ScriptBlock $ScriptBlock
    } else {
        $Data8 = Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock
    }
    return $Data8
}