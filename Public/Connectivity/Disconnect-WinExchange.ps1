function Disconnect-WinExchange {
    [CmdletBinding()]
    param(
        $SessionName = "Evotec"
    )
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession) {
        Remove-PSSession -Name $SessionName
    }
}