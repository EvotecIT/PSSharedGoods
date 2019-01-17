function Disconnect-WinService {
    [CmdletBinding()]
    param(

    )
    Get-PSSession | Remove-PSSession
}