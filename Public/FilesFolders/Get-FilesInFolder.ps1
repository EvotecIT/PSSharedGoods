function Get-FilesInFolder {
    [CmdletBinding()]
    param(
        [string] $Folder,
        [string] $Extension = '*.evtx'
    )
    $ReturnFiles = @()
    $Files = Get-ChildItem -Path $Folder -Filter $Extension -Recurse
    foreach ($File in $Files) {
        $ReturnFiles += $File.FullName
    }
    return $ReturnFiles
}