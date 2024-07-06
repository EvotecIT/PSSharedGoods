function Invoke-CommandCustom {
    <#
    .SYNOPSIS
    Invokes a script block with optional parameters and arguments.

    .DESCRIPTION
    The Invoke-CommandCustom function executes a script block with the ability to pass parameters and arguments. It provides options to return verbose output, errors, and warnings.

    .PARAMETER ScriptBlock
    Specifies the script block to execute.

    .PARAMETER Parameter
    Specifies a dictionary of parameters to pass to the script block.

    .PARAMETER Argument
    Specifies an array of arguments to pass to the script block.

    .PARAMETER ReturnVerbose
    Indicates whether to return verbose output.

    .PARAMETER ReturnError
    Indicates whether to return errors.

    .PARAMETER ReturnWarning
    Indicates whether to return warnings.

    .PARAMETER AddParameter
    Indicates whether to add parameters to the script block.

    .EXAMPLE
    Invoke-CommandCustom -ScriptBlock { Get-Process } -ReturnVerbose

    Description:
    Invokes the Get-Process cmdlet and returns verbose output.

    .EXAMPLE
    Invoke-CommandCustom -ScriptBlock { Get-Service } -Parameter @{Name="Spooler"} -ReturnError

    Description:
    Invokes the Get-Service cmdlet with the "Spooler" parameter and returns any errors encountered.

    #>
    [cmdletBinding()]
    param(
        [scriptblock] $ScriptBlock,
        [System.Collections.IDictionary] $Parameter,
        [array] $Argument,
        [switch] $ReturnVerbose,
        [switch] $ReturnError,
        [switch] $ReturnWarning,
        [switch] $AddParameter
    )
    $Output = [ordered]@{}
    $ps = [PowerShell]::Create()
    if ($ReturnVerbose) {
        $null = $ps.AddScript('$VerbosePreference = "Continue"').AddStatement()
    }
    if ($ScriptBlock) {
        if ($Parameter -and $AddParameter) {
            $Count = 0
            [string] $ScriptBlockParams = @(
                "param("
                foreach ($Key in $Parameter.Keys) {
                    $Count++
                    if ($Count -eq $Parameter.Keys.Count) {
                        "`$$($Key)"
                    } else {
                        "`$$($Key),"
                    }
                }
                ")"
                $ScriptBlock.ToString()
            )
            $ScriptBlockScript = [scriptblock]::Create($ScriptBlockParams)
            $null = $ps.AddScript($ScriptBlockScript)
        } else {
            $null = $ps.AddScript($ScriptBlock)
        }
    }
    if ($Parameter) {
        foreach ($Key in $Parameter.Keys) {
            $null = $ps.AddParameter($Key, $Parameter[$Key])
        }
    }
    if ($Argument) {
        foreach ($Arg in $Argument) {
            $null = $ps.AddArgument($Arg)
        }
    }
    $ErrorCaught = $null
    try {
        $InvokedCommand = $ps.Invoke()
    } catch {
        $ErrorCaught = $_
    }
    if ($InvokedCommand) {
        $Output['Output'] = $InvokedCommand
    }
    if ($ReturnVerbose) {
        if ($Ps.Streams.Verbose) {
            $Output['Verbose'] = $ps.Streams.Verbose
        }
    }
    if ($ReturnWarning) {
        if ($ps.Streams.Warning) {
            $Output['Warning'] = $ps.Streams.Warning
        }
    }
    if ($ReturnError) {
        if ($ErrorCaught) {
            $Output['Error'] = $ErrorCaught
        } else {
            if ($Ps.Streams.Error) {
                $Output['Error'] = $ps.Streams.Error
            }
        }
    }
    if ($ReturnError -or $ReturnVerbose -or $ReturnWarning) {
        $Output
    } else {
        $Output.Output
    }
}