function Save-XML {
    <#
    .SYNOPSIS
    Saves an XML document to a specified file path.

    .DESCRIPTION
    This function saves an XML document to a specified file path using UTF-8 encoding without BOM.

    .PARAMETER FilePath
    Specifies the path where the XML document will be saved.

    .PARAMETER xml
    Specifies the XML document to be saved.

    .EXAMPLE
    Save-XML -FilePath "C:\Documents\example.xml" -xml $xmlDocument
    Saves the XML document $xmlDocument to the file "example.xml" located in the "C:\Documents" directory.

    #>
    param (
        [string] $FilePath,
        [System.Xml.XmlNode] $xml
    )
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    $writer = New-Object System.IO.StreamWriter($FilePath, $false, $utf8WithoutBom)
    $xml.Save( $writer )
    $writer.Close()
}