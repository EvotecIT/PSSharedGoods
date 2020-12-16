function Set-PasswordRemotely {
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
}