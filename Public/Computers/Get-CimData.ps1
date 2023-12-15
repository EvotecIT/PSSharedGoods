function Get-CimData {
    <#
    .SYNOPSIS
    Helper function for retreiving CIM data from local and remote computers

    .DESCRIPTION
    Helper function for retreiving CIM data from local and remote computers

    .PARAMETER ComputerName
    Specifies computer on which you want to run the CIM operation. You can specify a fully qualified domain name (FQDN), a NetBIOS name, or an IP address. If you do not specify this parameter, the cmdlet performs the operation on the local computer using Component Object Model (COM).

    .PARAMETER Protocol
    Specifies the protocol to use. The acceptable values for this parametDer are: DCOM, Default, or Wsman.

    .PARAMETER Class
    Specifies the name of the CIM class for which to retrieve the CIM instances. You can use tab completion to browse the list of classes, because PowerShell gets a list of classes from the local WMI server to provide a list of class names.

    .PARAMETER Properties
    Specifies a set of instance properties to retrieve. Use this parameter when you need to reduce the size of the object returned, either in memory or over the network. The object returned also contains the key properties even if you have not listed them using the Property parameter. Other properties of the class are present but they are not populated.

    .PARAMETER NameSpace
    Specifies the namespace for the CIM operation. The default namespace is root\cimv2. You can use tab completion to browse the list of namespaces, because PowerShell gets a list of namespaces from the local WMI server to provide a list of namespaces.

    .PARAMETER Credential
    Specifies a user account that has permission to perform this action. The default is the current user.

    .EXAMPLE
    Get-CimData -Class 'win32_bios' -ComputerName AD1,EVOWIN

    .EXAMPLE
    Get-CimData -Class 'win32_bios'

    .EXAMPLE
    Get-CimClass to get all classes

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param(
        [parameter(Mandatory)][string] $Class,
        [string] $NameSpace = 'root\cimv2',
        [string[]] $ComputerName = $Env:COMPUTERNAME,
        [ValidateSet('Default', 'Dcom', 'Wsman')][string] $Protocol = 'Default',
        [pscredential] $Credential,
        [string[]] $Properties = '*'
    )
    $ExcludeProperties = 'CimClass', 'CimInstanceProperties', 'CimSystemProperties', 'SystemCreationClassName', 'CreationClassName'

    # Querying CIM locally usually doesn't work. This means if you're querying same computer you neeed to skip CimSession/ComputerName if it's local query
    [Array] $ComputersSplit = Get-ComputerSplit -ComputerName $ComputerName

    $CimObject = @(
        # requires removal of this property for query
        [string[]] $PropertiesOnly = $Properties | Where-Object { $_ -ne 'PSComputerName' }
        # Process all remote computers
        $Computers = $ComputersSplit[1]
        if ($Computers.Count -gt 0) {
            if ($Protocol -eq 'Default' -and $null -eq $Credential) {
                Get-CimInstance -ClassName $Class -ComputerName $Computers -ErrorAction SilentlyContinue -Property $PropertiesOnly -Namespace $NameSpace -Verbose:$false -ErrorVariable ErrorsToProcess | Select-Object -Property $Properties -ExcludeProperty $ExcludeProperties
            } else {
                $Option = New-CimSessionOption -Protocol $Protocol
                $newCimSessionSplat = @{
                    ComputerName  = $Computers
                    SessionOption = $Option
                    ErrorAction   = 'SilentlyContinue'
                }
                if ($Credential) {
                    $newCimSessionSplat['Credential'] = $Credential
                }
                $Session = New-CimSession @newCimSessionSplat -Verbose:$false
                if ($Session) {
                    Try {
                        $Info = Get-CimInstance -ClassName $Class -CimSession $Session -ErrorAction Stop -Property $PropertiesOnly -Namespace $NameSpace -Verbose:$false -ErrorVariable ErrorsToProcess | Select-Object -Property $Properties -ExcludeProperty $ExcludeProperties
                    } catch {
                        Write-Warning -Message "Get-CimData - No data for computer $($E.OriginInfo.PSComputerName). Failed with errror: $($E.Exception.Message)"
                    }
                    try {
                        $null = Remove-CimSession -CimSession $Session -ErrorAction SilentlyContinue
                    } catch {
                        Write-Warning -Message "Get-CimData - Failed to remove CimSession $($Session). Failed with errror: $($E.Exception.Message)"
                    }
                    $Info
                } else {
                    Write-Warning -Message "Get-CimData - Failed to create CimSession for $($Computers). Problem with credentials?"
                }
            }
            foreach ($E in $ErrorsToProcess) {
                Write-Warning -Message "Get-CimData - No data for computer $($E.OriginInfo.PSComputerName). Failed with errror: $($E.Exception.Message)"
            }
        } else {
            # Process local computer
            $Computers = $ComputersSplit[0]
            if ($Computers.Count -gt 0) {
                $Info = Get-CimInstance -ClassName $Class -ErrorAction SilentlyContinue -Property $PropertiesOnly -Namespace $NameSpace -Verbose:$false -ErrorVariable ErrorsLocal | Select-Object -Property $Properties -ExcludeProperty $ExcludeProperties
                $Info | Add-Member -Name 'PSComputerName' -Value $Computers -MemberType NoteProperty -Force
                $Info
            }
            foreach ($E in $ErrorsLocal) {
                Write-Warning -Message "Get-CimData - No data for computer $($Env:COMPUTERNAME). Failed with errror: $($E.Exception.Message)"
            }
        }
    )
    $CimObject
}