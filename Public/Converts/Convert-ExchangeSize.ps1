
<#
Convert-ExchangeSize -To MB -Size '49 GB (52,613,349,376 bytes)'
Convert-ExchangeSize -To GB -Size '49 GB (52,613,349,376 bytes)'
#>
function Convert-ExchangeSize {
    <#
    .SYNOPSIS
    Converts the size of Exchange data to a specified unit of measurement.

    .DESCRIPTION
    This function takes the size of Exchange data and converts it to the specified unit of measurement (Bytes, KB, MB, GB, TB).

    .PARAMETER To
    The unit of measurement to convert the size to. Default is 'MB'.

    .PARAMETER Size
    The size of Exchange data to be converted.

    .PARAMETER Precision
    The number of decimal places to round the converted size to. Default is 4.

    .PARAMETER Display
    Switch to display the converted size with the unit of measurement.

    .PARAMETER Default
    The default value to return if the size is null or empty. Default is 'N/A'.

    .EXAMPLE
    Convert-ExchangeSize -To MB -Size '49 GB (52,613,349,376 bytes)'
    # Returns the size converted to MB.

    .EXAMPLE
    Convert-ExchangeSize -To GB -Size '49 GB (52,613,349,376 bytes)' -Precision 2 -Display
    # Returns the size converted to GB with 2 decimal places and displays the result.

    #>
    [cmdletbinding()]
    param(
        [validateset("Bytes", "KB", "MB", "GB", "TB")][string]$To = 'MB',
        [string]$Size,
        [int]$Precision = 4,
        [switch]$Display,
        [string]$Default = 'N/A'
    )
    if ([string]::IsNullOrWhiteSpace($Size)) {
        return $Default
    }
    $Pattern = [Regex]::new('(?<=\()([0-9]*[,.].*[0-9])')  # (?<=\()([0-9]*.*[0-9]) works too
    $Value = ($Size | Select-String $Pattern -AllMatches).Matches.Value
    #Write-Verbose "Convert-ExchangeSize - Value Before: $Value"

    if ($null -ne $Value) {
        $Value = $Value.Replace(',', '').Replace('.', '')
    }

    switch ($To) {
        "Bytes" {return $value}
        "KB" {$Value = $Value / 1KB}
        "MB" {$Value = $Value / 1MB}
        "GB" {$Value = $Value / 1GB}
        "TB" {$Value = $Value / 1TB}

    }
    #Write-Verbose "Convert-ExchangeSize - Value After: $Value"
    if ($Display) {
        return "$([Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)) $To"
    } else {
        return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
    }
}