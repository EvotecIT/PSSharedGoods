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
            #$DomainController = $Env:LOGONSERVER -replace "\\"
            $Domain = $Env:USERDNSDOMAIN
            $Context = [System.DirectoryServices.ActiveDirectory.DirectoryContext]::new([System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Domain, $Domain)
            $DomainController = ([System.DirectoryServices.ActiveDirectory.DomainController]::FindOne($Context)).Name

        }
    }
    Process {
        $OldPasswordPlain = [System.Net.NetworkCredential]::new([string]::Empty, $OldPassword).Password
        $NewPasswordPlain = [System.Net.NetworkCredential]::new([string]::Empty, $NewPassword).Password

        $result = $NetApi32::NetUserChangePassword($DomainController, $UserName, $OldPasswordPlain, $NewPasswordPlain)
        if ($result) {
            Write-Host -Object "Set-PasswordRemotely - Password change for account $UserName failed on $DomainController. Please try again." -ForegroundColor Red
        } else {
            Write-Host -Object "Set-PasswordRemotely - Password change for account $UserName succeeded on $DomainController." -ForegroundColor Cyan
        }
    }
}