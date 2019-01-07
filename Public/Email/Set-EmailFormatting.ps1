function Set-EmailFormatting {
    param (
        $Template,
        $FormattingParameters,
        $ConfigurationParameters,
        $Logger
    )
    if ($ConfigurationParameters) {
        $WriteParameters = $ConfigurationParameters.DisplayConsole
    } else {
        $WriteParameters = @{ ShowTime = $true; LogFile = ""; TimeFormat = "yyyy-MM-dd HH:mm:ss" }
    }
    $Template = $Template.Split("`n") # https://blogs.msdn.microsoft.com/timid/2014/07/09/one-liner-fun-with-multi-line-blocktext-and-split-split/

    $Body = "<body>"

    if ($Logger) {
        $Logger.AddInfoRecord("Preparing template - adding HTML <BR> tags...")
    } else {
        Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "<BR>", " tags." -Color White, Yellow, White, Yellow
    }

    $StyleFlag = $false
    foreach ($t in $Template) {
        ## needs investigation
        <#
        if ($t -match 'style>') {
            $StyleFlag = -not $StyleFlag
        }
        if ($StyleFlag) {
            $Body += $t
            continue
        }
        if ($t -match '[\<|\</][\w+|\d+]') {
            $Body += $t
            continue
        }
        #>
        $Body += "$t<br>"
    }#>
    foreach ($style in $FormattingParameters.Styles.GetEnumerator()) {
        foreach ($value in $style.Value) {
            if ($value -eq "") { continue }
            if ($Logger) {
                $Logger.AddInfoRecord("Preparing template - adding HTML $($style.Name) tag for $value.")
            } else {
                Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "$($style.Name)", " tag for ", "$value", ' tags...' -Color White, Yellow, White, Yellow, White, Yellow
            }
            $Body = $Body.Replace($value, "<$($style.Name)>$value</$($style.Name)>")
        }
    }

    foreach ($color in $FormattingParameters.Colors.GetEnumerator()) {
        foreach ($value in $color.Value) {
            if ($value -eq "") { continue }
            if ($Logger) {
                $Logger.AddInfoRecord("Preparing template - adding HTML $($color.Name) tag for $value.")
            } else {
                Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "$($color.Name)", " tag for ", "$value", ' tags...' -Color White, Yellow, White, Yellow, White, Yellow
            }
            $Body = $Body.Replace($value, "<span style=color:$($color.Name)>$value</span>")
        }
    }
    foreach ($links in $FormattingParameters.Links.GetEnumerator()) {
        foreach ($link in $links.Value) {
            #write-host $link.Text
            #write-host $link.Link
            if ($link.Link -like "*@*") {
                if ($Logger) {
                    $Logger.AddInfoRecord("Preparing template - adding EMAIL Links for $($links.Key).")
                } else {
                    Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " EMAIL ", "Links for", " $($links.Key)..." -Color White, Yellow, White, White, Yellow, White
                }
                $Body = $Body -replace "<<$($links.Key)>>", "<span style=color:$($link.Color)><a href='mailto:$($link.Link)?subject=$($Link.Subject)'>$($Link.Text)</a></span>"
            } else {
                if ($Logger) {
                    $Logger.AddInfoRecord("[i] Preparing template - adding HTML Links for $($links.Key)")
                } else {
                    Write-Color @WriteParameters -Text "[i] Preparing template ", "adding", " HTML ", "Links for", " $($links.Key)..." -Color White, Yellow, White, White, Yellow, White
                }
                $Body = $Body -replace "<<$($links.Key)>>", "<span style=color:$($link.Color)><a href='$($link.Link)'>$($Link.Text)</a></span>"
            }
        }

    }
    if ($ConfigurationParameters) {
        if ($ConfigurationParameters.DisplayTemplateHTML -eq $true) { Get-HTML($Body) }
    }
    $Body += '</body>'
    return $Body
}