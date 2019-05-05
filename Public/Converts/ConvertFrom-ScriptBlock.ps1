function ConvertFrom-ScriptBlock {
    [CmdletBinding()]
    param(
        [ScriptBlock] $ScriptBlock
    )
    [Array] $Output = foreach ($Line in $ScriptBlock.Ast.EndBlock.Statements.Extent) {
        [string] $Line + [System.Environment]::NewLine
    }
    return $Output
}