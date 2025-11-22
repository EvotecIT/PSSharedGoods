function Get-ComputerCulture {
    <#
    .SYNOPSIS
    Retrieves culture information from a specified computer.

    .DESCRIPTION
    This function retrieves culture information from the specified computer. It provides details such as KeyboardLayoutId, DisplayName, and Windows Language.

    .PARAMETER ComputerName
    Specifies the name of the computer from which to retrieve culture information. Defaults to the local computer.

    .PARAMETER Credential
    Alternate credentials for remote Invoke-Command.

    .EXAMPLE
    Get-ComputerCulture
    Retrieves culture information from the local computer.

    .EXAMPLE
    Get-ComputerCulture -ComputerName "Server01"
    Retrieves culture information from a remote computer named Server01.

    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME,
        [pscredential] $Credential
    )
    $ScriptBlock = {
        Get-Culture | Select-Object KeyboardLayoutId, DisplayName, @{Expression = { $_.ThreeLetterWindowsLanguageName }; Label = "Windows Language" }
    }
    if ($ComputerName -eq $Env:COMPUTERNAME) {
        $Data8 = Invoke-Command -ScriptBlock $ScriptBlock
    } else {
        $invokeSplat = @{ ComputerName = $ComputerName; ScriptBlock = $ScriptBlock }
        if ($Credential) { $invokeSplat.Credential = $Credential }
        $Data8 = Invoke-Command @invokeSplat
    }
    return $Data8
}
