function Set-ADUserStatus {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [parameter(Mandatory = $true)][ValidateSet("Enable", "Disable")][String] $Option #,
        # $WriteParameters
    )
    if ($Option -eq 'Enable' -and $User.Enabled -eq $false) {
        #if (-not $WriteParameters) {
        #    Write-Color @Script:WriteParameters -Text 'Enabling user ', $User.DisplayName, ' in Active Directory.' -Color Yellow, Green, White, Yellow
        #} else {
        #    Write-Color @WriteParameters
        #}
        Set-ADUser -Identity $User -Enabled $true
        return $true
    } elseif ($Option -eq 'Disable' -and $User.Enabled -eq $true) {
        #if (-not $WriteParameters) {
        #    Write-Color @Script:WriteParameters -Text 'Disabling user ', $User.DisplayName, 'in Active Directory.' -Color Yellow, Green, White, Yellow
        #} else {
        #    Write-Color @WriteParameters
        #}
        Set-ADUser -Identity $User -Enabled $false
        return $true
    }
    return $false
}