function Get-ComputerSMB {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName
    )

    [Array] $CollectionComputers = $ComputerName.Where( { $_ -eq $Env:COMPUTERNAME }, 'Split')
    $SMB = @(
        if ($CollectionComputers[0].Count -gt 0) {
            $Output = Get-SmbServerConfiguration #| Select-Object EnableSMB2Protocol, EnableSMB1Protocol
            foreach ($_ in $Output) {
                [PSCustomObject] @{
                    ComputerName             = $Env:COMPUTERNAME
                    EnableSMB1Protocol       = $_.EnableSMB1Protocol
                    EnableSMB2Protocol       = $_.EnableSMB2Protocol
                    Smb2CreditsMin           = $_.Smb2CreditsMin
                    Smb2CreditsMax           = $_.Smb2CreditsMax
                    RequireSecuritySignature = $_.RequireSecuritySignature
                }
            }
        }
        if ($CollectionComputers[1].Count -gt 0) {
            $Output = Get-SmbServerConfiguration -CimSession $CollectionComputers[1] #| Select-Object EnableSMB2Protocol, EnableSMB1Protocol #
            foreach ($_ in $Output) {
                [PSCustomObject] @{
                    ComputerName             = $_.PSComputerName
                    EnableSMB1Protocol       = $_.EnableSMB1Protocol
                    EnableSMB2Protocol       = $_.EnableSMB2Protocol
                    Smb2CreditsMin           = $_.Smb2CreditsMin
                    Smb2CreditsMax           = $_.Smb2CreditsMax
                    RequireSecuritySignature = $_.RequireSecuritySignature
                }
            }
        }
    )
    $SMB
}

#Get-ComputerSMB -ComputerName AD1, EVOWIN, AD1,AD2,AD3,DC1,ADPreview2019 #| ft -a *