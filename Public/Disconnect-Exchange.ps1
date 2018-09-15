function Disconnect-Exchange {
    [CmdletBinding()]
    param(
        $SessionName = "Evotec"
    )
    Remove-PSSession -Name $SessionName
}