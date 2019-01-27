function Uninstall-ApplicationClickOnce {
    [CmdletBinding()]
    Param(
        [alias('ApplicationName')] $DisplayName
    )
    $App = Get-InstalledApplication -DisplayName $DisplayName -Type UserInstalled
    if ($App) {
        $selectedUninstallString = $App.UninstallString
        #Seperate cmd from parameters (First Space)
        $parts = $selectedUninstallString.Split(' ', 2)
        Start-Process -FilePath $parts[0] -ArgumentList $parts[1] -Wait
        #ToDo : Automatic press of OK
        #Start-Sleep 5
        #$wshell = new-object -com wscript.shell
        #$wshell.sendkeys("`"OK`"~")

        $app = Get-InstalledApplication -DisplayName $DisplayName -Type UserInstalled
        if ($app) {
            Write-Verbose 'Uninstall-ApplicationClickOnce - Uninstallation was not successfull.'
            return $false
        } else {
            Write-Verbose 'Uninstall-ApplicationClickOnce - Uninstallation was not successfull.'
            return $true
        }

    } else {
        return
    }
}
