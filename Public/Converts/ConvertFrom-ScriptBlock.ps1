function ConvertFrom-ScriptBlock {
    <#
    .SYNOPSIS
    Converts a ScriptBlock into an array of strings, each representing a line of the script block.

    .DESCRIPTION
    This function takes a ScriptBlock as input and converts it into an array of strings, where each string represents a line of the script block.

    .PARAMETER ScriptBlock
    The ScriptBlock to be converted into an array of strings.

    .EXAMPLE
    ConvertFrom-ScriptBlock -ScriptBlock {
        $Variable1 = "Value1"
        $Variable2 = "Value2"
        Write-Host "Hello, World!"
    }

    This example will output an array containing the following strings:
    $Variable1 = "Value1"
    $Variable2 = "Value2"
    Write-Host "Hello, World!"

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [ScriptBlock] $ScriptBlock
    )
    [Array] $Output = foreach ($Line in $ScriptBlock.Ast.EndBlock.Statements.Extent) {
        [string] $Line + [System.Environment]::NewLine
    }
    return $Output
}