function Get-WinADForestControllers {
    [alias('Get-WinADDomainControllers')]
    <#
    .SYNOPSIS


    .DESCRIPTION
    Long description

    .PARAMETER TestAvailability
    Parameter description

    .EXAMPLE
    Get-WinADForestControllers -TestAvailability | Format-Table

    .EXAMPLE
    Get-WinADDomainControllers

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [switch] $TestAvailability
    )
    $Forest = Get-AdForest
    $Servers = foreach ($D in $Forest.Domains) {
        try {
            Get-ADDomainController -Server $D -Filter * | Select Domain, HostName, Forest, IPv4Address, 'Comment'
        } catch {
            [PSCustomObject]@{
                Domain      = $D
                HostName    = ''
                Forest      = $Forest.RootDomain
                IPV4Address = ''
                Comment     = 'Error connecting to domain'
            }
        }
    }
    if ($TestAvailability) {
        foreach ($Server in $Servers) {
            if ($Server.IPV4Address -ne '') {
                $Output = Test-Connection -Count 1 -Server $Server.IPV4Address -Quiet -ErrorAction SilentlyContinue
                Add-Member -InputObject $Server -MemberType NoteProperty -Name 'Pingable' -Value $Output
            } else {
                Add-Member -InputObject $Server -MemberType NoteProperty -Name 'Pingable' -Value $false
            }
        }
    }
    return $Servers
}