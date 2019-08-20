function Start-InternalFunction {
    [CmdletBinding()]
    param(
        [ScriptBlock] $ScriptBlock,
        [string] $Module
    )

    $InternalModule = Import-Module -Name $Module -PassThru
    & $InternalModule $ScriptBlock
}