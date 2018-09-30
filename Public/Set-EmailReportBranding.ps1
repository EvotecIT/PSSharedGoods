function Set-EmailReportBrading {
    param (
        $FormattingOptions
    )
    if ($FormattingOptions.CompanyBranding.Link -and $FormattingOptions.CompanyBranding.Logo) {
        $Report = "<a style=`"text-decoration:none`" href=`"$($FormattingOptions.CompanyBranding.Link)`" class=`"clink logo-container`">" +
        "<img width=<fix> height=<fix> src=`"$($FormattingOptions.CompanyBranding.Logo)`" border=`"0`" class=`"company-logo`" alt=`"company-logo`">" +
        "</a>"
        if ($FormattingOptions.CompanyBranding.Width -ne "") {
            $report = $report -replace "width=<fix>", "width=$($FormattingOptions.CompanyBranding.Width)"
        } else {
            $report = $report -replace "width=<fix>", ""
        }
        if ($FormattingOptions.CompanyBranding.Height -ne "") {
            $report = $report -replace "height=<fix>", "height=$($FormattingOptions.CompanyBranding.Height)"
        } else {
            $report = $report -replace "height=<fix>", ""
        }
    }
    return $Repor
}