function Get-ComputerCulture {
    <#
    .SYNOPSIS
    Retrieves culture information from a specified computer.

    .DESCRIPTION
    This function retrieves culture information from the specified computer. It provides details such as KeyboardLayoutId, DisplayName, and Windows Language.

    .PARAMETER ComputerName
    Specifies the name of the computer from which to retrieve culture information. Defaults to the local computer.

    .EXAMPLE
    Get-ComputerCulture
    Retrieves culture information from the local computer.

    .EXAMPLE
    Get-ComputerCulture -ComputerName "Server01"
    Retrieves culture information from a remote computer named Server01.

    #>
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