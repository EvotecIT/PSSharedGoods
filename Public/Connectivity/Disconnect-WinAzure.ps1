function Disconnect-WinAzure {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Azure MSOL',
        [switch] $Output,
        [switch] $Force
    )
    $Object = @()
    if (-not $Force) {
        if ($Output) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "No way to do this. Kill PowerShell session manually." }
            return $Object
        } else {
            Write-Warning "Disconnect-WinAzure - There is no other way to disconnect from $Session then killing PowerShell session. Do this manually!"
            return
        }
    } else {
        Exit
    }
}

Disconnect-WinAzure -Output