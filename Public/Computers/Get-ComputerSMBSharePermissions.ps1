function Get-ComputerSMBSharePermissions {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName,
        [Parameter(Mandatory = $true)][alias('Name')][string] $ShareName
    )
    [Array] $Computers = Get-ComputerSplit -ComputerName $ComputerName
    $SMB = @(
        if ($Computers[0].Count -gt 0) {
            try {
                $Output = Get-SmbShareAccess -Name $ShareName -ErrorAction Stop
            } catch {
                $ErrorMessage = $_.Exception.Message
                Write-Warning "Get-ComputerSMBSharePermissions - Share $ShareName error: $ErrorMessage"
            }
            foreach ($_ in $Output) {
                Add-Member -InputObject $_ -Name 'PSComputerName' -Value $Env:COMPUTERNAME -MemberType NoteProperty -Force
                $_
            }
        }
        if ($Computers[1].Count -gt 0) {
            try {
                $Output = Get-SmbShareAccess -CimSession $Computers[1] -Name $ShareName -ErrorAction Stop
            } catch {
                $ErrorMessage = $_.Exception.Message
                Write-Warning "Get-ComputerSMBSharePermissions - Share $ShareName error: $ErrorMessage"
            }
            foreach ($_ in $Output) {
                $_
            }
        }
    )
    $SMB
}

#Get-ComputerSMBSharePermissions -ShareName Netlogon -ComputerName AD1,AD2