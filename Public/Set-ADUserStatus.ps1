function Set-ADUserStatus {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [parameter(Mandatory = $true)][ValidateSet("Enable", "Disable")][String] $Option
    )
    if ($Option -eq 'Enable' -and $User.Enabled -eq $false) {
        Write-Color @Script:WriteParameters -Text '[i]', ' Enabling user ', $User.DisplayName, ' in Active Directory.' -Color White, Yellow, Green, White, Yellow
        Set-ADUser -Identity $User -Enabled $true
    } elseif ($Option -eq 'Disable' -and $User.Enabled -eq $true) {
        Write-Color @Script:WriteParameters -Text '[i]', ' Disabling user ', $User.DisplayName, 'in Active Directory.' -Color White, Yellow, Green, White, Yellow
        Set-ADUser -Identity $User -Enabled $false
    }
}