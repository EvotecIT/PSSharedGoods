function Dismount-PSRegistryPath {
    <#
    .SYNOPSIS
    Dismounts a registry path.

    .DESCRIPTION
    This function dismounts a registry path specified by the MountPoint parameter. It unloads the registry path using reg.exe command.

    .PARAMETER MountPoint
    Specifies the registry path to be dismounted.

    .PARAMETER Suppress
    Suppresses the output if set to $true.

    .EXAMPLE
    Dismount-PSRegistryPath -MountPoint "HKLM:\Software\MyApp" -Suppress
    Dismounts the registry path "HKLM:\Software\MyApp" without displaying any output.

    .EXAMPLE
    Dismount-PSRegistryPath -MountPoint "HKCU:\Software\Settings"
    Dismounts the registry path "HKCU:\Software\Settings" and displays output if successful.

    #>
    [alias('Dismount-RegistryPath')]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)][string] $MountPoint,
        [switch] $Suppress
    )

    # This is required to force removal of the mount point
    [gc]::Collect()

    $pinfo = [System.Diagnostics.ProcessStartInfo]::new()
    $pinfo.FileName = "reg.exe"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = " unload $MountPoint"
    $pinfo.CreateNoWindow = $true
    $pinfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
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
            Write-Warning -Message "Dismount-PSRegistryPath - Couldn't unmount $MountPoint. $Errors"
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

<#
function Dismount-PSRegistryPath {
    [alias('Dismount-RegistryPath')]
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)][string] $MountPoint,
        [switch] $Suppress
    )

    # This is required to force removal of the mount point
    [gc]::Collect()

    # $pinfo = [System.Diagnostics.ProcessStartInfo]::new()
    # $pinfo.FileName = "reg.exe"
    # $pinfo.RedirectStandardError = $true
    # $pinfo.RedirectStandardOutput = $true
    # $pinfo.UseShellExecute = $false
    # $pinfo.Arguments = " unload $MountPoint"
    # $pinfo.CreateNoWindow = $true
    # $pinfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    # $p = [System.Diagnostics.Process]::new()
    # $p.StartInfo = $pinfo
    # $p.Start() | Out-Null
    # $p.WaitForExit()
    # $Output = $p.StandardOutput.ReadToEnd()
    # $Errors = $p.StandardError.ReadToEnd()

    $p = reg unload $MountPoint 2>&1
    #$Errors  , $Output = $p.Where({ $_ -is [System.Management.Automation.ErrorRecord] }, 'Split')
    if ($p -is [Array] -and $p[0] -is [System.Management.Automation.ErrorRecord] -or $p -is [System.Management.Automation.ErrorRecord]) {
        $Errors = $p | ForEach-Object { $_.ToString().Replace('System.Management.Automation.RemoteException', '') }
    } else {
        $Output = $p
    }
    if ($Errors) {
        if ($PSBoundParameters.ErrorAction -eq 'Stop') {
            throw $Errors
        } else {
            Write-Warning -Message "Dismount-PSRegistryPath - Couldn't unmount $MountPoint. $Errors"
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
#>