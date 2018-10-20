function Save-XML {
    param (
        [string] $FilePath,
        [System.Xml.XmlNode] $xml
    )
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    $writer = New-Object System.IO.StreamWriter($FilePath, $false, $utf8WithoutBom)
    $xml.Save( $writer )
    $writer.Close()
}