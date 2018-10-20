function Connect-WinAzure {
    [CmdletBinding()]
    param(
        [string] $SessionName = 'Evotec',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure,
        [switch] $FromFile
    )
    if ($FromFile) {
        if (Test-Path $Password) {
            Write-Verbose "Connect-Azure - Reading password from file $Password"
            if ($AsSecure) {
                $NewPassword = Get-Content $Password | ConvertTo-SecureString
                # Write-Verbose "Connect-Azure - Password to use: $Password"
            } else {
                $NewPassword = Get-Content $Password
                #Write-Verbose "Connect-Azure - Password to use: $Password"
            }
        } else {
            Write-Warning "Connect-Azure - Secure password from file couldn't be read. File not readable. Terminating."
            return
        }
    } else {
        $NewPassword = $Password
    }
    if ($UserName -and $NewPassword) {
        if ($AsSecure) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $NewPassword)
            #Write-Verbose "Connect-Azure - Using AsSecure option with Username $Username and password: $NewPassword"
        } else {
            $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
            #Write-Verbose "Connect-Azure - Using AsSecure option with Username $Username and password: $NewPassword converted to $SecurePassword"
        }
    }
    try {
        $Data = Connect-MsolService -Credential $Credentials -ErrorAction Stop
    } catch {
        $Data = $null
        $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
        Write-Warning "Connect-WinAzure - Failed with error message: $ErrorMessage"
    }
    return $Data
}