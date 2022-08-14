function Get-LocalComputerSid {
    [cmdletBinding()]
    param()
    try {
        $LocalAccountSID = Get-CimInstance -Query "SELECT SID FROM Win32_UserAccount WHERE LocalAccount = 'True'" -ErrorAction Stop | Select-Object -First 1 -ExpandProperty SID
        $LocalAccountSID.TrimEnd("-500")
    } catch {
        Write-Warning -Message "Get-LocalComputerSid - Error: $($_.Exception.Message)"
    }
}