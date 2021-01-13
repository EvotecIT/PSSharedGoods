function Invoke-CommandCustom {
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
    $InvokedCommand = $ps.Invoke()
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
        if ($Ps.Streams.Error) {
            $Output['Error'] = $ps.Streams.Error
        }
    }
    if ($ReturnError -or $ReturnVerbose -or $ReturnWarning) {
        $Output
    } else {
        $Output.Output
    }
}