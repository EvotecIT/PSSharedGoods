function Format-View {
    <#
    .SYNOPSIS
    Formats and displays objects in a customizable view.

    .DESCRIPTION
    The Format-View function formats and displays objects in a customizable view. It allows you to specify properties to include or exclude, control output streams, and customize the display format.

    .PARAMETER InputObject
    Specifies the object to format.

    .PARAMETER Property
    Specifies the properties of the object to include in the output.

    .PARAMETER ExcludeProperty
    Specifies the properties of the object to exclude from the output.

    .PARAMETER HideTableHeaders
    Indicates whether to hide table headers in the output.

    .PARAMETER Stream
    Specifies the output stream for the formatted object. Valid values are 'Output', 'Host', 'Warning', 'Verbose', 'Debug', and 'Information'.

    .PARAMETER List
    Indicates whether to display the object as a list.

    .PARAMETER Autosize
    Indicates whether to automatically adjust the column width based on the content.

    .EXAMPLE
    Format-View -InputObject $object -Property Name, Age -Stream Verbose
    Formats the object with only the 'Name' and 'Age' properties and outputs to the verbose stream.

    .EXAMPLE
    Get-Process | Format-View -Property Name, CPU -Stream Host
    Formats the process objects with only the 'Name' and 'CPU' properties and outputs to the host.

    #>
    [alias('FV', 'Format-Verbose', 'Format-Debug', 'Format-Warning')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [object] $InputObject,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 1, ParameterSetName = 'Property')]
        [Object[]] $Property,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 2, ParameterSetName = 'ExcludeProperty')]
        [Object[]] $ExcludeProperty,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 3)]
        [switch] $HideTableHeaders,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 6)]
        [validateset('Output', 'Host', 'Warning', 'Verbose', 'Debug', 'Information')]
        [string] $Stream = 'Verbose',
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 7)]
        [alias('AsList')][switch] $List,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 8)]
        [switch] $Autosize
    )
    Begin {
        $IsVerbosePresent = $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent

        if ($Stream -eq 'Output') {
            #
        } elseif ($Stream -eq 'Host') {
            #
        } elseif ($Stream -eq 'Warning') {
            [System.Management.Automation.ActionPreference] $WarningCurrent = $WarningPreference
            $WarningPreference = 'continue'
        } elseif ($Stream -eq 'Verbose') {
            [System.Management.Automation.ActionPreference] $VerboseCurrent = $VerbosePreference
            $VerbosePreference = 'continue'
        } elseif ($Stream -eq 'Debug') {
            [System.Management.Automation.ActionPreference] $DebugCurrent = $DebugPreference
            $DebugPreference = 'continue'
        } elseif ($Stream -eq 'Information') {
            [System.Management.Automation.ActionPreference] $InformationCurrent = $InformationPreference
            $InformationPreference = 'continue'
        }

        [bool] $FirstRun = $True # First run for pipeline
        [bool] $FirstLoop = $True # First loop for data
        [bool] $FirstList = $True # First loop for a list
        [int] $ScreenWidth = $Host.UI.RawUI.WindowSize.Width - 12 # Removes 12 chars because of VERBOSE: output
        $MyList = [System.Collections.Generic.List[Object]]::new()
    }
    Process {
        $MyList.Add($InputObject)
    }
    End {
        $Parameters = @{}
        if ($Property) {
            $Parameters.Property = $Property
        }
        if ($ExcludeProperty) {
            $Parameters.ExcludeProperty = $ExcludeProperty
        }
        if ($HideTableHeaders) {
            $Parameters.HideTableHeaders = $HideTableHeaders
        }

        if ($List) {
            # Show and set back to defaults
            if ($Stream -eq 'Output') {
                $MyList | Format-List @Parameters | Out-String | Write-Output
            } elseif ($Stream -eq 'Host') {
                $MyList | Format-List @Parameters | Out-String | Write-Host
            } elseif ($Stream -eq 'Warning') {
                $MyList | Format-List @Parameters | Out-String | Write-Warning
                $WarningPreference = $WarningCurrent
            } elseif ($Stream -eq 'Verbose') {
                $MyList | Format-List @Parameters | Out-String | Write-Verbose
                $VerbosePreference = $VerboseCurrent
            } elseif ($Stream -eq 'Debug') {
                $MyList | Format-List @Parameters | Out-String | Write-Debug
                $DebugPreference = $DebugCurrent
            } elseif ($Stream -eq 'Information') {
                $MyList | Format-List @Parameters | Out-String | Write-Information
                $InformationPreference = $InformationCurrent
            }
        } else {
            # Show and set back to defaults
            if ($Stream -eq 'Output') {
                $MyList | Format-Table @Parameters | Out-String | Write-Output
            } elseif ($Stream -eq 'Host') {
                $MyList | Format-Table @Parameters | Out-String | Write-Host
            } elseif ($Stream -eq 'Warning') {
                $MyList | Format-Table @Parameters | Out-String | Write-Warning
                $WarningPreference = $WarningCurrent
            } elseif ($Stream -eq 'Verbose') {
                $MyList | Format-Table @Parameters | Out-String | Write-Verbose
                $VerbosePreference = $VerboseCurrent
            } elseif ($Stream -eq 'Debug') {
                $MyList | Format-Table @Parameters | Out-String | Write-Debug
                $DebugPreference = $DebugCurrent
            } elseif ($Stream -eq 'Information') {
                $MyList | Format-Table @Parameters | Out-String | Write-Information
                $InformationPreference = $InformationCurrent
            }
        }
    }
}