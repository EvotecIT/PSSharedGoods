function Set-EmailReportBrading {
    param(
        [alias('FormattingOptions')] $FormattingParameters
    )
    if ($FormattingParameters.CompanyBranding.Link) {
        $Report = "<a style=`"text-decoration:none`" href=`"$($FormattingParameters.CompanyBranding.Link)`" class=`"clink logo-container`">"
    } else {
        $Report = ''
    }
    if ($FormattingParameters.CompanyBranding.Inline) {
        $Report += "<img width=<fix> height=<fix> src=`"cid:logo`" border=`"0`" class=`"company-logo`" alt=`"company-logo`"></a>"
    } else {
        $Report += "<img width=<fix> height=<fix> src=`"$($FormattingParameters.CompanyBranding.Logo)`" border=`"0`" class=`"company-logo`" alt=`"company-logo`"></a>"
    }
    if ($FormattingParameters.CompanyBranding.Width -ne "") {
        $Report = $Report -replace "width=<fix>", "width=$($FormattingParameters.CompanyBranding.Width)"
    } else {
        $Report = $Report -replace "width=<fix>", ""
    }
    if ($FormattingParameters.CompanyBranding.Height -ne "") {
        $Report = $Report -replace "height=<fix>", "height=$($FormattingParameters.CompanyBranding.Height)"
    } else {
        $Report = $Report -replace "height=<fix>", ""
    }
    return $Report
}