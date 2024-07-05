function Get-FilesInFolder {
    <#
    .SYNOPSIS
    Retrieves a list of files in a specified folder with the option to filter by extension.

    .DESCRIPTION
    This function retrieves a list of files in the specified folder. By default, it includes all files with the '.evtx' extension, but you can specify a different extension using the $Extension parameter.

    .PARAMETER Folder
    Specifies the folder path from which to retrieve files.

    .PARAMETER Extension
    Specifies the file extension to filter by. Default value is '*.evtx'.

    .EXAMPLE
    Get-FilesInFolder -Folder "C:\Logs"

    Description:
    Retrieves all files with the '.evtx' extension in the "C:\Logs" folder.

    .EXAMPLE
    Get-FilesInFolder -Folder "D:\Documents" -Extension '*.txt'

    Description:
    Retrieves all files with the '.txt' extension in the "D:\Documents" folder.

    #>
    [CmdletBinding()]
    param(
        [string] $Folder,
        [string] $Extension = '*.evtx'
    )

    $Files = Get-ChildItem -Path $Folder -Filter $Extension -Recurse
    $ReturnFiles = foreach ($File in $Files) {
        $File.FullName
    }
    return $ReturnFiles
}