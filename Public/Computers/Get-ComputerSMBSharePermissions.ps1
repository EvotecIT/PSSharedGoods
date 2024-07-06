function Get-ComputerSMBSharePermissions {
    <#
    .SYNOPSIS
    Retrieves SMB share permissions for specified computers and shares.

    .DESCRIPTION
    This function retrieves SMB share permissions for the specified computers and shares. It provides the option to translate the permissions into a more readable format.

    .PARAMETER ComputerName
    Specifies the names of the computers to retrieve SMB share permissions from.

    .PARAMETER ShareName
    Specifies the names of the shares to retrieve permissions for.

    .PARAMETER Translated
    Indicates whether to translate the permissions into a more readable format.

    .EXAMPLE
    Get-ComputerSMBSharePermissions -ComputerName "Server1" -ShareName "Share1" -Translated
    Retrieves SMB share permissions for Server1 and Share1 in a translated format.

    .EXAMPLE
    Get-ComputerSMBSharePermissions -ComputerName "Server1", "Server2" -ShareName "Share1", "Share2"
    Retrieves SMB share permissions for multiple servers and shares.

    #>
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