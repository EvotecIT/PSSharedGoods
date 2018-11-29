function Format-Verbose {
    [alias('FV')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
        [object] $InputObject,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 0, ParameterSetName = 'Property')]
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
        [alias('Rotate', 'RotateData', 'TransposeColumnsRows', 'TransposeData')]
        [switch] $Transpose,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 9)]
        [ValidateSet("ASC", "DESC", "NONE")]
        [string] $TransposeSort = 'NONE'
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
        $ArrayList = @()

    }
    Process {
        $ArrayList += $InputObject
    }
    End {
        $ArrayList | Format-Table  | Out-String | Write-Verbose
    }
}

#Get-Process | Format-Verbose