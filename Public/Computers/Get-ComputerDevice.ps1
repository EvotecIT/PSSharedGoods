function Get-ComputerDevice {
    <#
    .SYNOPSIS
    Retrieves information about computer devices.

    .DESCRIPTION
    This function retrieves information about computer devices using WMI.

    .PARAMETER ComputerName
    Specifies the name of the computer to query. Defaults to the local computer.

    .PARAMETER Protocol
    Specifies the protocol to use for the query. Valid values are 'Default', 'Dcom', or 'Wsman'. Default is 'Default'.

    .PARAMETER All
    Retrieves all properties of the computer devices.

    .PARAMETER Extended
    Retrieves extended properties of the computer devices.

    .EXAMPLE
    Get-ComputerDevice -ComputerName "Computer01" -Protocol "Wsman" -All
    Retrieves all properties of computer devices from a remote computer using Wsman protocol.

    .EXAMPLE
    Get-ComputerDevice -ComputerName "Computer02" -Extended
    Retrieves extended properties of computer devices from a remote computer.

    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [switch] $All,
        [switch] $Extended
    )
    [string] $Class = 'win32_pnpentity'
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = @(
            #'Caption'
            #'Description'
            #'InstallDate'
            'PNPClass'
            'Name'
            'Status'
            #'Availability'
            'ConfigManagerErrorCode'
            #'ConfigManagerUserConfig'
            'DeviceID'
            'ErrorCleared'
            'ErrorDescription'
            'LastErrorCode'
            #'PNPDeviceID'
            #'PowerManagementCapabilities'
            #'PowerManagementSupported'
            'StatusInfo'
            #'SystemName'
            'ClassGuid'
            'CompatibleID'
            'HardwareID'
            'Manufacturer'

            #'Present'
            #'Service'
            'PSComputerName'
        )
    }

    $ConfigManagerErrorCode = @{
        '0'  = "This device is working properly."
        '1'  = 'This device is not configured correctly.'
        '2'  = 'Windows cannot load the driver for this device.'
        '3'  = "The driver for this device might be corrupted, or your system may be running low on memory or other resources."
        '4'  = "This device is not working properly. One of its drivers or your registry might be corrupted."
        '5'  = "The driver for this device needs a resource that Windows cannot manage."
        '6'  = "The boot configuration for this device conflicts with other devices."
        '7'  = "Cannot filter."
        '8'  = "The driver loader for the device is missing."
        '9'  = "This device is not working properly because the controlling firmware is reporting the resources for the device incorrectly."
        '10' = "This device cannot start."
        '11' = "This device failed."
        '12' = "This device cannot find enough free resources that it can use."
        '13' = "Windows cannot verify this device's resources."
        '14' = "This device cannot work properly until you restart your computer."
        '15' = "This device is not working properly because there is probably a re-enumeration problem."
        '16' = "Windows cannot identify all the resources this device uses."
        '17' = "This device is asking for an unknown resource type."
        '18' = "Reinstall the drivers for this device."
        '19' = "Failure using the VxD loader."
        '20' = "Your registry might be corrupted."
        '21' = "System failure: Try changing the driver for this device. If that does not work, see your hardware documentation. Windows is removing this device."
        '22' = "This device is disabled."
        '23' = "System failure: Try changing the driver for this device. If that doesn't work, see your hardware documentation."
        '24' = "This device is not present, is not working properly, or does not have all its drivers installed."
        '25' = "Windows is still setting up this device."
        '26' = "Windows is still setting up this device."
        '27' = "This device does not have valid log configuration."
        '28' = "The drivers for this device are not installed."
        '29' = "This device is disabled because the firmware of the device did not give it the required resources."
        '30' = "This device is using an Interrupt Request (IRQ) resource that another device is using."
        '31' = "This device is not working properly because Windows cannot load the drivers required for this device."
    }
    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                $Device = [ordered]@{
                    ComputerName  = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    #'Caption'                     = $Data.Caption
                    #'Description'                 = $Data.Description
                    #'InstallDate'                 = $Data.InstallDate
                    'DeviceClass' = $Data.PNPClass
                    'Name'        = $Data.Name
                    'Status'      = $Data.Status
                    #'Availability'                = $Data.Availability
                    'ErrorCode'   = $ConfigManagerErrorCode["$($Data.ConfigManagerErrorCode)"]
                    'DeviceID'    = $Data.DeviceID
                }
                if ($Extended) {
                    $DeviceUpgrade = [ordered]@{
                        #'ConfigManagerUserConfig'     = $Data.ConfigManagerUserConfig
                        'ErrorCleared'     = $Data.ErrorCleared
                        'ErrorDescription' = $Data.ErrorDescription
                        'LastErrorCode'    = $Data.LastErrorCode
                        #'PNPDeviceID'                 = $Data.PNPDeviceID
                        #'PowerManagementCapabilities' = $Data.PowerManagementCapabilities
                        #'PowerManagementSupported'    = $Data.PowerManagementSupported
                        'StatusInfo'       = $Data.StatusInfo
                        #'SystemName'                  = $Data.SystemName
                        'ClassGuid'        = $Data.ClassGuid
                        'CompatibleID'     = $Data.CompatibleID
                        'HardwareID'       = $Data.HardwareID
                        'Manufacturer'     = if ($Data.Manufacturer) { $Data.Manufacturer.Replace('(', '').Replace(')', '') } else { }
                        #'Present'                     = $Data.Present
                        #'Service'                     = $Data.Service
                    }
                    [PSCustomObject] ($Device + $DeviceUpgrade)
                } else {
                    [PSCustomObject] $Device
                }
            }
        }
    }
}
#Get-ComputerDevice | Format-Table *
#Get-ComputerDevice -ComputerName AD1 -Extended | Format-Table *