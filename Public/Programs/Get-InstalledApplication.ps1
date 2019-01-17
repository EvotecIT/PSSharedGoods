function Get-InstalledApplication {
    <#
    .EXAMPLE
    Get-InstalledApplication -Type UserInstalled -DisplayName 'JetBrains dotCover 2017.1.1'
    #>
    [CmdletBinding()]
    Param(
        [string[]] $DisplayName, # = "Microsoft Exchange Online Powershell Module",
        [ValidateSet('UserInstalled', 'SystemWide')][string] $Type = 'UserInstalled',
        [switch] $All
    )
    if ($Type -eq 'UserInstalled') {
        $Registry = 'HKCU'
    } else {
        $Registry = 'HKLM'
    }

    $InstalledApplications = Get-ChildItem -Path "$Registry`:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Foreach-Object { Get-ItemProperty $_.PsPath }

    if ($DisplayName) {
        $InstalledApplications | Where-Object { $DisplayName -contains $_.DisplayName }
    } else {
        $InstalledApplications
    }
}