function Convert-Size {
    <#
    .SYNOPSIS
    Converts a value from one size unit to another.

    .DESCRIPTION
    This function converts a value from one size unit (Bytes, KB, MB, GB, TB) to another size unit based on the specified conversion. It provides flexibility to handle different size units and precision of the conversion.

    .PARAMETER From
    Specifies the original size unit of the input value.

    .PARAMETER To
    Specifies the target size unit to convert the input value to.

    .PARAMETER Value
    Specifies the numerical value to be converted.

    .PARAMETER Precision
    Specifies the number of decimal places to round the converted value to. Default is 4.

    .PARAMETER Display
    Indicates whether to display the converted value with the target size unit.

    .EXAMPLE
    Convert-Size -From 'KB' -To 'MB' -Value 2048
    # Converts 2048 Kilobytes to Megabytes.

    .EXAMPLE
    Convert-Size -From 'GB' -To 'TB' -Value 2.5 -Precision 2 -Display
    # Converts 2.5 Gigabytes to Terabytes with a precision of 2 decimal places and displays the result.

    #>
    # Original - https://techibee.com/powershell/convert-from-any-to-any-bytes-kb-mb-gb-tb-using-powershell/2376
    #
    # Changelog - Modified 30.03.2018 - przemyslaw.klys at evotec.pl
    # - Added $Display Switch
    [cmdletbinding()]
    param(
        [validateset("Bytes", "KB", "MB", "GB", "TB")]
        [string]$From,
        [validateset("Bytes", "KB", "MB", "GB", "TB")]
        [string]$To,
        [Parameter(Mandatory = $true)]
        [double]$Value,
        [int]$Precision = 4,
        [switch]$Display
    )
    switch ($From) {
        "Bytes" {$value = $Value }
        "KB" {$value = $Value * 1024 }
        "MB" {$value = $Value * 1024 * 1024}
        "GB" {$value = $Value * 1024 * 1024 * 1024}
        "TB" {$value = $Value * 1024 * 1024 * 1024 * 1024}
    }

    switch ($To) {
        "Bytes" {return $value}
        "KB" {$Value = $Value / 1KB}
        "MB" {$Value = $Value / 1MB}
        "GB" {$Value = $Value / 1GB}
        "TB" {$Value = $Value / 1TB}

    }
    if ($Display) {
        return "$([Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)) $To"
    } else {
        return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
    }

}