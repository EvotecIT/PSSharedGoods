function Set-PasswordRemotely {
    <#
    .SYNOPSIS
    Set-PasswordRemotely function changes a user's password on a remote domain controller.

    .DESCRIPTION
    The Set-PasswordRemotely function allows changing a user's password securely on a remote domain controller. It requires the username, old password, new password, and optionally the domain controller's DNS name or IP address.

    .PARAMETER UserName
    Specifies the username of the account for which the password will be changed.

    .PARAMETER OldPassword
    Specifies the old password of the user account.

    .PARAMETER NewPassword
    Specifies the new password to set for the user account.

    .PARAMETER DomainController
    Specifies the domain controller's DNS name or IP address. If not provided, the function will prompt for it or automatically determine it if the machine is joined to a domain.

    .EXAMPLE
    Set-PasswordRemotely -UserName "JohnDoe" -OldPassword $SecureOldPassword -NewPassword $SecureNewPassword -DomainController "DC01"

    Description:
    Changes the password for the user account "JohnDoe" on the domain controller "DC01" using the provided old and new passwords.

    .EXAMPLE
    Set-PasswordRemotely -UserName "JaneSmith" -OldPassword $SecureOldPassword -NewPassword $SecureNewPassword

    Description:
    Changes the password for the user account "JaneSmith" on the domain controller determined automatically, using the provided old and new passwords.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Secure')]
    param(
        [Parameter(ParameterSetName = 'Secure', Mandatory)][string] $UserName,
        [Parameter(ParameterSetName = 'Secure', Mandatory)][securestring] $OldPassword,
        [Parameter(ParameterSetName = 'Secure', Mandatory)][securestring] $NewPassword,
        [Parameter(ParameterSetName = 'Secure')][alias('DC', 'Server', 'ComputerName')][string] $DomainController
    )
    Begin {
        $DllImport = @'
[DllImport("netapi32.dll", CharSet = CharSet.Unicode)]
public static extern bool NetUserChangePassword(string domain, string username, string oldpassword, string newpassword);
'@
        $NetApi32 = Add-Type -MemberDefinition $DllImport -Name 'NetApi32' -Namespace 'Win32' -PassThru

        if (-not $DomainController) {
            if ($env:computername -eq $env:userdomain) {
                # not joined to domain, lets prompt for DC
                $DomainController = Read-Host -Prompt 'Domain Controller DNS name or IP Address'
            } else {
                $Domain = $Env:USERDNSDOMAIN
                $Context = [System.DirectoryServices.ActiveDirectory.DirectoryContext]::new([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Domain, $Domain)
                $DomainController = ([System.DirectoryServices.ActiveDirectory.DomainController]::FindOne($Context)).Name
            }
        }
    }
    Process {
        if ($DomainController -and $OldPassword -and $NewPassword -and $UserName) {
            $OldPasswordPlain = [System.Net.NetworkCredential]::new([string]::Empty, $OldPassword).Password
            $NewPasswordPlain = [System.Net.NetworkCredential]::new([string]::Empty, $NewPassword).Password

            $result = $NetApi32::NetUserChangePassword($DomainController, $UserName, $OldPasswordPlain, $NewPasswordPlain)
            if ($result) {
                Write-Host -Object "Set-PasswordRemotely - Password change for account $UserName failed on $DomainController. Please try again." -ForegroundColor Red
            } else {
                Write-Host -Object "Set-PasswordRemotely - Password change for account $UserName succeeded on $DomainController." -ForegroundColor Cyan
            }
        } else {
            Write-Warning "Set-PasswordRemotely - Password change for account failed. All parameters are required. "
        }
    }
    End {
        $OldPassword = $null
        $NewPassword = $null
        $OldPasswordPlain = $null
        $NewPasswordPlain = $null
        [System.GC]::Collect()
    }
}