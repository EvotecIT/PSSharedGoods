function Disconnect-WinSecurityCompliance {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Security and Compliance',
        [switch] $Output
    )
    $Object = @()
    $ExistingSession = Get-PSSession -Name $SessionName -ErrorAction SilentlyContinue
    if ($ExistingSession) {
        try {
            Remove-PSSession -Name $SessionName -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
            if ($Output) {
                $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. Error: $ErrorMessage" }
                return $Object
            } else {
                Write-Warning "Disconnect-WinSecurityCompliance - Failed with error message: $ErrorMessage"
                return
            }
        }
        if ($Output) {
            $Object += @{ Status = $true; Output = $SessionName; Extended = "Disconnection succeeded." }
            return $Object
        }
    } else {
        if ($Output) {
            $Object += @{ Status = $false; Output = $SessionName; Extended = "Disconnection failed. No connection exists." }
            return $Object
        }
    }

}