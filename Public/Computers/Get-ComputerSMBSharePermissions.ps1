function Get-ComputerSMBSharePermissions {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName,
        [Parameter(Mandatory = $true)][alias('Name')][string[]] $ShareName
    )
    [Array] $Computers = Get-ComputerSplit -ComputerName $ComputerName
    if ($Computers[0].Count -gt 0) {
        foreach ($Share in $ShareName) {
            try {
                $Output = Get-SmbShareAccess -Name $Share -ErrorAction Stop
            } catch {
                $ErrorMessage = $_.Exception.Message
                Write-Warning -Message "Get-ComputerSMBSharePermissions - Computer $Env:COMPUTERNAME, Share $Share, Error: $ErrorMessage"
            }
            foreach ($_ in $Output) {
                Add-Member -InputObject $_ -Name 'PSComputerName' -Value $Env:COMPUTERNAME -MemberType NoteProperty -Force
                $_
            }
        }
    }
    if ($Computers[1].Count -gt 0) {
        foreach ($Share in $ShareName) {
            try {
                $Output = Get-SmbShareAccess -CimSession $Computers[1] -Name $Share -ErrorAction Stop
            } catch {
                $ErrorMessage = $_.Exception.Message
                Write-Warning -Message "Get-ComputerSMBSharePermissions - Computer $($Computers[1]), Share $Share, Error: $ErrorMessage"
            }
            foreach ($_ in $Output) {
                $_
            }
        }
    }
}