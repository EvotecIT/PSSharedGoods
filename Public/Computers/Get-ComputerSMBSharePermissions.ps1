function Get-ComputerSMBSharePermissions {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName,
        [Parameter(Mandatory = $true)][alias('Name')][string[]] $ShareName,
        [switch] $Translated
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
            foreach ($O in $Output) {
                if (-not $Translated) {
                    $O | Add-Member -Name 'PSComputerName' -Value $Env:COMPUTERNAME -MemberType NoteProperty -Force
                    $O
                } else {
                    [PSCustomObject] @{
                        Name              = $O.Name              #: NETLOGON
                        ScopeName         = $O.ScopeName         #: *
                        AccountName       = $O.AccountName.ToString()       #: Everyone
                        AccessControlType = $O.AccessControlType.ToString() #: Allow
                        AccessRight       = $O.AccessRight.ToString()       #: Read
                        ComputerName      = $Env:COMPUTERNAME    #: AD2.AD.EVOTEC.XYZ
                    }
                }
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
            foreach ($O in $Output) {
                if (-not $Translated) {
                    $O
                } else {
                    [PSCustomObject] @{
                        Name              = $O.Name              #: NETLOGON
                        ScopeName         = $O.ScopeName         #: *
                        AccountName       = $O.AccountName.ToString()       #: Everyone
                        AccessControlType = $O.AccessControlType.ToString() #: Allow
                        AccessRight       = $O.AccessRight.ToString()       #: Read
                        ComputerName      = $O.PSComputerName    #: AD2.AD.EVOTEC.XYZ
                    }
                }
            }
        }
    }
}