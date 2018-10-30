
<#
Convert-ExchangeSize -To MB -Size '49 GB (52,613,349,376 bytes)'
Convert-ExchangeSize -To GB -Size '49 GB (52,613,349,376 bytes)'
#>
function Convert-ExchangeSize {
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
    $Pattern = [Regex]::new('(?<=\()([1-9]*[,.].*[1-9])')
    $Value = ($Size | Select-String $Pattern -AllMatches).Matches.Value

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
    if ($Display) {
        return "$([Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)) $To"
    } else {
        return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
    }

}