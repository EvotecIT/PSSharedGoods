function Get-ComputerSMBShare {
    [CmdletBinding()]
    param(
        [string[]] $ComputerName
    )
    [Array] $CollectionComputers = Get-ComputerSplit -ComputerName $ComputerName
    $SMB = @(
        if ($CollectionComputers[0].Count -gt 0) {
            $Output = Get-SmbShare
            foreach ($_ in $Output) {
                Add-Member -InputObject $_ -Name 'PSComputerName' -Value $Env:COMPUTERNAME -MemberType NoteProperty -Force
                $_
            }
        }
        if ($CollectionComputers[1].Count -gt 0) {
            $Output = Get-SmbShare -CimSession $CollectionComputers[1]
            foreach ($_ in $Output) {
                $_
            }
        }
    )
    $SMB
}

#Get-ComputerSMBShare -ComputerName AD1, EVOWIN | ft -AutoSize Name, PSComputerName