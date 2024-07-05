function Start-MyProgram {
    <#
    .SYNOPSIS
    Starts a program with specified arguments and logs the output.

    .DESCRIPTION
    This function starts a program with the provided arguments and logs the output using a specified logger. If no logger is provided, it returns the output as a string.

    .PARAMETER Program
    The path to the program to be executed.

    .PARAMETER CmdArgList
    An array of arguments to be passed to the program.

    .PARAMETER LoggerParameters
    A dictionary containing parameters for the logger.

    .EXAMPLE
    Start-MyProgram -Program "C:\Program.exe" -CmdArgList @("-arg1", "-arg2") -LoggerParameters @{"LogPath"="C:\Logs"; "LogLevel"="Info"}
    Starts the program "C:\Program.exe" with arguments "-arg1" and "-arg2" and logs the output using a logger with log path "C:\Logs" and log level "Info".

    .EXAMPLE
    Start-MyProgram -Program "C:\AnotherProgram.exe" -CmdArgList @("-input", "file.txt")
    Starts the program "C:\AnotherProgram.exe" with argument "-input file.txt" and returns the output as a string.

    #>
    [CmdletBinding()]
    param (
        [string] $Program,
        [string[]] $CmdArgList,
        [System.Collections.IDictionary] $LoggerParameters
    )

   # $Output = & $Program $CmdArgList 2>&1
    $Output = (cmd /c $Program $CmdArgList '2>&1')
    if (-not $LoggerParameters) {
        if ($Output) {
            return $Output
        }
    } else {
        $Logger = Get-Logger @LoggerParameters
        if ($null -ne $Output) {
            $Logger.AddInfoRecord("Running program $Program with output: $Output")
        } else {
            $Logger.AddInfoRecord("Running program $Program $CmdArgList")
        }
    }
}