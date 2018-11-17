function Format-TableVerbose {
    [alias('ftv')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 1)] $InputObject,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 0)][Object[]] $Property,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 2)][Object[]] $ExcludeProperty,
        [switch] $HideTableHeaders,
        [int] $ColumnHeaderSize,
        [switch] $AlignRight
    )
    Begin {
        $IsVerbosePresent = $PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent

        $VerboseCurrent = $VerbosePreference
        $VerbosePreference = 'continue'
        [bool] $FirstRun = $True # First run for pipeline
        [bool] $FirstLoop = $True # First loop for data
        [int] $ScreenWidth = $Host.UI.RawUI.WindowSize.Width - 12 # Removes 12 chars because of VERBOSE: output
        $ArrayList = @()
    }
    Process {
        if ((Get-ObjectCount -Object $InputObject) -eq 0) { break }
        if ($FirstRun) {
            $FirstRun = $false
            $Data = Format-PSTable -Object $InputObject -Property $Property -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -PreScanHeaders:$PreScanHeaders
            $Headers = $Data[0]
            if ($HideTableHeaders) {
                $Data.RemoveAt(0);
            }
            $ArrayList += $Data
        } else {
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
        Write-Verbose -Message ''
        foreach ($Row in $ArrayList ) {
            [string] $Output = ''
            [int] $ColumnNumber = 0
            [int] $CurrentColumnLength = 0
            # Prepare each data for row
            foreach ($ColumnValue in $Row) {

                # Set Column Header Size to static value or based on string length
                if ($ColumnHeaderSize) {
                    $PadLength = $ColumnHeaderSize + 1 # Add +1 to make sure there's space between columns
                } else {
                    $PadLength = $ColumnLength[$ColumnNumber] + 1 # Add +1 to make sure there's space between columns
                }

                # Makes sure to display all data on current screen size, the larger the screen, the more it fits
                $CurrentColumnLength += $PadLength
                if ($CurrentColumnLength -ge $ScreenWidth) {
                    break
                }

                # Prepare Data
                $ColumnValue = ("$ColumnValue".ToCharArray() | Select-Object -First ($PadLength)) -join ""
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
            Write-Verbose -Message $Output

            if (-not $HideTableHeaders) {
                # Add underline
                if ($FirstLoop) {
                    $HeaderUnderline = $Output -Replace '\w', '-'
                    Write-Verbose -Message $HeaderUnderline
                }
            }

            $FirstLoop = $false
        }
        Write-Verbose -Message ''

        $VerbosePreference = $VerboseCurrent
    }
}