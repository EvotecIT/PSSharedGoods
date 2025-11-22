function Get-ComputerRAM {
    <#
    .SYNOPSIS
    Retrieves information about the RAM of a specified computer.

    .DESCRIPTION
    This function retrieves detailed information about the RAM of a specified computer. It provides various properties such as Manufacturer, Model, Capacity, Speed, and more.

    .PARAMETER ComputerName
    Specifies the name of the computer to retrieve RAM information from. Defaults to the local computer.

    .PARAMETER Protocol
    Specifies the protocol to use for retrieving RAM information. Valid values are 'Default', 'Dcom', and 'Wsman'. Defaults to 'Default'.

    .PARAMETER Credential
    Alternate credentials for CIM queries. Default is current user.

    .PARAMETER All
    Indicates whether to retrieve all available properties of the RAM. If specified, all properties will be retrieved.

    .PARAMETER Extended
    Indicates whether to retrieve extended properties of the RAM. If specified, additional properties will be retrieved.

    .EXAMPLE
    Get-ComputerRAM -ComputerName "Server01" -Protocol Wsman
    Retrieves RAM information from a remote computer named Server01 using the Wsman protocol.

    .EXAMPLE
    Get-ComputerRAM -ComputerName "WorkstationA" -All
    Retrieves all available RAM properties from a computer named WorkstationA.

    #>
    [CmdletBinding()]
    param(
        [string] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [pscredential] $Credential,
        [switch] $All,
        [switch] $Extended
    )
    [string] $Class = 'Win32_physicalmemory '
    if ($All) {
        [string] $Properties = '*'
    } else {
        [string[]] $Properties = @(
            'InstallDate'
            #'Name'
            # 'Status'
            'Manufacturer'
            'Model'
            'OtherIdentifyingInfo'
            'PartNumber'
            'PoweredOn'
            'SerialNumber'
            'SKU'
            'Tag'
            'Version'
            'HotSwappable'
            'Removable'
            'Replaceable'
            'FormFactor'
            'BankLabel'
            'Capacity'
            #'DataWidth'
            'InterleavePosition'
            'MemoryType'
            #'PositionInRow'
            'Speed'
            #'TotalWidth'
            #'Attributes'
            'ConfiguredClockSpeed'
            'ConfiguredVoltage'
            'DeviceLocator'
            #'InterleaveDataDepth'
            'MaxVoltage'
            'MinVoltage'
            'SMBIOSMemoryType'
            'TypeDetail'
            'PSComputerName'
        )
    }
    $FormFactor = @{
        '0'  = 'Unknown'
        '1'  = 'Other'
        '2'  = 'SIP'
        '3'  = 'DIP'
        '4'  = 'ZIP'
        '5'  = 'SOJ'
        '6'  = 'Proprietary'
        '7'  = 'SIMM'
        '8'  = 'DIMM'
        '9'  = 'TSOP'
        '10' = 'PGA'
        '11' = 'RIMM'
        '12' = 'SODIMM'
        '13' = 'SRIMM'
        '14' = 'SMD'
        '15' = 'SSMP'
        '16' = 'QFP'
        '17' = 'TQFP'
        '18' = 'SOIC'
        '19' = 'LCC'
        '20' = 'PLCC'
        '21' = 'BGA'
        '22' = 'FPBGA'
        '23' = 'LGA'
    }
    $TypeDetails = @{
        '1'    = 'Reserved'
        '2'    = 'Other'
        '4'    = 'Unknown'
        '8'    = 'Fast-paged'
        '16'   = 'Static column'
        '32'   = 'Pseudo-static'
        '64'   = 'RAMBUS'
        '128'  = 'Synchronous'
        '256'  = 'CMOS'
        '512'  = 'EDO'
        '1024' = 'Window DRAM'
        '2048' = 'Cache DRAM'
        '4096' = 'Non-volatile'
    }
    $InterleavePosition = @{
        '0' = "Non-Interleaved"
        '1' = "First Position"
        '2' = "Second Position"
    }
    $MemoryType = @{
        '0'  = "Unknown"
        '1'  = "Other"
        '2'  = "DRAM"
        '3'  = "Synchronous DRAM"
        '4'  = "Cache DRAM"
        '5'  = "EDO"
        '6'  = "EDRAM"
        '7'  = "VRAM"
        '8'  = "SRAM"
        '9'  = "ROM"
        '10' = "ROM"
        '11' = "FLASH"
        '12' = "EEPROM"
        '13' = "FEPROM"
        '14' = "EPROM"
        '15' = "CDRAM"
        '16' = "3DRAM"
        '17' = "SDRAM"
        '18' = "SGRAM"
        '19' = "RDRAM"
        '20' = "DDR"
    }
    $MemoryTypeSMBIOS = @{
        '0'  = 'Unknown'
        '1'  = 'Other'
        '2'  = 'DRAM'
        '3'  = 'Synchronous DRAM'
        '4'  = 'Cache DRAM'
        '5'  = 'EDO'
        '6'  = 'EDRAM'
        '7'  = 'VRAM' #(7)
        '8'  = 'SRAM' #(8)
        '9'  = 'RAM' #(9)
        '10' = 'ROM'    #(10)
        '11' = 'Flash' #(11)
        '12' = 'EEPROM' #(12)
        '13' = 'FEPROM' #(13)
        '14' = 'EPROM' #(14)
        '15' = 'CDRAM' #(15)
        '16' = '3DRAM' #(16)
        '17' = 'SDRAM' #(17)
        '18' = 'SGRAM' #(18)
        '19' = 'RDRAM' #(19)
        '20' = 'DDR' #(20)
        '21' = 'DDR2' #(21) # DDR2—May not be available.
        '22' = 'DDR2 FB-DIMM' #(22) # DDR2—FB-DIMM, May not be available.
        '24' = 'DDR3' #—May not be available.
        '25' = 'FBD2'
        '26' = 'DDR4'
    }

    $Information = Get-CimData -ComputerName $ComputerName -Protocol $Protocol -Credential $Credential -Class $Class -Properties $Properties
    if ($All) {
        $Information
    } else {
        foreach ($Info in $Information) {
            foreach ($Data in $Info) {
                # # Remember to expand if changing properties above
                $Ram = [ordered] @{
                    ComputerName       = if ($Data.PSComputerName) { $Data.PSComputerName } else { $Env:COMPUTERNAME }
                    Manufacturer       = $Data.Manufacturer          #: 04CD
                    FormFactor         = $FormFactor["$($Data.FormFactor)"]            #: 8
                    SMBIOSMemoryType   = $MemoryTypeSMBIOS["$($Data.SMBIOSMemoryType)"]      #: 26
                    Size               = [math]::round($Data.Capacity / 1GB, 2)              #: 17179869184
                    Speed              = $Data.Speed                 #: 3200
                    InterleavePosition = $InterleavePosition["$($Data.InterleavePosition)"]    #: 2
                    MemoryType         = $MemoryType["$($Data.MemoryType)"]            #: 0
                    TypeDetail         = $TypeDetails["$($Data.TypeDetail)"]            #: 128
                    PartNumber         = $Data.PartNumber            #: F4 - 3200C16-16GVK
                    DeviceLocator        = $Data.DeviceLocator         #: ChannelB-DIMM0
                }
                if ($Extended) {
                    $RamExtended = [ordered] @{
                        InstallDate          = $Data.InstallDate
                        #Name                 = $Data.Name                  #: Physical Memory
                        #Status               = $Data.Status                #:
                        Model                = $Data.Model                 #:
                        OtherIdentifyingInfo = $Data.OtherIdentifyingInfo  #:

                        PoweredOn            = $Data.PoweredOn             #:
                        SerialNumber         = $Data.SerialNumber          #: 00000000
                        SKU                  = $Data.SKU                   #:
                        Tag                  = $Data.Tag                   #: Physical Memory 1
                        Version              = $Data.Version               #:
                        HotSwappable         = $Data.HotSwappable          #:
                        Removable            = $Data.Removable             #:
                        Replaceable          = $Data.Replaceable           #:
                        BankLabel            = $Data.BankLabel             #: BANK 2
                        #DataWidth            = $Data.DataWidth             #: 64
                        #PositionInRow        = $Data.PositionInRow         #: 1
                        #TotalWidth           = $Data.TotalWidth            #: 64
                        #Attributes           = $Data.Attributes            #: 2
                        ConfiguredClockSpeed = $Data.ConfiguredClockSpeed  #: 3200
                        ConfiguredVoltage    = $Data.ConfiguredVoltage     #: 1200
                        #InterleaveDataDepth  = $Data.InterleaveDataDepth   #: 1
                        MaxVoltage           = $Data.MaxVoltage            #: 1200
                        MinVoltage           = $Data.MinVoltage            #: 1200
                    }
                    [PSCustomObject] ($Ram + $RamExtended)
                } else {
                    [PSCustomObject] $Ram
                }
            }

        }
    }
}
#Get-ComputerRAM | Format-Table *
#Get-ComputerRAM -ComputerName AD1 | Format-Table *
