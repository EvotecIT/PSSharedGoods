function Get-FilesInFolder {
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