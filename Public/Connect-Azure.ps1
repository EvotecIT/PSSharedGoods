function Connect-Azure {
    param(
        [string] $SessionName = 'Evotec',
        [string] $Username,
        [string] $Password,
        [switch] $AsSecure
    )
    if ($UserName -and $Password) {
        if ($AsSecure) {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
        } else {
            $SecurePassword = $Password | ConvertTo-SecureString -asPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)
        }
    }
    $Data = Connect-MsolService -Credential $Credentials
    return $Data
}