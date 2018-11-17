function Format-TableVerbose {
    [alias('ftv')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, Position = 1)] $InputObject,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 0)][Object[]] $Property,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, Position = 2)][Object[]] $ExcludeProperty,
        [switch] $Autosize,
        [switch] $HideTableHeaders,
        [int] $MaximumHeaders = 10
    )
    Begin {
        $VerboseCurrent = $VerbosePreference
        $VerbosePreference = 'continue'
        $FirstRun = $True
        $PadRight = 0
        $PadLeft = 15

        $ScreenWidth = $Host.UI.RawUI.WindowSize.Width - 12
        #$ScreenHeight = $Host.UI.RawUI.WindowSize.Height
        #Write-Verbose "Format-TableVerbose - PadLeft: $PadLeft ScreenWidth $ScrenWidth"
    }
    Process {
        <#
        if ($Property) {
            $InputObject = $InputObject | Select-Object -Property $Property
            $PadLeft = $ScreenWidth / $Property.Count
        } else {
            # Properties unknown, Get properties of object
            $Property = Get-ObjectProperties -Object $InputObject
            $PropertyCount = $Property.Count
            if ($PropertyCount -ge $MaximumHeaders) {
                $PropertyCount = $MaximumHeaders
            }
            $Property = ($Property | Select-Object -First $PropertyCount)

            # Prepare Object with just right amount of columns
            $InputObject = $InputObject | Select-Object -Property $Property
            $PadLeft = $ScreenWidth / $PropertyCount
        }
#>

        if ($FirstRun) {
            $FirstRun = $false
            $Data = Format-PSTable -Object $InputObject -Property $Property -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -PreScanHeaders:$PreScanHeaders
            $Headers = $Data[0]

            Write-Color $StringLenghts -Color Red

            if ($HideTableHeaders) {
                $Data.RemoveAt(0);
            }


            $i = 0
            foreach ($RowData in $Data ) {
                $Output = ''
                foreach ($Value in $RowData) {

                    $Value = ("$Value".ToCharArray() | Select-Object -first ($PadLeft - 1)) -join ""

                    if ($Output -eq '') {
                        $Output = "$Value".PadRight($PadRight).PadLeft($PadLeft)
                    } else {
                        $Output = $Output + "$Value".PadRight($PadRight).PadLeft($PadLeft)
                    }
                }
                Write-Verbose -Message $Output

                if (-not $HideTableHeaders) {
                    # Add underline
                    if ($i -eq 0) {
                        $HeaderUnderline = $Output -Replace '\w', '-'
                        Write-Verbose -Message $HeaderUnderline
                    }
                }

                $i++
            }
        } else {

            $Data = Format-PSTable -Object $InputObject -Property $Property -ExcludeProperty $ExcludeProperty -NoAliasOrScriptProperties:$NoAliasOrScriptProperties -DisplayPropertySet:$DisplayPropertySet -PreScanHeaders:$PreScanHeaders -OverwriteHeaders $Headers -SkipTitle
            foreach ($RowData in $Data) {
                $Output = ''
                foreach ($Value in $RowData) {
                    $Value = ("$Value".ToCharArray() | Select-Object -first ($PadLeft - 1)) -join ""

                    if ($Output -eq '') {
                        $Output = "$Value".PadRight($PadRight).PadLeft($PadLeft)
                    } else {
                        $Output = $Output + "$Value".PadRight($PadRight).PadLeft($PadLeft)
                    }
                }
                Write-Verbose -Message $Output
            }
        }
    }
    End {





        $VerbosePreference = $VerboseCurrent
    }
}