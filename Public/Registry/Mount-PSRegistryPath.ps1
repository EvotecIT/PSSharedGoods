function Mount-PSRegistryPath {
    [alias('Mount-RegistryPath')]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)][string] $MountPoint,
        [Parameter(Mandatory)][string] $FilePath
    )

    $pinfo = [System.Diagnostics.ProcessStartInfo]::new()
    $pinfo.FileName = "reg.exe"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = " load $MountPoint $PathToNTUser"
    $p = [System.Diagnostics.Process]::new()
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $Output = $p.StandardOutput.ReadToEnd()
    $Errors = $p.StandardError.ReadToEnd()

    if ($Errors) {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw $Errors
        } else {
            Write-Warning -Message "Mount-PSRegistryPath - Couldn't mount $MountPoint. Error: $Errors"
        }
    } else {
        if ($Output -like "*operation completed*") {
            if (-not $Suppress) {
                return $true
            }
        }
    }
    if (-not $Suppress) {
        return $false
    }
}