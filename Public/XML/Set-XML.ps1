function Set-XML {
    param (
        [string] $FilePath,
        [string[]]$Paths,
        [string] $Node,
        [string] $Value
    )
    [xml]$xmlDocument = Get-Content -Path $FilePath -Encoding UTF8
    $XmlElement = $xmlDocument
    foreach ($Path in $Paths) {
        $XmlElement = $XmlElement.$Path
    }
    $XmlElement.$Node = $Value
    $xmlDocument.Save($FilePath)
    # Save-XML -FilePath $FilePath -xml $xmlDocument
}