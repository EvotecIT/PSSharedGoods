function Convert-Office365License {
    <#
    .SYNOPSIS
    This function helps converting Office 365 licenses from/to their SKU equivalent

    .DESCRIPTION
    This function helps converting Office 365 licenses from/to their SKU equivalent

    .PARAMETER License
    License SKU or License Name. Takes multiple values.

    .PARAMETER ToSku
    Converts license name to SKU

    .PARAMETER Separator

    .PARAMETER ReturnArray

    .EXAMPLE
    Convert-Office365License -License 'VISIOCLIENT','PROJECTONLINE_PLAN_1','test','tenant:VISIOCLIENT'

    .EXAMPLE
    Convert-Office365License -License "Office 365 (Plan A3) for Faculty","Office 365 (Enterprise Preview)", 'test' -ToSku
    #>

    [CmdletBinding()]
    param(
        [string[]] $License,
        [alias('SKU')][switch] $ToSku,
        [string] $Separator = ', ',
        [switch] $ReturnArray
    )
    if (-not $ToSku) {
        $ConvertedLicenses = foreach ($L in $License) {
            # Remove tenant from SKU
            #if ($L -match ':') {
            #    $Split = $L -split ':'
            #    $L = $Split[-1]
            #}

            # Removes : from tenant:VisioClient
            $L = $L -replace '.*(:)'

            $Conversion = $Script:O365SKU[$L]
            if ($null -eq $Conversion) {
                $L
            } else {
                $Conversion
            }
        }
    } else {
        $ConvertedLicenses = foreach ($L in $License) {
            #$Conversion = $Script:O365SKU.GetEnumerator() | Where-Object { $_.Value -eq $L }
            $Conversion = foreach ($_ in $Script:O365SKU.GetEnumerator()) {
                if ($_.Value -eq $L) {
                    $_
                    continue
                }
            }
            if ($null -eq $Conversion) {
                $L
            } else {
                $Conversion.Name
            }
        }
    }
    if ($ReturnArray) {
        return $ConvertedLicenses
    } else {
        return $ConvertedLicenses -join $Separator
    }
}