function Disconnect-WinSkype {
    [CmdletBinding()]
    param(
        [string] $SessionName = "Microsoft Skype",
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
                Write-Warning "Disconnect-WinSkype - Failed with error message: $ErrorMessage"
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