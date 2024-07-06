function Format-Stream {
    <#
    .SYNOPSIS
    Formats input objects for display in a stream-oriented manner.

    .DESCRIPTION
    The Format-Stream function formats input objects for display in a stream-oriented manner. It provides flexibility in displaying data in various streams such as Output, Host, Warning, Verbose, Debug, and Information.

    .PARAMETER InputObject
    Specifies the input objects to be formatted.

    .PARAMETER Property
    Specifies the properties of the input objects to include in the output.

    .PARAMETER ExcludeProperty
    Specifies the properties of the input objects to exclude from the output.

    .PARAMETER HideTableHeaders
    Indicates whether to hide the table headers in the output.

    .PARAMETER ColumnHeaderSize
    Specifies the size of the column headers in the output.

    .PARAMETER AlignRight
    Indicates whether to align the output data to the right.

    .PARAMETER Stream
    Specifies the stream to display the formatted data. Valid values are 'Output', 'Host', 'Warning', 'Verbose', 'Debug', and 'Information'.

    .PARAMETER List
    Indicates whether to display the output as a list.

    .PARAMETER Transpose
    Indicates whether to transpose the columns and rows of the output.

    .PARAMETER TransposeSort
    Specifies the sorting order when transposing the data. Valid values are 'ASC', 'DESC', and 'NONE'.

    .PARAMETER ForegroundColor
    Specifies the foreground color of the output.

    .PARAMETER ForegroundColorRow
    Specifies the foreground color of specific rows in the output.

    .EXAMPLE
    Get-Process | Format-Stream -Property Name, Id -Stream Host
    Displays the Name and Id properties of the processes in the Host stream.

    .EXAMPLE
    Get-Service | Format-Stream -ExcludeProperty Status -List
    Displays all service properties except Status as a list.

    #>
    [alias('FS', 'Format-TableStream', 'Format-ListStream')]
    ##[alias('ftv','ftd','fto','fth','fti','flv','fld','flo','flh','fli','Format-TableVerbose', 'Format-TableDebug', 'Format-TableInformation', 'Format-TableWarning')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
        [Array] $InputObject,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 0, ParameterSetName = 'Property')]
        [string[]] $Property,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 2, ParameterSetName = 'ExcludeProperty')]
        [string[]] $ExcludeProperty,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 3)]
        [switch] $HideTableHeaders,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 4)]
        [int] $ColumnHeaderSize,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 5)]
        [switch] $AlignRight,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 6)]
        [validateset('Output', 'Host', 'Warning', 'Verbose', 'Debug', 'Information')]
        [string] $Stream = 'Verbose',

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 7)]
        [alias('AsList')][switch] $List,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 8)]
        [alias('Rotate', 'RotateData', 'TransposeColumnsRows', 'TransposeData')]
        [switch] $Transpose,

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 9)]
        [ValidateSet('ASC', 'DESC', 'NONE')]
        [string] $TransposeSort = 'NONE',

        [alias('Color')]
        [System.ConsoleColor[]] $ForegroundColor,

        [alias('ColorRow')]
        [int[]] $ForegroundColorRow
    )
    Begin {
        $IsVerbosePresent = $PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent

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
        if ($InputObject.Count -eq 0) { break }
        if ($FirstRun) {
            $FirstRun = $false
            if ($Transpose) { $InputObject = Format-TransposeTable -Object $InputObject -Sort $TransposeSort }
            $Data = Format-PSTable -Object $InputObject -Property $Property -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -PreScanHeaders:$PreScanHeaders
            $Headers = $Data[0]
            if ($HideTableHeaders) {
                $Data.RemoveAt(0);
            }
            $ArrayList += $Data
        } else {
            if ($Transpose) { $InputObject = Format-TransposeTable -Object $InputObject -Sort $TransposeSort }
            $Data = Format-PSTable -Object $InputObject -Property $Property -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -PreScanHeaders:$PreScanHeaders -OverwriteHeaders $Headers -SkipTitle
            $ArrayList += $Data
        }
    }
    End {
        if (-not $ColumnHeaderSize) {
            $ColumnLength = [int[]]::new($Headers.Count);
            foreach ($Row in $ArrayList) {
                $i = 0
                foreach ($Column in $Row) {
                    $Length = "$Column".Length
                    if ($Length -gt $ColumnLength[$i]) {
                        $ColumnLength[$i] = $Length
                    }
                    $i++
                }
            }
            if ($IsVerbosePresent) {
                Write-Verbose "Format-TableVerbose - ScreenWidth $ScreenWidth"
                Write-Verbose "Format-TableVerbose - Column Lengths $($ColumnLength -join ',')"
            }
        }
        # Add empty line
        if ($Stream -eq 'Output') {
            Write-Output -InputObject ''
        } elseif ($Stream -eq 'Host') {
            Write-Host -Object ''
        } elseif ($Stream -eq 'Warning') {
            Write-Warning -Message ''
        } elseif ($Stream -eq 'Verbose') {
            Write-Verbose -Message ''
        } elseif ($Stream -eq 'Debug') {
            Write-Debug -Message ''
        } elseif ($Stream -eq 'Information') {
            Write-Information -MessageData ''
        }
        if ($List) {
            [int] $RowCount = 1
            foreach ($Row in $ArrayList ) {
                [string] $Output = ''
                [int] $ColumnNumber = 0
                [int] $CurrentColumnLength = 0

                if ($ColumnHeaderSize) {
                    $PadLength = $ColumnHeaderSize # Add +1 to make sure there's space between columns
                } else {
                    $PadLength = (($Headers.Length | Measure-Object -Maximum).Maximum) + 1 # Add +1 to make sure there's space between columns
                }


                # Prepare each data for row
                if (-not $FirstList) {
                    $i = 0
                    foreach ($ColumnValue in $Row) {
                        if (-not $HideTableHeaders) {
                            # Using Headers for a List
                            if ($AlignRight) {
                                $Head = $($Headers[$i]).PadLeft($PadLength)
                            } else {
                                $Head = $($Headers[$i]).PadRight($PadLength)
                            }
                            $Output = "$Head`: $ColumnValue"
                        } else {
                            # Hide table headers for a List switch
                            $Output = "$ColumnValue"
                        }

                        if ($Stream -eq 'Output') {
                            Write-Output -InputObject $Output
                        } elseif ($Stream -eq 'Host') {
                            Write-Host -Object $Output
                        } elseif ($Stream -eq 'Warning') {
                            Write-Warning -Message $Output
                        } elseif ($Stream -eq 'Verbose') {
                            Write-Verbose -Message $Output
                        } elseif ($Stream -eq 'Debug') {
                            Write-Debug -Message $Output
                        } elseif ($Stream -eq 'Information') {
                            Write-Information -MessageData $Output
                        }
                        $i++
                    }
                    $RowCount++
                    if ($RowCount -ne $ArrayList.Count) {
                        # Add empty line per each object but only if it's not last object
                        if ($Stream -eq 'Output') {
                            Write-Output -InputObject ''
                        } elseif ($Stream -eq 'Host') {
                            Write-Host -Object ''
                        } elseif ($Stream -eq 'Warning') {
                            Write-Warning -Message ''
                        } elseif ($Stream -eq 'Verbose') {
                            Write-Verbose -Message ''
                        } elseif ($Stream -eq 'Debug') {
                            Write-Debug -Message ''
                        } elseif ($Stream -eq 'Information') {
                            Write-Information -MessageData ''
                        }
                    }
                }
                $FirstList = $false
            }
        } else {
            # Process Data
            [int] $RowCountColors = 1
            foreach ($Row in $ArrayList ) {
                [string] $Output = ''
                [int] $ColumnNumber = 0
                [int] $CurrentColumnLength = 0
                # Prepare each data for row
                foreach ($ColumnValue in $Row) {

                    # Set Column Header Size to static value or based on string length
                    if ($ColumnHeaderSize) {
                        $PadLength = $ColumnHeaderSize # Add +1 to make sure there's space between columns
                    } else {
                        $PadLength = $ColumnLength[$ColumnNumber] + 1 # Add +1 to make sure there's space between columns
                    }

                    # Makes sure to display all data on current screen size, the larger the screen, the more it fits
                    $CurrentColumnLength += $PadLength
                    if ($CurrentColumnLength -ge $ScreenWidth) {
                        break
                    }

                    # Prepare Data
                    if ($ColumnHeaderSize) {
                        # if ColumnHeaderSize is defined we need to trim text and make sure there is space between for the ones being trimmed
                        $ColumnValue = ("$ColumnValue".ToCharArray() | Select-Object -First ($PadLength - 1)) -join ''
                    } else {
                        $ColumnValue = ("$ColumnValue".ToCharArray() | Select-Object -First ($PadLength)) -join ''
                    }
                    if ($Output -eq '') {
                        if ($AlignRight) {
                            $Output = "$ColumnValue".PadLeft($PadLength)
                        } else {
                            $Output = "$ColumnValue".PadRight($PadLength)
                        }
                    } else {
                        if ($AlignRight) {
                            $Output = $Output + "$ColumnValue".PadLeft($PadLength)
                        } else {
                            $Output = $Output + "$ColumnValue".PadRight($PadLength)
                        }
                    }
                    $ColumnNumber++
                }
                if ($Stream -eq 'Output') {
                    Write-Output -InputObject $Output
                } elseif ($Stream -eq 'Host') {
                    if ($ForegroundColorRow -contains $RowCountColors) {
                        [int] $Index = $ForegroundColorRow.IndexOf($RowCountColors)
                        Write-Host -Object $Output -ForegroundColor $ForegroundColor[$Index]
                    } else {
                        Write-Host -Object $Output
                    }
                } elseif ($Stream -eq 'Warning') {
                    Write-Warning -Message $Output
                } elseif ($Stream -eq 'Verbose') {
                    Write-Verbose -Message $Output
                } elseif ($Stream -eq 'Debug') {
                    Write-Debug -Message $Output
                } elseif ($Stream -eq 'Information') {
                    Write-Information -MessageData $Output
                }


                if (-not $HideTableHeaders) {
                    # Add underline
                    if ($FirstLoop) {
                        $HeaderUnderline = $Output -Replace '\w', '-'
                        #Write-Verbose -Message $HeaderUnderline
                        if ($Stream -eq 'Output') {
                            Write-Output -InputObject $HeaderUnderline
                        } elseif ($Stream -eq 'Host') {
                            if ($ForegroundColorRow -contains $RowCountColors) {
                                [int] $Index = $ForegroundColorRow.IndexOf($RowCountColors)
                                Write-Host -Object $HeaderUnderline -ForegroundColor $ForegroundColor[$Index]
                            } else {
                                Write-Host -Object $HeaderUnderline
                            }
                        } elseif ($Stream -eq 'Warning') {
                            Write-Warning -Message $HeaderUnderline
                        } elseif ($Stream -eq 'Verbose') {
                            Write-Verbose -Message $HeaderUnderline
                        } elseif ($Stream -eq 'Debug') {
                            Write-Debug -Message $HeaderUnderline
                        } elseif ($Stream -eq 'Information') {
                            Write-Information -MessageData $HeaderUnderline
                        }
                    }
                }

                $FirstLoop = $false
                $RowCountColors++
            }
        }

        # Add empty line
        if ($Stream -eq 'Output') {
            Write-Output -InputObject ''
        } elseif ($Stream -eq 'Host') {
            Write-Host -Object ''
        } elseif ($Stream -eq 'Warning') {
            Write-Warning -Message ''
        } elseif ($Stream -eq 'Verbose') {
            Write-Verbose -Message ''
        } elseif ($Stream -eq 'Debug') {
            Write-Debug -Message ''
        } elseif ($Stream -eq 'Information') {
            Write-Information -MessageData ''
        }


        # Set back to defaults
        if ($Stream -eq 'Output') {
            #
        } elseif ($Stream -eq 'Host') {
            #
        } elseif ($Stream -eq 'Warning') {
            $WarningPreference = $WarningCurrent
        } elseif ($Stream -eq 'Verbose') {
            $VerbosePreference = $VerboseCurrent
        } elseif ($Stream -eq 'Debug') {
            $DebugPreference = $DebugCurrent
        } elseif ($Stream -eq 'Information') {
            $InformationPreference = $InformationCurrent
        }
    }
}