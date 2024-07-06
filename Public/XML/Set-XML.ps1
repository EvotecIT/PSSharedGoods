function Set-XML {
    <#
    .SYNOPSIS
    Sets a specific node value in an XML file.

    .DESCRIPTION
    This function sets the value of a specified node in an XML file at the given path.

    .PARAMETER FilePath
    The path to the XML file.

    .PARAMETER Paths
    An array of paths to navigate through the XML structure.

    .PARAMETER Node
    The name of the node to set the value for.

    .PARAMETER Value
    The value to set for the specified node.

    .EXAMPLE
    Set-XML -FilePath "C:\example.xml" -Paths "Root", "Child" -Node "Value" -Value "NewValue"
    Sets the value of the "Value" node under "Root/Child" path in the XML file to "NewValue".

    .NOTES
    File encoding is assumed to be UTF-8.

    #>
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